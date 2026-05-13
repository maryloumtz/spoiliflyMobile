# Spoilifly Mobile

Application mobile Flutter inspirée du projet web `spoilifly`, connectée à la même API et pensée comme une déclinaison mobile orientée consultation, authentification et navigation dans les contenus premium.

## Objectif

Le projet répond au référentiel MDS "Projet Mobile Todo" :

- application mobile liée à un besoin métier
- navigation multi-écrans
- authentification
- connexion à une API existante
- base de widgets réutilisables
- documentation fonctionnelle, technique et graphique

## Documentation

- [Présentation du projet](docs/01-presentation-projet.md)
- [Charte graphique](docs/02-charte-graphique.md)
- [Documentation fonctionnelle](docs/03-documentation-fonctionnelle.md)
- [Documentation technique](docs/04-documentation-technique.md)
- [Résumé messagerie utilisateurs](docs/05-resume-messagerie-utilisateurs.md)

## Lancer le projet

### Front Flutter

```bash
/home/marti/flutter/bin/flutter run
```

Pour forcer une URL d'API :

```bash
/home/marti/flutter/bin/flutter run --dart-define=SPOILIFLY_API_BASE_URL=http://localhost:3000
```

### Backend Spoilifly

Le projet mobile consomme l'API du projet web situé dans :

```text
/home/marti/Documents/DeveloppementProject/spoilifly
```

Lancer le backend :

```bash
npm run dev
```

## Etat actuel

Déjà en place :

- onboarding d'accueil
- connexion / inscription
- navigation principale
- accueil
- catalogue
- bibliothèque
- profil
- écrans de détail
- widgets de champs réutilisables

Encore à renforcer :

- CRUD plus complet sur les entités métier
- création / édition de contenus côté utilisateur ou créateur
- gestion plus poussée des erreurs réseau
- finalisation documentaire au fil des nouvelles fonctionnalités
