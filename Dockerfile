FROM trafex/php-nginx:latest
LABEL maintainer="David Sn <divad.nnamtdeis@gmail.com>"
LABEL description="Customized version of trafex/php-nginx for BlueMap."
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf
