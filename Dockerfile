FROM tomcat:11.0-jdk21

# 1. Install only essential packages
RUN apt-get update && \
    apt-get install -y postgresql-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 2. Copy files from root (no build/ directory assumption)
COPY Donationwebapp.war /usr/local/tomcat/webapps/ROOT.war
COPY src/main/resources/schema.sql /schema.sql

# 3. Simplified startup script
RUN echo '#!/bin/sh\n\
set -e\n\
\n\
# Extract DB connection details\n\
DB_HOST=$(echo "$JDBC_DATABASE_URL" | cut -d@ -f2 | cut -d: -f1)\n\
DB_NAME=$(echo "$JDBC_DATABASE_URL" | cut -d/ -f4 | cut -d? -f1)\n\
\n\
# Wait for PostgreSQL\n\
echo "Waiting for PostgreSQL..."\n\
while ! PGPASSWORD="$JDBC_DATABASE_PASSWORD" psql -h "$DB_HOST" -U "$JDBC_DATABASE_USERNAME" -d "$DB_NAME" -c "SELECT 1"; do\n\
  sleep 2\ndone\n\
\n\
# Initialize schema\n\
PGPASSWORD="$JDBC_DATABASE_PASSWORD" psql -h "$DB_HOST" -U "$JDBC_DATABASE_USERNAME" -d "$DB_NAME" -f /schema.sql\n\
\nexec catalina.sh run' > /startup.sh && \
    chmod +x /startup.sh

# 4. Render-required settings
EXPOSE 8080
ENV PORT=8080
CMD ["/startup.sh"]
