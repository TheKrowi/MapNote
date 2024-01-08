local L = LibStub("AceLocale-3.0"):NewLocale("HandyNotes_MapNotes", "frFR")
if not L then return end

--1 General tab
L["Description"] = "Description"
L["Left-click on one of these symbols on a map, the corresponding adventure guide or map of the destination will open"] = "Si vous appuyez sur l'un de ces symboles sur une carte avec le bouton gauche de la souris, le guide d'aventure associé ou la carte de la cible s'ouvre"
L["Left-clicking on a multiple icon will open the map where the dungeons are located"] = "Si vous cliquez sur un symbole multiple avec le bouton de la souris gauche, la carte sur laquelle se trouvent les donjons sera ouverte"
L["Changes all passage symbols on all maps to dungeon, raid or multiple symbols. In addition, the passage option will be disabled everywhere and the symbols will be added to the respective raids, dungeons or multiple options (The dungeon map remains unchanged from all this)"] = "Changez tout à travers des symboles sur toutes les cartes en donjon, raid ou plusieurs symboles. De plus, l'option de passage est désactivée partout et les symboles des raids, donjons ou multiples respectifs sont ajoutés (la carte de donjon reste inchangée de tout cela)"
L["Show different icons on different maps. All icons are clickable (except on the minimap) and have a function Map icons work with or without the shift key. Simply change the Shift function!"] = "Affichez différentes icônes sur différentes cartes. Toutes les icônes sont cliquables (sauf sur la mini-carte) et ont une fonction Les icônes de carte fonctionnent avec ou sans la touche Maj. Changez simplement la fonction Maj !"
L["General"] =  "Général" 
L["General settings that apply to Azeroth / Continent / Dungeon map at the same time"] = "Paramètres généraux qui s'appliquent simultanément à la carte Azeroth / Continent / Donjon"
L["General settings / Additional functions"] = "Paramètres généraux / Fonctions supplémentaires"
L["Shift function!"] = "Fonction Shift!"
L["When enabled, you must press Shift before left- or right-clicking to interact with MapNotes icons. But this has an advantage because there are so many icons in the game, including from other addons, so you don't accidentally click on a symbol and change the map, or mistakenly create a TomTom point."] = "Lorsque cette option est activée, vous devez appuyer sur Shift avant de cliquer avec le bouton gauche ou droit pour interagir avec les icônes MapNotes. Mais cela présente un avantage car il y a tellement d'icônes dans le jeu, y compris celles provenant d'autres extensions, que vous ne cliquez donc pas accidentellement sur un et modifiez la carte, ou créez par erreur un point TomTom."
L["You must now always press Shift + Click at the same time to interact with the MapNotes icons"] = "Vous devez toujours appuyer sur le bouton Shift + Mouse en même temps pour interagir avec les symboles MapNotes"
L["You can now interact with MapNotes icons without having to press Shift + Click at the same time"] = "Vous pouvez désormais interagir avec les symboles MapNotes sans avoir à appuyer sur le bouton Shift + Mouse en même temps"
L["Settings apply to the zone map and the mini map at the same time"] = "Les paramètres s'appliquent à la carte de zone et à la mini-carte en même temps"
L["symbol size"] = "taille du symbole"
L["Changes the size of the icons"] = "Modifie la taille des icônes"
L["symbol visibility"] = "visibilité des symboles"
L["Changes the visibility of the icons"] = "Modifie la visibilité des icônes"
L["hide minimap button"] = "masquer le bouton de la mini-carte"
L["Hide the minimap button on the minimap"] = "Masquer le bouton de la mini-carte sur la mini-carte"
L["hide MapNotes!"] = "masquer MapNotes!"
L["-> Hide all MapNotes icons <-"] = "-> Masquer toutes les icônes MapNotes <-"
L["Disable MapNotes, all icons will be hidden on each map and all categories will be disabled"] = "Désactivez MapNotes, toutes les icônes seront masquées sur chaque carte et toutes les catégories seront désactivées"
L["Adventure guide"] = "Guide d'aventure"
L["Left-clicking on a MapNotes raid (green), dungeon (blue) or multiple icon (green&blue) on the map opens the corresponding dungeon or raid map in the Adventure Guide (the map must not be open in full screen)"] = "Un clic gauche sur un raid MapNotes (vert), un donjon (bleu) ou une icône multiple (vert et bleu) sur la carte ouvre la carte du donjon ou du raid correspondant dans le Guide d'aventure (la carte ne doit pas être ouverte en plein écran)"
L["TomTom waypoints"] = "Points de cheminement TomTom"
L["Shift+right click on a raid, dungeon, multiple symbol, portal, ship, zeppelin, passage or exit from MapNotes on the continent or dungeon map creates a TomTom waypoint to this point (but the TomTom add-on must be installed for this)"] = "Maj+clic droit sur un raid, un donjon, un symbole multiple, un portail, un navire, un zeppelin, un passage ou une sortie de MapNotes sur la carte du continent ou du donjon crée un waypoint TomTom jusqu'à ce point (mais le module complémentaire TomTom doit être installé pour cela )"
L["extra information"] = "informations supplémentaires"
L["Displays additional information for dungeons or raids. E.g. the number of bosses already killed"] = "Affiche des informations supplémentaires pour les donjons ou les raids. Par exemple, le nombre de boss déjà tués"
L["gray single"] = "Gris individuel"
L["Colors only individual points of assigned dungeons and raids in gray (if you have an ID)"] = "Seuls les points individuels colorés des donjons et des raids attribués en gris (si vous avez un ID)"
L["gray all"] = "Tout gris"
L["Colors EVERYONE! Assigned dungeons and raids also have multiple points in gray (if you have an ID)"] = "Color tout le monde! Donjons et raids attribués Gray également plusieurs points (si vous avez un ID)"
L["enemy faction"] = "faction ennemie"
L["Shows enemy faction (horde/alliance) icons"] = "Affiche les icônes de faction ennemie (horde/alliance)"
L["Informations"] = "Informations"
L["Chat commands:"] = "Commandes de discussion :"
L["to show MapNotes info in chat: /mn, /MN"] = "pour afficher les informations MapNotes dans le chat : /mn, /MN"
L["to open MapNotes menu: /mno, /MNO"] = "pour ouvrir le menu MapNotes : /mno, /MNO"
L["to close MapNotes menu: /mnc, /MNC"] = "pour fermer le menu MapNotes : /mnc, /MNC"
L["to show minimap button: /mnb or /MNB"] = "pour afficher le bouton de la mini-carte : /mnb ou /MNB"
L["to hide minimap button: /mnbh or /MNBH"] = "pour masquer le bouton de la mini-carte : /mnbh ou /MNBH"
--2 Azeroth tab specific
L["Azeroth map"] = "Carte d'Azeroth"
--3 Continent tab specific
L["Continent map"] = "Carte des continents"
--4 Zone tab specific
L["Zone / Minimap"] = "Zones/mini carte"
--5 DungeonMap Tab specific
L["Dungeon map"] =  "Carte du donjon" 
--6 Map Tabs together
L["Activate icons"] = "Activer les icônes"
L["Show individual icons"] = "Afficher les icônes individuelles"
L["Exits"] = "Sorties"
L["Raids"] = "Raids"
L["Dungeons"] = "Donjons"
L["Passages"] = "Passage"
L["Multiple"] = "Plusieurs"
L["Portals"] = "Portails"
L["Zeppelins"] = "Zeppelin"
L["Ships"] = "Navires"
L["Transport"] = "Transport"
L["Ogre Waygate"] = "Porte de passage de l'Ogre"
L["Old Instances"] = "Anciens cas"
L["Show icons of passage on this map"] = "Afficher les icônes de passage sur cette carte"
L["Show icons of raids on this map"] = "Afficher les icônes des raids sur cette carte"
L["Show icons of dungeons on this map"] = "Afficher les icônes des donjons sur cette carte"
L["Show icons of multiple on this map"] = "Afficher plusieurs icônes sur cette carte"
L["Show icons of portals on this map"] = "Afficher les icônes des portails sur cette carte"
L["Show icons of zeppelins on this map"] = "Afficher les icônes des zeppelins sur cette carte"
L["Show icons of ships on this map"] = "Afficher les icônes des navires sur cette carte"
L["Show all MapNotes for a specific map"] = "Afficher toutes les MapNotes pour une carte spécifique"
L["Show icons of MapNotes dungeon exit on this map"] = "Afficher les icônes de sortie du donjon MapNotes sur cette carte"
L["Enables the display of all possible icons on this map"] = "Permet l'affichage de toutes les icônes possibles sur cette carte"
L["Show icons of passage to raids and dungeons on this map"] = "Afficher les icônes de passage vers les raids et donjons sur cette carte"
L["Show icons of other transport possibilities on this map"] = "Afficher les icônes des autres possibilités de transport sur cette carte"
L["Show Ogre Waygate icons from Garrison on this map"] = "Afficher les icônes Ogre Waygate de Garrison sur cette carte"
L["Activates the display of all possible icons on this map"] = "Active l'affichage de toutes les icônes possibles sur cette carte"
L["Show icons of multiple (dungeons,raids) on this map"] = "Afficher les icônes de plusieurs (donjons, raids) sur cette carte"
L["Show icons of other transport possibilities on the continent and minimap"] = "Afficher les icônes des autres possibilités de transport sur le continent et la mini-carte"
L["Show all Outland MapNotes dungeon, raid, portal, zeppelin and ship icons on this map"] = "Afficher toutes les icônes des donjons, raids, portails, zeppelins et navires d'Outland MapNotes sur cette carte"
L["Show all Draenor MapNotes dungeon, raid, portal, zeppelin and ship icons on this map"] = "Afficher toutes les icônes des donjons, raids, portails, zeppelins et navires Draenor MapNotes sur cette carte"
L["Show all Shadowlands MapNotes dungeon, raid, portal, zeppelin and ship icons on this map"] = "Afficher toutes les icônes des donjons, raids, portails, zeppelins et navires de Shadowlands MapNotes sur cette carte"
L["Show all Kalimdor MapNotes dungeon, raid, portal, zeppelin and ship icons on this map"] = "Afficher toutes les icônes des donjons, raids, portails, zeppelins et navires Kalimdor MapNotes sur cette carte"
L["Show all Eastern Kingdom MapNotes dungeon, raid, portal, zeppelin and ship icons on this map"] = "Afficher toutes les icônes des donjons, raids, portails, zeppelins et navires de Eastern Kingdom MapNotes sur cette carte"
L["Show all Northrend MapNotes dungeon, raid, portal, zeppelin and ship icons on this map"] = "Afficher toutes les icônes des donjons, raids, portails, zeppelins et navires Northrend MapNotes sur cette carte"
L["Show all Pandaria MapNotes dungeon, raid, portal, zeppelin and ship icons on this map"] = "Afficher toutes les icônes des donjons, raids, portails, zeppelins et navires Pandaria MapNotes sur cette carte"
L["Show all Zandalar MapNotes dungeon, raid, portal, zeppelin and ship icons on this map"] = "Afficher toutes les icônes des donjons, raids, portails, zeppelins et navires Zandalar MapNotes sur cette carte"
L["Show all Kul Tiras MapNotes dungeon, raid, portal, zeppelin and ship icons on this map"] = "Afficher toutes les icônes des donjons, raids, portails, zeppelins et navires de Kul Tiras MapNotes sur cette carte"
L["Show all Broken Isles MapNotes dungeon, raid, portal, zeppelin and ship icons on this map"] = "Afficher toutes les icônes des donjons, raids, portails, zeppelins et navires de Broken Isles MapNotes sur cette carte"
L["Show all Dragon Isles MapNotes dungeon, raid, portal, zeppelin and ship icons on this map"] = "Afficher toutes les icônes des donjons, raids, portails, zeppelins et navires Dragon Isles MapNotes sur cette carte"
L["Certain icons can be displayed or not displayed. If the option (Activate icons) has been activated in this category"] = "Certaines icônes peuvent être affichées ou non. Si l'option (Activer les icônes) a été activée dans cette catégorie"
L["Show vanilla versions of dungeons and raids such as Naxxramas, Scholomance or Scarlet Monastery, which require achievements or other things"] = "Affichez les versions vanille des donjons et des raids tels que Naxxramas, Scholomance ou le Monastère Écarlate, qui nécessitent des succès ou d'autres choses"
L["Individual icons that are too close to other icons on this map are not 100% accurately placed on this map! For more precise coordinates, please use the points on the zone map"] = "Les symboles individuels qui sont trop proches des autres symboles de cette carte ne sont pas placés à 100% précisément sur cette carte! Pour des coordonnées plus détaillées, veuillez utiliser les points sur la carte de zone"
--7 Maps
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
--8 Core specific
L["Shift function"] = "Fonction Shift"
L["-> MiniMapButton <-"] = "-> MiniMapButton <-"
L["MapNotes menu window"] = "Fenêtre du menu MapNotes"
L["All set icons have been restored"] = "Toutes les icônes définies ont été restaurées"
L["All MapNotes icons have been hidden"] = "Toutes les icônes MapNotes ont été masquées"
L["is activated"] = "est activé"
L["is deactivated"] = "est désactivé"
L["are shown"] = "sont indiqués"
L["are hidden"] = "sont cachés"
L["Left-click => Open/Close"] = "Clic gauche => Ouvrir/Fermer"
L["Right-click => Open/Close"] = "Clic droit => Ouvrir/Fermer"
L["Shift + Right-click => hide"] = "Maj + clic droit => masquer"
--9 transport
L["icons"] = "Icônes"
L["Exit"] = "Sortie"
L["Entrance"] = "Entrée"
L["Passage"] = "Passage"
L["Portal"] = "Portail"
L["Portalroom"] = "Salle du portail"
L["The Dark Portal"] = "Le portail des ténèbres"
L["Captain Krooz"] = "Capitaine Krooz"
L["Use the Old Keyring"] = "Utilisez le vieux porte-clés"
L["Travel"] = "Voyage"
L["Old Keyring"] = "Vieux porte-clés"
L["Old Version"] = "Ancienne version"
L["Secret Portal"] = "Portail secret"
L["Secret Entrance"] = "Entrée secrète"
L["Ogre Waygate to Garrison"] = "Ogre Waygate vers la garnison"
L["in the basement"] = "au sous-sol"
L["(on the tower)"] = "(sur la tour)"
L["(inside portal chamber)"] = "(à l'intérieur de la chambre du portail)"
L["(inside building)"] = "(à l'intérieur du bâtiment)"
--10 places
L["Graveyard"] = "Cimetière"
L["Library"] = "Bibliothèque"
L["Cathedral"] = "Cathédrale"
L["Armory"] = "Arsenal"
L["Ashran"] = "Ashran"
L["The Timeways"] = "Les voies temporelles"
L["Vol'mar"] = "Vol'mar"
--11 Specific
L["Shows locations of raids, dungeons, portals ,ship and zeppelins icons on different maps"] = "Affiche les emplacements des raids, des donjons, des portails, des navires et des icônes de zeppelins sur différentes cartes"
L["(Wards of the Dread Citadel - Achievement)"] = "(Quartiers de la Citadelle d'Effroi - Succès)"
L["(Memory of Scholomance - Achievement)"] = "(Mémoire de Scholomance - Réussite)"
L["(its only shown up ingame if your faction is currently occupying Bashal'Aran)"] = "(il n'apparaît dans le jeu que si votre faction occupe actuellement Bashal'Aran)"
L["This Arathi Highlands portal is only active if your faction is currently occupying Ar'gorok"] = "Ce portail des Hautes Terres d'Arathi n'est actif que si votre faction occupe actuellement Ar'gorok"
L["This Darkshore portal is only active if your faction is currently occupying Bashal'Aran"] = "Ce portail de Sombrivage n'est actif que si votre faction occupe actuellement Bashal'Aran"
L["(Grand Admiral Jes-Tereth) will take you to Vol'Dun, Nazmir or Zuldazar"] = "(Le Grand Amiral Jes-Tereth) vous emmènera à Vol'Dun, Nazmir ou Zuldazar"
L["(Dread-Admiral Tattersail) will take you to Drustvar, Tiragarde Sound or Stormsong Valley"] = "(Dread-Admiral Tattersail) vous emmènera à Drustvar, au détroit de Tiragarde ou à la vallée Chantorage"
L["Old Keyring \n You get the Scarlet Key in the \n [Loot-Filled Pumpkin] from [Hallow's End Event] or from the [Auction House] \n now you can activate the [Old Keyring] here \n to activate old dungeonversions from the Scarlet Monastery"] = "Ancien porte-clés \n Vous obtenez la clé écarlate dans la \n [Citrouille remplie de butin] de [Événement de la Sanssaint] ou de la [Hôtel des ventes] \n vous pouvez maintenant activer l'[Ancien porte-clés] ici \n pour activer l'ancien versions de donjon du Monastère Écarlate"
L["Appears first after a certain instance progress \n or requires a certain achievement"] = "Apparaît en premier après une certaine progression de l'instance \n ou nécessite une certaine réussite" 