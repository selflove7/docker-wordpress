FROM ubuntu

ARG WORDPRESS_VERSION=latest

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_PRIORITY=critical

# Install Apache, PHP, and other dependencies
RUN apt-get update && \
    apt-get install -y apache2 php libapache2-mod-php php-mysql wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
# Download and extract WordPress files
RUN wget -O wordpress.tar.gz https://wordpress.org/latest.tar.gz && \
    tar -xvf wordpress.tar.gz -C /var/www/html/ && \
    rm wordpress.tar.gz
    
# Add the ServerName directive to the Apache configuration
RUN echo "ServerName 127.0.0.1" >> /etc/apache2/apache2.conf

# Set the working directory
WORKDIR /var/www/html/wordpress

# Create the uploads directory and set ownership and permissions
RUN mkdir -p /var/www/html/wordpress/wp-content/uploads && \
    chown -R www-data:www-data /var/www/html/wordpress && \
    chmod -R 755 /var/www/html/wordpress && \
    chown -R www-data:www-data /var/www/html/wordpress/wp-content/uploads
    
# Expose port 80
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2ctl", "-D", "FOREGROUND"]
