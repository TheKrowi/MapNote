local L = LibStub("AceLocale-3.0"):NewLocale("HandyNotes_MapNotes", "esMX")
if not L then return end

--1 General tab
L["Description"] = "Descripción"
L["Left-click on one of these symbols on a map, the corresponding adventure guide or map of the destination will open"] = "Si haces clic con el botón izquierdo en uno de estos símbolos en un mapa, se abrirá la guía de aventura o el mapa correspondiente del destino"
L["Left-clicking on a multiple icon will open the map where the dungeons are located"] = "Al hacer clic con el botón izquierdo en un icono múltiple, se abrirá el mapa donde se encuentran las mazmorras"
L["Changes all passage symbols on all maps to dungeon, raid or multiple symbols. In addition, the passage option will be disabled everywhere and the symbols will be added to the respective raids, dungeons or multiple options (The dungeon map remains unchanged from all this)"] = "Cambia todos los símbolos de pasaje en todos los mapas a mazmorras, bandas o símbolos múltiples. Además, la opción de pasaje se desactivará en todas partes y los símbolos se agregarán a las respectivas incursiones, mazmorras o múltiples opciones (El mapa de mazmorras permanece sin cambios desde todo esto)"
L["Show different icons on different maps. All icons are clickable (except on the minimap) and have a function Map icons work with or without the shift key. Simply change the Shift function!"] = "Muestra diferentes símbolos en diferentes mapas. Se puede hacer clic en todos los símbolos (excepto en el minimapa) y tienen una función Los símbolos del mapa funcionan con o sin la tecla Mayús. ¡Simplemente cambie la función Shift!"
L["General"] = "General"
L["General settings that apply to Azeroth / Continent / Dungeon map at the same time"] = "Ajustes generales que se aplican al mapa de Azeroth/Continente/Mazmorra al mismo tiempo"
L["General settings / Additional functions"] = "Ajustes generales / Funciones adicionales"
L["Shift function!"] = "¡Función de cambio!"
L["When enabled, you must press Shift before left- or right-clicking to interact with MapNotes icons. But this has an advantage because there are so many icons in the game, including from other addons, so you don't accidentally click on a symbol and change the map, or mistakenly create a TomTom point."] = "Cuando está habilitado, debe presionar Mayús antes de hacer clic con el botón izquierdo o derecho para interactuar con los iconos de MapNotes. Pero esto tiene una ventaja porque hay muchos símbolos en el juego, incluso de otros complementos, por lo que no haces clic accidentalmente en un símbolo y cambias el mapa, o creas por error un punto TomTom."
L["You must now always press Shift + Click at the same time to interact with the MapNotes icons"] = "Ahora debe presionar siempre Mayús + Clic al mismo tiempo para interactuar con los iconos de MapNotes"
L["You can now interact with MapNotes icons without having to press Shift + Click at the same time"] = "Ahora puede interactuar con los iconos de MapNotes sin tener que pulsar Mayús + Clic al mismo tiempo"
L["Settings apply to the zone map and the mini map at the same time"] = "La configuración se aplica al mapa de zona y al minimapa al mismo tiempo"
L["symbol size"] = "Tamaño del símbolo"
L["Changes the size of the icons"] = "Cambia el tamaño del símbolos"
L["symbol visibility"] = "Visibilidad de los símbolos"
L["Changes the visibility of the icons"] = "Cambia la visibilidad de los símbolos"
L["hide minimap button"] = "Botón Ocultar minimapa"
L["Hide the minimap button on the minimap"] = "Ocultar el botón del minimapa en el minimapa"
L["hide MapNotes!"] = "ocultar MapNotes!"
L["-> Hide all MapNotes icons <-"] = "-> Ocultar todos los símbolos de MapNotes <- "
L["Disable MapNotes, all icons will be hidden on each map and all categories will be disabled"] = "Deshabilite MapNotes, todos los íconos se ocultarán en cada mapa y todas las categorías se deshabilitarán"
L["Adventure guide"] = "Guía de aventura"
L["Left-clicking on a MapNotes raid (green), dungeon (blue) or multiple icon (green&blue) on the map opens the corresponding dungeon or raid map in the Adventure Guide (the map must not be open in full screen)"] = "Al hacer clic con el botón izquierdo en una banda de MapNotes (verde), una mazmorra (azul) o un icono múltiple (verde y azul) en el mapa, se abre la mazmorra o el mapa de banda correspondiente en la Guía de aventuras (el mapa no debe estar abierto en pantalla completa)"
L["TomTom waypoints"] = "Puntos de referencia de TomTom"
L["Shift+right click on a raid, dungeon, multiple symbol, portal, ship, zeppelin, passage or exit from MapNotes on the continent or dungeon map creates a TomTom waypoint to this point (but the TomTom add-on must be installed for this)"] = "Mayús + clic derecho en una incursión, mazmorra, símbolo múltiple, portal, barco, zepelín, pasaje o salida de MapNotes en el mapa de continente o mazmorra crea un waypoint de TomTom hasta este punto (pero el complemento de TomTom debe estar instalado para esto)"
L["extra information"] = "información adicional"
L["Displays additional information for dungeons or raids. E.g. the number of bosses already killed"] = "Muestra información adicional para mazmorras o bandas. Por ejemplo, el número de jefes ya asesinados"
L["gray single"] = "gris sencillo"
L["Colors only individual points of assigned dungeons and raids in gray (if you have an ID)"] = "Colorea solo los puntos individuales de las mazmorras y bandas asignadas en gris (si tienes un ID)"
L["gray all"] = "gris todo"
L["Colors EVERYONE! Assigned dungeons and raids also have multiple points in gray (if you have an ID)"] = "¡Colores TODOS! Las mazmorras y bandas asignadas también tienen varios puntos en gris (si tienes un ID)"
L["enemy faction"] = "Facción enemiga"
L["Shows enemy faction (horde/alliance) icons"] = "Muestra los símbolos de la facción enemiga (horda/alianza)"
L["Informations"] = "Informaciones"
L["Chat commands:"] = "Comandos de chat:"
L["to show MapNotes info in chat: /mn, /MN"] = "para mostrar información de MapNotes en el chat: /mn, /MN"
L["to open MapNotes menu: /mno, /MNO"] = "para abrir el menú de MapNotes: /mno, /MNO"
L["to close MapNotes menu: /mnc, /MNC"] = "para cerrar el menú de MapNotes: /mnc, /MNC"
L["to show minimap button: /mnb or /MNB"] = "Para mostrar el botón del minimapa: /mnb o /MNB"
L["to hide minimap button: /mnbh or /MNBH"] = "para ocultar el botón del minimapa: /mnbh o /MNBH "
--2 Azeroth tab specific "
L["Azeroth map"] = "Mapa de Azeroth"
--3 Continent tab specific
L["Continent map"] = "Mapa del continente"
--4 Zone tab specific--4 Específico de la pestaña de la zona
L["Zone / Minimap"] = "Zona / Minimapa"
--5 DungeonMap Tab specific--5 Pestaña específica de DungeonMap
L["Dungeon map"] =  "Mapa de mazmorras"
--6 Map Tabs together--6 pestañas de mapa juntas
L["Activate icons"] = "Activar iconos"
L["Show individual icons"] = "Mostrar iconos individuales"
L["Exits"] = "Salidas"
L["Raids"] = "Incursiones"
L["Dungeons"] = "Mazmorras"
L["Passages"] = "Pasajes"
L["Multiple"] = "Múltiples"
L["Portals"] = "Portales"
L["Zeppelins"] = "Zepelines"
L["Ships"] = "Naves"
L["Transport"] = "Transporte"
L["Ogre Waygate"] = "Puerta del Ogro Camino"
L["Old Instances"] = "Instancias antiguas" 
L["Show icons of passage on this map"] = "Mostrar iconos de paso en este mapa"
L["Show icons of raids on this map"] = "Mostrar iconos de incursiones en este mapa"
L["Show icons of dungeons on this map"] = "Mostrar iconos de mazmorras en este mapa"
L["Show icons of multiple on this map"] = "Mostrar iconos de varios en este mapa"
L["Show icons of portals on this map"] = "Mostrar iconos de portales en este mapa"
L["Show icons of zeppelins on this map"] = "Mostrar iconos de zepelines en este mapa"
L["Show icons of ships on this map"] = "Mostrar iconos de barcos en este mapa"
L["Show all MapNotes for a specific map"] = "Mostrar todas las MapNotes para un mapa específico" 
L["Show icons of MapNotes dungeon exit on this map"] = "Mostrar iconos de la salida de la mazmorra de MapNotes en este mapa"
L["Enables the display of all possible icons on this map"] = "Habilita la visualización de todos los iconos posibles en este mapa"
L["Show icons of passage to raids and dungeons on this map"] = "Mostrar iconos de paso a incursiones y mazmorras en este mapa"
L["Show icons of other transport possibilities on this map"] = "Mostrar iconos de otras posibilidades de transporte en este mapa"
L["Show Ogre Waygate icons from Garrison on this map"] = "Mostrar los iconos de Ogre Waygate de Garrison en este mapa"
L["Activates the display of all possible icons on this map"] = "Activa la visualización de todos los iconos posibles en este mapa"
L["Show icons of multiple (dungeons,raids) on this map"] = "Mostrar iconos de múltiples (mazmorras, incursiones) en este mapa"
L["Show icons of other transport possibilities on the continent and minimap"] = "Mostrar iconos de otras posibilidades de transporte en el continente y minimapa" 
L["Show all Outland MapNotes dungeon, raid, portal, zeppelin and ship icons on this map"] = "Mostrar todos los iconos de mazmorras, bandas, portales, zepelines y barcos de Terrallende MapNotes en este mapa"
L["Show all Draenor MapNotes dungeon, raid, portal, zeppelin and ship icons on this map"] = "Mostrar todos los iconos de mazmorras, bandas, portales, zepelines y barcos de Draenor MapNotes en este mapa"
L["Show all Shadowlands MapNotes dungeon, raid, portal, zeppelin and ship icons on this map"] = "Mostrar todos los iconos de mazmorras, bandas, portales, zepelines y barcos de Shadowlands MapNotes en este mapa"
L["Show all Kalimdor MapNotes dungeon, raid, portal, zeppelin and ship icons on this map"] = "Mostrar todos los iconos de mazmorras, bandas, portales, zepelines y barcos de Kalimdor MapNotes en este mapa"
L["Show all Eastern Kingdom MapNotes dungeon, raid, portal, zeppelin and ship icons on this map"] = "Mostrar todos los iconos de mazmorras, bandas, portales, zepelines y barcos de Eastern Kingdom MapNotes en este mapa"
L["Show all Northrend MapNotes dungeon, raid, portal, zeppelin and ship icons on this map"] = "Mostrar todos los iconos de mazmorras, bandas, portales, zepelines y barcos de Rasganorte en este mapa"
L["Show all Pandaria MapNotes dungeon, raid, portal, zeppelin and ship icons on this map"] = "Mostrar todos los iconos de mazmorras, bandas, portales, zepelines y naves de Pandaria en este mapa"
L["Show all Zandalar MapNotes dungeon, raid, portal, zeppelin and ship icons on this map"] = "Mostrar todos los iconos de mazmorras, bandas, portales, zepelines y barcos de Zandalar en este mapa"
L["Show all Kul Tiras MapNotes dungeon, raid, portal, zeppelin and ship icons on this map"] = "Mostrar todos los iconos de mazmorras, bandas, portales, zepelins y barcos de Kul Tiras en este mapa"
L["Show all Broken Isles MapNotes dungeon, raid, portal, zeppelin and ship icons on this map"] = "Mostrar todos los iconos de mazmorras, bandas, portales, zepelines y barcos de Broken Isles MapNotes en este mapa"
L["Show all Dragon Isles MapNotes dungeon, raid, portal, zeppelin and ship icons on this map"] = "Mostrar todos los iconos de mazmorras, bandas, portales, zepelines y barcos de Dragon Isles MapNotes en este mapa"
L["Certain icons can be displayed or not displayed. If the option (Activate icons) has been activated in this category"] = "Ciertos iconos pueden mostrarse o no mostrarse. Si se ha activado la opción (Activar iconos) en esta categoría"
L["Show vanilla versions of dungeons and raids such as Naxxramas, Scholomance or Scarlet Monastery, which require achievements or other things"] = "Mostrar versiones vainilla de mazmorras e incursiones como Naxxramas, Scholomance o Scarlet Monastery, que requieren logros u otras cosas"
L["Individual icons that are too close to other icons on this map are not 100% accurately placed on this map! For more precise coordinates, please use the points on the zone map"] = "¡Los íconos individuales que están demasiado cerca de otros íconos en este mapa no se colocan con precisión al 100% en este mapa! Para coordenadas más precisas, utilice los puntos del mapa de la zona"
--7 Maps--7 Mapas
L["Kalimdor"] = "Kalimdor"
L["Eastern Kingdom"] = "Reino del Este"
L["Outland"] = "Terrallende"
L["Northrend"] = "Rasganorte"
L["Pandaria"] = "Pandaria"
L["Draenor"] = "Draenor"
L["Broken Isles"] = "Islas Abruptas"
L["Zandalar"] = "Zandalar"
L["Kul Tiras"] = "Kul Tiras"
L["Shadowlands"] = "Tierras Sombrías"
L["Dragon Isles"] = "Islas Dragón"
--8 Core specific--8 Específico del núcleo
L["Shift function"] = "Función de cambio"
L["-> MiniMapButton <-"] = "-> MiniMapButton <-"
L["MapNotes menu window"] = "Ventana de menú de MapNotes"
L["All set icons have been restored"] = "Se han restaurado todos los iconos del conjunto"
L["All MapNotes icons have been hidden"] = "Se han ocultado todos los iconos de MapNotes"
L["is activated"] = "está activado"
L["is deactivated"] = "está desactivado"
L["are shown"] = "se muestran"
L["are hidden"] = "están ocultos"
L["Left-click => Open/Close"] = "Clic izquierdo = > Abrir/Cerrar"
L["Right-click => Open/Close"] = "Clic derecho = > Abrir/Cerrar"
L["Shift + Right-click => hide"] = "Mayús + clic derecho = > ocultar"
--9 transport--9 Transporte
L["icons"] = "Iconos"
L["Exit"] = "Salir"
L["Entrance"] = "Entrada"
L["Passage"] = "Pasaje"
L["Portal"] = "Portal"
L["Portalroom"] = "Sala de portales"
L["The Dark Portal"] = "El Portal Oscuro"
L["Captain Krooz"] = "Capitán Krooz"
L["Use the Old Keyring"] = "Usa el llavero antiguo"
L["Travel"] = "Viajar"
L["Old Keyring"] = "Llavero viejo"
L["Old Version"] = "Versión antigua"
L["Secret Portal"] = "Portal secreto"
L["Secret Entrance"] = "Entrada secreta"
L["Ogre Waygate to Garrison"] = "Puerta de paso de ogros a la guarnición"
L["in the basement"] = "En el sótano"
L["(on the tower)"] = "(en la torre)"
L["(inside portal chamber)"] = "(dentro de la cámara del portal)"
L["(inside building)"] = "(dentro del edificio)"
--10 places--10 plazas
L["Graveyard"] = "Cementerio"
L["Library"] = "Biblioteca"
L["Cathedral"] = "Catedral"
L["Armory"] = "Armería"
L["Ashran"] = "Ashran"
L["The Timeways"] = "Los caminos del tiempo"
L["Vol'mar"] = "Vol'mar"
--11 Specific--11 Específico 
L["Shows locations of raids, dungeons, portals ,ship and zeppelins icons on different maps"] = "Muestra ubicaciones de incursiones, mazmorras, portales, iconos de barcos y zepelines en diferentes mapas"
L["(Wards of the Dread Citadel - Achievement)"] = "(Guardianes de la Ciudadela del Terror - Logro)"
L["(Memory of Scholomance - Achievement)"] = "(Memoria de Scholomance - Logro)"
L["(its only shown up ingame if your faction is currently occupying Bashal'Aran)"] = "(solo aparece en el juego si tu facción está ocupando Bashal'Aran)"
L["This Arathi Highlands portal is only active if your faction is currently occupying Ar'gorok"] = "Este portal de las Tierras Altas de Arathi solo está activo si tu facción está ocupando Ar'gorok"
L["This Darkshore portal is only active if your faction is currently occupying Bashal'Aran"] = "Este portal de Costa Oscura solo está activo si tu facción está ocupando Bashal'Aran"
L["(Grand Admiral Jes-Tereth) will take you to Vol'Dun, Nazmir or Zuldazar"] = "(El Gran Almirante Jes-Tereth) te llevará a Vol'Dun, Nazmir o Zuldazar"
L["(Dread-Admiral Tattersail) will take you to Drustvar, Tiragarde Sound or Stormsong Valley"] = "(El Almirante del Terror Velajada) te llevará a Drustvar, al Estrecho de Tiragarde o al Valle Canto Tormenta"
L["Old Keyring \n You get the Scarlet Key in the \n [Loot-Filled Pumpkin] from [Hallow's End Event] or from the [Auction House] \n now you can activate the [Old Keyring] here \n to activate old dungeonversions from the Scarlet Monastery"] = "Llavero antiguo \n Obtienes la llave escarlata en el \n [Calabaza llena de botín] de [Evento de Halloween ] o de la [Casa de subastas] \n ahora puedes activar el [Llavero antiguo] aquí \n para activar versiones de mazmorras antiguas del Monasterio Escarlata"
L["Appears first after a certain instance progress \n or requires a certain achievement"] = "Aparece primero después de un determinado progreso de instancia \n o requiere un determinado logro" 