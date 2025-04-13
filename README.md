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
