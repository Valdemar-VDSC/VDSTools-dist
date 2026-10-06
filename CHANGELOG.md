# Journal des versions

## 1.2.1 — 6 octobre 2026

Correction d'un contrôle, et le piège qui allait avec. **Rien à changer dans les projets qui
emploient la bibliothèque**, sauf à vouloir griser un bouton à icône.

- **`NativeIconButtonControl` suit `Enabled`.** Le contrôle héberge un `NSButton` ; `Enabled`
  appartient à `DesktopCanvas`, qu'une sous-classe ne peut pas redéfinir, et AppKit ne le
  propage pas aux sous-vues. Le canevas s'éteignait donc seul, tandis que le bouton restait
  dessiné comme actif — et, puisqu'il est au-dessus, il continuait de recevoir les clics.
  Désormais le bouton suit `Enabled` au dessin suivant, un clic est refusé dès que le contrôle
  est éteint, sans attendre aucun dessin, et **`SetEnabled`** fait les deux sur le champ.
- **La démonstration le montre** : la page Bouton à icône des Contrôles plaçables gagne un
  interrupteur `Enabled`, à côté de ceux du symbole et du bezel.
- **Un piège mesuré de plus**, avec sa note : les douze autres contrôles hébergés ont le même
  angle mort, sans conséquence visible pour ceux qui ne font que montrer.
- 102 classes, 799 méthodes publiques, 61 pièges documentés.


## 1.2.0 — 6 octobre 2026

Version de barre latérale, née d'un commentaire sur le forum. **Tout est additif** :
`SelectionChanged` ne change pas, aucun programme existant n'est à réécrire.

- **`NativeSidebarItem`** : la poignée d'une ligne — `Tag`, `Title`, `Section`, `Index`, `Page`,
  `IsValid`. Le lien vers la barre est faible : garder des poignées ne retient pas en vie une
  fenêtre fermée.
- **Événement `SelectedItem(item, page, title)`** sur les deux barres, à côté de
  `SelectionChanged`.
- **Étiquettes.** Sans elle, un programme reconnaît une ligne par son titre, qui est traduit, ou
  par son numéro de page, qui bouge dès qu'on insère une ligne au-dessus. `AddItem` prend une
  étiquette et `LastItem` rend la poignée ; la barre plate a `SetTag` et `TagAt`, posés à part —
  une étiquette optionnelle sur `Add` aurait rendu ambigu tout appel à trois arguments.
- **Repli des sections depuis le code** : `CollapseSection`, `ExpandSection`, `SectionExpanded`,
  et `AddSection(titre, repliée)` pour démarrer fermée. Au passage, `ItemAt`, `CurrentItem` et
  `SelectPage`.
- **L'état survit à la fermeture** : `AutosaveName` le confie à AppKit ; `SaveState` et
  `RestoreState` le rendent en JSON, à ranger dans une préférence ou à joindre à un document.
- **Deux pièges mesurés de plus** : changer une procédure en fonction casse tous ses appels,
  Xojo refusant d'ignorer une valeur rendue ; et l'autosauvegarde d'un `NSOutlineView` restaure
  *pendant* `reloadData` — posée après le chargement des lignes, elle enregistre fidèlement sans
  jamais restaurer.
- Pas encore là, et demandée : une section imbriquée dans une section.
- 102 classes, 798 méthodes publiques, 60 pièges documentés.


## 1.1.1 — 18 septembre 2026

Correction de l'application de démonstration. **La bibliothèque est inchangée** : rien à
mettre à jour dans les projets qui l'emploient.

- **Chaque réglage de la fenêtre Contrôles plaçables affichait `^`** au lieu de son résultat —
  « controlSize = Petite », par exemple. Quatre constantes de la démo étaient tronquées depuis
  la 1.0.0 ; la principale, employée par tous les réglages, était réduite à son premier caractère.
- Un second en-tête « Boutons » apparaissait au-dessus du bouton à icône.
- Le pied de la barre latérale annonçait vingt-sept contrôles au lieu de vingt-huit.


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
