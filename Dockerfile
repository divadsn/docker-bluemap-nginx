FROM trafex/php-nginx:latest

LABEL maintainer="David Sn <divad.nnamtdeis@gmail.com>"
LABEL description="Customized version of trafex/php-nginx for BlueMap."

# Set BlueMap version
ARG BLUEMAP_VERSION=3.14

# Set user to root for installation
USER root

# Install dependencies
RUN apk add --no-cache curl unzip

# Download and extract BlueMap.jar to temporary directory
RUN tmpdir=$(mktemp -d) && \
    curl -L "https://github.com/BlueMap-Minecraft/BlueMap/releases/download/v${BLUEMAP_VERSION}/BlueMap-${BLUEMAP_VERSION}-spigot.jar" -o "${tmpdir}/BlueMap.jar" && \
    unzip "${tmpdir}/BlueMap.jar" -d "${tmpdir}" && \
    unzip "${tmpdir}/de/bluecolored/bluemap/webapp.zip" -d /var/www/html && \
    mv /var/www/html/_index.php /var/www/html/index.php && \
    chown -R nobody:nobody /var/www/html && \
    rm -rf "${tmpdir}"

# Patch index.php to use database credentials from environment variables
RUN sed -i 's/\$hostname = .*/$hostname = getenv("MYSQL_HOSTNAME");/' /var/www/html/index.php && \
    sed -i 's/\$port = .*/$port = getenv("MYSQL_PORT");/' /var/www/html/index.php && \
    sed -i 's/\$username = .*/$username = getenv("MYSQL_USERNAME");/' /var/www/html/index.php && \
    sed -i 's/\$password = .*/$password = getenv("MYSQL_PASSWORD");/' /var/www/html/index.php && \
    sed -i 's/\$database = .*/$database = getenv("MYSQL_DATABASE");/' /var/www/html/index.php

# Copy nginx configuration
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/conf.d /etc/nginx/conf.d/

# Set user back to nobody
USER nobody
