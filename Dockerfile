# # Version 0.0.1
# This file needs to be in the host with Docker installed.
# Reference for indix file, http://stackoverflow.com/questions/10674867/nginx-default-public-www-location

from ubuntu:14.04
maintainer Richard Kuo "kuotie@gmail.com"

run apt-get update
run apt-get install -y nginx
run echo 'hi everyone, this is from nginx container in git' \
    > /usr/share/nginx/html/index.html
expose 80
