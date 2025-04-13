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
