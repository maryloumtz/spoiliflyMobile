# Documentation fonctionnelle

## Résumé

Spoilifly Mobile permet à un utilisateur de consulter des oeuvres, naviguer dans des spoilers premium, gérer sa session et retrouver sa bibliothèque personnelle via une API commune avec le projet web.

## Utilisateurs cibles

- utilisateur final consommant des contenus premium
- utilisateur connecté souhaitant retrouver ses achats
- potentiellement créateur / admin dans les futures extensions

## Fonctionnalités actuelles

### 1. Onboarding

L'application démarre sur un écran d'accueil qui présente l'univers produit et redirige vers le formulaire d'authentification.

### 2. Authentification

L'utilisateur peut :

- créer un compte
- se connecter
- visualiser / masquer son mot de passe

### 3. Accueil

L'écran d'accueil affiche :

- des oeuvres mises en avant
- les contenus récents
- les derniers spoilers publiés

### 4. Catalogue

L'utilisateur peut :

- consulter la liste des oeuvres
- rechercher
- filtrer par type
- ouvrir le détail d'une oeuvre

### 5. Détail d'oeuvre

L'utilisateur voit :

- les informations de l'oeuvre
- les spoilers associés
- les éléments de pack éventuels

### 6. Détail de spoiler

L'utilisateur peut consulter :

- le teaser
- le niveau du spoiler
- le prix
- le contenu premium si débloqué

### 7. Bibliothèque

L'utilisateur connecté retrouve ses contenus acquis ou associés à son compte.

### 8. Profil

L'utilisateur peut consulter :

- ses informations de session
- son historique d'achats
- son état connecté

## Navigation

Navigation principale actuellement présente :

- Accueil
- Catalogue
- Bibliothèque
- Profil

## Données métier principales

- utilisateur
- profil
- oeuvre
- spoiler
- pack
- achat
- bibliothèque

## Contraintes fonctionnelles

- l'application dépend du backend `spoilifly`
- certaines pages nécessitent une session authentifiée
- la disponibilité des données dépend de l'API et du token utilisateur

## Evolutions fonctionnelles prévues

- plus de CRUD métier
- édition de profil
- messages
- meetings
- checkout
- fonctionnalités créateur / admin selon avancement
