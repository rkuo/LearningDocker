# Version 0.0.2
# This file needs to be in the host with Docker installed.
# Reference for indix file, http://stackoverflow.com/questions/10674867/nginx-default-public-www-location

from ubuntu:14.04
maintainer Richard Kuo "kuotie@gmail.com"
env refreshed_at 2014-11-30

run apt-get update
run apt-get -y -q install nginx
run mkdir -p /var/www/html 

add nginx/global.conf /etc/nginx/conf.d/      # with / at the end
add nginx/nginx.conf /etc/nginx/nginx.conf

expose 80

