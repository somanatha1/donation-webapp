FROM tomcat:11.0-jdk21

# Install PostgreSQL client for database initialization
RUN apt-get update && apt-get install -y postgresql-client && apt-get clean

# Set secure defaults
RUN useradd -m -u 1001 tomcat_user && \
    chown -R tomcat_user:tomcat_user /usr/local/tomcat && \
    chmod -R 750 /usr/local/tomcat

# Change Tomcat port configuration (FIXED)
RUN sed -i.bak \
    -e 's/port="8080"/port="9090"/g' \
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
COPY --chown=root:root --chmod=644 schema.sql /schema.sql
COPY --chown=tomcat_user:tomcat_user --chmod=750 Donationwebapp.war /usr/local/tomcat/webapps/ROOT.war

# Create database initialization script with appropriate permissions
RUN echo '#!/bin/bash\n\
set -e\n\
\n\
# Wait for PostgreSQL to be ready\n\
echo "Waiting for PostgreSQL database to be ready..."\n\
until PGPASSWORD="${POSTGRES_PASSWORD}" psql -h "${POSTGRES_HOST}" -U "${POSTGRES_USER}" -d "${POSTGRES_DB}" -c "\\q" 2>/dev/null; do\n\
  echo "PostgreSQL is unavailable - sleeping for 2 seconds"\n\
  sleep 2\n\
done\n\
\n\
echo "PostgreSQL is up - executing schema"\n\
\n\
# Run the SQL script\n\
PGPASSWORD="${POSTGRES_PASSWORD}" psql -h "${POSTGRES_HOST}" -U "${POSTGRES_USER}" -d "${POSTGRES_DB}" -f /schema.sql\n\
\n\
echo "Schema initialization complete"\n\
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
EXPOSE 9090
HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost:9090/ || exit 1

# Use our custom startup script
CMD ["/usr/local/bin/startup.sh"]



