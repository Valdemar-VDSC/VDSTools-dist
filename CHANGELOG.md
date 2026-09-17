# Journal des versions

## 1.1.0 — 17 septembre 2026

- **`NativeIconButtonControl`** : un bouton à icône qu'on pose dans l'IDE, 28ᵉ contrôle plaçable.
  Symbole SF, position de l'icône, icône collée au titre, bezel et gabarit dans l'inspecteur ;
  image de fichier ou `Picture` par le code.
- **`NativeButton`** : `ImagePosition` et `ImageHugsTitle`, avec les neuf positions d'AppKit,
  plus `SetImage` et `SetPicture`.
- **Deux pièges mesurés de plus** : Xojo efface l'image d'un bouton hérité à chaque passage —
  d'où un contrôle hébergé plutôt qu'un héritage ; et une icône `Above` sort le titre hors du
  cadre avec le bezel `Push`.
- 101 classes, 774 méthodes publiques, 58 pièges documentés.

## 1.0.0 — 16 septembre 2026

Première version distribuée.

- **100 classes**, dont 27 contrôles à poser dans l'IDE.
- **macOS 27** : visibilité des images de menu (`preferredImageVisibility`) et effet de verre
  interactif (`effectIsInteractive`), tous deux inertes sur un système antérieur.
- **Glisser de lignes** dans les tableaux et les arborescences, avec une ombre à la manière de
  Numbers : la ligne d'origine reste en place et sélectionnée, une copie suit le curseur.
- **Champs de texte** posés dans des cadres de groupe dans la démonstration : sous macOS 27 le
  fond de fenêtre clair est blanc pur, et un champ posé à même la fenêtre ne se distinguait plus.
- Référence développeur en français et en anglais, **56 pièges** documentés.
