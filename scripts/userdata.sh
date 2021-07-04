#!/bin/bash

sudo apt update -y
sudo apt install nginx -y
curl http://169.254.169.254/latest/meta-data/local-ipv4 -o /var/www/html/index.html
