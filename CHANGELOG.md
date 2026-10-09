# Journal des versions

## 1.3.1 — 9 octobre 2026

**Correction d'un plantage de la 1.3.0.** Sélectionner une ligne dont l'icône est une `Picture`
faisait planter une application **construite** — jamais sous l'IDE. Toute application qui emploie
les images de ligne de la 1.3.0 doit être reconstruite avec cette version.

- **La cause** : `Picture.CopyOSHandle(MacNSImage)` rend un objet **autorelâché**, malgré le
  « Copy » de son nom. La bibliothèque le relâchait après l'avoir posé, croyant en être devenue
  propriétaire : une sur-libération. La vue retenant l'image, l'affichage restait juste ; c'est au
  vidage du pool que l'image mourait sous la vue qui la désignait encore, et le plantage arrivait
  au rafraîchissement suivant — `EXC_BAD_ACCESS` dans `objc_release`, appelé depuis
  `objc_autoreleasePoolPop`, sans une seule image Xojo dans la pile.
- **Corrigé aux trois endroits** : les deux barres latérales, le tableau et l'arborescence, et
  `NativeButton.SetPicture` — où la même croyance dormait depuis la 1.1.0 sans se montrer, faute
  d'avoir jamais été appelée dans une application construite. C'est de là qu'elle avait été
  recopiée.
- **Le 62ᵉ piège**, avec sa preuve : un handle rendu par le framework Xojo est PRÊTÉ, et la
  convention « copy » d'Objective-C ne s'y applique pas.
- Rien d'autre ne change : aucune signature, aucun comportement visible.

Merci à l'acheteur qui l'a signalé avec sa pile d'appel et son tableau de cas — c'est le tableau
qui a isolé la variable, et la pile qui a donné la preuve.


## 1.3.0 — 8 octobre 2026

Une **image à soi** comme icône de ligne, là où seul un symbole SF était accepté — dans les
deux barres latérales, dans le tableau et dans l'arborescence. Tout est additif.

- **`NativeTableView.SetRowImage(row, image)`** et **`NativeOutlineView.SetNodeImage(node, image)`**
  posent une `Picture` au début de la première colonne ; `Nil` l'enlève.
- **`NativeSidebar.Add(title, image)`** ajoute une entrée dont l'icône est une image, et
  **`SetImage(index, image)`** la pose sur une entrée déjà là. La barre hiérarchique a
  **`SetImage(section, item, image)`**.
- **AUSSI PERSISTANTE QU'UN SYMBOLE**, ce qui était la demande : l'image vit dans le modèle et
  est relue à chaque construction de cellule. Elle survit donc au rechargement, au tri, au
  déplacement d'une ligne, au repli d'une section et au défilement.
- **Image et symbole s'excluent** : poser l'une efface l'autre, pour qu'il n'y ait jamais deux
  icônes à départager. Une image n'est pas teintée — `contentTintColor` ne vaut que pour un
  symbole et repeindrait une vignette en aplat — et elle est réduite proportionnellement,
  jamais agrandie.
- **Une fuite de vues corrigée dans les deux barres latérales.** Les cellules, leurs libellés,
  leurs icônes, les pastilles et les vues de ligne étaient alloués sans être rendus : cela
  fuyait à chaque construction de cellule, donc à chaque rechargement et chaque fois qu'une
  ligne redevenait visible. Neuf objets par cellule au plus. C'est la correction faite dans le
  tableau en septembre, qui n'avait pas été reportée ici — et elle devenait coûteuse avec des
  images.
- La démonstration le montre : un interrupteur sur les pages Tableau et Arborescence, et le
  disque de la barre latérale hiérarchique porte désormais une image fabriquée en code.
- 102 classes, 804 méthodes publiques, 61 pièges documentés.


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
