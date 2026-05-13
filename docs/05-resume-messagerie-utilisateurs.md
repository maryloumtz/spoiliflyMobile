# Résumé - Recherche utilisateurs dans le chat

## Ce qui a été ajouté

On a ajouté une liste d'utilisateurs fictifs côté Spoilifly, puis on l'a rendue disponible dans l'application Flutter avec un appel API.

## Côté Spoilifly

Les utilisateurs fictifs ont été ajoutés dans :

```text
data/spoilifly-db.json
src/services/server/seed.ts
```

Une nouvelle route API a été créée :

```http
GET /api/users
```

Elle renvoie les utilisateurs disponibles pour le chat, sans exposer les mots de passe.

Exemple de réponse :

```json
{
  "users": [
    {
      "id": "user-ava",
      "email": "ava@spoilifly.local",
      "role": "user",
      "displayName": "Ava Theorist",
      "avatarUrl": null
    }
  ]
}
```

## Côté Flutter

Dans l'application mobile, on a ajouté :

- un modèle `UserDirectoryItem`
- un appel API `fetchUsers`
- une recherche utilisateur dans l'écran Chat

Fichiers modifiés :

```text
lib/src/core/models.dart
lib/src/services/messages_service.dart
lib/src/pages/messages_page.dart
```

## Fonctionnement dans le chat

Quand l'utilisateur ouvre le Chat :

1. l'app récupère les messages avec `GET /api/messages`
2. l'app récupère les utilisateurs avec `GET /api/users`
3. le champ destinataire permet de chercher par nom ou par email
4. quand un utilisateur est sélectionné, son email est rempli automatiquement
5. le message est envoyé avec `POST /api/messages`

## Vérifications faites

```bash
flutter analyze
flutter test
npm run lint
npx tsc --noEmit
```
