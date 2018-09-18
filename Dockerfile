FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8


RUN apt-get update -y && apt-get install -y software-properties-common python-software-properties wget unzip apache2 apache2-utils && rm -rf /var/lib/apt/lists/*
RUN add-apt-repository ppa:ondrej/php
RUN apt-get update -y && apt-get install -y php5.6 libapache2-mod-php5.6 php5.6-ldap php5.6-mysql && rm -rf /var/lib/apt/lists/*
RUN phpenmod mcrypt
RUN phpenmod openssl
RUN wget https://github.com/bbalet/jorani/archive/v0.6.4.tar.gz
RUN rm -Rf /var/www/html
RUN tar zxvf v0.6.4.tar.gz
RUN mv /jorani-0.6.4 /var/www/html/
RUN a2enmod rewrite

COPY 000-default.conf /etc/apache2/sites-enabled/000-default.conf
COPY database.php /var/www/html/application/config/database.php
COPY email.php /var/www/html/application/config/email.php
COPY config.php /var/www/html/application/config/config.php



# Configure Apache2
ENV APACHE_RUN_USER     www-data
ENV APACHE_RUN_GROUP    www-data
ENV APACHE_LOG_DIR      /var/log/apache2
env APACHE_PID_FILE     /var/run/apache2.pid
env APACHE_RUN_DIR      /var/run/apache2
env APACHE_LOCK_DIR     /var/lock/apache2
env APACHE_LOG_DIR      /var/log/apache2

EXPOSE 80
ENTRYPOINT [ "/usr/sbin/apache2", "-DFOREGROUND" ]