FROM tomcat:11.0-jdk21

# 1. Install dependencies
RUN apt-get update && \
    apt-get install -y postgresql-client curl && \
    apt-get clean

# 2. Copy files from ROOT directory
COPY --chown=tomcat:tomcat Donationwebapp.war /usr/local/tomcat/webapps/ROOT.war
COPY --chown=tomcat:tomcat src/main/resources/schema.sql /usr/local/tomcat/schema.sql

# 3. Startup script
RUN echo '#!/bin/bash\n\
set -e\n\
\n\
# Parse connection details from Render environment\n\
DB_HOST=$(echo "$JDBC_DATABASE_URL" | awk -F[@:/] '\''{print $4}'\'')\n\
DB_NAME=$(echo "$JDBC_DATABASE_URL" | awk -F/ '\''{print $NF}'\'' | awk -F? '\''{print $1}'\'')\n\
\n\
echo "Waiting for PostgreSQL at ${DB_HOST}:5432..."\n\
until PGPASSWORD="$JDBC_DATABASE_PASSWORD" psql -h "$DB_HOST" -U "$JDBC_DATABASE_USERNAME" -d "$DB_NAME" -c "SELECT 1" >/dev/null 2>&1; do\n\
  echo "PostgreSQL not ready - retrying in 2 seconds..."\n\
  sleep 2\ndone\n\
\n\
# Initialize schema if needed\n\
if ! PGPASSWORD="$JDBC_DATABASE_PASSWORD" psql -h "$DB_HOST" -U "$JDBC_DATABASE_USERNAME" -d "$DB_NAME" \\
     -c "SELECT 1 FROM pg_tables WHERE schemaname = '\''public'\'' AND tablename = '\''users'\''" | grep -q 1; then\n\
  echo "Initializing database schema..."\n\
  psql -h "$DB_HOST" -U "$JDBC_DATABASE_USERNAME" -d "$DB_NAME" -f /usr/local/tomcat/schema.sql\n\
fi\n\
\nexec catalina.sh run' > /usr/local/bin/startup.sh && \
    chmod +x /usr/local/bin/startup.sh

# 4. Port configuration (required by Render)
EXPOSE 8080
ENV PORT=8080
CMD ["/usr/local/bin/startup.sh"]
