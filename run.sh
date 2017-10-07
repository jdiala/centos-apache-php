#!/bin/bash

grep -q "^xdebug\.remote_host" /etc/opt/rh/rh-php56/php.ini \
 || echo "xdebug.remote_host = $XDEBUG_REMOTE_HOST
" >> /etc/opt/rh/rh-php56/php.ini

/opt/rh/rh-php56/root/usr/sbin/php-fpm --daemonize

rm -f /var/run/httpd/httpd.pid

/usr/sbin/httpd -DFOREGROUND

