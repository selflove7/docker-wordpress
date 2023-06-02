ARG BASE_TAG=php7.4-apache

FROM wordpress:${BASE_TAG}

RUN apt-get update && \
  apt-get install -y msmtp libmemcached-dev zlib1g-dev && \
  pecl install memcached && \
  apt-get clean

ADD apache2-entrypoint.sh /usr/local/bin/
ADD common-config.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/apache2-entrypoint.sh
RUN chmod +x /usr/local/bin/common-config.sh

ENTRYPOINT [ "apache2-entrypoint.sh" ]
CMD [ "apache2-foreground" ]
