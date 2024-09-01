FROM php:7.1-apache
# FROM apache-php-laravel
LABEL maintainer=staxx@gmail.com


# WORKDIR /var/www/html

# COPY src/ . 

# Copy application source
COPY src/ /var/www/html/
COPY .env /var/www/html/src/.env
RUN chown -R www-data:www-data /var/www/html/src


ENV DB_HOST=172.17.0.2
ENV DB_DATABASE=homestead
ENV DB_USERNAME=homestead
ENV DB_PASSWORD=securepass

RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    zlib1g-dev \
    unzip \
    zip \
    git 
   

RUN docker-php-ext-install gd pdo pdo_mysql
RUN docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg 
    
RUN docker-php-ext-install gd pdo pdo_mysql
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install
RUN php artisan migrate
RUN php artisan db:seed
RUN php artisan key:generate

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf
COPY start-apache /usr/local/bin/start-apache
RUN chmod +x /usr/local/bin/start-apache
RUN a2enmod rewrite

ENTRYPOINT ["/usr/local/bin/start-apache"]

