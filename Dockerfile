FROM tomcat:11.0-jdk21

# Install PostgreSQL client
RUN apt-get update && \
    apt-get install -y postgresql-client && \
    apt-get clean

# Copy application files
COPY Donationwebapp.war /usr/local/tomcat/webapps/ROOT.war
COPY src/main/resources/schema.sql /schema.sql

# Startup script with proper JDBC URL parsing
RUN echo '#!/bin/sh\n\
set -e\n\
\n\
# Extract hostname from JDBC URL (remove jdbc:postgresql:// prefix)\n\
DB_HOST_PORT="${JDBC_DATABASE_URL#*://}"\n\
DB_HOST="${DB_HOST_PORT%%/*}"\n\
DB_HOST="${DB_HOST%%:*}"\n\
DB_PORT="${DB_HOST_PORT#*:}"\n\
DB_PORT="${DB_PORT%%/*}"\n\
DB_NAME="${DB_HOST_PORT#*/}"\n\
DB_NAME="${DB_NAME%%\?*}"\n\
\n\
echo "Waiting for PostgreSQL at ${DB_HOST}:${DB_PORT:-5432}..."\n\
until PGPASSWORD="${JDBC_DATABASE_PASSWORD}" psql -h "${DB_HOST}" -p "${DB_PORT:-5432}" -U "${JDBC_DATABASE_USERNAME}" -d "${DB_NAME}" -c "SELECT 1" >/dev/null 2>&1; do\n\
  sleep 2\ndone\n\
\n\
# Initialize schema\n\
PGPASSWORD="${JDBC_DATABASE_PASSWORD}" psql -h "${DB_HOST}" -p "${DB_PORT:-5432}" -U "${JDBC_DATABASE_USERNAME}" -d "${DB_NAME}" -f /schema.sql\n\
\nexec catalina.sh run' > /startup.sh && \
    chmod +x /startup.sh

EXPOSE 8080
ENV PORT=8080
CMD ["/startup.sh"]
