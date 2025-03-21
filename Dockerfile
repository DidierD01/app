# Utilise l'image officielle PHP 8.2 avec Apache
FROM php:8.2-apache

# Active le module rewrite d'Apache
RUN a2enmod rewrite

# Autorise l'utilisation des fichiers .htaccess
RUN sed -i 's|AllowOverride None|AllowOverride All|g' /etc/apache2/apache2.conf

# Ajoute le nom du serveur pour éviter un avertissement Apache
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Installe les extensions PHP nécessaires (mysqli, pdo, pdo_mysql)
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Définit le répertoire de travail
WORKDIR /var/www/html

# Copie tout le contenu du dossier `app` dans le répertoire de travail
COPY . /var/www/html/

# Donne les permissions nécessaires à Apache
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Redirige les logs Apache vers la sortie standard pour les voir dans Render
RUN ln -sf /dev/stdout /var/log/apache2/access.log && \
    ln -sf /dev/stderr /var/log/apache2/error.log

# Expose le port 80 pour Apache
EXPOSE 80
