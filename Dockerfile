FROM tomcat:11.0-jdk21

# 1. Install dependencies
RUN apt-get update && \
    apt-get install -y postgresql-client curl && \
    apt-get clean

# 2. Copy your files (adjust paths as needed)
# For Dynamic Web Project, your WAR file is typically in:
#   - Eclipse: /build/Donationwebapp.war
#   - Other IDEs: Check your build output directory
COPY --chown=tomcat:tomcat build/Donationwebapp.war /usr/local/tomcat/webapps/ROOT.war
COPY --chown=tomcat:tomcat src/main/resources/schema.sql /usr/local/tomcat/schema.sql

# 3. Startup script (unchanged)
RUN echo '#!/bin/bash\n\
set -e\n\
\n\
# Parse connection details\n\
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
  sleep 2\ndone\n\
\n\
# Initialize schema if needed\n\
if ! PGPASSWORD="${JDBC_DATABASE_PASSWORD}" psql -h "${DB_HOST}" -p "${DB_PORT:-5432}" \
     -U "${JDBC_DATABASE_USERNAME}" -d "${DB_NAME}" \
     -c "SELECT 1 FROM pg_tables WHERE schemaname = '\''public'\'' AND tablename = '\''users'\''" | grep -q 1; then\n\
  echo "Initializing database schema..."\n\
  psql -h "${DB_HOST}" -p "${DB_PORT:-5432}" \
       -U "${JDBC_DATABASE_USERNAME}" -d "${DB_NAME}" -f /usr/local/tomcat/schema.sql\n\
fi\n\
\nexec catalina.sh run' > /usr/local/bin/startup.sh && \
    chmod +x /usr/local/bin/startup.sh

# 4. Final config
EXPOSE 8080
ENV PORT=8080
CMD ["/usr/local/bin/startup.sh"]
