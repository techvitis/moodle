# Use the official Ubuntu 20.04 image
FROM ubuntu:20.04

# Install necessary packages
RUN apt-get update  
RUN apt-get install -y apache2 git  software-properties-common && rm -rf /var/lib/apt/lists/*

# Add PHP repository
RUN add-apt-repository ppa:ondrej/php && apt-get update

# Install PHP 8.0 and required extensions
RUN apt-get install -y php8.2 
RUN apt-get install -y postgresql-13 
RUN apt-get install -y postgresql-contrib 
RUN apt-get install -y php8.2-pgsql 
RUN apt-get install -y libapache2-mod-php8.0 
RUN apt-get install -y graphviz 
RUN apt-get install -y aspell 
RUN apt-get install -y ghostscript 
RUN apt-get install -y clamav 
RUN apt-get install -y php8.0-pspell 
RUN apt-get install -y php8.2-curl 
RUN apt-get install -y php8.2-gd 
RUN apt-get install -y php8.2-intl 
RUN apt-get install -y php8.0-mysql 
RUN apt-get install -y php8.2-xml 
RUN apt-get install -y php8.2-xmlrpc 
RUN apt-get install -y php8.0-ldap 
RUN apt-get install -y php8.2-zip 
RUN apt-get install -y php8.2-soap 
RUN apt-get install -y php8.2-mbstring 
RUN rm -rf /var/lib/apt/lists/*

# Enable Apache modules
RUN a2enmod rewrite

# Copy local Moodle repository into the Docker image
COPY . /var/www/html/moodle

# Create moodledata directory
RUN mkdir /var/moodledata 
RUN chown -R www-data /var/moodledata 
RUN  chmod -R 777 /var/moodledata
RUN chmod -R 777 /var/www

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
