FROM wordpress:latest

# Install things
RUN apt-get update && apt-get install -y \
	libjpeg-dev \
	libpng-dev \
#	libpng12-dev \
#	zlibc \
#	zlib1g \
	zlib1g-dev \
  mysql-client \
  wget \
  unzip \
	nano \
	sudo \
	less \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
  && docker-php-ext-install gd mysqli zip opcache

# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini


##############################################################################################
# WORDPRESS CUSTOM SETUP
##############################################################################################

# Custom scripts
# ADD vars.sh /vars.sh
ADD entrypoint.sh /entrypoint.sh
ADD plugins.sh /plugins.sh
RUN chmod +x /entrypoint.sh /plugins.sh # /vars.sh

# execute custom entrypoint script
CMD ["/entrypoint.sh"]

# Cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
