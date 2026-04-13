# Documentation technique

## Stack

- Flutter
- Dart
- Material 3
- API HTTP du projet `spoilifly`

## Architecture actuelle

L'application est organisée autour de plusieurs dossiers :

- `lib/src/core` : configuration, session, modèles, client API
- `lib/src/services` : accès fonctionnel aux endpoints
- `lib/src/pages` : écrans
- `lib/src/widgets` : composants réutilisables

## Point d'entrée

- `lib/main.dart`
- `lib/src/app.dart`

## Configuration API

La base URL est centralisée dans :

- `lib/src/core/config.dart`

Elle peut être surchargée avec :

```bash
--dart-define=SPOILIFLY_API_BASE_URL=...
```

## Authentification

Le projet mobile consomme les routes du backend `spoilifly` :

- `/api/auth/login`
- `/api/auth/register`
- `/api/auth/me`

Le token d'accès est injecté côté client mobile pour les endpoints protégés.

## Services

Services actuellement présents :

- `AuthService`
- `CatalogService`
- `ProfileService`

## Widgets réutilisables

Widgets UI déjà extraits :

- `AppScaffold`
- `AppTextField`
- `AppPasswordField`
- `WorkCard`
- `LoadingView`
- `ErrorView`
- `EmptyView`

## Modèles

Les modèles Flutter reprennent le contrat de données du projet web `spoilifly` afin de rester alignés avec l'API existante.

## Tests et qualité

Vérifications déjà utilisées pendant le développement :

- `flutter analyze`
- `flutter test`

## Lien avec le projet web

Projet web source :

```text
/home/marti/Documents/DeveloppementProject/spoilifly
```

Le projet mobile a été pensé pour réutiliser :

- les endpoints API
- les types de données métier
- la logique de navigation produit
- l'identité visuelle générale

## Points techniques à améliorer

- mutualiser davantage les composants UI
- gérer plus finement les erreurs HTTP et CORS
- compléter les écrans liés aux fonctionnalités avancées
- introduire une gestion d'état plus structurée si la complexité augmente

## Réponse au référentiel

Le projet répond déjà techniquement aux attentes suivantes :

- plusieurs pages
- menu de navigation
- authentification
- réutilisation d'une API existante
- composants réutilisables
- documentation du projet
