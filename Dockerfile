FROM composer:2.6.6 as build
WORKDIR /app
COPY . /app
RUN composer install && \
     composer update

FROM php:8.3-apache
RUN docker-php-ext-install pdo pdo_mysql

EXPOSE 8081
USER root
WORKDIR /var/www/laravel
COPY --from=build /app /var/www/laravel/
COPY docker/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY .env.example /var/www/laravel/.env
RUN chmod 777 -R /var/www/laravel/storage/ && \
    echo "Listen 8081" >> /etc/apache2/ports.conf && \
    chown -R www-data:www-data /var/www/laravel/ && \
    chmod -R a+rwx /var/www/laravel/ && \
    a2enmod rewrite