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
    rsync \
    which \
    patch \
    && rm -rf /var/cache/yum/* \
	&& yum clean all

# 'which' is needed for drush

RUN sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/ { s/AllowOverride None/AllowOverride All/i }' /etc/httpd/conf/httpd.conf


ENV PATH "/composer/vendor/bin:$PATH"
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /composer
ENV COMPOSER_VERSION 1.4.2

RUN curl -s -f -L -o /tmp/installer.php https://raw.githubusercontent.com/composer/getcomposer.org/da290238de6d63faace0343efbdd5aa9354332c5/web/installer \
 && php -r " \
    \$signature = '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410'; \
    \$hash = hash('SHA384', file_get_contents('/tmp/installer.php')); \
    if (!hash_equals(\$signature, \$hash)) { \
        unlink('/tmp/installer.php'); \
        echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
        exit(1); \
    }" \
 && php /tmp/installer.php --no-ansi --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION} \
 && rm /tmp/installer.php \
 && composer --ansi --version --no-interaction

RUN curl https://drupalconsole.com/installer -L -o drupal.phar \
 && mv drupal.phar /usr/local/bin/drupal \
 && chmod +x /usr/local/bin/drupal

RUN composer global require drush/drush

EXPOSE 80 443

COPY index.php /var/www/html

RUN chown -R apache:apache /var/www/html \
	&& chmod 770 /var/www/html \
	&& chmod -R g+w /var/www/html

COPY run.sh /run.sh
RUN chmod a+rx /run.sh

ENTRYPOINT ["/run.sh"]

