# Journal des versions

## 1.7.0 — 9 novembre 2026

**Les tables.** `NativeTableView` gagne ce qu'il faut pour un vrai classeur de documents, et la
démo une fenêtre **Classeur** (⌘5) qui s'enrichit à chaque ajout.

- **`NativeTableView.CellClicked(row, column, x, y)`** : le clic simple, avec la cellule ET le
  point dans la cellule, compté depuis son coin haut gauche — de quoi ouvrir un menu à l'endroit
  cliqué. `row` et `column` sont ceux du modèle, quels que soient le tri et l'ordre des colonnes.
- **`CellKinds.Image` : une image dans n'importe quelle colonne**, là où `SetRowImage` ne pose
  qu'en tête de la première. `SetCellImage(row, column, picture)` pour une vignette à soi,
  `SetCellSymbol(row, column, name)` pour un symbole système, teinté par `SetCellTextColor`.
  Réduite sans se déformer, jamais agrandie, placée selon l'alignement de la cellule ; le texte
  de la cellule devient ce que lit VoiceOver, et reste la clé du tri.
- **`SetColumnWidths("44,84,*,90,10%")` : des largeurs qui suivent la fenêtre.** Des points,
  des pourcentages de la largeur disponible, des parts de ce qui reste (`*`, `2*`), recalculés à
  chaque redimensionnement ; la table remplit sa zone au point près. Un glisser dans l'en-tête
  garde l'unité de la colonne — et sa largeur dans une fenêtre trop étroite, la table défilant
  alors horizontalement —, et `ColumnWidths` rend l'expression du moment, à ranger dans les
  préférences. `SetColumnWidth(column, width)` pose une largeur en points. Sans expression, rien
  ne change.
- **Lignes de section : `AddSectionRow(title)`**, la ligne de groupe d'AppKit — un titre sur toute
  la largeur, collé en haut pendant que sa section défile. Elle ne se sélectionne pas (les flèches
  la sautent), ne se glisse pas, ne lève aucun clic ; le tri par défaut trie à l'intérieur de
  chaque section. `SetRowIsGroup` et `RowIsGroup` pour une ligne existante. Dans le Classeur, le
  bouton « Grouper par type ».
- **Colonnes figées : `FrozenColumns = 2`.** Les premières colonnes restent en place quand la
  table défile de côté. Deux `NSTableView` sur un même modèle, la seconde posée en vue flottante
  du même `NSScrollView` : le défilement vertical, inertie comprise, la sélection, le focus, le
  tri, les largeurs, les sections et les opérations animées passent d'une moitié à l'autre, et
  VoiceOver lit une seule table. Les indices de colonne ne changent pas, `Handle` non plus. Une
  colonne se déplace d'un côté ou de l'autre de la frontière, jamais à travers. La partie figée
  est opaque et ses colonnes gardent leur largeur sous une expression de largeur ; les sections
  ne flottent pas tant que des colonnes sont figées. Le balayage des lignes se fait sur la partie
  figée, qui tient toujours dans la vue : le geste complet y valide l'action, et sur les colonnes
  qui défilent le geste horizontal fait défiler la table. Zéro par défaut : rien ne change pour
  qui ne s'en sert pas. Dans le Classeur, l'aperçu et le nom.
- **`ColumnAtPoint` rend la colonne du modèle**, et `CellFrame` la prend, même après un
  déplacement de colonne par l'utilisateur. Les deux confondaient jusqu'ici l'ordre affiché et
  celui du modèle.
- **La barre latérale se recale seule.** Le style source-list élargit la liste au-delà de sa
  zone visible ; `NativeSidebar` et `NativeOutlineSidebar` corrigent désormais d'elles-mêmes, à
  l'ouverture comme à chaque changement de taille — diviseur, repli, fenêtre. L'appel à `Refit`
  différé après l'ouverture n'est plus nécessaire ; il reste public et sans effet de bord.
- **Un libellé de barre latérale trop long finit par « … »**. Il passait à la ligne, et la
  seconde ligne tombait hors de la cellule : « Tous les documents » s'affichait « Tous les », sans
  rien pour dire qu'il manquait un mot.

**L'inspecteur, suite.** Sept ajouts demandés par le même acheteur que la 1.6.3, après son
passage à la 1.6.3 : les declares qui lui restaient. Aucune signature existante ne change.

- **`NativePopupButton.SetItemSystemFont(index, design)`** : New York, SF Rounded ou SF Mono,
  les variantes de la police système, qui n'ont pas de nom de famille à donner à `SetItemFont`.
- **`NativePopupButton.SetItemTitle(index, title)`** : renommer un item sur place, menu ouvert ou
  non, en gardant son image et sa police.
- **`NativePopupButton.SetItemSymbol` prend une description pour VoiceOver**, en troisième
  paramètre optionnel ; sur l'icône d'un menu déroulant sans titre, c'est le nom du bouton.
- **`NativeStatusItem.SetMenuItemShortcut(index, key, modifiers)`** : changer le raccourci d'un
  item après coup, pour un raccourci que l'utilisateur enregistre.
- **`NativeTextField.FontWeight` et `LabelColor`** : demi-gras, moyen ou toute autre graisse, et
  les gris du système (secondaire, tertiaire…), qui suivent le mode sombre — le titre d'un groupe
  sous le titre gras d'une section.
- **`NativeButton.SetControlSize` règle aussi la police**, comme celui de `NativeTextField` : une
  case `Small` d'une fenêtre Lire les informations prend ses 11 points. Elle gardait jusqu'ici la
  police à 13 points.
- **Comment on a quitté un champ, et y rester sur Tab** : `NativeTextField.EndedBy` dit Retour,
  Tab, Maj-Tab, Échap ou un clic, dans `Accepted` comme dans `EditingEnded` ; l'événement
  **`TabPressed(backward)`** garde le clavier dans le champ s'il renvoie True — le seul champ d'un
  inspecteur, dont Tab filait vers le champ de recherche de la barre d'outils. Sans `nextKeyView`,
  que macOS 27 réécrit de lui-même.
- **La référence précise deux points** : le masque de redimensionnement de `NativeScrollView`,
  qui vaut 0 quand on la pose à la main, et `SetItemPicture`, dont `pointSize` est le plus long
  côté de l'image.

## 1.6.3 — 4 novembre 2026

**L'inspecteur.** Six petits ajouts et une classe, demandés par l'acheteur qui construit avec nos
contrôles un inspecteur à la manière de Pages et une fenêtre Lire les informations. Aucune
signature existante ne change : tout est méthode nouvelle ou paramètre optionnel.

- **`ToolTip` sur chaque contrôle**, à côté d'`Enabled` : `NativeButton`, `NativePopupButton`,
  `NativeSegmentedControl`, `NativeColorWell`, `NativeSwitch`, `NativeSlider`, `NativeStepper`,
  `NativeTextField`, `NativeDatePicker`, `NativeComboBox`, `NativeSearchField`,
  `NativeLevelIndicator`, `NativeTokenField`, `NativePathControl`, `NativeComboButton`. Et
  **`NativeSegmentedControl.SetSegmentToolTip(index, text)`** : une infobulle par segment.
- **La police de `NativeTextField`** : `FontSize` et `Bold`, et **`SetControlSize`**, qui règle
  le gabarit ET la police — `Small` donne les 11 points d'un inspecteur. AppKit ne relie pas les
  deux de lui-même.
- **Un champ mot de passe** : `New NativeTextField("", NativeTextField.Bezels.Square, True)` crée
  une `NSSecureTextField`, avec `Accepted`, `Changed` et le reste. `IsSecure` le dit.
- **Une saisie qui compte en quittant le champ** : `NativeTextField.AcceptsOnEndEditing = True`
  fait partir `Accepted` aussi sur Tab ou sur un clic ailleurs, et plus seulement sur Retour —
  la saisie d'un inspecteur. Et un événement **`EditingEnded(text)`**, pour la sortie du champ
  quelle qu'en soit la cause.
- **Des images, des symboles et des polices dans les items de `NativePopupButton`** :
  `SetItemPicture` pour une pastille de couleur, `SetItemSymbol` — sur le premier item d'un menu
  déroulant, c'est l'icône du bouton, le « … » du Finder —, et `SetItemFont`, chaque police dans
  sa propre face, comme le menu de Pages.
- **`NativeStatusItem`** : un raccourci affiché sur un item (`AddMenuItem(title, key,
  modifiers)`, avec `ModCommand`, `ModShift`, `ModOption`, `ModControl`), et le symbole à
  l'échelle `Large` des extras du système (`SetSymbol(…, scale)`).
- **Nouvelle classe `NativeScrollView`** : une `NSScrollView` autour d'une vue à soi, pour un
  inspecteur plus haut que sa fenêtre. `UseFlippedDocument(height)` puis `AddView`, comme dans un
  popover ; ou `SetDocumentView` pour une vue existante — un `MakeFlippedContainer` garni de
  contrôles créés par `New`. La vue suit la largeur visible ; défilement vertical seul, sans
  bordure ni fond, par défaut. Pas de `DesktopContainer` Xojo pour l'instant.
- **Documenté** : `NativeSegmentedControl.SelectedIndex = -1` ne sélectionne aucun segment, pour
  une valeur qui n'est aucun d'eux. Ça marchait déjà ; la référence ne le disait pas.
- **Dans la démonstration** : la bulle « Réglages d'export » de la page Popover devient un
  inspecteur plus haut qu'elle — destination, mot de passe et bouton Exporter sont en dessous, on
  y descend en défilant. Des pastilles devant les couleurs, chaque police dans sa face et le
  « … » du déroulant sur la page Boutons, menus et champs natifs ; une infobulle par segment et un segmenté sans
  segment choisi ; et sur la page Grille et pile, le formulaire devient un inspecteur — titre en
  gras, libellés à 11 points, un symbole par format, une destination qui compte dès qu'on quitte
  le champ, un champ mot de passe, une infobulle sur chaque réglage. L'extra de la barre de menus montre ses raccourcis, à la grande échelle. Les extraits de l'inspecteur montrent chaque nouveauté avec son code.
- 105 classes, 897 méthodes publiques, 66 pièges documentés.

## 1.6.2 — 3 novembre 2026

**Éteindre ce qui ne s'applique pas, et une bulle sous la barre d'outils.** Trois petits ajouts
demandés par l'acheteur de la 1.6.1, qui construit avec nos contrôles un inspecteur à la manière
du panneau Format de Pages. Rien d'existant ne change.

- **`Enabled` sur chaque contrôle.** Seul `NativeButton` l'avait. Les quatorze autres l'ont
  désormais, et la table aussi : `NativePopupButton`, `NativeSegmentedControl`, `NativeColorWell`, `NativeSwitch`,
  `NativeSlider`, `NativeStepper`, `NativeTextField`, `NativeDatePicker`, `NativeComboBox`,
  `NativeSearchField`, `NativeLevelIndicator`, `NativeTokenField`, `NativePathControl`,
  `NativeComboButton`. Grisé, et sourd au clic comme au clavier.
- **`NativeSegmentedControl.SetSegmentEnabled(index, enabled)`** et `IsSegmentEnabled` : un
  segment éteint, les autres actifs — Pages grise « diminuer le retrait » à la marge gauche.
- **Corrigé : un contrôle plaçable hébergé éteint restait cliquable.** Onze d'entre eux —
  `NativeColorWellControl`, `NativeComboButtonControl`, `NativeDatePickerControl`,
  `NativeLevelIndicatorControl`, `NativePathBarControl`, `NativeSearchFieldControl`,
  `NativeSegmentedButtonControl`, `NativeStepperControl`, `NativeSwitchControl`,
  `NativeTableViewControl`, `NativeTokenFieldControl` — laissaient leur contrôle AppKit allumé
  sous un canevas éteint, dessiné comme actif et agissant. Ils suivent désormais leur `Enabled`
  et offrent `SetEnabled`, comme `NativeIconButtonControl` depuis la 1.2.1. `NativeTableView` a
  aussi gagné `Enabled`.
- **`NativePopover.Show(item As NativeToolbarItem)`** : la bulle sous un bouton de barre
  d'outils, comme le « Aa » de Notes. macOS 14 ; avant, la vue de l'item s'il en a une.
- **Dans la démonstration** : le bouton Rétablir des segments momentanés est éteint ;
  l'interrupteur de la bulle garnie éteint le taux de compression et le format ; et l'item
  Dossier de la barre d'outils ouvre cette même bulle sous lui.
- 104 classes, 878 méthodes publiques, 66 pièges documentés.

## 1.6.1 — 20 octobre 2026

**Des images qui ne sont pas des symboles, et le balayage de Mail.** Trois demandes d'un même
acheteur, qui construit une application de guides illustrés avec VDSTools. Aucune signature
existante ne change : tout s'ajoute, ou prend un paramètre facultatif.

- **`NativeButton.SetPicture(source, pointSize)`** — et `NativeIconButtonControl.SetPicture`.
  Un acheteur voyait un bouton de palette (`PushOnPushOff`, `AccessoryBar`) rester vide avec
  une `Picture` tirée de PNG. **Une sonde dans la démonstration ne l'a pas reproduit** : huit
  variantes — Picture gardée ou lâchée, avant ou après le type, avec ou sans `Refit`, hors
  écran et à l'écran — ont toutes dessiné leur image. Elle a trouvé autre chose : une image de
  32 pixels faisait **32 points et débordait** du bouton. Désormais `pointSize` fixe la taille,
  et le bouton **réduit** une image trop grande (`ProportionallyDown`) au lieu de la laisser
  dépasser. La conversion passe par le nouveau `Cocoa.ImageFromPicture`, le chemin qui marchait
  chez lui.
- **`Cocoa.ImageFromPicture(pic, pointSize)`** : une `Picture` en `NSImage` comme Apple les veut
  — une taille en points, **une représentation par résolution**. Une Picture à plusieurs
  résolutions garde son 1x et son 2x.
- **Une image d'item de menu qui n'est pas un symbole.** `NativeMenu.AddItem(title, pic)` pour
  une `Picture`, et **`AddItem(title, file)` pour l'icône que le Finder montre** d'un fichier ou
  d'une application — ce qu'Apple recommande pour un menu « Déplacer vers » : toutes les
  densités, rien à fabriquer. `SetPicture(index, pic)` et `SetFileIcon(index, file)` pour un
  item existant, et `Cocoa.IconForFile` pour le reste. 16 points, visibles sous macOS 27.
  *Attention :* `AddItem("titre", Nil)` ne se compile plus — Xojo ne sait pas choisir entre
  Picture et FolderItem ; sans image, `AddItem("titre")` suffit.
- **Les actions de balayage sur `NativeTableView`**, comme dans Mail et Notes. L'événement
  `RowActions(row, edge)` demande les boutons d'un bord, `AddRowAction(title, symbol,
  destructive, background)` les ajoute — plusieurs par bord, chacun de sa couleur s'il le faut —,
  et `RowActionChosen(row, edge, index)` dit lequel a été cliqué. La
  table ne supprime rien d'elle-même : c'est l'application qui appelle `RemoveRow`. **Le geste
  complet valide la première action**, comme dans Mail — à condition que la ligne tienne
  entière dans la vue (voir plus bas).
- **`NativeTableView.SetColumnLevel(column, style, maximum, editable)`** : la jauge d'une colonne
  `CellKinds.Level` prend les quatre styles de `NSLevelIndicator` — barre continue (par défaut),
  barre en segments, pertinence, et **étoiles** (`Rating`). Éditable, elle se règle au clic, et
  la valeur part dans `CellChanged` comme une case cochée. De quoi remplacer des étoiles
  dessinées à la main par celles du système.
  **Et par cellule** : `SetCellLevelStyle(row, column, style)` donne à une ligne un autre style
  que celui de sa colonne — des étoiles ici, des segments là. Rangé dans la ligne comme
  l'alignement d'une cellule, il la suit quand on trie.
- **Corrigé dans la documentation** : la référence disait que `CopyOSHandle` rendait un objet
  dont on devenait propriétaire — c'était faux depuis le 9 octobre ; et le commentaire de
  `SetButtonType` affirmait que l'image était remise à zéro — la sonde a montré qu'elle survit.
- **Dans la démonstration** : le bouton `AccessoryBar` de la planche des bezels porte une
  Picture de 16 points ; le menu enrichi a un sous-menu « Déplacer vers » aux icônes de TextEdit,
  Aperçu et Finder ; la grande table de la page Tableau propose **Épingler** et **Fait** en
  balayant vers la droite, **Supprimer** vers la gauche. Sa dernière colonne
  devient une **note** qu'on donne en cliquant — en étoiles, et sur trois lignes en segments,
  en barre ou en traits de pertinence.
- **Corrigé : `SetColumnVisible` laissait la table déborder.** Masquer une colonne fait combler
  la place par la dernière — c'est voulu. Mais au retour de la colonne, la dernière restait
  élargie, et une barre de défilement horizontale apparaissait. Elle reprend désormais la
  largeur donnée à `AddColumn`.
- **66ᵉ piège : une table qui défile horizontalement perd son balayage.** Les gestes
  horizontaux vont aux boutons au lieu du défilement, et le geste complet ne valide plus rien.
  Ce n'est pas une limite d'AppKit : la propriété existe (`allowsFullSwipe`, absente de
  l'en-tête public, vraie par défaut) ; la table de la démonstration débordait de quelques
  points. Ramenée dans sa largeur, tout a fonctionné.
- 104 classes, 864 méthodes publiques, 66 pièges documentés.

## 1.6.0 — 19 octobre 2026 : « le modèle »

**Le dessous du tableau est refait, et rien au-dessus ne bouge.** Aucune signature n'a changé,
aucune méthode n'a été ajoutée ni retirée : les 39 méthodes publiques qui prennent un rang le
prennent toujours. Une seule propriété s'ajoute, le tri naturel, et elle est éteinte par défaut. Ce qui change est ce qu'il y a dessous — et pourquoi trois défauts de la même
famille ne peuvent plus se produire.

- **Seize tableaux parallèles deviennent une liste de lignes.** Le texte, les sous-titres, les
  info-bulles, les étiquettes, les deux couleurs et leurs drapeaux, le gras, les deux alignements
  et leurs drapeaux, l'icône, l'image, l'étiquette de ligne : tout cela vivait dans seize tableaux
  indexés par ligne × colonne. **Six endroits** devaient les parcourir tous — ajout, insertion,
  suppression, vidage, déplacement, tri — et en oublier un ne se voyait qu'au premier tri, sur un
  attribut et pas sur le texte. C'est arrivé **trois fois en deux mois** : `MoveRowModel` qui ne
  recopiait que le texte et l'icône, `SortBy` qui oubliait les sous-titres de la 1.3.2 à la 1.5.0,
  et les étiquettes qui ont failli suivre. Désormais une ligne est un objet, `NativeTableRow` :
  la déplacer déplace tout ce qu'elle porte.
- **`SortBy` et `MoveRowModel` rétrécissent de moitié** — il n'y a plus de tableaux à
  reconstruire, seulement une liste à permuter.
- **Chaque ligne porte un numéro jamais réutilisé.** Il n'est pas encore exposé : c'est le point
  d'accroche de la source de données virtuelle, qui désignera les lignes par identifiant plutôt
  que par rang.
- **L'épreuve et le banc se déclenchent à la demande**, sous `#If DebugBuild` : ils n'existent
  pas dans une application construite, et la démonstration distribuée ne les porte pas — la
  leçon de la 1.3.1, où une boucle de mesure avait voyagé.
- **Mesuré avant d'être publié**, et le résultat a décidé de la forme. Un banc remplit, trie,
  insère et vide une table de 1 000, 10 000 puis 100 000 lignes, sur la 1.5.1 puis sur chaque
  mouture de la 1.6.0. À 100 000 lignes et cinq colonnes :

  | | 1.5.1 (plat) | objet | + paresse | **1.6.0 publiée** |
  |---|---:|---:|---:|---:|
  | Remplissage | 423,6 ms | 507,7 | 310,4 | **284,6 ms** |
  | Tri | 471,3 ms | 127,3 | 128,2 | **117,4 ms** |
  | 100 insertions au milieu | 126,0 ms | 12,6 | 11,4 | **9,7 ms** |
  | Vidage | 4,7 ms | 62,4 | 40,7 | 10,4 ms |
  | Mémoire | 64,2 Mo | 218,3 | 145,3 | **40,1 Mo** |

  La dernière colonne est mesurée **sur le code livré**, gardes comprises ; trois passes
  antérieures donnaient 275 à 285 ms et 40,1 à 40,2 Mo.

  La première mouture **triplait la mémoire** : treize petits tableaux par ligne, et l'en-tête
  d'un tableau coûte plus que ses cinq cases. Ne les remplir qu'à la demande en a rendu un
  tiers ; il a fallu les sortir dans un **objet de style créé à la première écriture** pour que
  le reste parte. Une ligne ordinaire porte désormais deux objets — elle-même et son texte — là
  où le modèle plat allouait le style de chaque cellule, utilisé ou non.
- **Un défaut ancien, trouvé par l'épreuve sans l'avoir cherché — dans la table ET dans
  l'arborescence.** `InsertRow`, `RemoveRow`, `MoveRow` d'un côté, `InsertNode`, `RemoveNode`,
  `MoveNode` de l'autre, appelaient AppKit sans vérifier qu'il partageait le décompte du modèle.
  Or `AddRow` et `AddNode` ne touchent que le modèle — c'est ce qui les rend rapides dans une
  boucle, à charge pour l'appelant d'appeler `Reload` à la fin. Quelques ajouts puis une opération
  animée **sans** `Reload` annonçaient donc à AppKit un changement sur des lignes ou des enfants
  dont il ignorait l'existence : il levait une exception. Et une exception **Objective-C**
  traverse le `Try` de Xojo comme s'il n'existait pas — elle remontait jusqu'au gestionnaire
  d'AppKit, qui l'inscrivait au journal système et **abandonnait en silence** l'événement Xojo en
  cours. Ni dialogue, ni plantage, ni rapport. **19 exceptions sur la session avant la
  correction, aucune après.** C'est le **64ᵉ piège** documenté.
- **La première correction de l'arborescence était fausse, et c'est le 65ᵉ piège.** Pour savoir
  si AppKit était en retard, elle lui demandait `numberOfChildrenOfItem:` — qui **interroge la
  source de données**, donc rend le décompte du modèle. La garde comparait le modèle à lui-même
  et disait toujours oui ; l'épreuve est tombée sur un déplacement. Mesuré au même instant :
  `numberOfRows` rendait 3, `numberOfChildrenOfItem:` rendait 6. La table se garde désormais par
  `numberOfRows`, qui rend bien ce qu'AppKit tient ; l'arborescence tient elle-même un drapeau,
  levé par `AddNode` et baissé par un `Reload` complet. **Un scénario déterministe reproduit le
  défaut dans chacune — AppKit à 3, modèle à 6 — et passe.**
- **Et vérifié avant d'être publié** : une épreuve aléatoire — 400 opérations, **7 125
  vérifications d'attribut**, cinq familles relues sur chaque ligne à chaque tour — ne relève
  aucun écart. C'est elle qui prouve la promesse de cette version ; le reste n'est que vitesse.
- **Le tri naturel, en option : `SortsNaturally`.** Le tri par défaut est alphabétique : il range
  « Tâche 10 » avant « Tâche 2 », et « Tâche 100000 » entre 100 et 101. Coché, il lit chaque
  suite de chiffres comme un nombre, comme le Finder et les tables d'une application Swift. Il
  est **éteint par défaut** — le tri d'hier reste celui d'aujourd'hui tant qu'on ne le demande
  pas —, réglable aussi dans l'Inspecteur de `NativeTableViewControl`, et une table déjà triée
  par un clic d'en-tête se retrie aussitôt, en levant `SortChanged` d'abord. Une clé par ligne
  plutôt qu'un comparateur : `localizedStandardCompare:` aurait demandé quelque 1,7 million
  d'appels pour 100 000 lignes.
- **La démonstration le montre** : un bouton **« 100 000 lignes »** sur la page Tableau remplit
  la table par `AddTableRow` puis un seul `Reload` et affiche le temps pris. On trie ensuite par
  « Tâche », on coche **Tri naturel** juste dessous, et l'ordre se corrige sous les yeux. Un
  second clic sur le bouton rétablit les cinq tâches.
- 104 classes, 853 méthodes publiques, 65 pièges documentés.

**Ce qu'un acheteur doit en attendre : rien, sauf s'il coche le tri naturel.** Si quelque chose
change pour vous dans cette version, c'est un défaut — signalez-le, il sera corrigé en priorité. C'est précisément pour
pouvoir dire cela que ce chantier a sa propre version, séparée des ajouts de la 1.5.0.


## 1.5.1 — 15 octobre 2026

**Deux corrections, aucune fonction nouvelle** — cette fois le troisième chiffre dit ce qu'il dit
d'habitude.

- **Le journal d'`ObjCClass` ne parlait pas au bon moment.** Ajouté la veille pour signaler qu'une
  méthode greffée sur une classe créée à l'exécution ne remplace pas celle qui s'y trouve déjà, il
  parlait **dans les deux cas** : quand une autre implémentation avait pris la place, et quand
  c'était simplement la nôtre, posée par une instance précédente de la même classe. Un acheteur a
  compté des dizaines de lignes à l'ouverture de deux fenêtres — `VDSButtonTarget`,
  `VDSTextFieldTarget`, `VDSFlippedView`… — avec au milieu la seule qui le concernait. La
  bibliothèque **compare désormais les implémentations** : elle se tait quand celle en place est
  la sienne, et nomme la classe et le sélecteur quand elle diffère.
- **Le 63ᵉ piège est réécrit.** Il reposait sur un cas d'acheteur dont il n'était pas la cause :
  l'intéressé a mesuré que son enveloppe n'était pas dans le projet lors de l'exécution en
  question. Le mécanisme, lui, est réel et reste décrit — une classe créée à l'exécution
  n'appartient à personne, et une application qui greffe sur les nôtres prend la place sans que
  nous le sachions. Ce qui a été retiré, c'est l'attribution.
- **Un avertissement de la 1.5.0 blâmait le bon usage.** `OpensMenuOnClick` posée AVANT l'ajout de
  l'item à la barre — ce que la référence conseille et ce que la démonstration fait — écrivait
  « no remembered target » dans le journal au lancement : la barre n'avait encore rien câblé, donc
  il n'y avait rien à reposer. Le cas est maintenant silencieux. **Et il cachait un vrai trou** :
  la barre ne retenait sa cible que pour les items qui répondent au clic, si bien qu'un menu
  déroulant ajouté tel quel ne pouvait plus jamais redevenir un bouton d'action — il n'avait
  jamais vu la cible. Elle est désormais retenue par tout item ajouté.
- **`SymbolWeights` et `SymbolScales` étaient nommées sans être documentées** : la signature de
  `SetIcon` les citait, la liste des énumérations de `NativeToolbarItem` ne montrait
  qu'`ItemStyles`. Les valeurs des deux y figurent maintenant. Signalé par le même acheteur, qui
  a trouvé `SymbolWeights.Light` en essayant.

Rien d'autre ne change : aucune signature, aucun comportement.


## 1.5.0 — 14 octobre 2026

**Tout ce que le tableau ne savait pas encore faire.** Quarante-six méthodes et sept propriétés de
plus sur `NativeTableView` — les trous de son API comblés, un défaut du tri trouvé en les
comblant, et le dépôt entrant qui ferme la 1.4.0. Rien de ce qui compilait hier ne compile
autrement : aucune signature ne change.

- **Le tri laissait les sous-titres sur place.** `SortBy` reconstruisait dix tableaux parallèles
  et oubliait le onzième : le texte changeait de ligne, le sous-titre restait à la sienne. Présent
  depuis la 1.3.2, trouvé en relisant la méthode pour y ajouter les étiquettes. Même famille que
  le défaut de `MoveRowModel` corrigé en septembre — un tableau parallèle ajouté sans faire le
  tour des **six** endroits qui touchent au modèle.
- **Les lecteurs qui manquaient** : `CellBackground`, `CellHasBackground`, `CellTextColor`,
  `CellHasTextColor`, `CellBold`, `CellAlignment`, `CellVerticalAlignment`, `RowIcon`, `RowImage`,
  `ColumnTitle`, `ColumnWidth`, `ColumnKind`, `ColumnAlignment`, `ColumnVerticalAlignment`. Une
  API qui écrit sans relire oblige l'appelant à tenir son propre registre, et deux registres
  finissent par diverger.
- **Repérage** : `RowAtPoint`, `ColumnAtPoint`, `CellFrame`, aux coordonnées de la vue hôte,
  origine en haut à gauche — celles de `MouseDown`. C'est ce qui manquait pour ouvrir un menu
  contextuel sur la bonne ligne, la sélection ne suffisant pas.
- **Défilement et encarts** : `ScrollPosition`, `ScrollPositionX`, `SetContentInsets`,
  `ContentInsets`, `AutoHidesScrollers`, `HasVerticalScroller`, `HasHorizontalScroller`. Les
  encarts servent surtout à une table posée sous une barre de titre translucide, dont la première
  ligne naît sinon sous le flou.
- **Sélection** : `AllowsEmptySelection` — à `False`, la table garde toujours une ligne choisie —
  et `SelectAll`.
- **Colonnes** : `SetColumnTitle` renomme sans recréer, `SetColumnVisible` et `ColumnVisible`
  masquent sans décaler les indices.
- **Étiquettes libres** : `SetRowTag`, `SetCellTag`, `SetColumnTag` et leurs lecteurs. Une
  étiquette **voyage avec sa ligne** — tri, déplacement, insertion, suppression —, là où un
  tableau parallèle tenu par l'appelant se décale au premier tri sans rien dire.
- **Info-bulle par cellule** : `SetCellTooltip`, là où Xojo n'en a qu'une par contrôle.
- **Case indéterminée** : `SetColumnAllowsMixedState`, `SetCellCheckState`, `CellCheckState`,
  énumération `CheckStates`. `NSControlStateValueMixed` vaut **-1**, et non 2.
- **Édition et grille** : `EditCell` ouvre l'éditeur d'une cellule depuis le code,
  `SetGridColor` et `ClearGridColor` teintent les traits de grille.
- **Texte et fichiers délimités** : `Content` en lecture et en écriture, `ImportDelimited` et
  `ExportDelimited` avec les guillemets du RFC 4180 dans les deux sens.

La page Tableau de la démonstration montre les quatre qui se voient : l'info-bulle de cellule,
la case indéterminée, la colonne masquée et les encarts de contenu.

Le contrôle plaçable n'expose rien de neuf dans l'Inspecteur : tout cela s'appelle sur la table
qu'il héberge, par `Table()`. Relevé en lisant l'API de la `DesktopTable` que Xojo 2026r3 ajoute
à son framework — ce qui manquait chez nous y était nommé.

### Le dépôt entrant

**La table accepte ce qui vient du dehors** — la moitié manquante de la 1.4.0. Depuis celle-ci,
une ligne savait sortir vers TextEdit ou vers Mail ; la table, elle, n'acceptait que ses propres
lignes, et seulement si le réordonnancement était permis.

- **`AcceptDragType`**, avec les deux raccourcis **`AcceptFileDrop`** et **`AcceptTextDrop`**, et
  **`ClearDragTypes`** pour ne plus rien accepter. Rien n'est accepté tant qu'aucun type n'est
  demandé : une table qui dirait oui à tout afficherait un curseur de dépôt sur ce qu'elle ne sait
  pas lire. Les raccourcis **lisent** la constante système au lieu de recopier son texte — une
  chaîne recopiée devient fausse sans prévenir, et le dépôt échouerait alors en silence.
- **`AcceptDrop`** dit que le dépôt a eu lieu, avec la ligne ET l'endroit : `OnRow` sur la ligne,
  `BetweenRows` sur un bord — `row` est alors le rang du bord —, `OnTable` hors de toute ligne.
- **`ShouldRefuseDrop`** pour refuser au survol, avant que l'utilisateur ne lâche. Il demande ce
  qu'il faut **refuser**, comme `ShouldRefuseColumnReorder` : sans gestionnaire branché, un
  événement qui rend un Booléen rend `False`, donc poser la question à l'endroit ferait refuser
  tous les dépôts d'un appelant qui a pourtant demandé un type.
- **`DragFiles`**, **`DragText`** et **`DragHasType`**, partagées : lire ce que le dépôt porte sans
  un seul `Declare`, le pendant d'`AddDragType` qui écrit. `DragText` rend **une ligne par
  élément** — un dépôt de trois lignes en porte trois, et le presse-papiers interrogé d'un bloc ne
  rendrait que la première.
- **Un dépôt venu du dehors est une COPIE.** Ce qui vient d'ailleurs n'est pas à nous, et une autre
  application ne doit pas voir son élément s'en aller ; le réordonnancement reste un déplacement.
- **Le type privé du glisser est propre à CHAQUE table**, non à la classe — un défaut endormi
  depuis la 1.1.0, trouvé en écrivant la démonstration à deux tables. Une constante de classe
  faisait écrire le même type aux deux : glisser une ligne de l'une vers l'autre faisait prendre
  le glisser pour un réordonnancement interne, et l'indice écrit par la table de départ était lu
  comme un indice de la table d'arrivée. Conséquence voulue : pour faire passer une ligne d'une
  table à l'autre, on écrit un **type public** dans `WritingRow` et l'autre le relit par
  `DragText` — les deux tables ne savent alors rien l'une de l'autre, et la même ligne se dépose
  aussi bien dans TextEdit. Vaut aussi pour deux arborescences.
- **L'arborescence refuse** un dépôt venu du dehors : ses méthodes de source lui sont propres, à
  nœud et indice d'enfant plutôt qu'à ligne. Rien ne plante, le curseur dit non.

### Trois demandes d'acheteur, hors tableau

- **`NativeMenuToolbarItem.OpensMenuOnClick`** : un menu déroulant PUR, dont le clic ouvre le menu
  au lieu de déclencher une action et de réserver le menu à l'appui prolongé — le bouton de tri de
  Mail. Tout tient à l'action : AppKit fait du `NSMenuToolbarItem` un bouton à deux temps dès
  qu'il en a une. La propriété la retire, et **rétablit le chevron en le faisant passer par son
  contraire** : sans cet aller-retour, AppKit le dessine alors même que `ShowsIndicator` est à
  `False`. Relevé par l'acheteur, reproduit ici.
- **`SetIcon` accepte un poids et une échelle de symbole**, par deux énumérations `SymbolWeights`
  et `SymbolScales`. **Pas un `Double`**, comme la demande le proposait : `NSFontWeightRegular`
  vaut ZÉRO, et un défaut à zéro ne pourrait pas distinguer « poids ordinaire » de « ne touche à
  rien ». Les neuf poids sont **lus** sur les constantes exportées d'AppKit, par la nouvelle
  `Cocoa.ExportedDouble`, plutôt que recopiés.
- **La démonstration les montre** : page Barre d'outils de la fenêtre principale, deux cases de
  plus — le clic qui ouvre le menu, et le symbole en poids léger — à côté de celle qui existait
  pour le chevron.
- **Le silence d'`ObjCClass` est rompu.** Greffer une méthode sur une classe créée à l'exécution
  qui la porte déjà ne faisait rien, sans un mot — et c'est ce qui a coûté deux versions à un
  acheteur dont l'enveloppe de `pasteboardWriterForRow:` tenait le nom `VDSTableDS` : la nôtre
  n'était jamais posée et `WritingRow` ne partait jamais. La bibliothèque le dit maintenant dans
  le journal, et c'est le **63ᵉ piège** documenté.

La page Tableau de la démonstration porte maintenant **deux tables** : la grande, et une liste
étroite « Terminées » à côté, avec un mot d'explication sous elle plutôt qu'au bas de la page.
Une tâche passe de l'une à l'autre et revient, sur une ligne ou entre deux ; la petite **refuse au
survol** ce qu'elle a déjà, ce qui montre `ShouldRefuseDrop` à l'œuvre.

Et elle arrive **telle qu'on l'a prise** — icône et sous-titre compris. L'élément glissé porte
**deux saveurs** : `public.utf8-plain-text` pour le reste du monde, qui ne sait prendre qu'une
chaîne, et un type à nous qui porte le titre, le sous-titre et le nom de l'icône. Chacun prend ce
qu'il sait lire : TextEdit reçoit le titre seul, l'autre table reçoit la tâche entière. C'est à
cela que sert le second paramètre d'`AddDragType`, et l'`uti` de `DragText`. La démonstration y
emploie `CellSubtitle` et `RowIcon`, deux des lecteurs ajoutés plus haut.

Un fichier du Finder et du texte de TextEdit arrivent aussi, et les branchements passent par
`AddHandler maTable.Table.AcceptDrop`, le contrôle plaçable ne relayant pas ces événements.

L'application ouvre désormais **ses deux fenêtres** au lancement, la principale devant.

**102 classes, 853 méthodes publiques, 63 pièges documentés.**

### Et la suite, déjà nommée

**La 1.6.0 sera « le modèle ».** Tout ce qui précède est ADDITIF — aucune signature ne change,
rien de ce qui compilait hier ne compile autrement, et les deux seules corrections sont nommées
plus haut. La prochaine, elle, refera le dessous du tableau : les seize tableaux parallèles qui
rangent le texte, les styles, les étiquettes et les icônes deviendront une liste de lignes à
**identifiant**, et ces attributs suivront leur ligne par construction plutôt que par discipline.
Les signatures publiques ne bougeront pas davantage — elles prendront toujours un rang —, mais le
dessous sera neuf, et il vaut mieux que cela porte son propre numéro.

C'est ce qui ouvrira la **source de données virtuelle** : une table qui ne garde plus ses lignes
et les demande à l'application, pour les listes qui se comptent en centaines de milliers.


## 1.4.0 — 14 octobre 2026

**Une ligne peut sortir de la table sans que la table se réordonne.**

- **`AllowsRowDragging`**, nouvelle et indépendante d'`AllowsRowReordering`. Jusqu'ici, le
  réordonnancement commandait tout : à `False`, `pasteboardWriterForRow:` rendait `Nil` et le
  masque de source tombait à zéro — donc **aucun glisser ne partait**, pas même vers une barre
  latérale ou une autre application. Le nom disait « réordonner », le code disait « tout
  glisser ». Les deux se combinent désormais librement : réordonner seulement, sortir seulement,
  les deux, ou rien.
- **Le glisser vers une autre application** est permis pour la première fois, en COPIE : le
  masque de source n'était posé que pour les glissers locaux.
- **`WritingRow`** et **`AddDragType`** : l'événement est levé au moment où la ligne est saisie,
  et la méthode y pose un type de plus sans écrire un seul `Declare`. Le contrôle plaçable ne le relaie pas :
  on l'accroche sur la table qu'il héberge, `AddHandler monTableau.Table.WritingRow, AddressOf …`,
  `Table()` étant là pour ce que l'Inspecteur n'expose pas. Ce que la table écrit
  d'elle-même est l'indice de la ligne, sous un type privé qui ne veut rien dire hors d'elle :
  sans cela, un dépôt sur Mail ou sur le Finder ne recevait rien.
- La carte et la pile suivent dans tous les cas, puisqu'elles ne dépendaient que du glisser.
- Le contrôle plaçable expose la propriété dans l'Inspecteur, à côté de `AllowsRowReordering`.
- 102 classes, 805 méthodes publiques, 62 pièges documentés.

Signalé par le même acheteur, qui contournait en remplaçant `pasteboardWriterForRow:` et en
reposant le masque après chaque changement : les deux crochets peuvent partir.


## 1.3.4 — 12 octobre 2026

**Le curseur porte quelque chose hors de la table**, et la carte n'a plus de liseré clair.

- **Une pile suit le curseur dehors.** L'ombre du glisser est une vue posée DANS la table : elle
  ne pouvait rien montrer au-delà de ses bords, et l'image d'AppKit était vidée faute de contenu
  utilisable. Le curseur ne portait donc plus rien dès qu'on sortait de la liste — gênant quand
  les lignes se déposent ailleurs, sur une barre latérale par exemple. La bibliothèque compose
  désormais une **pile à la manière de Mail** : jusqu'à trois vignettes décalées, et une pastille
  rouge comptant les lignes au-delà d'une seule.
- **L'une ou l'autre, jamais les deux** : la carte tant qu'on est dans la table, la pile dès qu'on
  en sort. Montrées ensemble, elles se marchaient dessus — constaté à l'image. L'échange se fait
  **du côté de la source**, dans `draggingSession:movedToPoint:` : une vue qui n'est plus la
  destination n'a plus rien à dire sur les éléments du glisser, tandis que la source tient sa
  session d'un bout à l'autre, où que le curseur aille.
- **La vignette est un MORCEAU de la ligne, à sa taille réelle**, et non la ligne entière réduite :
  une ligne est large et basse, et rapetissée elle devient un bandeau dont on ne lit plus rien.
- **Le compte des lignes est laissé à AppKit**, qui dessine déjà sa pastille rouge : en ajouter une
  seconde en aurait donné deux.
- **Les deux bandes claires en haut et en bas de la carte** avaient deux causes, toutes deux
  corrigées. La photo, d'abord : `rectOfRow` rend la ligne ET l'espace qui la sépare de la
  suivante, et cet espace est du fond de table ; elle s'arrête maintenant où la ligne s'arrête,
  l'espacement étant lu sur `intercellSpacing` plutôt qu'écrit en dur. La carte, ensuite : elle
  gardait quatre points de marge en haut et en bas pour que son liseré ne mange pas le contenu,
  et ces quatre points laissaient voir son propre fond — blanc en apparence claire — au-dessus
  d'une ligne sélectionnée bleue. La marge est supprimée : le liseré recouvre les deux points
  extrêmes de la photo, qui sont le bord de la ligne et où rien n'est dessiné.


## 1.3.3 — 11 octobre 2026

**Trois défauts du glisser de lignes**, tous signalés avec leurs mesures.

- **L'ombre suit le curseur.** Elle n'était déplacée que depuis `validateDrop`, qu'AppKit n'appelle
  pas à chaque mouvement mais seulement quand la destination proposée change — cinq fois sur un
  glisser de 95 points, d'où des bonds de 11 à 24 points. La table est désormais instanciée depuis
  une sous-classe qui redéfinit `draggingUpdated:`, appelée à chaque mouvement. C'est le **premier
  appel à `super` de la bibliothèque**, et il est obligatoire : c'est super qui calcule la ligne
  proposée, dessine le trait d'insertion et appelle `validateDrop`. Si la sous-classe ne peut pas
  être créée, la table retombe sur la classe d'origine et l'ombre avance par bonds, comme avant.
- **Le trait d'insertion ne traverse plus l'ombre.** AppKit ajoute sa vue de destination APRÈS
  l'ombre et la repasse devant à chaque mise à jour : l'ordre des sous-vues ne peut pas gagner.
  Le calque de l'ombre porte maintenant un `zPosition` élevé, qui décide de l'ordre de dessin quoi
  qu'il arrive.
- **Le trait va au bord de ligne le plus proche.** Recadrer un dépôt « sur » une ligne en dépôt
  « au-dessus » de la même ligne renvoyait le trait au bord supérieur dès qu'on entrait dans la
  moitié basse, puis au bord suivant quand AppKit reproposait « au-dessus » : un va-et-vient à
  chaque ligne traversée.

Les trois contournements que l'acheteur avait écrits — sous-classe, `zPosition` et recadrage —
deviennent inutiles : la bibliothèque les porte.

La page Tableau de la démonstration permet de le voir : le glisser de lignes y est actif.


## 1.3.2 — 11 octobre 2026

**Le texte d'une colonne à sous-titre était tronqué**, quelle que soit la largeur de la colonne.

- **La cause** : une cellule est bâtie contre une largeur d'attente de 120 points, puis AppKit la
  redimensionne à la colonne réelle. Ce qu'on y pose ne s'étire que s'il porte un masque de
  redimensionnement — l'étiquette, la jauge et le menu en avaient un depuis toujours, la boîte
  qui empile le titre et le sous-titre n'en avait pas. Elle restait donc large de 116 points, ou
  96 avec une icône, dans une colonne de 400, et un rechargement n'y changeait rien puisqu'une
  cellule neuve sortait pareille.
- **Corrigé** : la boîte suit la cellule en largeur et en hauteur, les deux champs suivent la
  boîte en largeur et restent tenus en haut. Plus rien à faire côté appelant — ni masque posé à
  la main dans `didAddRowView`, ni reprise après `ReloadRow`.
- La page Tableau de la démonstration le montre : sa colonne à sous-titre se redimensionne, et le
  texte suit désormais le bord qu'on tire.
- Rien d'autre ne change : aucune signature, aucun autre comportement.

Signalé, mesuré et contourné par le même acheteur que la 1.3.1 — largeurs et masques relevés
cellule par cellule, ce qui ne laissait plus qu'à poser les trois masques manquants.


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
