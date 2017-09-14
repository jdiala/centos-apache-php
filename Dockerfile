FROM centos:centos7
MAINTAINER Jovette Diala <jdiala@keymind.com>

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

RUN	yum -y update \
	&& yum --setopt=tsflags=nodocs -y install \
    httpd \
    mod_ssl \
    php56w \
    php56w-opcache \
    php56w-mysqlnd \
    php56w-mbstring \
    php56w-dom \
    php56w-gd \
    && rm -rf /var/cache/yum/* \
	&& yum clean all

RUN sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/ { s/AllowOverride None/AllowOverride All/i }' /etc/httpd/conf/httpd.conf

EXPOSE 80 443

COPY index.php /var/www/html

RUN chown -R apache:apache /var/www/html \
	&& chmod 770 /var/www/html \
	&& chmod -R g+w /var/www/html

COPY run.sh /run.sh
RUN chmod a+rx /run.sh

ENTRYPOINT ["/run.sh"]

