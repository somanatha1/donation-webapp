FROM tomcat:11.0-jdk21

# Install PostgreSQL client for database initialization
RUN apt-get update && \
    apt-get install -y postgresql-client curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set secure defaults
RUN useradd -m -u 1001 tomcat_user && \
    chown -R tomcat_user:tomcat_user /usr/local/tomcat && \
    chmod -R 750 /usr/local/tomcat

# Change Tomcat port configuration
RUN sed -i.bak \
    -e 's/port="8080"/port="${PORT:-9090}"/g' \
    -e 's/relaxedQueryChars="[^"]*"/relaxedQueryChars=""/g' \
    -e 's/relaxedPathChars="[^"]*"/relaxedPathChars=""/g' \
    /usr/local/tomcat/conf/server.xml && \
    rm /usr/local/tomcat/conf/server.xml.bak

# Clean default apps
RUN rm -rf /usr/local/tomcat/webapps/* && \
    rm -rf /usr/local/tomcat/webapps.dist/*

# Install PostgreSQL JDBC driver
ADD --chown=tomcat_user:tomcat_user --chmod=640 \
    https://jdbc.postgresql.org/download/postgresql-42.7.1.jar \
    /usr/local/tomcat/lib/postgresql.jar

# Copy schema and deployment files
COPY --chown=tomcat_user:tomcat_user --chmod=640 src/main/resources/schema.sql /schema.sql
COPY --chown=tomcat_user:tomcat_user --chmod=750 Donationwebapp.war /usr/local/tomcat/webapps/ROOT.war

# Create database initialization script
RUN echo '#!/bin/bash\n\
set -e\n\
\n\
# Export Render environment variables to match psql expectations\n\
export PGHOST="${JDBC_DATABASE_URL/*@/}"\n\
export PGHOST="${PGHOST/:*/}"\n\
export PGPORT="${JDBC_DATABASE_URL/*:/}"\n\
export PGPORT="${PGPORT/\/*/}"\n\
export PGUSER="${JDBC_DATABASE_USERNAME}"\n\
export PGPASSWORD="${JDBC_DATABASE_PASSWORD}"\n\
export PGDATABASE="${JDBC_DATABASE_URL/*\//}"\n\
export PGDATABASE="${PGDATABASE/\?*/}"\n\
\n\
echo "Waiting for PostgreSQL at ${PGHOST}:${PGPORT} to be ready..."\n\
until psql -c "\\q" 2>/dev/null; do\n\
  echo "PostgreSQL is unavailable - sleeping..."\n\
  sleep 2\n\
done\n\
\n\
echo "PostgreSQL is up - checking if schema needs initialization"\n\
\n\
if ! psql -c "SELECT 1 FROM pg_tables WHERE schemaname = '\''public'\'' AND tablename = '\''users'\''" | grep -q 1; then\n\
  echo "Initializing database schema..."\n\
  psql -f /schema.sql\n\
  echo "Schema initialization complete"\n\
else\n\
  echo "Database already initialized, skipping schema creation"\n\
fi\n\
\n\
# Start Tomcat\n\
exec catalina.sh run' > /usr/local/bin/startup.sh && \
    chmod 755 /usr/local/bin/startup.sh

# Environment and memory settings
ENV CATALINA_OPTS="-Djava.security.egd=file:/dev/./urandom -Xms256m -Xmx512m"

# Final permissions
RUN find /usr/local/tomcat/conf -type f -exec chmod 640 {} \; && \
    find /usr/local/tomcat/bin -type f -exec chmod 750 {} \; && \
    chmod 750 /usr/local/tomcat/logs

USER tomcat_user
EXPOSE ${PORT:-9090}
HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost:${PORT:-9090}/ || exit 1

# Use our custom startup script
CMD ["/usr/local/bin/startup.sh"]



