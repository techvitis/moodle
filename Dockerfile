# Use the official Ubuntu 20.04 image
FROM ubuntu:20.04

# Install necessary packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apache2 \
    git \
    software-properties-common \
    postgresql \
    postgresql-contrib \
    && rm -rf /var/lib/apt/lists/*

# Add PHP repository
RUN add-apt-repository ppa:ondrej/php && apt-get update

# Install PHP 8.0 and required extensions
RUN apt-get install -y \RUN apt-get install -y \
    php8.0 \
    php8.0-pgsql \
    libapache2-mod-php8.0 \
    graphviz \
    aspell \
    ghostscript \
    clamav \
    php8.0-pspell \
    php8.0-curl \
    php8.0-gd \
    php8.0-intl \
    php8.0-mysql \
    php8.0-xml \
    php8.0-xmlrpc \
    php8.0-ldap \
    php8.0-zip \
    php8.0-soap \
    php8.0-mbstring \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache modules
RUN a2enmod rewrite

# Copy local Moodle repository into the Docker image
COPY . /var/www/html/moodle

# Create moodledata directory
RUN mkdir /var/moodledata && chown -R www-data /var/moodledata && chmod -R 777 /var/moodledata

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
