#!/bin/bash

rm -f /var/run/httpd/httpd.pid

/usr/sbin/httpd -DFOREGROUND

