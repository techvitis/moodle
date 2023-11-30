# Use the official Ubuntu 20.04 image
FROM ubuntu:20.04

# Install necessary packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apache2 \
    git \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Add PHP repository
RUN add-apt-repository ppa:ondrej/php && apt-get update

# Install PHP 8.2 and required extensions
RUN apt-get install -y \
    php8.2 \
    php8.2-pgsql \
    libapache2-mod-php8.2 \
    graphviz \
    aspell \
    ghostscript \
    clamav \
    php8.2-pspell \
    php8.2-curl \
    php8.2-gd \
    php8.2-intl \
    php8.2-mysql \
    php8.2-xml \
    php8.2-xmlrpc \
    php8.2-ldap \
    php8.2-zip \
    php8.2-soap \
    php8.2-mbstring \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache modules
RUN a2enmod rewrite

# Copy local Moodle repository into the Docker image
COPY . /var/www/html/moodle

# Create moodledata directory
RUN mkdir /var/moodledata && chown -R www-data:www-data /var/moodledata && chmod -R 777 /var/moodledata

# Set permissions for Moodle directory
RUN chmod -R 0755 /var/www/html/moodle

# Fix deprecated string syntax
RUN find /var/www/html/moodle -type f -name '*.php' -exec sed -i 's/\${\([^}]*\)}/{$\1}/g' {} +

# Restart Apache
RUN service apache2 restart

# Expose ports
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2ctl", "-D", "FOREGROUND"]
