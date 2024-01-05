local L = LibStub("AceLocale-3.0"):NewLocale("HandyNotes_MapNotes", "frFR")
if not L then return end

-- 1 = General tab specific
-- 2 = Azeroth tab specific
-- 3 = Continent tab specific
-- 4 = Dungeon tab specific
-- 5 = Map Tabs together
-- 5 = Entrance/Exit/Passage nodes
-- 6 = Core specific
-- 7 = Specific


--1 General tab
L["Description"] = "Description"
L["Show different symbols on different maps. All symbols are clickable (except on the minimap) and have a function Map symbols work with or without the shift key. Simply change the Shift function!"] = "Affichez différents symboles sur différentes cartes.  Tous les symboles sont cliquables (sauf sur la mini-carte) et ont une fonction Les symboles de la carte fonctionnent avec ou sans la touche Maj.  Changez simplement la fonction Shift !"
L["General"] = "Général"
L["General settings that apply to Azeroth / Continent / Dungeon map at the same time"] = "Paramètres généraux qui s'appliquent simultanément à la carte Azeroth / Continent / Donjon"
L["General settings / Additional functions"] = "Paramètres généraux / Fonctions supplémentaires"
L["use Shift function!"] = "Fonction Shift !"
L["When enabled, you must press Shift before left- or right-clicking to interact with MapNotes icons. But this has an advantage because there are so many symbols in the game, including from other addons, so you don't accidentally click on a symbol and change the map, or mistakenly create a TomTom point."] = "Lorsqu'il est activé, vous devez appuyer sur Maj avant de cliquer avec le bouton gauche ou droit pour interagir avec les icônes MapNotes.  Mais cela a un avantage car il y a tellement de symboles dans le jeu, y compris ceux d'autres addons, donc vous ne cliquez pas accidentellement sur un symbole et ne changez pas la carte, ou ne créez pas par erreur un point TomTom."
L["symbol size"] = "taille du symbole"
L["Changes the size of the symbols"] = "Change la taille du symboles"
L["symbol visibility"] = "visibilité des symboles"
L["Changes the visibility of the symbols"] = "Modifie la visibilité des symboles"
L["hide minimap button"] = "masquer le bouton de la mini-carte"
L["Hide the minimap button on the minimap"] = "Masquer le bouton de la mini-carte sur la mini-carte"
L["hide MapNotes!"] = "masquer MapNotes !"
L["-> Hide all MapNotes symbols <-"] = "-> Masquer tous les symboles MapNotes <-"
L["Disable MapNotes, all icons will be hidden on each map and all categories will be disabled"] = "Désactivez MapNotes, toutes les icônes seront masquées sur chaque carte et toutes les catégories seront désactivées"
L["Adventure guide"] = "Guide d'aventure"
L["Left-clicking on a MapNotes raid (green), dungeon (blue) or multiple icon (green&blue) on the map opens the corresponding dungeon or raid map in the Adventure Guide (the map must not be open in full screen)"] = "Un clic gauche sur une icône MapNotes de raid (vert), de donjon (bleu) ou multiple (vert et bleu) sur la carte ouvre la carte du donjon ou du raid correspondant dans le Guide d'aventure (la carte ne doit pas être ouverte en plein écran)"
L["TomTom waypoints"] = "Points de cheminement TomTom"
L["Shift+right click on a raid, dungeon, multiple symbol, portal, ship, zeppelin, passage or exit from MapNotes on the continent or dungeon map creates a TomTom waypoint to this point (but the TomTom add-on must be installed for this)"] = "Maj+clic droit sur un raid, un donjon, un symbole multiple, un portail, un navire, un zeppelin, un passage ou une sortie de MapNotes sur la carte du continent ou du donjon crée un waypoint TomTom jusqu'à ce point (mais le module complémentaire TomTom doit être installé pour cela)"
L["killed Bosses"] = "boss tués"
L["For dungeons and raids in which you have killed bosses and have therefore been assigned an ID, this symbol on the Azeroth and continent map will show you the number of killed or remaining bosses as soon as you hover over this dungeon or raid symbol (for example 2/8 mythic, 4/7 heroic etc)"] = "Pour les donjons et raids dans lesquels vous avez tué des boss et auquel vous avez donc attribué un identifiant, ce symbole sur la carte d'Azeroth et du continent vous indiquera le nombre de boss tués ou restants dès que vous survolerez ce symbole de donjon ou de raid (par exemple 2/8 mythique, 4/7 héroïque etc.)"
L["gray symbols"] = "symboles gris"
L["If you are assigned to a dungeon or raid and have an ID, this option will turn the dungeon or raid icon gray until this ID is reset so that you can see which dungeon or raid you have started or completed"] = "Si vous êtes affecté à un donjon ou à un raid et que vous disposez d'un identifiant, cette option rendra l'icône du donjon ou du raid grise jusqu'à ce que cet identifiant soit réinitialisé afin que vous puissiez voir quel donjon ou raid vous avez commencé ou terminé."
L["multiple gray"] = "plusieurs gris"
L["Colors multi-points of dungeons and/or raids in gray if you are assigned to any dungeon or raid of this multi-point and have an ID so that you can see that you have started or completed any dungeon or raid of the multi-point"] = "Colore les multi-points des donjons et/ou raids en gris si vous êtes affecté à un donjon ou raid de ce multi-point et que vous disposez d'un identifiant afin que vous puissiez voir que vous avez commencé ou terminé n'importe quel donjon ou raid du multi-point."
L["enemy faction"] = "faction ennemie"
L["Shows enemy faction (horde/alliance) symbols"] = "Affiche les symboles de la faction ennemie (horde/alliance)"
L["Informations"] = "Informations"
L["Chat commands:"] = "Commandes de discussion :"
L["to show MapNotes info in chat: /mn, /MN, /mnh, /MNH, /mapnotes, /MAPNOTES, /mnhelp, /MNHELP"] = "pour afficher les informations MapNotes dans le chat : /mn, /MN, /mnh, /MNH, /mapnotes, /MAPNOTES, /mnhelp, /MNHELP"
L["to open MapNotes menu: /mno, /MNO"] = "pour ouvrir le menu MapNotes : /mno, /MNO"
L["to close MapNotes menu: /mnc, /MNC"] = "pour fermer le menu MapNotes : /mnc, /MNC"
L["to show minimap button: /mnb or /MNB"] = "pour afficher le bouton de la mini-carte : /mnb ou /MNB"
L["to hide minimap button: /mnbh or /MNBH"] = "pour masquer le bouton de la mini-carte : /mnbh ou /MNBH"
--2 Azeroth tab specific "---------"
L["Information: Individual Azeroth symbols that are too close to other symbols on the Azeroth map are not 100% accurately placed on the Azeroth map! For precise coordination, please use the points on the continent map or zone map"] = "Information : Les symboles individuels d'Azeroth qui sont trop proches des autres symboles sur la carte d'Azeroth ne sont pas placés avec précision à 100 % sur la carte d'Azeroth !  Pour une coordination précise, veuillez utiliser les points sur la carte du continent ou la carte des zones"
L["Azeroth map"] = "Carte d'Azeroth"
L["Azeroth map settings. Certain symbols can be displayed or not displayed. If the option (Activate symbols) has been activated in this category"] = "Paramètres de la carte Azeroth.  Certains symboles peuvent être affichés ou non.  Si l'option (Activer les symboles) a été activée dans cette catégorie"
L["Activates the display of all possible symbols on the Azeroth map"] = "Active l'affichage de tous les symboles possibles sur la carte d'Azeroth"
L["Show symbols of raids on the Azeroth map"] = "Afficher les symboles des raids sur la carte d'Azeroth"
L["Show symbols of dungeons on the Azeroth map"] = "Afficher les symboles des donjons sur la carte d'Azeroth"
L["Show symbols of passage to raids and dungeons on the Azeroth map"] = "Afficher les symboles de passage vers les raids et les donjons sur la carte d'Azeroth"
L["Show symbols of multiple on the Azeroth map"] = "Afficher les symboles de plusieurs sur la carte d'Azeroth"
L["Show symbols of portals on the Azeroth map"] = "Afficher les symboles des portails sur la carte d'Azeroth"
L["Show symbols of zeppelins on the Azeroth map"] = "Afficher les symboles des zeppelins sur la carte d'Azeroth"
L["Show symbols of ships on the Azeroth map"] = "Afficher les symboles des navires sur la carte d'Azeroth"
L["Show symbols of other transport possibilities on the Azeroth map"] = "Afficher les symboles des autres possibilités de transport sur la carte d'Azeroth"
L["Show all MapNotes for a specific map"] = "Afficher toutes les MapNotes pour une carte spécifique"
L["Show all Kalimdor MapNotes dungeon, raid, portal, zeppelin and ship symbols on the Azeroth map"] = "Afficher tous les symboles des donjons, raids, portails, zeppelins et navires Kalimdor MapNotes sur la carte d'Azeroth"
L["Show all Eastern Kingdom MapNotes dungeon, raid, portal, zeppelin and ship symbols on the Azeroth map"] = "Afficher tous les symboles des donjons, raids, portails, zeppelins et navires de Eastern Kingdom MapNotes sur la carte d'Azeroth"
L["Show all Northrend MapNotes dungeon, raid, portal, zeppelin and ship symbols on the Azeroth map"] = "Afficher tous les symboles des donjons, raids, portails, zeppelins et navires Northrend MapNotes sur la carte d'Azeroth"
L["Show all Pandaria MapNotes dungeon, raid, portal, zeppelin and ship symbols on the Azeroth map"] = "Afficher tous les symboles des donjons, raids, portails, zeppelins et navires de Pandaria MapNotes sur la carte d'Azeroth"
L["Show all Zandalar MapNotes dungeon, raid, portal, zeppelin and ship symbols on the Azeroth map"] = "Afficher tous les symboles des donjons, raids, portails, zeppelins et navires Zandalar MapNotes sur la carte d'Azeroth"
L["Show all Kul Tiras MapNotes dungeon, raid, portal, zeppelin and ship symbols on the Azeroth map"] = "Afficher tous les symboles des donjons, raids, portails, zeppelins et navires de Kul Tiras MapNotes sur la carte d'Azeroth"
L["Show all Broken Isles MapNotes dungeon, raid, portal, zeppelin and ship symbols on the Azeroth map"] = "Afficher tous les symboles des donjons, raids, portails, zeppelins et navires MapNotes des Îles Brisées sur la carte d'Azeroth"
L["Show all Dragon Isles MapNotes dungeon, raid, portal, zeppelin and ship symbols on the Azeroth map"] = "Afficher tous les symboles des donjons, raids, portails, zeppelins et navires de Dragon Isles MapNotes sur la carte d'Azeroth"
--3 Continent tab specific "---------"
L["Continent map"] = "Carte des continents"
L["Continent map settings. Certain symbols can be displayed or not displayed. If the option (Activate symbols) has been activated in this category"] = "Paramètres de la carte des continents.  Certains symboles peuvent être affichés ou non.  Si l'option (Activer les symboles) a été activée dans cette catégorie"
L["Activates the display of all possible symbols on the continent map"] = "Active l'affichage de tous les symboles possibles sur la carte du continent"
L["Show symbols of raids on the continant map and minimap"] = "Afficher les symboles des raids sur la carte du continent et la mini-carte"
L["Show symbols of dungeons on the continant map and minimap"] = "Afficher les symboles des donjons sur la carte du continent et la mini-carte"
L["Show symbols of passage to raids and dungeons on the continent map"] = "Afficher les symboles de passage aux raids et donjons sur la carte du continent"
L["Show symbols of multiple (dungeons,raids) on the continant map and minimap"] = "Afficher les symboles de plusieurs (donjons, raids) sur la carte du continent et la mini-carte"
L["Show symbols of portals on the continant map and minimap"] = "Afficher les symboles des portails sur la carte du continent et la mini-carte"
L["Show symbols of zeppelins on the continant map and minimap"] = "Afficher les symboles des zeppelins sur la carte du continent et la mini-carte"
L["Show symbols of ships on the continant map and minimap"] = "Afficher les symboles des navires sur la carte du continent et la mini-carte"
L["Show symbols of other transport possibilities on the continent and minimap"] = "Afficher les symboles des autres possibilités de transport sur le continent et la mini-carte"
L["Show Ogre Waygate symbols from Garrison on the Draenor continent and zone map"] = "Afficher les symboles Ogre Waygate de Garrison sur le continent et la carte des zones de Draenor."
L["Show all Kalimdor MapNotes dungeon, raid, portal, zeppelin and ship symbols on the continent map"] = "Afficher tous les symboles des donjons, raids, portails, zeppelins et navires de Kalimdor MapNotes sur la carte du continent"
L["Show all Eastern Kingdom MapNotes dungeon, raid, portal, zeppelin and ship symbols on the continent map"] = "Afficher tous les symboles des donjons, raids, portails, zeppelins et navires de Eastern Kingdom MapNotes sur la carte du continent"
L["Show all Outland MapNotes dungeon, raid, portal, zeppelin and ship symbols on the continent map"] = "Afficher tous les symboles des donjons, raids, portails, zeppelins et navires d'Outland MapNotes sur la carte du continent"
L["Show all Northrend MapNotes dungeon, raid, portal, zeppelin and ship symbols on the continent map"] = "Afficher tous les symboles des donjons, raids, portails, zeppelins et navires de Northrend MapNotes sur la carte du continent"
L["Show all Pandaria MapNotes dungeon, raid, portal, zeppelin and ship symbols on the continent map"] = "Afficher tous les symboles des donjons, raids, portails, zeppelins et navires de Pandaria MapNotes sur la carte du continent"
L["Show all Draenor MapNotes dungeon, raid, portal, zeppelin and ship symbols on the continent map"] = "Afficher tous les symboles des donjons, raids, portails, zeppelins et navires de Draenor MapNotes sur la carte du continent"
L["Show all Broken Isles MapNotes dungeon, raid, portal, zeppelin and ship symbols on the continent map"] = "Afficher tous les symboles des donjons, raids, portails, zeppelins et navires de Broken Isles MapNotes sur la carte du continent"
L["Show all Zandalar MapNotes dungeon, raid, portal, zeppelin and ship symbols on the continent map"] = "Afficher tous les symboles des donjons, raids, portails, zeppelins et navires de Zandalar MapNotes sur la carte du continent"
L["Show all Kul Tiras MapNotes dungeon, raid, portal, zeppelin and ship symbols on the continent map"] = "Afficher tous les symboles des donjons, raids, portails, zeppelins et navires de Kul Tiras MapNotes sur la carte du continent"
L["Show all Shadowlands MapNotes dungeon, raid, portal, zeppelin and ship symbols on the continent map"] = "Afficher tous les symboles des donjons, raids, portails, zeppelins et navires de Shadowlands MapNotes sur la carte du continent"
L["Show all Dragon Isles MapNotes dungeon, raid, portal, zeppelin and ship symbols on the continent map"] = "Afficher tous les symboles de donjon, raid, portail, zeppelin et navire Dragon Isles MapNotes sur la carte du continent"
--4 DungeonMap Tab specific "---------"
L["Dungeon map"] =  "Carte du donjon"
L["Dungeon map settings. Certain symbols can be displayed or not displayed. If the option (Activate symbols) has been activated in this category. Shows MapNotes exit and passage points on the dungeon map (these symbols are for orientation purposes only and nothing happens when you click on them)"] = "Paramètres de la carte du donjon.  Certains symboles peuvent être affichés ou non.  Si l'option (Activer les symboles) a été activée dans cette catégorie.  Affiche les points de sortie et de passage MapNotes sur la carte du donjon (ces symboles sont uniquement à des fins d'orientation et rien ne se passe lorsque vous cliquez dessus)"
L["Enables the display of all possible symbols on the dungeon map (these symbols are for orientation purposes only and nothing happens when you click on them)"] = "Permet l'affichage de tous les symboles possibles sur la carte du donjon (ces symboles sont uniquement à des fins d'orientation et rien ne se passe lorsque vous cliquez dessus)"
L["Exits"] = "Sorties"
L["Show symbols of MapNotes dungeon exit on the dungeon map"] = "Afficher les symboles de sortie du donjon MapNotes sur la carte du donjon"
L["Show symbols of passage on the dungeon map"] = "Afficher les symboles de passage sur la carte du donjon"
L["Show symbols of portals on the dungeon map"] = "Afficher les symboles des portails sur la carte du donjon"
L["Show symbols of other transport possibilities on the dungeon map"] = "Afficher les symboles d'autres possibilités de transport sur la carte du donjon"
--5 Map Tabs together "---------"
L["Activate symbols"] = "Activer les symboles"
L["Show individual symbols"] = "Afficher les symboles individuels"
L["Raids"] = "Raids"
L["Dungeons"] = "Donjons"
L["Passages"] = "Passages"
L["Multiple"] = "Plusieurs"
L["Portals"] = "Portails"
L["Zeppelins"] = "Zeppelin"
L["Ships"] = "Navires"
L["Transport"] = "Transport"
L["Ogre Waygate"] = "Porte d'accès ogre"
L["Old Instances"] = "Anciennes instances"
L["Show vanilla versions of dungeons and raids such as Naxxramas, Scholomance or Scarlet Monastery, which require achievements or other things"] = "Afficher des versions vanille de donjons et de raids tels que Naxxramas, Scholomance ou Scarlet Ministry, qui nécessitent des succès ou d'autres choses"
--Maps "---------"
L["Kalimdor"] = "Kalimdor"
L["Eastern Kingdom"] = "Royaume de l'Est"
L["Outland"] = "Outreterre"
L["Northrend"] = "Norfendre"
L["Pandaria"] = "Pandarie"
L["Draenor"] = "Draenor"
L["Broken Isles"] = "Îles Brisées"
L["Zandalar"] = "Zandalar"
L["Kul Tiras"] = "Koul Tiras"
L["Shadowlands"] = "Terres de l'Ombre"
L["Dragon Isles"] = "Îles du Dragon"
--6 Core specific "---------"
L["Shift function"] = "Fonction de décalage"
L["-> MiniMapButton <-"] = "-> MiniMapButton <-"
L["MapNotes menu window"] = "Fenêtre du menu MapNotes"
L["All set symbols have been restored"] = "Tous les symboles définis ont été restaurés"
L["All MapNotes symbols have been hidden"] = "Tous les symboles MapNotes ont été masqués"
L["is activated"] = "est activé"
L["is deactivated"] = "est désactivé"
L["are shown"] = "sont indiqués"
L["are hidden"] = "sont cachés"
L["Left-click => Open/Close"] = "Clic gauche => Ouvrir/Fermer"
L["Right-click => Open/Close"] = "Clic droit => Ouvrir/Fermer"
L["Shift + Right-click => hide"] = "Maj + clic droit => masquer"
--transport "---------"
L["symbols"] = "symboles"
L["Exit"] = "Sortie"
L["Entrance"] = "Entrée"
L["Passage"] = "Passage"
L["Portal"] = "Portail"
L["Portalroom"] = "Salle du portail"
L["The Dark Portal"] = "Le portail obscur"
L["Captain Krooz"] = "Capitaine Krooz"
L["Use the Old Keyring"] = "Utilisez l'ancien porte-clés"
L["Travel"] = "Voyage"
L["Old Keyring"] = "Porte-clés ancien"
L["Old Version"] = "Ancienne version"
L["Secret Portal"] = "Portail secret"
L["Secret Entrance"]  = "Entrée secrète"
L["Ogre Waygate to Garrison"] = "Ogre Waygate vers la garnison"
L["in the basement"] = "au sous-sol"
L["(on the tower)"] = "(sur la tour)"
L["(inside portal chamber)"] = "(à l'intérieur de la chambre portail)"
L["(inside building)"] = "(à l'intérieur du bâtiment)"
--places "---------"
L["Graveyard"] = "Cimetière"
L["Library"] = "Bibliothèque"
L["Cathedral"] = "cathédrale"
L["Armory"] = "Arsenal"
L["Ashran"] = "Ashran"
L["The Timeways"] = "Les voies temporelles"
L["Vol'mar"] = "Vol’mar"
--7 Specific "---------"
L["Shows locations of raids, dungeons, portals ,ship and zeppelins symbols on different maps"] = "Affiche les emplacements des symboles de raids, de donjons, de portails, de navires et de zeppelins sur différentes cartes"
L["(Wards of the Dread Citadel - Achievement)"] = "(Quartiers de la Citadelle d'Effroi - Succès)"
L["(Memory of Scholomance - Achievement)"] = "(Mémoire de Scholomance - Succès)"
L["(its only shown up ingame if your faction is currently occupying Bashal'Aran)"] = "(il n'apparaît dans le jeu que si votre faction occupe actuellement Bashal'Aran)"
L["This Arathi Highlands portal is only active if your faction is currently occupying Ar'gorok"] = "Ce portail des Hautes Terres d'Arathi n'est actif que si votre faction occupe actuellement Ar'gorok."
L["This Darkshore portal is only active if your faction is currently occupying Bashal'Aran"] = "Ce portail de Sombrivage n'est actif que si votre faction occupe actuellement Bashal'Aran."
L["(Grand Admiral Jes-Tereth) will take you to Vol'Dun, Nazmir or Zuldazar"] = "(Grand Amiral Jes-Tereth) vous emmènera à Vol'Dun, Nazmir ou Zuldazar"
L["(Dread-Admiral Tattersail) will take you to Drustvar, Tiragarde Sound or Stormsong Valley"] = "(Dread-Admiral Tattersail) vous emmènera à Drustvar, au détroit de Tiragarde ou à la vallée Chantorage."
L["Old Keyring \n You get the Scarlet Key in the \n [Loot-Filled Pumpkin] from [Hallow's End Event] or from the [Auction House] \n now you can activate the [Old Keyring] here \n to activate old dungeonversions from the Scarlet Monastery"] = "Ancien porte-clés \n Vous obtenez la clé écarlate dans la \n [Citrouille remplie de butin] de l'[Événement de la Sanssaint] ou de l'[Hôtel des ventes] \n vous pouvez maintenant activer l'[Ancien porte-clés] ici \n pour activer les anciennes versions de donjon du monastère écarlate"
L["Appears first after a certain instance progress \n or requires a certain achievement"] = "Apparaît d'abord après une certaine progression de l'instance \n ou nécessite une certaine réussite"