FROM tomcat:11.0-jdk21

# Install PostgreSQL client and curl for health checks
RUN apt-get update && \
    apt-get install -y postgresql-client curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Secure defaults for Tomcat
RUN useradd -m -u 1001 tomcat_user && \
    chown -R tomcat_user:tomcat_user /usr/local/tomcat && \
    chmod -R 750 /usr/local/tomcat

# Configure Tomcat to use Render's PORT environment variable
RUN sed -i.bak \
    -e 's/port="8080"/port="${PORT:-8080}"/g' \
    -e 's/relaxedQueryChars="[^"]*"/relaxedQueryChars="[]"/g' \
    -e 's/relaxedPathChars="[^"]*"/relaxedPathChars="[]"/g' \
    /usr/local/tomcat/conf/server.xml && \
    rm /usr/local/tomcat/conf/server.xml.bak

# Clean default apps
RUN rm -rf /usr/local/tomcat/webapps/* && \
    rm -rf /usr/local/tomcat/webapps.dist/*

# Install PostgreSQL JDBC driver
ADD --chown=tomcat_user:tomcat_user --chmod=640 \
    https://jdbc.postgresql.org/download/postgresql-42.7.1.jar \
    /usr/local/tomcat/lib/postgresql.jar

# Copy application files
COPY --chown=tomcat_user:tomcat_user --chmod=640 schema.sql /schema.sql
COPY --chown=tomcat_user:tomcat_user --chmod=750 Donationwebapp.war /usr/local/tomcat/webapps/ROOT.war

# Environment variables for JVM and DB
ENV CATALINA_OPTS="-Djava.security.egd=file:/dev/./urandom -Xms256m -Xmx512m"
ENV DB_INITIALIZED="false"

# Health check (ensure app is responsive)
HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost:${PORT:-8080}/health-check || exit 1

# Startup script with DB initialization
RUN echo '#!/bin/bash\n\
set -e\n\
\n\
# Parse Render DB URL if using JDBC_DATABASE_URL\n\
if [ -n "$JDBC_DATABASE_URL" ]; then\n\
    DB_HOST=$(echo "$JDBC_DATABASE_URL" | awk -F[@:/] '\''{print $4}'\'')\n\
    DB_NAME=$(echo "$JDBC_DATABASE_URL" | awk -F/ '\''{print $NF}'\'' | awk -F? '\''{print $1}'\'')\n\
fi\n\
\n\
# Wait for PostgreSQL\n\
echo "Waiting for PostgreSQL at ${DB_HOST:-$PGHOST}:${DB_PORT:-$PGPORT:-5432}..."\n\
until PGPASSWORD="${JDBC_DATABASE_PASSWORD:-$PGPASSWORD}" psql -h "${DB_HOST:-$PGHOST}" \
-U "${JDBC_DATABASE_USERNAME:-$PGUSER}" -d "${DB_NAME:-$PGDATABASE}" -c "SELECT 1" >/dev/null 2>&1; do\n\
    echo "PostgreSQL is unavailable - retrying in 2 seconds..."\n\
    sleep 2\n\
done\n\
\n\
# Initialize schema if not exists\n\
if ! PGPASSWORD="${JDBC_DATABASE_PASSWORD:-$PGPASSWORD}" psql -h "${DB_HOST:-$PGHOST}" \
-U "${JDBC_DATABASE_USERNAME:-$PGUSER}" -d "${DB_NAME:-$PGDATABASE}" \
-c "SELECT 1 FROM pg_tables WHERE schemaname = '\''public'\'' AND tablename = '\''users'\''" | grep -q 1; then\n\
    echo "Initializing database schema..."\n\
    PGPASSWORD="${JDBC_DATABASE_PASSWORD:-$PGPASSWORD}" psql -h "${DB_HOST:-$PGHOST}" \
    -U "${JDBC_DATABASE_USERNAME:-$PGUSER}" -d "${DB_NAME:-$PGDATABASE}" -f /schema.sql\n\
    echo "Schema initialization complete"\n\
else\n\
    echo "Database already initialized"\n\
fi\n\
\n\
# Start Tomcat\n\
exec catalina.sh run' > /usr/local/bin/startup.sh && \
    chmod 755 /usr/local/bin/startup.sh

# Final permissions
RUN find /usr/local/tomcat/conf -type f -exec chmod 640 {} \; && \
    find /usr/local/tomcat/bin -type f -exec chmod 750 {} \; && \
    chmod 750 /usr/local/tomcat/logs

USER tomcat_user
EXPOSE ${PORT:-8080}

# Use our custom startup script
CMD ["/usr/local/bin/startup.sh"]



