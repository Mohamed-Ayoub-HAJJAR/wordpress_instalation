#!/bin/bash

# Demande le nom du projet
echo "Nom du projet : "
read project_name

db_name="wp_${project_name}"
domain="${project_name}.local"

# Demande les informations de connexion MySQL
echo "Entrez le nom d'utilisateur MySQL : "
read db_user
echo "Entrez le mot de passe MySQL pour l'utilisateur $db_user : "
read -s db_password

# Création du dossier
echo "Création du dossier /var/www/$project_name"
sudo mkdir -p /var/www/$project_name

# Télécharger WordPress si ce n'est pas déjà présent
if [ ! -d "/var/www/wordpress" ]; then
    echo "Téléchargement de WordPress..."
    wget https://wordpress.org/latest.tar.gz -P /var/www/
    sudo tar -xvzf /var/www/latest.tar.gz -C /var/www/
    sudo rm /var/www/latest.tar.gz
else
    echo "WordPress déjà présent dans /var/www/"
fi

# Copier WordPress dans le dossier du projet
echo "Copie de WordPress dans /var/www/$project_name..."
sudo cp -r /var/www/wordpress/* /var/www/$project_name/

# Création de la base de données
echo "Création de la base de données..."
if ! mysql -u $db_user -p$db_password -e "USE $db_name"; then
    echo "La base de données n'existe pas, création en cours..."
    sudo mysql -u $db_user -p$db_password -e "CREATE DATABASE $db_name;"
else
    echo "La base de données $db_name existe déjà."
fi

# Configuration de wp-config.php
echo "Configuration de WordPress..."
cp /var/www/$project_name/wp-config-sample.php /var/www/$project_name/wp-config.php
sed -i "s/database_name_here/$db_name/" /var/www/$project_name/wp-config.php
sed -i "s/username_here/$db_user/" /var/www/$project_name/wp-config.php
sed -i "s/password_here/$db_password/" /var/www/$project_name/wp-config.php

# Sécuriser wp-config.php
sudo chmod 600 /var/www/$project_name/wp-config.php

# Configuration de Nginx
echo "Configuration de Nginx..."
nginx_conf="/etc/nginx/sites-available/$project_name"
echo "server {
    listen 8080;
    server_name $domain;
    root /var/www/$project_name;
    index index.php index.html;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \\.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }
    error_log /var/log/nginx/${project_name}_error.log;
    access_log /var/log/nginx/${project_name}_access.log;
}" | sudo tee $nginx_conf > /dev/null

# Activation du site
echo "Activation du site..."
sudo ln -s $nginx_conf /etc/nginx/sites-enabled/
sudo systemctl restart nginx

# Ajout au fichier hosts
echo "Ajout au fichier hosts..."
echo "127.0.0.1 $domain" | sudo tee -a /etc/hosts

echo "Installation terminée. Rendez-vous sur http://$domain:8080 pour finaliser l'installation de WordPress."
