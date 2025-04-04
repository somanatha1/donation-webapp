FROM tomcat:11.0-jdk21

# Install dependencies
RUN apt-get update && \
    apt-get install -y postgresql-client curl && \
    apt-get clean

# First copy only the POM file to cache dependencies
COPY pom.xml .
# Optional: You can add a step to build your WAR file here if using multi-stage build

# Then copy the actual application files
COPY --chown=tomcat:tomcat src/main/resources/schema.sql /usr/local/tomcat/schema.sql
COPY --chown=tomcat:tomcat Donationwebapp.war /usr/local/tomcat/webapps/ROOT.war

# Startup script
RUN echo '#!/bin/bash\n\
set -e\n\
\n\
# Extract connection details from Render'\''s environment\n\
DB_URL="${JDBC_DATABASE_URL#*@}"\n\
DB_HOST="${DB_URL%:*}"\n\
DB_PORT="${DB_URL#*:}"\n\
DB_PORT="${DB_PORT%%/*}"\n\
DB_NAME="${JDBC_DATABASE_URL##*/}"\n\
DB_NAME="${DB_NAME%%\?*}"\n\
\n\
echo "Waiting for PostgreSQL at ${DB_HOST}:${DB_PORT:-5432}..."\n\
until PGPASSWORD="${JDBC_DATABASE_PASSWORD}" psql -h "${DB_HOST}" -p "${DB_PORT:-5432}" \
     -U "${JDBC_DATABASE_USERNAME}" -d "${DB_NAME}" -c "SELECT 1" >/dev/null 2>&1; do\n\
  echo "PostgreSQL not ready - retrying in 2 seconds..."\n\
  sleep 2\ndone\n\
\n\
# Initialize schema if needed\n\
if ! PGPASSWORD="${JDBC_DATABASE_PASSWORD}" psql -h "${DB_HOST}" -p "${DB_PORT:-5432}" \
     -U "${JDBC_DATABASE_USERNAME}" -d "${DB_NAME}" \
     -c "SELECT 1 FROM pg_tables WHERE schemaname = '\''public'\'' AND tablename = '\''users'\''" | grep -q 1; then\n\
  echo "Initializing database schema..."\n\
  PGPASSWORD="${JDBC_DATABASE_PASSWORD}" psql -h "${DB_HOST}" -p "${DB_PORT:-5432}" \
       -U "${JDBC_DATABASE_USERNAME}" -d "${DB_NAME}" -f /usr/local/tomcat/schema.sql\n\
fi\n\
\nexec catalina.sh run' > /usr/local/bin/startup.sh && \
    chmod +x /usr/local/bin/startup.sh

# Port configuration
EXPOSE 8080
ENV PORT=8080
CMD ["/usr/local/bin/startup.sh"]

