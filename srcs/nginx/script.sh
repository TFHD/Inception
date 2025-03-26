#!/bin/bash

mkdir -p /etc/nginx/ssl
apt-get install openssl -y
apt-get install vim -y

nginx -g daemon off;
