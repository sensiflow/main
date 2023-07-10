#!/bin/bash

NGINX_SECURE=$1
API_SECURE=$2

cd /nginx-files


cp -r ./static /static

if [ "$NGINX_SECURE" = 'true' ]; then
    echo "Using nginx with ssl"
    cp ./confs/nginx-secure.conf /etc/nginx/nginx.conf
else
    echo "Using nginx without ssl"
    cp ./confs/nginx-unsecure.conf /etc/nginx/nginx.conf
fi

if [ "$API_SECURE" = 'true' ]; then
    echo "Using api with ssl"
    sed -i 's/proxy_pass http:/proxy_pass https:/' /etc/nginx/nginx.conf
   
else
    echo "Using api without ssl"
    #Do nothing as this is the default
fi

