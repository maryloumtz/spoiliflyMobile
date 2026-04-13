# Charte graphique

## Direction visuelle

L'application adopte une direction "premium dark" inspirée de `spoilifly` :

- fond sombre bleu nuit
- accents ambrés pour les éléments importants
- couleur secondaire menthe / cyan doux pour les halos et contrastes
- cartes translucides avec bordures légères
- formes très arrondies pour donner un rendu moderne mobile

## Palette principale

### Couleurs d'interface

- `#040B13` : fond principal
- `#0F1823` : surface de carte
- `#172332` : surface secondaire
- `#13202F` : fond des champs

### Couleurs d'accent

- `#F2BF75` : couleur primaire, CTA, highlights
- `#8ED8C3` : couleur secondaire, éléments de soutien

### Couleurs d'état

- rouge translucide pour les erreurs
- texte blanc et blancs atténués pour la hiérarchie

## Principes UI

- les CTA importants utilisent la teinte ambre
- les cartes utilisent un fond sombre semi-transparent
- les bordures sont discrètes et peu contrastées
- les badges et chips gardent toujours le même rayon
- les écrans doivent rester cohérents entre mobile étroit et large

## Typographie

Faute de police de marque dédiée ajoutée au projet, la hiérarchie typographique repose sur :

- titres lourds et compacts
- sous-titres en blanc atténué
- labels et méta-informations avec espacement plus marqué

## Formes et rayons

- grandes cartes : rayon autour de `28-36`
- champs : rayon autour de `18-20`
- chips / badges : rayon très élevé de type "pill"

## Composants communs

Composants graphiques déjà standardisés :

- `AppScaffold`
- `AppTextField`
- `AppPasswordField`
- `WorkCard`
- `StatusViews`

## Règles de cohérence

- ne pas changer de palette entre les écrans
- ne pas multiplier les styles de champs
- garder les mêmes règles de boutons primaires / secondaires
- conserver la même logique de cartes translucides et halos lumineux

## Intention produit

Le rendu doit évoquer :

- une application de contenus premium
- une navigation claire
- une ambiance éditoriale et cinématographique
- une continuité esthétique avec le projet web `spoilifly`
