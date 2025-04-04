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

# Configure Tomcat
RUN sed -i.bak \
    -e 's/port="8080"/port="${PORT:-8080}"/g' \
    /usr/local/tomcat/conf/server.xml && \
    rm /usr/local/tomcat/conf/server.xml.bak

# Clean default apps
RUN rm -rf /usr/local/tomcat/webapps/* && \
    rm -rf /usr/local/tomcat/webapps.dist/*

# Install PostgreSQL JDBC driver
ADD --chown=tomcat_user:tomcat_user --chmod=640 \
    https://jdbc.postgresql.org/download/postgresql-42.7.1.jar \
    /usr/local/tomcat/lib/postgresql.jar

# Copy application files (FIXED PATH)
COPY --chown=tomcat_user:tomcat_user src/main/resources/schema.sql /schema.sql
COPY --chown=tomcat_user:tomcat_user Donationwebapp.war /usr/local/tomcat/webapps/ROOT.war

# Environment variables
ENV CATALINA_OPTS="-Djava.security.egd=file:/dev/./urandom -Xms256m -Xmx512m"

# Startup script
RUN echo '#!/bin/bash\n\
set -e\n\
\n\
# Parse connection details from Render env vars\n\
DB_HOST=$(echo "${JDBC_DATABASE_URL}" | awk -F[@:/] '\''{print $4}'\'')\n\
DB_NAME=$(echo "${JDBC_DATABASE_URL}" | awk -F/ '\''{print $NF}'\'' | awk -F? '\''{print $1}'\'')\n\
\n\
echo "Waiting for PostgreSQL at ${DB_HOST}:5432..."\n\
until PGPASSWORD="${JDBC_DATABASE_PASSWORD}" psql -h "${DB_HOST}" -U "${JDBC_DATABASE_USERNAME}" -d "${DB_NAME}" -c "SELECT 1" >/dev/null 2>&1; do\n\
  sleep 2\n\
done\n\
\n\
if ! PGPASSWORD="${JDBC_DATABASE_PASSWORD}" psql -h "${DB_HOST}" -U "${JDBC_DATABASE_USERNAME}" -d "${DB_NAME}" \
   -c "SELECT 1 FROM pg_tables WHERE schemaname = '\''public'\'' AND tablename = '\''users'\''" | grep -q 1; then\n\
   echo "Initializing database schema..."\n\
   PGPASSWORD="${JDBC_DATABASE_PASSWORD}" psql -h "${DB_HOST}" -U "${JDBC_DATABASE_USERNAME}" -d "${DB_NAME}" -f /schema.sql\n\
fi\n\
\nexec catalina.sh run' > /usr/local/bin/startup.sh && \
    chmod 755 /usr/local/bin/startup.sh

USER tomcat_user
EXPOSE ${PORT:-8080}
CMD ["/usr/local/bin/startup.sh"]


