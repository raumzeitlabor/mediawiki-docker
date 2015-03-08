FROM phusion/baseimage:0.9.16
MAINTAINER Simon Elsbrock <simon@iodev.org>

ENV LANG en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive

CMD ["/sbin/my_init"]
VOLUME "/data"

RUN \
    echo "Acquire::Languages \"none\";\nAPT::Install-Recommends \"true\";\nAPT::Install-Suggests \"false\";" > /etc/apt/apt.conf ;\
    echo "Europe/Berlin" > /etc/timezone && dpkg-reconfigure tzdata ;\
    locale-gen en_US.UTF-8 en_DK.UTF-8 de_DE.UTF-8 ;\
    apt-get -q -y update ;\
    apt-get install -y aria2c nginx-light \
        php5-fpm \
        php5-mysql \
        php5-imagick \
        php5-mcrypt \
        php5-curl \
        php5-cli \
        php5-memcache \
        php5-intl \
        php5-gd \
        php5-xdebug \
        php5-gd \
        php5-imap \
        php-mail \
        php-pear \
        unzip \
        php-apc ;\
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN \
    echo "daemon off;" >> /etc/nginx/nginx.conf ;\
    mkdir /etc/service/nginx ;\
    echo "#!/bin/sh\n/usr/sbin/nginx" > /etc/service/nginx/run ;\
    chmod +x /etc/service/nginx/run

ADD service-php5-fpm.sh /etc/service/php5-fpm/run
RUN chmod +x /etc/service/php5-fpm/run

ADD nginx-site.conf /etc/nginx/sites-available/default
#ADD https://github.com/raumzeitlabor/logstash-docker/raw/master/logstash-fwd.conf /etc/syslog-ng/conf.d/

RUN \
    cd /tmp && aria2c -s 4 https://releases.wikimedia.org/mediawiki/1.23/mediawiki-1.23.8.tar.gz ;\
    mkdir /data && cd /data ;\
    tar xvzf /tmp/mediawiki-1.23.8.tar.gz --strip-components=1 -C /data ;\
    rm /tmp/mediawiki-1.23.8.tar.gz

ADD docker-entrypoint.sh /etc/rc.local

RUN sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini ;\
    php5dismod xdebug ;\
    chown www-data /data/images ;\
    chmod +x /etc/rc.local

EXPOSE 80
