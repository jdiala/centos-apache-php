#!/bin/bash

/opt/rh/rh-php56/root/usr/sbin/php-fpm --daemonize

rm -f /var/run/httpd/httpd.pid

/usr/sbin/httpd -DFOREGROUND

