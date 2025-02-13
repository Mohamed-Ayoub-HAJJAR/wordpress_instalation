**Script d'installation de WordPress**
Ce script facilite l'installation de WordPress sur un serveur local utilisant Nginx et MySQL, tout en configurant automatiquement un projet WordPress. Il est spécialement conçu pour un environnement de développement local.

**Prérequis**
Avant d'exécuter le script, assurez-vous que les éléments suivants sont installés sur votre machine :

**Nginx** : Le serveur web qui hébergera votre application.
**MySQL** : La base de données nécessaire pour WordPress.
**PHP** : PHP avec PHP-FPM pour faire fonctionner WordPress.
**wget** : Utilisé pour télécharger WordPress depuis son site officiel.
**sudo** : Permet d'exécuter certaines commandes en tant qu'administrateur.

**Installation**

Cloner le dépôt : Pour récupérer le script, commencez par cloner le dépôt :

git clone https://github.com/votre-utilisateur/nom-du-depot.git
cd wordpress_instalation

Rendre le script exécutable : Après avoir téléchargé ou cloné le script, assurez-vous qu'il soit exécutable :

chmod +x installer_wordpress.sh

Exécuter le script : Une fois le script prêt, lancez-le pour configurer votre projet WordPress. Vous serez invité à entrer des informations de connexion à la base de données pendant l'exécution.


./installer_wordpress.sh

**Étapes du script**

Nom du projet : Le script vous demandera de spécifier un nom pour votre projet WordPress.

Informations de connexion MySQL : Vous devrez fournir votre nom d'utilisateur et votre mot de passe MySQL.

Création du dossier et téléchargement de WordPress : Le script vérifiera si WordPress est déjà installé sur le serveur. Si ce n'est pas le cas, il le téléchargera et l'extraira dans le répertoire approprié.

Création de la base de données : Le script vérifiera l'existence de la base de données. Si elle n'existe pas, elle sera créée automatiquement.

Configuration de WordPress : Le fichier wp-config.php sera automatiquement configuré en fonction des informations que vous avez fournies pour la base de données.

Configuration de Nginx : Une configuration Nginx sera générée et activée pour votre projet.

Ajout du domaine dans le fichier hosts : Le script ajoutera une entrée dans le fichier /etc/hosts pour que vous puissiez accéder au projet via un domaine local, par exemple nom_du_projet.local.

Finalisation : Après avoir exécuté le script, vous pourrez finaliser l'installation de WordPress en accédant à http://nom_du_projet.local depuis votre navigateur.

Dépannage
Erreur : Nginx ne démarre pas après l'exécution du script :

Vérifiez si le port 80 est déjà utilisé par un autre service.
Exécutez sudo nginx -t pour vérifier que la configuration Nginx est correcte.
Erreur : Impossible de se connecter à la base de données :

Vérifiez les informations de connexion MySQL et assurez-vous que le service MySQL est bien en cours d'exécution.
