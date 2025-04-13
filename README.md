# 🧠 Inception - Projet Docker de l'école 42

## 📚 Sujet

**Inception** est un projet du cursus de l'école 42 visant à initier les étudiants à la virtualisation en utilisant **Docker**. L’objectif principal est de créer une infrastructure complète et fonctionnelle, basée sur des conteneurs, tout en respectant des contraintes précises de sécurité et d’organisation.

---

## 🎯 Objectifs

- Mettre en place un serveur **WordPress** avec une base de données **MariaDB**.
- Héberger ces services dans des **conteneurs Docker** distincts.
- Utiliser **Docker Compose** pour orchestrer les conteneurs.
- Protéger les connexions avec **Nginx** en HTTPS (via **certificats TLS auto-signés**).
- Rendre l’ensemble **persistant** (volumes) et **sécurisé** (droits, utilisateurs).
- S’assurer que l’architecture est modulaire et maintenable.

---

## 🧱 Architecture du projet

Voici un aperçu des services généralement attendus dans ce projet :

![image](https://github.com/user-attachments/assets/97a318d9-b3e7-4fe5-ac63-d6f7bdd7a573)

inception/ </br>
   │</br>
   ├── srcs/</br>
   ├── docker-compose.yml </br>
   ├── requirements/</br>
   │   ├── nginx/ </br>
   │   ├── wordpress/</br>
   │   └── mariadb/</br>
   └── .env</br>
   └── README.md</br>

---

## 💾​ Composition du projet :

Comme dit ci-dessus vous devez architecturer votre projet et votre réseau comme le demmande sujet. Il faut donc savoir comment utiliser docker compose et savoir ce que c'est ! Docker Compose est un outil qui facilite la gestion et le déploiement d'applications multi-conteneurs. Il permet de définir et de lancer des services Docker en utilisant un fichier de configuration YAML nommé docker-compose.yml.
Docker compose sera donc votre architecte qui va deployer votre infrastructure.
Ce dernier va etre composé en trois parties :

- **Les services** (vos containers)
- **Les volumes** (vos datas)
- **Le network** (vos containers vont pouvoir communiquer en exposant des ports)

Voici un exemple dans le fichier *docker-compose.yml* :

![image](https://github.com/user-attachments/assets/481d7afc-563a-4287-9e46-369faa2447d3)

Ceci est la déclaration du containers Nginx c'est donc un service comme Mariadb ou Wordpress. Je vais vous expliquer ce que veux dire ces quelques lignes :

- **container_name** : on donne ici le nom de notre image nginx le meme nom que son container (demandé dans le sujet)
- **build** : on indique ou le fichier Dockerfile se trouve pour build notre image (car oui chaque container va posseder un Dockerfile, c'est en quelques sorte notre fichier d'instructions)
- **networks** : on spécifie ici a quel network va appartenir notre container (évidemment tous les containers seront dans notre network "inception")
- **volumes** : on indique si notre container va etre doté d'un volume pour stocker des données, pour Nginx il va appartenir au volume "wordpress" dans le fichier "/var/www/html"
- **depends_on** : lors du lancement de notre docker-compose.yml, il faut quand meme preciser si un container en dépend d'un autre ou pas pour son bon foncionnement (par exemple dans le container wordpress, ce dernier a besoin que MariaDB soit ON pour accéder aux valeurs de sa base de données pour les users)
- **ports ou expose** : Certains containers vont avoir besoin d'un port ou d'un expose pour pouvoir communiquer entre eux, la différence entre les deux c'est qu'un port rend un service accessible depuis l’extérieur de Docker et un expose indique que le container écoute sur un ou plusieurs ports, sans les rendre accessibles à l’extérieur. Ici seulement le container Nginx va etre doté d'un port car il est le seul point d'entrée de notre infrastructure (demandé par le sujet et hors bonus) donc par conséquence les autres containers seront doté d'exposes. "443:443" veut dire que le port 443 (droite des :) est mappé vers le port 443 (gauche des :) sur la machine hôte.
- **restart** : le sujet demande a ce qu'en cas de crash le coontainer doit se relancer c'est pour cela que dans le projet il existe plusieurs flag de restart et le notre sera "on-failure"
- **env_file** : on peut ajouter a nos containers des variables d'environnements (utile pour les mots de passes, clées API ou bien logins)

![image](https://github.com/user-attachments/assets/010b0015-1d36-40c1-ac1f-522c419b1e96)

Voici un bref résumé de ce que vous pouvez retrouver dans un fichier docker-compose.yml

---

## 📂​ Nginx : 

-> Nginx est un serveur web ultra-performant, aussi utilisé comme "Reverse proxy", "Load balancer", "Serveur de cache", "Proxy pour applications web". Pour le projet Nginx sera utilisé de plusieurs maniere :

- Il peut servir des fichiers statiques (HTML, CSS, images, etc.) très rapidement, bien plus efficacement qu’Apache dans certains cas.
- Il agit comme un intermédiaire entre les clients et un ou plusieurs serveurs internes. Exemple : il reçoit une requête et la redirige vers un service WordPress ou une API.
- Il peut gérer le chiffrement SSL pour sécuriser la communication avec les utilisateurs (via certificats TLS auto-signés ou officiels).
- Il peut répartir la charge entre plusieurs serveurs (backend), pour éviter qu’un seul serveur ne soit surchargé.
- Il peut stocker temporairement des réponses pour accélérer les temps de chargement et réduire la charge serveur.

Bon apres savoir ce qu'est Nginx il est temps de l'installer et le configurer ! Attaquons nous au Dockerfile du container (j'ai mis certains commentaire pour vous aider a mieux comprendre ces lignes).

```dockerfile
FROM debian:bullseye

RUN apt update -y && apt upgrade -y && apt install -y nginx openssl

#SETUP SSL KEY
RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/certificate.crt -keyout /etc/nginx/ssl/certificate.key -subj "/C=FR/ST=NA/L=Angouleme/O=42/OU=42/CN=$DOMAIN_NAME/UID=sabartho"

#CREATE /var/run/nginx DIRECTORY AND COPY NGINX CONFIG
RUN mkdir -p /var/run/nginx
COPY ./conf/nginx.conf /etc/nginx/conf.d

#SET PORT 443 FOR INTERNET LIKE SUBJECT ASK
EXPOSE 443

#LAUNCH NGINX ("-g" ALLOW FOR EDIT THE MAIN FILE CONFIG ; "daemon off" ALLOW NGINX TO RUN IN THE FOREGROUND)
CMD ["nginx", "-g", "daemon off;"]
```

Pour chaque container on va avoir besoin d'une image ou en d'autre terme un moyen un starter-pack, sur quel OS on va tourner ou meme est ce qu'on a besoin d'un OS pourquoi pas prendre directement juste Nginx ?

Le sujet demande a ce que les images utilisés soient seulement les versions dites "old-stable" de Debian ou de Alpine (Trop dommage on aurait pu télécharger des images préfaites ça aurait été plus simple et moins loooooong 🫠​)

Donc je préfere utiliser debian par préférence et car je connais mieux l'OS et pour ce qui est de la version aujourd'hui le 13/04/2025 la version old-stable est "Bullseye" donc notre image va etre debian:bullseye pour tout nos fichiers dockers.

`FROM debian:bullseye`

Oo va devoir aussi creer notre certificat SSL/TLS signé par nous meme

`openssl req -x509 -nodes -out /etc/nginx/ssl/certificate.crt -keyout /etc/nginx/ssl/certificate.key -subj "/C=FR/ST=NA/L=Angouleme/O=42/OU=42/CN=$DOMAIN_NAME/UID=sabartho"`


Pour la config de Nginx on va devoir changer quelques valeurs pour que containers reponde aux exigeances du sujet 🫵

```nginx
server {
    listen      443 ssl;
    server_name $DOMAIN_NAME www.$DOMAIN_NAME;
    root    /var/www/html/;
    index index.php;

    ssl_certificate     /etc/nginx/ssl/certificate.crt;
    ssl_certificate_key /etc/nginx/ssl/certificate.key;
    ssl_protocols       TLSv1.2 TLSv1.3;
    ssl_session_timeout 10m;
    keepalive_timeout 70;

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass wordpress:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
    }
[...]
```

On dit ici que notre serveur va écouter sur le port 443, le nom de notre serveur sera donc $DOMAIN_NAME (valeur dans le .env), que sa racine est /var/www/html et que la page par defaut sera index.php.

On précise aussi les certificats SSL utilisés (ceux qu'on a générés plus tot) et aussi le protocole utilisé : `TLSv1.2 TLSv1.3` (demandé par le sujet)

On doit aussi dire a Nginx d'envoyer nos requetes php `location ~ \.php$` vers wordpress `wordpress:9000` car Nginx ne sait pas exécuter du PHP tout seul, il faut un intermédiaire pour envoyer le fichier .php à un interpréteur PHP, récupérer le résultat, puis le renvoyer au navigateur.

On va utiliser FastCGI pour interpreter notre PHP. FastCGI est un protocole de communication qui permet à un serveur web (comme Nginx) de parler avec un interpréteur d’un langage serveur (comme PHP, Python...). Plus précisément, c’est un pont entre le serveur web et le moteur d’exécution du code dynamique.

C’est là que FastCGI entre en jeu :
Nginx transmet la requête via FastCGI → PHP-FPM (dans le container wordpress d'ou le wordpress:9000) exécute le code → Nginx récupère la réponse → et l’envoie au client.

---

## 📂​ MariaDB : 

-> Il nous faut stocker tous nos users et d'autres données utiles pour que Wordpress puisse y acceder. MariaDB est un système de gestion de base de données relationnelle (SGBD), open-source, basé sur MySQL. Si vous faites la je vous fait pas un cours vous devez surement savoir qu'est ce qu'une base de donnée ^^.

Regardon ce que dit le Dockerfile :

```dockerfile
FROM debian:bullseye

RUN apt update -y && apt upgrade -y && apt install -y mariadb-server mariadb-client gettext-base

#EXPOSE PORT 3306 LIKE SUBJECT ASK AND COPY MARIADB CONFIG
EXPOSE 3306
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf


RUN mkdir ./entrypoint-initdb.d
COPY ./tools/init.sql.template /entrypoint-initdb.d
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld


#COPY ENTRYPOINT AND ADD EXECUTION PERMISSIONS
COPY ./tools/entrypoint.sh ./
RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
CMD ["mysqld"]
```

Bon alors en réalité il n'y pas beaucoup de choses mais quand meme quelques truc en plus par rapport a Nginx.

On installe les packages nécéssaires pour MariaDB et aussi `gettext-base` qui aura toute son importance vous aller voir.
On expose le port 3306 au sein du network, on se donne des droits, on copie les configs de MariaDB et un fichier d'execution ?

Dans ce Dockerfile, on a une nomenclature un peu bizarre :

```dockerfile
ENTRYPOINT ["./entrypoint.sh"]
CMD ["mysqld"]
```

Pour ceux qui debute en Dockerfile vous ne devez surrement pas trop connaitre le mot "ENTRYPOINT" (au passage je n'ai pas expliqué les autres termes du Dockerfile mais je pense qu'il sont plutot evident si vous les traduisez 🥹).

Un entrypoint est le point d’entrée principal d’un conteneur Docker.
C’est le programme ou script qui est exécuté automatiquement quand un conteneur démarre.

🧠 En gros :
ENTRYPOINT = "Qu’est-ce que mon conteneur est censé faire ?"

Par exemple :

- Un conteneur Nginx : son entrypoint est le binaire nginx.

- Un conteneur MariaDB : son entrypoint est le serveur de base de données.

- Un conteneur custom WordPress : souvent, c’est un script shell qui prépare l’environnement (création de config, DB, etc.)

ça se définit comme ça :

```dockerfile
ENTRYPOINT ["executable", "param1", "param2"]
```

Certains pourraient confondre l'utilité de CMD et de ENTRYPOINT, voici la petite différence :

![image](https://github.com/user-attachments/assets/24c7893b-71dd-48b8-bd7c-f3f43edd9da4)

donc une fois combiné

```dockerfile
ENTRYPOINT ["./entrypoint.sh"]
CMD ["mysqld"]
```

ça revient à lancer (vous allez comprendre pourquoi apres l'explication du script):

```bash
./entrypoint.sh mysqld
```

Regardont donc le script de plus pres :

```bash
#!/bin/bash

if [ -f /entrypoint-initdb.d/init.sql.template ]; then
  envsubst < /entrypoint-initdb.d/init.sql.template > /etc/mysql/init.sql
  rm /entrypoint-initdb.d/init.sql.template
fi

exec "$@"
```

Whoua un script tout petit c'est génial ça va pas etre trop dur ! En réalité ce script est trompeur mais vous allez voir c'est pas tres dur a comprendre !

Premierement, la condition "if" sera executé si le fichier "-f /entrypoint-initdb.d/init.sql.template" existe.

Ensuite heuuuu `envsubst < /entrypoint-initdb.d/init.sql.template > /etc/mysql/init.sql` wtf ?
Tout a l'heure je vous avait dit qu'on avait installé un package `gettext-base` et je ne vous avait pas expliqué pourquoi. Eh bien `gettext-base` est un package de Ubuntu/Debian, il contient des outils de base pour la gestion de traduction, mais surtout la commande `envsubst` = **"environment substitute"**. C’est un outil qui remplace les variables d’environnement dans des fichiers texte.

Donc c'est a dire qu'on va changer toutes les variables d'environnement $USER1, $USER2 par les vraies variables : sabartho, sabartho1 du fichier `entrypoint-initdb.d/init.sql.template` et creer ce fichier remplacement qui se nommera `init.sql` dans `/etc/mysql/`

Voici le fichier **entrypoint-initdb.d/init.sql.template** :

```bash
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ADMIN_PASS}';
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
CREATE USER IF NOT EXISTS '${DB_USER2}'@'%' IDENTIFIED BY '${DB_PASSWORD2}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```

Pour les connaisseurs ce fichier contient des commandes **SQL** :

- `ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ADMIN_PASS}';` : change le mot de passe du 'root'@'localhost' par ${DB_ADMIN_PASS}
- `CREATE DATABASE IF NOT EXISTS ${DB_NAME}` : creation de la database ${DB_NAME} si elle n'existe pas
- `CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}`, `CREATE USER IF NOT EXISTS '${DB_USER2}'@'%' IDENTIFIED BY '${DB_PASSWORD2}` : creation de nos 2 users
- `GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%' WITH GRANT OPTION;` : on donne tous les privileges au ${DB_USER} sur la database ${DB_NAME}
- `FLUSH PRIVILEGES;` : on met a jour ces modifications de privileges

En réalité pour ceux qui auront compris ce sont des instructions qui vont etre effectuées lors du démmarage de notre container MariaDB, ce fichier va servir donc de fichier d'initialisation (mentionné dans le fichier de config qu'on a modifié) :

```mariadb
[server]
init_file = /etc/mysql/init.sql

[mysqld]
user                    = root
socket                  = /run/mysqld/mysqld.sock
port                    = 3306
datadir                 = /var/lib/mysql
skip-networking			= 0
bind-address            = 0.0.0.0
```

Voici donc notre fichier d'initialisation pret `init_file = /etc/mysql/init.sql` et notre container pret a etre lancé !

Ho mais quelle commande lance MariaDB je ne la vois nulle part 👀 ! Je ne vous ai pas parlé de la derniere ligne du fichier d'execution :

```bash
exec "$@"
```

Pour ceux qui ne connaissent pas la commande `exec`, grossierrement elle execute des commandes si vous ecrivez dans votre terminal : `exec "echo bonjour"` vous allez avoir `bonjour`.

Et `$@` représente tous les arguments passés à un script ou à une fonction, un par un, en conservant les guillemets.

Bon eh bien si on a éxécuté la commande suivante `./entrypoint.sh mysqld` on aura :

```bash
exec "mysqld"
```

Le service mysqld va donc se lancer !

---

## 📂​ Wordpress : 

Si vous etes ici c'est que vous avez survecu a mes explications GG et merci <3.

Bon passons donc a la derniere partie de ce projet, l'installation de **Wordpress** et honnetement je pense que c'est la plus simple des 3 parties.

Pour ceux qui vivent dans une caverne, WordPress est un CMS (Content Management System) — en français, un système de gestion de contenu. Il permet de créer, gérer et publier facilement un site web sans avoir à coder (ou très peu).

Voici le fichier Dockerfile du container Wordpress :

```dockerfile
FROM debian:bullseye

RUN apt update -y && apt upgrade -y && apt install -y curl php-fpm php-mysqli

#ADD RIGHTS TO /run/php
RUN mkdir -p /run/php && chown www-data:www-data /run/php

#COPY WORDPRESS CONFIG AND SET THE WORK DIR
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d
WORKDIR /var/www/html

#COPY SETUP SCRIPT AND ADD RIGHTS
COPY ./tools/script.sh .
RUN chmod +x script.sh

#SET PORTS 9000 LIKE SUBJECT ASK
EXPOSE 9000

ENTRYPOINT ["/var/www/html/script.sh"]
CMD ["php-fpm7.4", "-F"]
```

Honnetement ayant donné les explications pour MariaDB il n'y donc pas grand choses a expliquer sur ce Dockerfile, on installe les packages dont on a besoin, on copie le fichier de configuration modifié, on expose le port et on execute le script.

```dockerfile
ENTRYPOINT ["/var/www/html/script.sh"]
CMD ["php-fpm7.4", "-F"]
```

donc si vous avez bien compris c'est comme si on executais dans bash : 

```bash
./var/www/html/script.sh "php-fpm7.4", "-F"
```

Voici ce qui se trouve dans le script :

```bash
#!/bin/sh

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

chmod +x wp-cli.phar

./wp-cli.phar core download --allow-root
./wp-cli.phar config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASSWORD --dbhost=mariadb --allow-root
./wp-cli.phar core install --url=$DOMAIN_NAME --title=inception --admin_user=$WP_USER --admin_password=$WP_PASS --admin_email=$WP_MAIL --allow-root
./wp-cli.phar user create $WP_USER2 $WP_MAIL2 --role=author --user_pass=$WP_PASS2 --allow-root
./wp-cli.phar user set-role 2 editor --allow-root

./wp-cli.phar theme install astra --activate --allow-root

[...]

exec "$@"
```

Alors la il y a plus de choses a dire, mais bon en réalité c'est juste de la configuration rien d'exceptionnel.

Premierement on télécharge la WP-CLI de wordpress, mais c'est exactement ? 
C’est la version exécutable (en .phar) de WP-CLI, un outil en ligne de commande pour gérer un site WordPress sans interface graphique. Car oui il faut que quand on arrive sur notre site tout soit déja pret donc on configure avant le lancement.

Ensuite voici le détails des commandes : 

- `./wp-cli.phar core download --allow-root` : télécharge tous les fichiers de wordpress
- `./wp-cli.phar config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASSWORD --dbhost=mariadb --allow-root` : setup la DataBase avec wordpress
- `./wp-cli.phar core install --url=$DOMAIN_NAME --title=inception --admin_user=$WP_USER --admin_password=$WP_PASS --admin_email=$WP_MAIL --allow-root` : on installe et stup wordpress avec le titre, l'url et les infos de l'admin
- `./wp-cli.phar user create $WP_USER2 $WP_MAIL2 --role=author --user_pass=$WP_PASS2 --allow-root` : on creer un deuxieme user (demandé par le sujet)
- `./wp-cli.phar user set-role 2 editor --allow-root` : on met a cet user le droit d'éditer les comments (sujet de correction)
- `./wp-cli.phar theme install astra --activate --allow-root` : j'installe le theme astra parce que le theme de base est moche 😝

et on execute `php-fpm7.4 -F`
