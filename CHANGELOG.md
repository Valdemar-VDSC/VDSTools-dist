# Journal des versions

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
