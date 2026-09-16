# VDSTools

Chrome de fenêtre, barre d'outils et contrôles **macOS natifs** pour Xojo — en Xojo pur.
Aucun plugin, aucun framework externe, aucun Objective-C compilé : uniquement des `Declare`.

Cible **macOS 15** et au-delà. IDE Xojo minimum 2021r3.

Ce dépôt porte la **documentation** et les **versions distribuées**. Le source de la
bibliothèque n'y figure pas.

---

## Télécharger

Tout est dans la [dernière version](../../releases/latest) :

| Fichier | Ce que c'est |
|---|---|
| `VDSTools-x.y.z.xojo_library` | La bibliothèque compilée, à ajouter à un projet Xojo |
| `VDSToolsDemoByLib.xojo_binary_project` | Le projet de démonstration, qui utilise la bibliothèque |
| `VDSToolsDemo-x.y.z.zip` | L'application de démonstration, prête à lancer |

## Documentation

- [Référence développeur — français](docs/reference-fr.html)
- [Developer reference — English](docs/reference-en.html)

Elle couvre les 100 classes, leurs énumérations, et surtout **56 pièges** : ceux qui ont coûté
cher, avec leur symptôme, qui presque toujours pointe ailleurs que la cause.

L'application de démonstration en est le complément vivant : **34 pages**, chacune montrant un
sujet avec son extrait de code dans l'inspecteur, en français et en anglais. Une seconde
fenêtre, **Contrôles plaçables** (Cmd+4), consacre une page à chacun des 27 contrôles qu'on
pose dans l'IDE, avec toutes ses options réglables à chaud.

## Ce que ça apporte

Xojo ne donne accès ni à `NSToolbar`, ni à `NSSplitViewController`, ni à la barre latérale
source-list, ni aux tableaux à cellules riches, ni aux onglets de fenêtre, ni au menu Fenêtre
du système. VDSTools compte **100 classes**, réparties par rôle :

| Domaine | Classes | Contenu |
|---|--:|---|
| Noyau | 5 | Le pont vers le runtime Objective-C, le registre de propriétaires, l'hébergement des vues, les couleurs système |
| Fenêtre | 3 | `NSSplitViewController` comme chrome de fenêtre, les onglets, le niveau et le comportement de fenêtre |
| Barre latérale | 3 | Barre latérale plate ou hiérarchique, en style source-list |
| Barre d'outils | 7 | `NSToolbar` et ses types d'items, personnalisation comprise |
| Contrôles | 27 | Un contrôle AppKit par classe, du bouton à l'éditeur de texte riche |
| Contrôles plaçables | 27 | Ceux qu'on **pose dans l'IDE** : quinze héritent d'un contrôle Xojo, douze hébergent un objet AppKit |
| Surfaces | 9 | Popover, alerte, menus enrichis, vibrance, cadres, 3D |
| Disposition | 2 | `NSGridView` et `NSStackView` — les deux contrôles qui suppriment les coordonnées |
| Système | 17 | Barre de menus, panneaux de fichiers, QuickLook, Dock, curseurs, haptique, Finder |

## Prise en main

1. Ajouter la bibliothèque au projet Xojo.
2. Poser la licence dans `App.Opening`, **avant** qu'une fenêtre ne soit habillée :

```xojo
VDSLicence.SetLicence("Nom du licencié", "VDS01-XXXXXX-XXXXXX-XXXXXX-XXXXXX")
```

Le nom doit être recopié **exactement** tel qu'il figure sur la licence : il entre dans le
calcul du code, une espace en trop suffit à le faire refuser.

3. Habiller la fenêtre :

```xojo
mChrome = New NativeWindowChrome
mChrome.Install(mSidebar.BuildSidebarView(230, Self.Height), 230, 200, 340)
mChrome.Title = "Mon application"
```

## Licence

**L'exécution depuis l'IDE est libre** — le contrôle n'est même pas compilé sous l'IDE. Une
application **construite** sans licence valide fonctionne, mais porte un filigrane.

Les conditions d'utilisation figurent dans [CONDITIONS.md](CONDITIONS.md).

---

## English

Native macOS window chrome, toolbar and controls for Xojo, in pure Xojo — no plugin, no
external framework, no compiled Objective-C, only `Declare`s. Targets macOS 15 and later.

100 classes over what AppKit offers and Xojo does not expose, 27 of them controls you drop in
the IDE: `NSToolbar` and its customisation sheet, `NSSplitViewController` chrome, source-list
sidebars, view-based tables and outlines, window tabs, the system Window menu, QuickLook, the
Dock tile, and more.

This repository carries the documentation and the released builds; the library source is not
part of it. Grab the compiled library and the demo from the
[latest release](../../releases/latest), and read the
[English reference](docs/reference-en.html).

Running from the IDE is free; a built application needs a licence.
