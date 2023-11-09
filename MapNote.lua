--## Interface: 100200
--## Version: 1.6
--## Title: |cff00ccff> |cffff0000Map|r|cff00ccffNote|r|cffff0000 <
--## Notes: Shows locations of |cffffcc00dungeons, raids, portals, ships, zeppelins, entrance/exit and passages symbols!|r
--## Author: BadBoyBarny
--## RequiredDeps: HandyNotes
--## X-Curse-Project-ID: 912524
--## IconTexture: Interface\AddOns\MapNote\Images\MN_Logo
--## SavedVariables: MapNoteDB

local L = LibStub("AceLocale-3.0"):GetLocale("MapNote")

local db
local icons = { }
local nodes = { }
local minimap = { }
local mapIDs = { }
local lfgIDs = { }
local assignedIDs = { }

icons["Dungeon"] = "Interface\\MINIMAP\\Dungeon"
icons["Raid"] = "Interface\\MINIMAP\\Raid"
icons["VDungeon"] = "Interface\\Addons\\MapNote\\images\\vanilladungeons.tga"
icons["VRaid"] = "Interface\\Addons\\MapNote\\images\\vanilladungeons.tga"
icons["VKey1"] = "Interface\\Addons\\MapNote\\images\\vkey1.blp"
icons["Multiple"] = "Interface\\Addons\\MapNote\\images\\merged.tga"
icons["Locked"] = "Interface\\Addons\\MapNote\\images\\gray.blp"
icons["Zeppelin"] = "Interface\\Addons\\MapNote\\images\\zeppelin.tga"
icons["HZeppelin"] = "Interface\\Addons\\MapNote\\images\\hzeppelin.tga"
icons["AZeppelin"] = "Interface\\Addons\\MapNote\\images\\azeppelin.tga"
icons["Portal"] = "Interface\\Addons\\MapNote\\images\\portal.tga"
icons["HPortal"] = "Interface/Minimap/Vehicle-HordeMagePortal"
icons["APortal"] = "Interface/Minimap/Vehicle-AllianceMagePortal"
icons["Ship"] = "Interface\\Addons\\MapNote\\images\\ship.tga"
icons["HShip"] = "Interface\\Addons\\MapNote\\images\\hship.tga"
icons["AShip"] = "Interface\\Addons\\MapNote\\images\\aship.tga"
icons["Exit"] = "Interface\\Addons\\MapNote\\images\\purpleEntranceExit"
icons["Passageup"] = "Interface\\Addons\\MapNote\\images\\passageup"
icons["Passagedown"] = "Interface\\Addons\\MapNote\\images\\passagedown"
icons["Passageright"] = "Interface\\Addons\\MapNote\\images\\passageright"
icons["Passageleft"] = "Interface\\Addons\\MapNote\\images\\passageleft"
icons["TransportHelper"] = "Interface\\Addons\\MapNote\\images\\tport.blp"


local function updateAssignedID()
    table.wipe(assignedIDs)
    for i=1,GetNumSavedInstances() do
        local name, _, _, _, locked, _, _, _, _, difficultyName, numEncounters, encounterProgress = GetSavedInstanceInfo(i)
        if (locked) then
            if (not assignedIDs[name]) then
            assignedIDs[name] = { }
            end
            assignedIDs[name][difficultyName] = encounterProgress .. "/" .. numEncounters
        end
    end
end

local pluginHandler = { }
function pluginHandler:OnEnter(uiMapId, coord)
  local nodeData = nil

	if (minimap[uiMapId] and minimap[uiMapId][coord]) then
	  nodeData = minimap[uiMapId][coord]
	end
	if (nodes[uiMapId] and nodes[uiMapId][coord]) then
	  nodeData = nodes[uiMapId][coord]
	end
	
	if (not nodeData) then return end
	
	local tooltip = self:GetParent() == WorldMapButton and WorldMapTooltip or GameTooltip
	if ( self:GetCenter() > UIParent:GetCenter() ) then 
	  tooltip:SetOwner(self, "ANCHOR_LEFT")
	else
		tooltip:SetOwner(self, "ANCHOR_RIGHT")
	end

    if (not nodeData.name) then return end

	local instances = { strsplit("\n", nodeData.name) }
	

	updateAssignedID()
	
	for i, v in pairs(instances) do
	  if (db.assignedID and (assignedIDs[v] or (lfgIDs[v] and assignedIDs[lfgIDs[v]]))) then
 	    if (assignedIDs[v]) then
	      for a,b in pairs(assignedIDs[v]) do
	        tooltip:AddDoubleLine(v, a .. " " .. b, 1, 1, 1, 1, 1, 1)
 	      end
	    end
      if (lfgIDs[v] and assignedIDs[lfgIDs[v]]) then
        for a,b in pairs(assignedIDs[lfgIDs[v]]) do
          tooltip:AddDoubleLine(v, a .. " " .. b, 1, 1, 1, 1, 1, 1)
        end
      end
	  else
	    tooltip:AddLine(v, nil, nil, nil, false)
	  end
	end
	tooltip:Show()
end

function pluginHandler:OnLeave(uiMapID, coord)
    if self:GetParent() == WorldMapButton then
      WorldMapTooltip:Hide()
    else
      GameTooltip:Hide()
    end
end

do
	local tablepool = setmetatable({}, {__mode = 'k'})
	
	local function deepCopy(object)
		local lookup_table = {}
		local function _copy(object)
			if type(object) ~= "table" then
				return object
			elseif lookup_table[object] then
				return lookup_table[object]
			end

			local new_table = {}
			  lookup_table[object] = new_table
			for index, value in pairs(object) do
				new_table[_copy(index)] = _copy(value)
			end

			return setmetatable(new_table, getmetatable(object))
		end
			return _copy(object)
	end

	local function iter(t, prestate)
		if not t then return end
		local data = t.data

		local state, value = next(data, prestate)

		while value do
			local alpha
			
			local allLocked = true
			local anyLocked = false
			if value.name == nil then value.name = value.id end
			local instances = { strsplit("\n", value.name) }
			for i, v in pairs(instances) do
				if (not assignedIDs[v] and not assignedIDs[lfgIDs[v]]) then
					allLocked = false
				else
					anyLocked = true
				end
			end

			local icon = icons[value.type]
			if ((anyLocked and db.graymultipleID) or (allLocked and not db.graymultipleID) and db.assignedgray) then   
				icon = icons["Locked"]
			end

			if t.minimapUpdate or value.showInZone then
			  return state, nil, icon, db.azerothScale, alpha
			end
      
			state, value = next(data, state)
		end
		wipe(t)
		tablepool[t] = true
	end


	local function iterCont(t, prestate)
		if not t then return end
    if not db.showContinent then return end
		local zone = t.C[t.Z]
		local data = nodes[zone]
		local state, value
		while zone do
			if data then
				state, value = next(data, prestate)
				while state do
					local icon, alpha

					icon = icons[value.type]
					local allLocked = true
					local anyLocked = false
					local instances = { strsplit("\n", value.name) }
					for i, v in pairs(instances) do
						if (not assignedIDs[v] and not assignedIDs[lfgIDs[v]]) then
							allLocked = false
						else
							anyLocked = true
						end
					end
	  
					if ((anyLocked and db.graymultipleID) or (allLocked and not db.graymultipleID) and db.assignedgray) then   
						icon = icons["Locked"]
					end

					if not value.hideOnContinent and db.showContinent then
						return state, zone, icon, db.continentScale, alpha
          end
					state, value = next(data, state)
				end
			end
			t.Z = next(t.C, t.Z)
			zone = t.C[t.Z]
			data = nodes[zone]
			prestate = nil
		end
		wipe(t)
		tablepool[t] = true
	end

	function pluginHandler:GetNodes2(uiMapId, isMinimapUpdate)
		local C = deepCopy(HandyNotes:GetContinentZoneList(uiMapId))
		if C then
			table.insert(C, uiMapId)
			local tbl = next(tablepool) or {}
			tablepool[tbl] = nil
			tbl.C = C
			tbl.Z = next(C)
			tbl.contId = uiMapId
			return iterCont, tbl, nil
		else
			if (nodes[uiMapId] == nil) then return iter end 
			local tbl = next(tablepool) or {}
			tablepool[tbl] = nil
			tbl.minimapUpdate = isMinimapUpdate
			if (isMinimapUpdate and minimap[uiMapId]) then
				tbl.data = minimap[uiMapId]
			else
				tbl.data = nodes[uiMapId]
			end
			return iter, tbl, nil
		end
	end
end

local waypoints = {}
local function setWaypoint(uiMapID, coord)
	local dungeon = nodes[uiMapID][coord]

	local waypoint = nodes[dungeon]
	if waypoint and TomTom:IsValidWaypoint(waypoint) then
		return
	end

	local title = dungeon.name
	local x, y = HandyNotes:getXY(coord)
	waypoints[dungeon] = TomTom:AddWaypoint(uiMapID, x, y, {
		title = dungeon.name,
		persistent = nil,
		minimap = true,
		world = true
	})
end

function pluginHandler:OnClick(button, pressed, uiMapId, coord)
    if (not pressed) then return end
    if IsShiftKeyDown() and (button == "RightButton" and db.tomtom and TomTom) then
        setWaypoint(uiMapId, coord)
        return
        end
    if (button == "LeftButton" and db.journal) then
        if (not EncounterJournal_OpenJournal) then
        UIParentLoadAddOn('Blizzard_EncounterJournal')
        end
        local dungeonID
        if (type(nodes[uiMapId][coord].id) == "table") then
            dungeonID = nodes[uiMapId][coord].id[1]
        else
            dungeonID = nodes[uiMapId][coord].id
        end
  
        if (not dungeonID) then return end

        local name, _, _, _, _, _, _, link = EJ_GetInstanceInfo(dungeonID)
        if not link then return end
        local difficulty = string.match(link, 'journal:.-:.-:(.-)|h') 
        if (not dungeonID or not difficulty) then return end
        EncounterJournal_OpenJournal(difficulty, dungeonID)
        _G.EncounterJournal:SetScript("OnShow", BBBEncounterJournal_OnShow)
    end
end

local defaults = {
  profile = {
      show = {
      Azeroth = true,
      Continent = true,
      Dungeon = true,
      DungeonMap = true,
      EnemyFaction = true,
      OldVanilla = true,
      Raid = true,
      Multiple = true,
      Gray = true,
      Portal = true,
      HPortal = true,
      APortal = true,
      Zeppelin = true,
      Ship = true,
      HShip = true,
      AShip = true,
      },

    --1
      hideAddon = false,
      journal = true,
      tomtom = true,
      assignedID = true,
      assignedgray = true,
      graymultipleID = true,
      showEnemyFaction = true,
      showOldVanilla = true,
    
    --2 Azeroth map
      showAzeroth = true,
      azerothScale = 1.2,
      hideAzerothRaid = false,
      hideAzerothDungeon = false,
      hideAzerothMultiple = false,
      hideAzerothPortals = false,
      hideAzerothZeppelins = false,
      hideAzerothShips = false,
      hideAzerothKalimdor = false,
      hideAzerothEasternKingdom = false,
      hideAzerothNorthrend = false,
      hideAzerothKulTiras = false,
      hideAzerothPandaria = false,
      hideAzerothBrokenIsles = false,
      hideAzerothZandalar = false,
      hideAzerothDragonIsles = false,

    --3 Continent map
      showContinent = true,
      continentScale = 1.2,
      hideRaids = false,
      hideDungeons = false,
      hideMultiple = false,
      hidePortals = false,
      hideZeppelins = false,
      hideShips = false,
      hideKalimdor = false,
      hideEasternKingdom = false,
      hideOutland = false,
      hideNorthrend = false,
      hidePandaria = false,
      hideDraenor = false,
      hideBrokenIsles = false,
      hideZandalar = false,
      hideKulTiras = false,
      hideShadowlands = false,
      hideDragonIsles = false,

    --4 Inside Dungeon Map
      showDungeonMap = true,
      hideExit = false,
      hidePassage = false,
  },
}

local Addon = CreateFrame("Frame")
Addon:RegisterEvent("PLAYER_LOGIN")
Addon:SetScript("OnEvent", function(self, event, ...) return self[event](self, ...) end)

local function updateStuff()
    updateAssignedID()
    HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote")
end

function Addon:PLAYER_ENTERING_WORLD()
    if (not self.faction) then
        self.faction = UnitFactionGroup("player")
        self:PopulateTable()
        self:PopulateMinimap()
        self:ProcessTable()
    end
 
        updateAssignedID()
        updateStuff()
end

function Addon:PLAYER_LOGIN()
local options = {
  type = "group",
  name = "MapNote",
  childGroups = "tab",
  desc = "Locations of dungeon, raid and transport symbols",
  get = function(info) return db[info[#info]] end,
  set = function(info, v) db[info[#info]] = v HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
  args = {  
    GeneralTab = {
      type = 'group',
      name = L['General'],
      desc = L["General settings that apply to Azeroth / Continent / Dungeon map at the same time"],
      order = 0,
      args = {
        hideMapNoteheader = {
          type = "header",
          name = " |cffff0000" .. L["• Hide all MapNote symbols !"] .."\n",
          order = 0.1,
          },
        hideAddon = {
          type = "toggle",
          name = "|cffff0000" .. L["• hide MapNote!"] .."\n",
          desc = L["Disable MapNote, all icons will be hidden on each map and all categories will be disabled"],
          order = 0.2,
          get = function() return db.show["HideMapNote"] end,
          set = function(info, v) db.show["HideMapNote"] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
          },    
        GeneralHeader = {
          type = "header",
          name = L["General settings / Additional functions"],
          order = 0.3,
          },
        journal = {
          disabled = function() return db.show["HideMapNote"] end,
          type = "toggle",
          name = L["• Adventure guide"],
          desc = L["Left-clicking on a MapNote raid (green), dungeon (blue) or multiple icon (green&blue) on the map opens the corresponding dungeon or raid map in the Adventure Guide (the map must not be open in full screen)"],
          order = 1,
          },    
        tomtom = {
          disabled = function() return db.show["HideMapNote"] end,
          type = "toggle",
          name = L["• TomTom waypoints"],
          desc = L["Shift+right click on a raid, dungeon, multiple symbol, portal, ship, zeppelin, passage or exit from MapNote on the continent or dungeon map creates a TomTom waypoint to this point (but the TomTom add-on must be installed for this)"],
          order = 2,
          },
        assignedID = {
          disabled = function() return db.show["HideMapNote"] end,
          type = "toggle",
          name = L["• killed Bosses"],
          desc = L["For dungeons and raids in which you have killed bosses and have therefore been assigned an ID, this symbol on the Azeroth and continent map will show you the number of killed or remaining bosses as soon as you hover over this dungeon or raid symbol (for example 2/8 mythic, 4/7 heroic etc)"],
          order = 3,
          },
        assignedgray = {
          disabled = function() return db.show["HideMapNote"] end,
          type = "toggle",
          name = L["• gray colored symbols"],
          desc = L["If you are assigned to a dungeon or raid and have an ID, this option will turn the dungeon or raid icon gray until this ID is reset so that you can see which dungeon or raid you have started or completed"],
          order = 4,
          },
        graymultipleID = {
          disabled = function() return db.show["HideMapNote"] end,
          type = "toggle",
          name = L["• gray multiple points"],
          desc = L["Colors multi-points of dungeons and/or raids in gray if you are assigned to any dungeon or raid of this multi-point and have an ID so that you can see that you have started or completed any dungeon or raid of the multi-point"],
          order = 5,
          },
        showEnemyFaction = {
          disabled = function() return db.show["HideMapNote"] end,
          type = "toggle",
          name = L["• enemy faction"],
          desc = L["Shows enemy faction (horde/alliance) symbols too"],
          order = 6,
          get = function() return db.show["EnemyFaction"] end,
          set = function(info, v) db.show["EnemyFaction"] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
         },
        showOldVanilla = {
          disabled = function() return db.show["HideMapNote"] end,
          type = "toggle",
          name = L["• Old Raids/Dungeons"],
          desc = L["Show vanilla versions of dungeons and raids such as Naxxramas, Scholomance or Scarlet Monastery, which require achievements or other things"],
          order = 7,
          get = function() return db.show["OldVanilla"] end,
          set = function(info, v) db.show["OldVanilla"] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
        }
      }
    },
    AzerothTab = {
      disabled = function() return db.show["HideMapNote"] end,
      type = 'group',
      name = L["Azeroth map"],
      desc = L["Azeroth map settings. Certain symbols can be displayed or not displayed. If the option (Activate symbols) has been activated in this category"],
      order = 2,
      args = {
        desc = {
          type = "description",
          name = "|cff00ccff" .. L["Information: Individual Azeroth symbols that are too close to other symbols on the Azeroth map are not 100% accurately placed on the Azeroth map! For precise coordination, please use the points on the continent map or zone map"] .."\n",
          order = 20.0
        },
        Azerothheader1 = {
          type = "header",
          name = L["Azeroth map options"],
          order = 20,
          },
        showAzeroth = {
          type = "toggle",
          name = L["Activate symbols"],
          desc = L["Activates the display of all possible symbols on the Azeroth map"],
          order = 20.1,
          get = function() return db.show["Azeroth"] end,
          set = function(info, v) db.show["Azeroth"] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
          },
        azerothScale = {
          disabled = function() return not db.show["Azeroth"] end,
          type = "range",
          name = L["symbol size"],
          desc = L["Resizes symbols on the continent map"],
          min = 0.5, max = 2, step = 0.1,
          order = 20.3,
          },
        Azerothheader2 = {
          type = "header",
          name = L["Hide individual symbols"],
          order = 21
          },
        hideAzerothRaid = {
          disabled = function() return not db.show["Azeroth"] end,
          type = "toggle",
          name = L["• Raids"],
          desc = L["Hide symbols of raids on the Azeroth map"],
          order = 21.1,
          set = function(info, v) db[info[#info]] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
          },
        hideAzerothDungeon = {
          disabled = function() return not db.show["Azeroth"] end,
          type = "toggle",
          name = L["• Dungeons"],
          desc = L["Hide symbols of dungeons on the Azeroth map"],
          order = 21.2,
          set = function(info, v) db[info[#info]] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
          },
        hideAzerothMultiple = {
          disabled = function() return not db.show["Azeroth"] end,
          type = "toggle",
          name = L["• Multiple"],
          desc = L["Hide symbols of multiple on the Azeroth map"],
          order = 21.3,
          set = function(info, v) db[info[#info]] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
          },
        hideAzerothPortals = {
          disabled = function() return not db.show["Azeroth"] end,
          type = "toggle",
          name = L["• Portals"],
          desc = L["Hide symbols of portals on the Azeroth map"],
          order = 21.4,
          set = function(info, v) db[info[#info]] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
          },
        hideAzerothZeppelins = {
          disabled = function() return not db.show["Azeroth"] end,
          type = "toggle",
          name = L["• Zeppelins"],
          desc = L["Hide symbols of zeppelins on the Azeroth map"],
          order = 21.5,
          set = function(info, v) db[info[#info]] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
          },
        hideAzerothShips = {
          disabled = function() return not db.show["Azeroth"] end,
          type = "toggle",
          name = L["• Ships"],
          desc = L["Hide symbols of ships on the Azeroth map"],
          order = 21.6,
          set = function(info, v) db[info[#info]] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
        },
        Azerothheader3 = {
          type = "header",
          name = L["Hide all MapNote for a specific map"],
          order = 22
          },
        hideAzerothKalimdor = {
          disabled = function() return not db.show["Azeroth"] end,
          type = "toggle",
          name = L["• Kalimdor"],
          desc = L["Hide all Kalimdor MapNote dungeon, raid, portal, zeppelin and ship symbols on the Azeroth map"],
          order = 22.1,
          set = function(info, v) db[info[#info]] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
          },
        hideAzerothEasternKingdom = {
          disabled = function() return not db.show["Azeroth"] end,
          type = "toggle",
          name = L["• Eastern Kingdom"],
          desc = L["Hide all Eastern Kingdom MapNote dungeon, raid, portal, zeppelin and ship symbols on the Azeroth map"],
          order = 22.2,
          set = function(info, v) db[info[#info]] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
          },
        hideAzerothNorthrend = {
          disabled = function() return not db.show["Azeroth"] end,
          type = "toggle",
          name = L["• Northrend"],
          desc = L["Hide all Northrend MapNote dungeon, raid, portal, zeppelin and ship symbols on the Azeroth map"],
          order = 22.3,
          set = function(info, v) db[info[#info]] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
          },
        hideAzerothPandaria = {
          disabled = function() return not db.show["Azeroth"] end,
          type = "toggle",
          name = L["• Pandaria"],
          desc = L["Hide all Pandaria MapNote dungeon, raid, portal, zeppelin and ship symbols on the Azeroth map"],
          order = 22.4,
          set = function(info, v) db[info[#info]] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
          },
        hideAzerothBrokenIsles = {
          disabled = function() return not db.show["Azeroth"] end,
          type = "toggle",
          name = L["• Broken Isles"],
          desc = L["Hide all Broken Isles MapNote dungeon, raid, portal, zeppelin and ship symbols on the Azeroth map"],
          order = 22.5,
          set = function(info, v) db[info[#info]] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
          },  
        hideAzerothZandalar = {
          disabled = function() return not db.show["Azeroth"] end,
          type = "toggle",
          name = L["• Zandalar"],
          desc = L["Hide all Zandalar MapNote dungeon, raid, portal, zeppelin and ship symbols on the Azeroth map"],
          order = 22.6,
          set = function(info, v) db[info[#info]] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
          },
        hideAzerothKulTiras = {
          disabled = function() return not db.show["Azeroth"] end,
          type = "toggle",
          name = L["• Kul Tiras"],
          desc = L["Hide all Kul Tiras MapNote dungeon, raid, portal, zeppelin and ship symbols on the Azeroth map"],
          order = 22.7,
          set = function(info, v) db[info[#info]] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
          },
        hideAzerothDragonIsles = {
          disabled = function() return not db.show["Azeroth"] end,
          type = "toggle",
          name = L["• Dragon Isles"],
          desc = L["Hide all Dragon Isles MapNote dungeon, raid, portal, zeppelin and ship symbols on the Azeroth map"],
          order = 22.8,
          set = function(info, v) db[info[#info]] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
          },
      }
    },
    ContinentTab = {
      disabled = function() return db.show["HideMapNote"] end,
      type = 'group',
      name = L["Continent map"],
      desc = L["Continent map settings. Certain symbols can be displayed or not displayed. If the option (Activate symbols) has been activated in this category"],
      order = 3,
      args = {
        continentheader1 = {
          type = "header",
          name = L["Continent map options"],
          order = 30,
          },
        showContinent = {
          type = "toggle",
          name = L["Activate symbols"],
          desc = L["Activates the display of all possible symbols on the continent map"],
          order = 30.1,
          get = function() return db.show["Continent"] end,
          set = function(info, v) db.show["Continent"] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
          },
        continentScale = {
          disabled = function() return not db.show["Continent"] end,
          type = "range",
          name = L["symbol size"],
          desc = L["Resizes symbols on the continent map"],
          min = 0.5, max = 2, step = 0.1,
          order = 30.2,
          },
        continentheader2 = {
          type = "header",
          name = L["Hide individual symbols"],
          order = 30.3,
          },
        hideRaids = {
          disabled = function() return not db.show["Continent"] end,
          type = "toggle",
          name = L["• Raids"],
          desc = L["Hide symbols of raids on the continant map and minimap"],
          order = 30.4,
          set = function(info, v) db[info[#info]] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
          },
        hideDungeons = {
          disabled = function() return not db.show["Continent"] end,
          type = "toggle",
          name = L["• Dungeons"],
          desc = L["Hide symbols of dungeons on the continant map and minimap"],
          order = 30.5,
          set = function(info, v) db[info[#info]] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
          },
        hideMultiple = {
          disabled = function() return not db.show["Continent"] end,
          type = "toggle",
          name = L["• Multiple"],
          desc = L["Hide symbols of multiple (dungeons,raids) on the continant map and minimap"],
          order = 30.6,
          set = function(info, v) db[info[#info]] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
          },
        hidePortals = {
          disabled = function() return not db.show["Continent"] end,
          type = "toggle",
          name = L["• Portals"],
          desc = L["Hide symbols of portals on the continant map and minimap"],
          order = 30.7,
          set = function(info, v) db[info[#info]] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
          },
        hideZeppelins = {
          disabled = function() return not db.show["Continent"] end,
          type = "toggle",
          name = L["• Zeppelins"],
          desc = L["Hide symbols of zeppelins on the continant map and minimap"],
          order = 30.8,
          set = function(info, v) db[info[#info]] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
          },
        hideShips = {
          disabled = function() return not db.show["Continent"] end,
          type = "toggle",
          name = L["• Ships"],
          desc = L["Hide symbols of ships on the continant map and minimap"],
          order = 30.9,
          set = function(info, v) db[info[#info]] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
        },
        continentheader3 = {
          type = "header",
          name = L["Hide all MapNote for a specific map"],
          order = 31
          },
        hideKalimdor= {
          disabled = function() return not db.show["Continent"] end,
          type = "toggle",
          name = L["• Kalimdor"],
          desc = L["Hide all Kalimdor MapNote dungeon, raid, portal, zeppelin and ship symbols on the continent map"],
          order = 31.1,
          set = function(info, v) db[info[#info]] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
          },
        hideEasternKingdom = {
          disabled = function() return not db.show["Continent"] end,
          type = "toggle",
          name = L["• Eastern Kingdom"],
          desc = L["Hide all Eastern Kingdom MapNote dungeon, raid, portal, zeppelin and ship symbols on the continent map"],
          order = 31.2,
          set = function(info, v) db[info[#info]] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
          },
        hideOutland = {
          disabled = function() return not db.show["Continent"] end,
          type = "toggle",
          name = L["• Outland"],
          desc = L["Hide all Outland MapNote dungeon, raid, portal, zeppelin and ship symbols on the continent map"],
          order = 31.3,
          set = function(info, v) db[info[#info]] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
          },
        hideNorthrend = {
          disabled = function() return not db.show["Continent"] end,
          type = "toggle",
          name = L["• Northrend"],
          desc = L["Hide all Northrend MapNote dungeon, raid, portal, zeppelin and ship symbols on the continent map"],
          order = 31.4,
          set = function(info, v) db[info[#info]] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
          },
        hidePandaria = {
          disabled = function() return not db.show["Continent"] end,
          type = "toggle",
          name = L["• Pandaria"],
          desc = L["Hide all Pandaria MapNote dungeon, raid, portal, zeppelin and ship symbols on the continent map"],
          order = 31.5,
          set = function(info, v) db[info[#info]] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
          },
        hideDraenor = {
          disabled = function() return not db.show["Continent"] end,
          type = "toggle",
          name = L["• Draenor"],
          desc = L["Hide all Draenor MapNote dungeon, raid, portal, zeppelin and ship symbols on the continent map"],
          order = 31.6,
          set = function(info, v) db[info[#info]] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
          },
        hideBrokenIsles = {
          disabled = function() return not db.show["Continent"] end,
          type = "toggle",
          name = L["• Broken Isles"],
          desc = L["Hide all Broken Isles MapNote dungeon, raid, portal, zeppelin and ship symbols on the continent map"],
          order = 31.7,
          set = function(info, v) db[info[#info]] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
          },
        hideZandalar = {
          disabled = function() return not db.show["Continent"] end,
          type = "toggle",
          name = L["• Zandalar"],
          desc = L["Hide all Zandalar MapNote dungeon, raid, portal, zeppelin and ship symbols on the continent map"],
          order = 31.8,
          set = function(info, v) db[info[#info]] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
          },
        hideKulTiras = {
          disabled = function() return not db.show["Continent"] end,
          type = "toggle",
          name = L["• Kul Tiras"],
          desc = L["Hide all Kul Tiras MapNote dungeon, raid, portal, zeppelin and ship symbols on the continent map"],
          order = 31.9,
          set = function(info, v) db[info[#info]] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
          },
        hideShadowlands = {
          disabled = function() return not db.show["Continent"] end,
          type = "toggle",
          name = L["• Shadowlands"],
          desc = L["Hide all Shadowlands MapNote dungeon, raid, portal, zeppelin and ship symbols on the continent map"],
          order = 32.0,
          set = function(info, v) db[info[#info]] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
          },
        hideDragonIsles = {
          disabled = function() return not db.show["Continent"] end,
          type = "toggle",
          name = L["• Dragon Isles"],
          desc = L["Hide all Dragon Isles MapNote dungeon, raid, portal, zeppelin and ship symbols on the continent map"],
          order = 32.1,
          set = function(info, v) db[info[#info]] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
        },
      }
    },
    DungeonMapTab = {
      disabled = function() return db.show["HideMapNote"] end,
      type = 'group',
      name = L["Dungeon map"],
      desc = L["Dungeon map settings. Certain symbols can be displayed or not displayed. If the option (Activate symbols) has been activated in this category. Shows MapNote exit and passage points on the dungeon map (these symbols are for orientation purposes only and nothing happens when you click on them)"],
      order = 4,
      args = {
        DungeonMapheader1 = {
          type = "header",
          name = L["Dungeon map options"],
          order = 40,
          },
        showDungeonMap = {
          type = "toggle",
          name = L["Activate symbols"],
          desc = L["Enables the display of all possible symbols on the dungeon map (these symbols are for orientation purposes only and nothing happens when you click on them)"],
          order = 40.1,
          get = function() return db.show["DungeonMap"] end,
          set = function(info, v) db.show["DungeonMap"] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
          },
        DungeonMapheader2 = {
          type = "header",
          name = L["Hide individual symbols"],
          order = 41.0,
          },
        hideExit = {
          disabled = function() return not db.show["DungeonMap"] end,
          type = "toggle",
          name = L["• Exit"],
          desc = L["Hide symbols of MapNote dungeon exit on the dungeon map"],
          order = 41.1,
          set = function(info, v) db[info[#info]] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
          },
        hidePassage = {
          disabled = function() return not db.show["DungeonMap"] end,
          type = "toggle",
          name = L["• Passage"],
          desc = L["Hide symbols of passage on the dungeon map"],
          order = 41.2,
          set = function(info, v) db[info[#info]] = v self:FullUpdate() HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MapNote") end,
          },
      }
    }
  }
}

  HandyNotes:RegisterPluginDB("MapNote", pluginHandler, options)
  self.db = LibStub("AceDB-3.0"):New("MapNoteDB", defaults, true)
  db = self.db.profile
  Addon:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function Addon:PopulateMinimap()
    local temp = { }
    for k,v in pairs(nodes) do
        if (minimap[k]) then
            for a,b in pairs(minimap[k]) do
	            temp[a] = true
            end
            for c,d in pairs(v) do
                if (not temp[c] and not d.hideOnMinimap) then
	                minimap[k][c] = d
	            end
            end
        end
    end
end

function Addon:PopulateTable()
table.wipe(nodes)
table.wipe(minimap)


-- Dungeon MapNote
nodes[280] = { } -- Maraudon Caverns of Maraudon
nodes[281] = { } -- Caverns of Maraudon
-- Outland
nodes[246] = { } -- Shattered Halls
nodes[256] = { } -- Auchenai Crypts
nodes[258] = { } -- Sethekk Halls
nodes[260] = { } -- Shadow Labyrinth
nodes[261] = { } -- Blood Furnace
nodes[262] = { } -- The Underbog
nodes[263] = { } -- Steamvault
nodes[265] = { } -- Slave Pens
nodes[266] = { } -- Botanica
nodes[267] = { } -- Mechanar
nodes[269] = { } -- Arcatraz
nodes[272] = { } -- Mana Tombs
nodes[332] = { } -- Serpentshrine Cavern
nodes[330] = { } -- Gruul
nodes[331] = { } -- Magtheridons
nodes[334] = { } -- The Eye
nodes[339] = { } -- Black Temple
nodes[340] = { } -- Karabor Sewers
nodes[341] = { } -- Sanctuary of Shadows
nodes[342] = { } -- Halls of Anguish
nodes[343] = { } -- Gorefiend's Vigil
nodes[344] = { } -- Den of Mortal Delights
nodes[345] = { } -- Chamber of Command
nodes[346] = { } -- Temple Summit
nodes[347] = { } -- Hellfire Ramparts
-- Draenor
nodes[573] = { } -- Bloodmaul Slag Mines
nodes[574] = { } -- Shadowmoon Burial Grounds
nodes[593] = { } -- Auchindoun
nodes[595] = { } -- Iron Docks
nodes[598] = { } -- Blackrock Foundry
nodes[601] = { } -- Skyreach
nodes[606] = { } -- Grimrail Depot
nodes[611] = { } -- Highmaul
nodes[620] = { } -- The Everbloom
nodes[661] = { } -- Hellfire Citadel
-- Shadowlands
nodes[1663] = { } -- Halls of Atonement
nodes[1666] = { } -- The Necrotic Wake
nodes[1669] = { } -- Mists of Tirna Scithe
nodes[1674] = { } -- Plaguefall
nodes[1675] = { } -- Sanguine Depths
nodes[1680] = { } -- De Other Side
nodes[1683] = { } -- Theater of Pain
nodes[1692] = { } -- Spires of Ascension
nodes[1735] = { } -- Castle Nathria 
nodes[1989] = { } -- Tazavesh, the Veiled Market
nodes[1998] = { } -- Sanctum of Domination  
nodes[2047] = { } -- Sepulcher of the First Ones
-- Dragonflight 
nodes[2073] = { } -- The Azure Vault
nodes[2080] = { } -- Neltharus
nodes[2082] = { } -- Halls of Infusion  
nodes[2093] = { } -- The Nokhud Offensive
nodes[2095] = { } -- Ruby Life Pools 
nodes[2096] = { } -- Brackenhide Hollow
nodes[2097] = { } -- Algeth'ar Academy
nodes[2190] = { } -- Dawn of the Infinite
nodes[2096] = { } -- Brackenhide Hollow
nodes[2097] = { } -- Algeth'ar Academy
nodes[2190] = { } -- Dawn of the Infinite
nodes[2119] = { } -- Vault of the Incarnates
nodes[2166] = { } -- Aberrus, the Shadowed Crucible
nodes[2232] = { } -- Amirdrassil


-- Map MapNote
nodes[947] = { } -- Azeroth
-- Kalimdor & Eastern Kingdom
nodes[10] = { } -- Barrens    
nodes[11] = { } -- Wailing Caverns
nodes[12] = { } -- Kalimdor 
nodes[13] = { } -- Eastern Kingdoms   
nodes[14] = { } -- Arathi Highlands
nodes[15] = { } -- Badlands
nodes[17] = { } -- Blasted Lands
nodes[18] = { } -- Tirisfal   
nodes[19] = { } -- ScarletMonasteryEntrance 
nodes[21] = { } -- Silverpine    
nodes[22] = { } -- WesternPlaguelands 
nodes[23] = { } -- EasternPlaguelands
nodes[27] = { } -- DunMorogh
nodes[30] = { } -- New Tinker Town  
nodes[33] = { } -- BlackrockMountain
nodes[36] = { } -- BurningSteppes    
nodes[42] = { } -- DeadwindPass   
nodes[50] = { } -- StranglethornJungle
nodes[51] = { } -- SwampOfSorrows
nodes[52] = { } -- Westfall    
nodes[55] = { } -- The Deadmines Caverns
nodes[62] = { } -- Darkshore Vanilla
nodes[63] = { } -- Ashenvale  
nodes[64] = { } -- Thousand Needles  
nodes[66] = { } -- Desolace    
nodes[67] = { } -- Maraudon Outside  
nodes[68] = { } -- Maraudon Foulspore Cavern    
nodes[69] = { } -- Feralas
nodes[70] = { } -- Dustwallow
nodes[71] = { } -- Tanaris
nodes[75] = { } -- Caverns of Time
nodes[81] = { } -- Silithus    
nodes[84] = { } -- Stormwind City   
nodes[85] = { } -- Orgrimmar 
nodes[94] = { } -- Eversong Woods
nodes[110] = { } -- Silvermoon City   
nodes[199] = { } -- Southern Barrens  
nodes[210] = { } -- Stranglethorn Vale
nodes[224] = { } -- Stranglethorn Vale
nodes[327] = { } -- AhnQiraj The Fallen Kingdom  
nodes[469] = { } -- New Tinkertown 
nodes[2070] = { } -- New Tirisfal
-- Outland
nodes[95] = { } -- Ghostlands    
nodes[100] = { } -- Hellfire 
nodes[102] = { } -- Zangarmarsh   
nodes[104] = { } -- ShadowmoonValley  
nodes[105] = { } -- BladesEdgeMountains    
nodes[108] = { } -- TerokkarForest
nodes[109] = { } -- Netherstorm
nodes[122] = { } -- Sunwel, Isle of Quel'Danas 
-- Wrath of the Lich King
nodes[113] = { } -- Northrend
nodes[114] = { } -- Borean Tundra
nodes[115] = { } -- Dragonblight    
nodes[117] = { } -- HowlingFjord    
nodes[118] = { } -- IcecrownGlacier  
nodes[120] = { } -- The Storm Peaks
nodes[121] = { } -- Zul'Drak
nodes[123] = { } -- LakeWintergrasp  
nodes[125] = { } -- Dalaran City    
nodes[127] = { } -- Crystalsong Forest 
-- Catalysm
nodes[198] = { } -- Hyjal
nodes[203] = { } -- Vashjir
nodes[204] = { } -- VashjirDepths 
nodes[207] = { } -- Deepholm
nodes[241] = { } -- TwilightHighlands   
nodes[244] = { } -- TolBarad    
nodes[249] = { } -- Uldum  
nodes[948] = { } -- The Maelstrom
nodes[1527] = { } -- Uldum
-- Misk of Pandaria
nodes[371] = { } -- TheJadeForest
nodes[376] = { } -- ValleyoftheFourWinds    
nodes[379] = { } -- KunLaiSummit  
nodes[388] = { } -- TownlongWastes    
nodes[390] = { } -- ValeofEternalBlossoms    
nodes[422] = { } -- DreadWastes   
nodes[424] = { } -- Pandaria   
nodes[433] = { } -- ThehiddenPass
nodes[504] = { } -- IsleoftheThunderKing
nodes[1530] = { } -- ValeofEternalBlossoms New
-- Warlords of Draenor
nodes[1]  = { } -- Durotar
nodes[463] = { } -- Echo Isles
nodes[525] = { } -- FrostfireRidge
nodes[543] = { } -- Gorgrond
nodes[550] = { } -- NagrandDraenor
nodes[539] = { } -- ShadowmoonValleyDR
nodes[542] = { } -- SpiresOfArak
nodes[534] = { } -- TanaanJungle
nodes[535] = { } -- Talador
nodes[572] = { } -- Draenor
nodes[588] = { } -- Ashran
nodes[590] = { } -- Frostwall
nodes[624] = { } -- Warspear
-- Legion
nodes[619] = { } -- Broken Isles
nodes[627] = { } -- Dalaran
nodes[630] = { } -- Aszuna
nodes[905] = { } -- Argus
nodes[941] = { } -- Krokuun, Vindikaar Lower Deck
-- Battle of Azeroth
nodes[862] = { } -- Zuldazar
nodes[863] = { } -- Nazmir
nodes[864] = { } -- Vol'Dun
nodes[875] = { } -- Zandalar
nodes[876] = { } --Kul'Tiras
nodes[895] = { } -- Tiragarde Sound
nodes[896] = { } -- Drustvar
nodes[942] = { } -- Stormsong Valley
nodes[1161] = { } --  Boralus City
nodes[1163] = { } -- Inside Dazar'alor
nodes[1165] = { } -- Dazar'alor
nodes[1169] = { } -- Tol Dagor
nodes[1355] = {} -- Nazjatar
nodes[1462] = {} -- Mechagon
-- Shadowlands
nodes[1533] = { } -- Bastion
nodes[1536] = { } -- Maldraxxus
nodes[1543] = { } -- The Maw
nodes[1565] = { } -- Ardenweald
nodes[1525] = { } -- Revendreth
nodes[1543] = { } -- The Maw
nodes[1670] = { } -- Oribos
nodes[1550] = { } -- Shadowlands
nodes[1970] = { } -- Zereth Mortis 
nodes[2016] = { } -- Tazavesh, the Veiled Market
-- Dragonflight
nodes[1978] = { } -- Dragon Isles
nodes[2022] = { } -- The Waking Shores
nodes[2023] = { } -- Ohn'ahran Plains
nodes[2024] = { } -- The Azure Span
nodes[2025] = { } -- Thaldraszus
nodes[2026] = { } -- The Forbidden Reach
nodes[2133] = { } -- Zaralek Cavern
nodes[2112] = { } -- Valdrakken
nodes[2200] = { } -- The Emerald Dream

if not db.show["HideMapNote"] then

  -- Old Vanilla versions from Dungeons/Raids
  if db.show["OldVanilla"] then

    nodes[947][90194066] = { 
    name = L["Old version of Naxxramas - Secret Entrance (Wards of the Dread Citadel - Achievement)"],
    type = "VRaid",
    showInZone = true,
    hideOnContinent = false,
    }-- Old Naxxramas version - Secret Entrance - Wards of the Dread Citadel

    nodes[947][89714326] = { 
    name = L["Old version of Scholomance - Secret Entrance (Memory of Scholomance - Achievement)"],
    type = "VRaid",
    showInZone = true,
    hideOnContinent = false,
    }-- Old version of Scholomance - Secret Entrance

    nodes[13][54113049] = { 
    name = L["Old version of Naxxramas - Secret Entrance (Wards of the Dread Citadel - Achievement)"],
    type = "VRaid",
    showInZone = true,
    }-- Old Naxxramas version - Secret Entrance - Wards of the Dread Citadel

    nodes[23][42152576] = { 
    name = L["Old version of Naxxramas - Secret Entrance (Wards of the Dread Citadel - Achievement)"],
    type = "VRaid",
    showInZone = true,
    hideOnContinent = true,
    }-- Old Naxxramas version - Secret Entrance - Wards of the Dread Citadel

    nodes[19][48275496] = {
    name = L["Old keychain - use the old keychain to activate the old versions of Scarlet Monastery dungeons (you need to get first (The Scarlet Key) from Hallow's End world event or buy from auction house)"],
    type = "VKey1",
    showInZone = true,
    } -- Scarlet Monastery Key for Old dungeons

    nodes[13][46193139] = {
    name = L["Old keychain - use the old keychain to activate the old versions of Scarlet Monastery dungeons (you need to get first (The Scarlet Key) from Hallow's End world event or buy from auction house)"],
    type = "VKey1",
    showInZone = true,
    } -- Scarlet Monastery Key for Old dungeons

    nodes[18][83863199] = {
    name = L["Old keychain - use the old keychain to activate the old versions of Scarlet Monastery dungeons (you need to get first (The Scarlet Key) from Hallow's End world event or buy from auction house)"],
    type = "VKey1",
    showInZone = true,
    hideOnContinent = true,
    } -- Scarlet Monastery Key for Old dungeons

    nodes[947][86344322] = {
    name = L["Old keychain - use the old keychain to activate the old versions of Scarlet Monastery dungeons (you need to get first (The Scarlet Key) from Hallow's End world event or buy from auction house)"],
    type = "VKey1",
    showInZone = true,
    } -- Scarlet Monastery Key for Old dungeons

    nodes[18][85353028] = {
    name = L["Old version of Scarlet Monastery Cathedral (need to activate the old keychain at 48.33 55.88 inside the Scarlet Monastery)"],
    type = "VDungeon",
    showInZone = false,
    } -- Scarlet Monastery - Cathedral

    nodes[18][85153180] = {
    name = L["Old version of Scarlet Monastery Library (need to activate the old keychain at 48.33 55.88 inside the Scarlet Monastery)"],
    type = "VDungeon",
    showInZone = false,
    } -- Scarlet Monastery - Library

    nodes[18][84763039] = {
    name = L["Old version of Scarlet Monastery Graveyard (need to activate the old keychain at 48.33 55.88 inside the Scarlet Monastery)"],
    type = "VDungeon",
    showInZone = false,
    } -- Scarlet Monastery - Graveyard

    nodes[18][85573138] = {
    name = L["Old version of Scarlet Monastery Armory (need to activate the old keychain at 48.33 55.88 inside the Scarlet Monastery)"],
    type = "VDungeon",
    showInZone = false,
    } -- Scarlet Monastery - Armory

    nodes[19][78882223] = {
    name = L["Old version of Scarlet Monastery Cathedral (need to activate the old keychain at 48.33 55.88 inside the Scarlet Monastery)"],
    type = "VDungeon",
    showInZone = true,
    } -- Scarlet Monastery - Cathedral

    nodes[19][78255762] = {
    name = L["Old version of Scarlet Monastery Library (need to activate the old keychain at 48.33 55.88 inside the Scarlet Monastery)"],
    type = "VDungeon",
    showInZone = true,
    } -- Scarlet Monastery - Library

    nodes[19][68832372] = {
    name = L["Old version of Scarlet Monastery Graveyard (need to activate the old keychain at 48.33 55.88 inside the Scarlet Monastery)"],
    type = "VDungeon",
    showInZone = true,
    } -- Scarlet Monastery - Graveyard

    nodes[19][86414766] = {
    name = L["Old version of Scarlet Monastery Armory (need to activate the old keychain at 48.33 55.88 inside the Scarlet Monastery)"],
    type = "VDungeon",
    showInZone = true,
    } -- Scarlet Monastery - Armory

    nodes[13][51383556] = {
    type = "VDungeon",
    name = L["Old version of Scholomance - Secret Entrance (Memory of Scholomance - Achievement)"],
    showInZone = true,
    } -- Old Scholomance version - Memory of Scholomance - Secret Entrance Old Scholomance version

    nodes[22][70897246] = {
    type = "VDungeon",
    name = L["Old version of Scholomance - Secret Entrance (Memory of Scholomance - Achievement)"],
    showInZone = true,
    hideOnContinent = true,
    } -- Old Scholomance version - Memory of Scholomance - Secret Entrance Old Scholomance version
  end

  --Inside Dungeon MapNote
  if db.show["DungeonMap"] then

    if (not self.db.profile.hideExit) then

    --Kalimdor
      nodes[66][29106256] = {
      id = 232,
      type = "Dungeon",
      hideOnContinent = true,
      } -- Maraudon Outside 

      nodes[280][62402795] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Maraudon Caverns of Maraudon Orange Crystal

      nodes[280][78676842] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Maraudon Caverns of Maraudon Purple Crystal 


    --Draenor


    --Outland
      nodes[340][21756343] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Black Temple exit

      nodes[334][50168768] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- The Eye

      nodes[330][81397732] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Gruul

      nodes[331][60991776] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Magtheridons

      nodes[332][13436343] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Serpentshrine Cavern

      nodes[266][90343942] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Botanica

      nodes[267][49378580] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Mechanar

      nodes[269][41378627] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Arcatraz

      nodes[265][21121328] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Slave Pens

      nodes[263][17353047] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Steamvault

      nodes[347][52207097] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Hellfire Ramparts

      nodes[262][28027003] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- The Underbog

      nodes[261][48439051] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Blood Furnace

      nodes[260][21750952] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Shadow Labyrinth

      nodes[246][61929285] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Shattered Halls

      nodes[258][73393824] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Sethekk Halls

      nodes[272][33361564] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Mana Tombs

      nodes[256][44197716] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Auchenai Crypts

    -- Draenor
      nodes[595][52048698] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Bloodmaul Slag Mines

      nodes[574][08256955] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Shadowmoon Burial Grounds

      nodes[593][49849145] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Auchindoun

      nodes[595][29594366] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Iron Docks

      nodes[598][41059246] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Blackrock Foundry

      nodes[601][60362459] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Skyreach

      nodes[606][32422553] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Grimrail Depoot

      nodes[611][26772324] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Highmaul    

      nodes[620][72295519] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Everbloom     

      nodes[661][72604342] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Hellfire Citadel 

    --Shadowlands
      nodes[1663][89875409] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Halls of Atonement

      nodes[1666][82863999] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- The Necrotic Wake

      nodes[1669][93861796] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Mists of Tirna Scithe

      nodes[1674][29981643] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Plaguefall

      nodes[1675][09825103] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Sanguine Depths

      nodes[1680][50581456] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- De Other Side

      nodes[1683][50498296] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Theater of Pain

      nodes[1692][40586445] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Spires of Ascension      

      nodes[1735][34468069] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Castle Nathria      

      nodes[1998][29478607] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Sanctum of Domination  

      nodes[1989][90914372] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Tazavesh, the Veiled Market

      nodes[2047][07465150] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Sepulcher of the First Ones
      

    --Dragon Isles
      nodes[2073][77623071] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- The Azure Vault

      nodes[2080][52562070] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Neltharus

      nodes[2082][08403471] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Halls of Infusion      

      nodes[2093][60673862] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- The Nokhud Offensive

      nodes[2095][42789333] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Ruby Life Pools 
      
      nodes[2096][06524366] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Brackenhide Hollow

      nodes[2097][42157591] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Algeth'ar Academy

      nodes[2190][33202089] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Dawn of the Infinite
     
      nodes[2119][63509475] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Vault of the Incarnates

      nodes[2166][51269498] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Aberrus, the Shadowed Crucible

      nodes[2232][50789310] = {
      name = L["Exit"],
      type = "Exit",
      showInZone = true,
      } -- Aberrus, the Shadowed Crucible
      end

    if (not self.db.profile.hidePassage) then

        -- Maraudon
        nodes[280][13585809] = { 
        name = L["Passage"],
        type = "Passageleft",
        showInZone = true,
        } -- Maraudon passage to Zaetar's Grave

        nodes[281][29120410] = {
        name = L["Passage"],
        type = "Passageright",
        showInZone = true,
        } -- Maraudon passage to Zaetar's Grave

        -- Black Temple
        nodes[339][76054672] = { 
        name = L["Passage"],
        UiMapID = 340,
        type = "Passageright",
        showInZone = true,
        } -- Black Temple passage

        nodes[339][28657991] = {
        name = L["Passage"],
        type = "Passagedown",
        showInZone = true,
        } -- Black Temple passage

        
        nodes[340][27240693] = {
        name = L["Passage"],
        type = "Passageup",
        showInZone = true,
        } -- Black Temple passage

        nodes[341][61933384] = {
        name = L["Passage"],
        type = "Passageright",
        showInZone = true,
        } -- Black Temple passage

        nodes[341][21124985] = {
        name = L["Passage"],
        type = "Passageleft",
        showInZone = true,
        } -- Black Temple passage

        nodes[341][57859035] = {
        name = L["Passage"],
        type = "Passageleft",
        showInZone = true,
        } -- Black Temple passage

        nodes[341][26302301] = {
        name = L["Passage"],
        type = "Passagedown",
        showInZone = true,
        } -- Black Temple passage

        nodes[342][63033918] = {
        name = L["Passage"],
        type = "Passageleft",
        showInZone = true,
        } -- Black Temple passage

        nodes[343][74966845] = {
        name = L["Passage"],
        type = "Passageright",
        showInZone = true,
        } -- Black Temple passage

        nodes[344][008254813] = {
        name = L["Passage"],
        type = "Passageup",
        showInZone = true,
        } -- Black Temple passage

        nodes[344][67275590] = {
        name = L["Passage"],
        type = "Passagedown",
        showInZone = true,
        } -- Black Temple passage

        nodes[345][47333054] = {
        name = L["Passage"],
        type = "Passageup",
        showInZone = true,
        } -- Black Temple passage

        nodes[345][69461241] = {
        name = L["Passage"],
        type = "Passageup",
        showInZone = true,
        } -- Black Temple passage

        nodes[346][52821234] = {
        name = L["Passage"],
        type = "Passageup",
        showInZone = true,
        } -- Black Temple passage
    end
  end


  --Azeroth MapNote
	if db.show["Azeroth"] then
    
    if (not self.db.profile.hideAzerothKalimdor) then  --Kalimdor
      
      if (not self.db.profile.hideAzerothDungeon) then  --Dungeons

        nodes[947][26635536] = {
        id = 240,
        type = "Dungeon",
        showInZone = true,
        } -- Wailing Caverns

        nodes[947][22724585] = {
        id = 227,
        type = "Dungeon",
        showInZone = true,
        } -- Blackfathom Deeps

        nodes[947][27126301] = {
        id = 233,
        type = "Dungeon",
        showInZone = true,
        } -- Razorfen Downs

        nodes[947][27416697] = {
        id = 241,
        type = "Dungeon",
        showInZone = true,
        } -- Zul'Farrak    

        nodes[947][20055663] = {
        id = 232,
        type = "Dungeon",
        showInZone = true,
        } -- Maraudon

        nodes[947][22126200] = {
        id = 230,
        lfgid = 36,
        type = "Dungeon",
        showInZone = true,
        } -- Dire Maul - Capital Gardens

        nodes[947][29395008] = {
        id = 226,
        type = "Dungeon",
        showInZone = true,
        } -- Ragefire

        nodes[947][25766218] = {
        id = 234,
        type = "Dungeon",
        showInZone = true,
        } -- Razorfen Kraul

        nodes[947][26777580] = {
        id = 68,
        type = "Dungeon",
        showInZone = true,
        } -- The Vortex Pinnacle

        nodes[947][25237426] = {
        id = 69,
        type = "Dungeon",
        showInZone = true,
        } -- Lost City of Tol'Vir

        nodes[947][26337316] = {
        id = 70,
        type = "Dungeon",
        showInZone = true,
        } -- Halls of Origination

        nodes[947][46234797] = {
        id = 67,
        type = "Dungeon",
        showInZone = true,
        } -- The Stonecore

      end

      if (not self.db.profile.hideAzerothRaid) then  --Raids
        nodes[947][27684669] = {
        id = 78,
        type = "Raid",
        showInZone = true,
        } -- Firelands

        nodes[947][28906346] = {
        id = 760,
        type = "Raid",
        showInZone = true,
        } -- Onyxia's Lair

        nodes[947][21116955] =  {
        id = { 744, 743 },
        type = "Raid",
        showInZone = true,
        } -- Temple of Ahn'Qiraj, Ruins of Ahn'Qiraj

        nodes[947][23887588] = {
        id = 74,
        type = "Raid",
        showInZone = true,
        } -- Throne of the Four Winds
      end

      if (not self.db.profile.hideAzerothMultiple) then  --Multiple Nodes

        nodes[947][30076932] = {
        id = { 187, 279, 255, 251, 750, 184, 185, 186 },
        type = "Multiple",
        showInZone = true,
      } -- Dragon Soul, The Battle for Mount Hyjal, The Culling of Stratholme, Black Morass, Old Hillsbrad Foothills, End Time, Well of Eternity, Hour of Twilight Heroic
      end

      if (not self.db.profile.hideAzerothShips) then  --Ships
        nodes[947][29125574] = { 
        name = L["Ship to Booty Bay, Stranglethorn Vale"],
        type = "Ship",
        showInZone = true,
        } -- Ship from Ratchet to Booty Bay

        if (self.faction == "Horde") or db.show["EnemyFaction"] then
          nodes[947][31315572] = {
          name = L["Ship to Dazar'alor, Zandalar"],
          type = "HShip",
          showInZone = true,
          } -- Ship from Echo Isles to Dazar'alor - Zandalar
        end
      end

      if (not self.db.profile.hideAzerothPortals) then  --Portals

          nodes[947][22226727] = {
          name = L["Portal to Zandalar(horde)/Boralus(alliance)"],
          type = "Portal",
          showInZone = true,
          } -- Portal from Silithus to Zandalar

        if (self.faction == "Horde") or db.show["EnemyFaction"] then
          nodes[947][23994090] = {
          name = L["Portal to Zandalar (its only shown up ingame if your faction is currently occupying Bashal'Aran"],
          type = "HPortal",
          showInZone = true,
          } -- Portal from New Darkshore to Zandalar
        end

        if (self.faction == "Alliance") or db.show["EnemyFaction"] then
          nodes[947][24484189] = {
          name = L["Portal to Boralus (its only shown up ingame if your faction is currently occupying Bashal'Aran"],
          type = "APortal",
          showInZone = true,
          } -- Portal from New Darkshore to Boralus
        end
      end

      if (not self.db.profile.hideAzerothZeppelins) then  --Zeppelins

        if (self.faction == "Horde") or db.show["EnemyFaction"] then
          nodes[947][30485132] = {
          name = L["Zeppelin to Walking Shores, Dragon Isles"],
          type = "HZeppelin",
          showInZone = true,
          } -- Zeppelin from Durotar to The Walking Shores - Dragonflight
        end
      end

      if (not self.db.profile.hideShips) then

        if (self.faction == "Horde") or db.show["EnemyFaction"] then
          nodes[947][31315552] = {
          name = L["Ship to Dazar'alor, Zuldazar"],
          type = "HShip",
          } -- Ship from Echo Isles to Dazar'alor - Zandalar
        end

        if (self.faction == "Alliance") or db.show["EnemyFaction"] then
          nodes[947][29966131] = {
          name = L["Ship to Menethil Harbor, Wetlands"],
          type = "AShip",
          showInZone = true,
          } -- Ship from Dustwallow Marsh to Menethil Harbor
        end
        
      end
    end

    if (not self.db.profile.hideAzerothEasternKingdom) then  --Eastern Kingdom

      if (not self.db.profile.hideAzerothDungeon) then  --Dungeons

        nodes[947][92813801] = {
        id = 77,
        type = "Dungeon",
        showInZone = true,
        } -- Zul'Aman

        nodes[947][91972614] = {
        id = 249,
        type = "Dungeon",
        showInZone = true,
        } -- Magisters' Terrace

        nodes[947][86434185] = {
        id = { 311, 316 },
        type = "Dungeon",
        showInZone = true,
        } -- Scarlet Halls, Monastery

        nodes[947][90175975] = { 
        id = 239,
        name = "Uldaman back entrance",
        type = "Dungeon",
        showInZone = true,
        } -- Uldaman (Secondary Entrance)

        nodes[947][83204721] = {
        id = 64,
        type = "Dungeon",
        showInZone = true,
        } -- Shadowfang Keep

        nodes[947][88634402] = { 
        id = 246,
        type = "Dungeon",
        showInZone = true,
        } -- Scholomance

        nodes[947][89593995] = {
        id = 236,
        lfgid = 40,
        type = "Dungeon",
        showInZone = true,
        } -- Stratholme

        nodes[947][90503929] = {
        id = 236,
        lfgid = 274,
        type = "Dungeon",
        showInZone = true,
        }-- Stratholme Service Entrance

        nodes[947][84445688] = {
        id = 231,
        type = "Dungeon",
        showInZone = true,
        } -- Gnomeregan

        nodes[947][86767011] = {
        id = 76,
        type = "Dungeon",
        showInZone = true,
        } -- Zul'Gurub

        nodes[947][90366709] = {
        id = 237,
        type = "Dungeon",
        showInZone = true,
        } -- The Temple of Atal'hakkar

        nodes[947][83226850] = {
        id = 63,
        type = "Dungeon",
        showInZone = true,
        } -- Deadmines  

        nodes[947][84056387] = {
        id = 238,
        type = "Dungeon",
        showInZone = true,
        } -- The Stockade

        nodes[947][79985920] = {
        id = 65,
        type = "Dungeon",
        showInZone = true,
        } -- Throne of Tides
      end

      if (not self.db.profile.hideAzerothRaid) then  --Raids

        nodes[947][80455260] = {
        id = 75,
        type = "Raid",
        showInZone = true,
        } -- Baradin Hold

        nodes[947][90652724] = {
        id = 752,
        type = "Raid",
        showInZone = true,
        } -- Sunwell Plateau

        nodes[947][90655621] = {
        id = 72,
        type = "Raid",
        showInZone = true,
        } -- The Bastion of Twilight

        nodes[947][89945460] = {
        id = 71,
        type = "Dungeon",
        showInZone = true,
        } -- Grim Batol
      end

      if (not self.db.profile.hideAzerothMultiple) then

        nodes[947][88006838] = {
        id = { 745, 860 }, 
        type = "Multiple",
        showInZone = true,
        } -- Karazhan, Return to Karazhan

        nodes[947][89225843] = { 
        id = { 1197, 239 },
        type = "Dungeon",
        showInZone = true,
        } --  Legacy of Tyr Dragonflight Dungeon & Vanilla Uldaman    

        nodes[947][86536189] = {
        id = { 73, 741, 742, 66, 228, 229, 559 },
        type = "Multiple",
        showInZone = true,
        } -- Blackwind Descent, Molten Core, Blackwing Lair, Blackrock Caverns, Blackrock Depths, Lower Blackrock Spire, Upper Blackrock Spire
      end

      if (not self.db.profile.hideAzerothPortals) then  --Portals

        if (self.faction == "Horde") or db.show["EnemyFaction"] then
          nodes[947][84864258] = {
          name = L["Portal to Orgrimmar"],
          type = "HPortal",
          showInZone = true,
          } -- Portal from Tirisfal to Orgrimmar 

          nodes[947][88074841] = {
          name = L["Portal to Zandalar"],
          type = "HPortal",
          showInZone = true,
          hideOnContinent = false,
          } -- Portal from Arathi to Zandalar

          nodes[947][91853164] = {
          name = L["Portal to Orgrimmar"],
          type = "HPortal",
          showInZone = true,
          } -- Portal from Silvermoon to Orgrimmar 

          nodes[947][89587016] = {
          name = L["Dark Portal (Portal to Warspear, Ashran)"],
          type = "HPortal",
          showInZone = true,
          hideOnContinent = true,
          } -- Portal from Blasted Lands to Warspear
        end

        if (self.faction == "Alliance") or db.show["EnemyFaction"] then
          nodes[947][89587016] = {
          name = L["Dark Portal (Portal to Stormshield, Ashran)"],
          type = "APortal",
          showInZone = true,
          hideOnContinent = true,
          } -- Portal from Blasted Lands to Stormshield
        end
      end

      if (not self.db.profile.hideAzerothZeppelins) then  --Zeppelins

        if (self.faction == "Horde") or db.show["EnemyFaction"] then
          nodes[947][85057132] = {
          name = L["Zeppelin to Orgrimmar"],
          type = "HZeppelin",
          showInZone = true,
          } -- Zeppelin from Stranglethorn Valley to Ogrimmar
        end
      end

      if (not self.db.profile.hideAzerothShips) then  --Ships

        nodes[947][84667504] = { 
        name = L["Ship to Ratchet, Northern Barrens"],
        type = "Ship",
        showInZone = true,
        } -- Ship from Booty Bay to Ratchet

        if (self.faction == "Alliance") or db.show["EnemyFaction"] then
          nodes[947][83286294] = { 
          name = L["Ships to Valiance Keep, Borean Tundra and to Boralus Harbor, Tiragarde Sound"],
          type = "AShip",
          showInZone = true,
          } -- Ship from Stormwind to Valiance Keep
        end
      end
    end

    if (not self.db.profile.hideAzerothNorthrend) then  --Northrend

      if (not self.db.profile.hideAzerothDungeon) then  --Dungeons

        nodes[947][47451709] = {
        id = { 271, 272 },
        type = "Dungeon",
        } -- Ahn'kahet The Old Kingdom, Azjol-Nerub

        nodes[947][57062211] = {
        id = { 286, 285 },
        type = "Dungeon",
        showInZone = true,
        } -- Utgarde Pinnacle, Utgarde Keep,

        nodes[947][53111487] = {
        id = 273,
        type = "Dungeon",
        showInZone = true,
        } -- Drak'Tharon Keep

        nodes[947][56481047] = {
        id = 274,
        type = "Dungeon",
        showInZone = true,
        } -- Gundrak

        nodes[947][50781352] = {
        id = 283,
        type = "Dungeon",
        showInZone = true,
        } -- The Violet Hold
      end

      if (not self.db.profile.hideAzerothRaid) then  --Raids

        nodes[947][52131713] = {
        id = 754,
        type = "Raid",
        showInZone = true,
        } -- Naxxramas

        nodes[947][50001736] = {
        id = { 755, 761 },
        type = "Raid",
        showInZone = true,
        } -- The Ruby Sanctum, The Obsidian Sanctum

        nodes[947][46291352] = {
        id =  753, 
        type = "Raid",
        showInZone = true,
        } -- Vault of Archavon
      end

      if (not self.db.profile.hideAzerothMultiple) then  --Multiple nodes

        nodes[947][47421290] = {
        id = { 758, 276, 278, 280 },
        type = "Multiple",
        showInZone = true,
        } -- Icecrown Citadel, The Forge of Souls, Halls of Reflection, Pit of Saron

        nodes[947][51880617] = {
        id = { 759, 277, 275 },
        type = "Multiple",
        showInZone = true,
        } -- Ulduar, Halls of Stone, Halls of Lightning

        nodes[947][49290747] = {
        id = { 757, 284 },
        type = "Multiple",
        showInZone = true,
        } -- Trial of the Crusader, Trial of the Champion

        nodes[947][40641671] = {
        id = { 756, 282, 281 },
        type = "Multiple",
        showInZone = true,
        } -- The Eye of Eternity, The Nexus, The Oculus
      end

      if (not self.db.profile.hideAzerothPortals) then  --Portals

        if (self.faction == "Horde") or db.show["EnemyFaction"] then
          nodes[947][49401233] = {
          name = L["Portal to Orgrimmar"],
          type = "HPortal",
          showInZone = true,
          } -- Portal from Old Dalaran to Orgrimmar
        end

        if (self.faction == "Alliance") or db.show["EnemyFaction"] then
          nodes[947][49151346] = {
          name = L["Portal to Stormwind City"],
          type = "APortal",
          showInZone = true,
          } -- Portal from Old Dalaran to Stormwind
        end
      end

      if (not self.db.profile.hideAzerothZeppelins) then  --Zeppelins

        if (self.faction == "Horde") or db.show["EnemyFaction"] then
          nodes[947][41841870] = {
          name = L["Zeppelin to Orgrimmar"],
          type = "HZeppelin",
          showInZone = true,
          } -- Zeppelin from Borean Tundra to Ogrimmar
        end
      end

      if (not self.db.profile.hideAzerothShips) then  --Zeppelins

        if (self.faction == "Alliance") or db.show["EnemyFaction"] then
          nodes[947][43232009] = {
          name = L["Ship to Stormwind City"],
          type = "AShip",
          showInZone = true,
          } -- Ship from Borean Tundra to Stormwind

          nodes[947][57602350] = {
          name = L["Ship to Stormwind City"],
          type = "AShip",
          showInZone = true,
          } -- Ship from Borean Tundra to Stormwind
        end
      end
    end


    if (not self.db.profile.hideAzerothPandaria) then  --Pandaria

      if (not self.db.profile.hideAzerothDungeon) then  --Dungeons
        nodes[947][53138189] = {
        id = 313,
        type = "Dungeon",
        showInZone = true,
        } -- Temple of the Jade Serpent

        nodes[947][47568563] = {
        id = 302,
        type = "Dungeon",
        showInZone = true,
        } -- Stormstout Brewery 

        nodes[947][45737584] = {
        id = 312,
        type = "Dungeon",
        showInZone = true,
        } -- Shado-Pan Monastery

        nodes[947][41918090] = {
        id = 324,
        type = "Dungeon",
        showInZone = true,
        } -- Siege of Niuzao Temple

        nodes[947][46468244] = {
        id = 303,
        type = "Dungeon",
        showInZone = true,
        } -- Gate of the Setting Sun
      end

      if (not self.db.profile.hideAzerothRaid) then  --Raids

        nodes[947][47857509] = {
        id = 317,
        type = "Raid",
        showInZone = true,
        } -- Mogu'shan Vaults

        nodes[947][43598371] = {
        id = 330,
        type = "Raid",
        showInZone = true,
        } -- Heart of Fear

        nodes[947][41907121] = {
        id = 362,
        type = "Raid",
        showInZone = true,
        } -- Throne of Thunder  

        nodes[947][49688206] = {
        id = 320,
        type = "Raid",
        showInZone = true,
        } -- Terrace of Endless Spring 
      end

      if (not self.db.profile.hideAzerothMultiple) then  --Multiple nodes

        nodes[947][48658140] = {
        id = { 369, 321 },
        type = "Multiple",
        showInZone = true,
        } -- Siege of Orgrimmar
      end

      if (not self.db.profile.hideAzerothPortals) then  --Portals

        nodes[947][40147153] = {
        name = L["Portal to Shado-Pan Garrison, TownlongWastes"],  
        type = "Portal",
        showInZone = true,
        } -- Portal from Shado-Pan Garrison to IsleoftheThunderKing

        nodes[947][43408025] = {
        name = L["Portal to Isle of the ThunderKing"],
        type = "Portal",
        showInZone = true,
        } -- Portal from IsleoftheThunderKing to Shado-Pan Garrison

        if (self.faction == "Horde") or db.show["EnemyFaction"] then
          nodes[947][50477732] = {
          name = L["Portal to Orgrimmar"],
          type = "HPortal",
          showInZone = true,
          } -- Portal from Jade Forest to Orgrimmar
        end
      end
    end

    if (not self.db.profile.hideAzerothBrokenIsles) then  --Legion

      if (not self.db.profile.hideAzerothDungeon) then  --Dungeons

        nodes[947][58804606] = {
        id = 777,
        type = "Dungeon",
        showInZone = true,
        } -- Assault on Violet Hold
      
        nodes[947][66413395] = {
        id = 945,
        type = "Dungeon",
        showInZone = true,
        } -- Seat of the Triumvirate 

        nodes[947][55944783] = {
        id = 707,
        type = "Dungeon",
        showInZone = true,
        } -- Vault of the Wardens

        nodes[947][56864411] = {
        id = 716,
        type = "Dungeon",
        showInZone = true,
        } -- Eye of Azshara

        nodes[947][54743861] = {
        id = 740,
        type = "Dungeon",
        showInZone = true,
        } -- Black Rook Hold

        nodes[947][58883744] = {
        id = 767,
        type = "Dungeon",
        showInZone = true,
        } -- Neltharion's Lair

        nodes[947][61533801] = {
        id = 727,
        type = "Dungeon",
        showInZone = true,
        } -- Maw of Souls
      end

      if (not self.db.profile.hideAzerothRaid) then  --Raids

        nodes[947][65603682] = {
        id = 946,
        type = "Raid",
        showInZone = true,
        } -- Antorus, the Burning Thron
      end

      if (not self.db.profile.hideAzerothMultiple) then --Multiple nodes

        nodes[947][60954565] = {
        id = { 875, 900 },
        type = "Multiple",
        showInZone = true,
        } -- Tomb of Sargeras, Cathedral of the Night 

        nodes[947][56043739] = {
        id = { 762, 768 },
        type = "Multiple",
        showInZone = true,
        } -- Darkheart Thicket, The Emerald Nightmare

        nodes[947][58864194] = {
        id = { 786, 800, 726 },
        type = "Multiple",
        showInZone = true,
        } -- The Nighthold, Court of Stars, The Arcway

        nodes[947][62843965] = {
        id = { 721, 861 },
        type = "Multiple",
        showInZone = true,
        } -- Halls of Valor, Trial of Valor
      end

      if (not self.db.profile.hideAzerothPortals) then  --Portals
        
        if (self.faction == "Horde") or db.show["EnemyFaction"] then
          nodes[947][58124501] = {
          name = L["Portal to Orgrimmar"],
          type = "HPortal",
          showInZone = true,
          } -- Portal from New Dalaran to Orgrimmar 

          nodes[947][55624409] = {
          name = L["Portal to Orgrimmar"],
          type = "HPortal",
          showInZone = true,
          hideOnContinent = false,
          } -- Portal to Orgrimmar from Aszuna
        end

        if (self.faction == "Alliance") or db.show["EnemyFaction"] then
          nodes[947][57774634] = {
          name = L["Portal to Stormwind City"],
          type = "APortal",
          showInZone = true,
          } -- Portal from New Dalaran to Stormwind

          nodes[947][55624409] = {
          name = L["Portal to Stormwind City"],
          type = "APortal",
          showInZone = true,
          hideOnContinent = false,
          } -- Portal to Stormwind from Aszuna
        end
      end
    end

    if (not self.db.profile.hideAzerothZandalar) then  --Zandalar

      if (not self.db.profile.hideAzerothDungeon) then  --Dungeons

        nodes[947][54116471] = {
        id = 968,
        type = "Dungeon",
        showInZone = true,
        } -- Atal'Dazar

        nodes[947][52726453] = {
        id = 1041,
        type = "Dungeon",
        showInZone = true,
        } -- Kings' Rest

        nodes[947][52725672] = {
        id = 1030,
        type = "Dungeon",
        showInZone = true,
        } -- Temple of Sethraliss    
      
        if (self.faction == "Horde") or db.show["EnemyFaction"] then
          nodes[947][55156668] = {
          id = 1012,
          type = "Dungeon",
          showInZone = true,
          } -- The MOTHERLODE HORDE
        end

        if (self.faction == "Alliance") then
          nodes[947][53386795] = {
          id = 1012,
          type = "Dungeon",
          showInZone = true,
          } -- The MOTHERLODE Alliance
        end
      end

      if (not self.db.profile.hideAzerothRaid) then  --Raids

        nodes[947][60705670] = { 
        id = 1179,
        type = "Raid",
        showInZone = true,
        } -- The Eternal Palace

        if (self.faction == "Horde") or db.show["EnemyFaction"] then
        nodes[947][55186352] = {
        id = 1176,
        type = "Raid",
        showInZone = true,
        } -- Battle of Dazar'alor
        end
      end

      if (not self.db.profile.hideAzerothMultiple) then  --Multiple nodes

        nodes[947][55926026] = {
        id = { 1031, 1022 },
        type = "Multiple",
        showInZone = true,
        } -- Uldir, The Underrot
      end

      if (not self.db.profile.hideAzerothPortals) then  --Portals

      end

      if (not self.db.profile.hideAzerothShips) then  --Ships

        if (self.faction == "Horde") or db.show["EnemyFaction"] then
          nodes[947][55506808] = {
          name = L["Ship to Echo Isles, Durotar or to Drustvar or to Tiragarde Sound or to Stormsong Valley"],
          type = "HShip",
          showInZone = true,
          } -- Ship from Zandalar to Echo Isles
        end

        if (self.faction == "Alliance") or db.show["EnemyFaction"] then
          nodes[947][54066793] = {
          name = L["Back to Boralus"],
          type = "AShip",
          showInZone = true,
          } -- Ship from Zuldazar to Boralus

          nodes[947][51405743] = {
          name = L["Back to Boralus"],
          type = "AShip",
          showInZone = true,
          } -- Ship from Vol'dun to Boralus

          nodes[947][56705875] = {
          name = L["Back to Boralus"],
          type = "AShip",
          showInZone = true,
          } -- Ship from Nazmir to Boralus
        end
      end
    end

    if (not self.db.profile.hideAzerothKulTiras) then  --Kul Tiras

      if (not self.db.profile.hideAzerothDungeon) then  --Dungeons

        nodes[947][66824486] = { 
        id = 1178,
        type = "Dungeon",
        showInZone = true,
        } -- Operation: Mechagon

        nodes[947][74365363] = {
        id = 1001,
        type = "Dungeon",
        showInZone = true,
        } -- Freehold

        nodes[947][68354901] = {
        id = 1021,
        type = "Dungeon",
        showInZone = true,
        } -- Waycrest Manor

        nodes[947][74224240] = {
        id = 1036,
        type = "Dungeon",
        showInZone = true,
        } -- Shrine of Storm

        nodes[947][76205044] = {
        id = 1002,
        type = "Dungeon",
        showInZone = true,
        } -- Tol Dagor
      end

      if (not self.db.profile.hideAzerothRaid) then  --Raids
        nodes[947][74404422] = {
        id = 1177,
        type = "Raid",
        showInZone = true,
        } -- Crucible of Storms
      end

      if (not self.db.profile.hideAzerothMultiple) then  --Multiple

        if (self.faction == "Alliance") then
          nodes[947][73014936] = {
          id = { 1176, 1023 },
          type = "Multiple",
          showInZone = true,
          } -- Battle of Dazar'alor, Boralus
        end

      end

      if (not self.db.profile.hideAzerothPortals) then  --Portals

        if (self.faction == "Alliance") or db.show["EnemyFaction"] then
          nodes[947][55666511] = {
          name = L["Portalroom from Dazar'alor"],
          type = "HPortal",
          showInZone = true,
          } -- Portalroom from Dazar'Alor

          nodes[947][73394840] = {
          name = L["Portalroom from Boralus"],
          type = "APortal",
          showInZone = true,
          } -- Portalroom from Boralus
        end
      end

      if (not self.db.profile.hideAzerothShips) then  --Ship

        if (self.faction == "Horde") or db.show["EnemyFaction"] then
          nodes[947][67265130] = { 
          name = L["Back to Zuldazar"],
          type = "HShip",
          showInZone = true,
          } -- Ship from Drustvar to Zuldazar

          nodes[947][72244228] = { 
          name = L["Back to Zuldazar"],
          type = "HShip",
          showInZone = true,
          } -- Ship from Stormsong Valley to Zuldazar

          nodes[947][74745185] = { 
          name = L["Back to Zuldazar"],
          type = "HShip",
          showInZone = true,
          } -- Ship from Tiragarde Sound to Zuldazar

          nodes[947][65864376] = { 
          name = L["(Captain Krooz) will take you back to Zuldazar"],
          type = "TransportHelper",
          showInZone = true,
          } -- Ship from Mechagon to Zuldazar
        end

        if (self.faction == "Alliance") or db.show["EnemyFaction"] then
          nodes[947][73914927] = {
          name = L["Ship to Stormwind City or to Vol'Dun or to Nazmir or to Zuldazar"],
          type = "AShip",
          showInZone = true,
          } -- Ship to Stormwind from Boralus
        end
      end
    end

    if (not self.db.profile.hideAzerothDragonIsles) then  --Dragon Isles
       
        if (not self.db.profile.hideAzerothDungeon) then  --Dungeons

        nodes[947][77241864] = {
        id = 1202,
        type = "Dungeon",
        showInZone = true,
        } -- Ruby Life Pools 

        nodes[947][74891765] = {
        id = 1199,
        type = "Dungeon",
        showInZone = true,
        } -- Neltharus

        nodes[947][75192161] = {
        id = 1198,
        type = "Dungeon",
        showInZone = true,
        } -- The Nokhud Offensive

        nodes[947][73352689] = {
        id = 1196,
        type = "Dungeon",
        showInZone = true,
        } -- Brackenhide Hollow

        nodes[947][76072854] = {
        id = 1203,
        type = "Dungeon",
        showInZone = true,
        } -- The Azure Vault

        nodes[947][79611825] = {
        id = 1201,
        type = "Dungeon",
        showInZone = true,
        } -- Algeth'ar Academy

        nodes[947][79532136] = {
        id = 1204,
        type = "Dungeon",
        showInZone = true,
        } -- Halls of Infusion

        nodes[947][79902331] = {
        id = 1209,
        type = "Dungeon",
        showInZone = true,
        } -- Dawn of the Infinite
      end

      if (not self.db.profile.hideAzerothRaid) then  --Raids

        nodes[947][81372023] = {
        id = 1200,
        type = "Raid",
        showInZone = true,
        } -- Vault of the Incarnates

        nodes[947][85002623] = {
        id = 1208,
        type = "Raid",
        showInZone = true,
        }-- Aberrus, the Shadowed Crucible

        nodes[947][71222297] = {
        id = 1207,
        type = "Raid",
        showInZone = true,
        }-- Amirdrassil, the Dream's Hope
      end

      if (not self.db.profile.hideAzerothPortals) then  --Portals

        nodes[947][77692120] = {
        name = L["Portal to Nazmir, Uldum or Tiragarde Sound"],
        type = "Portal",
        showInZone = true,
        } --  Portal from Valdrakken to Nazmir, Uldum and Tiragarde Sound
        
      end

      if (not self.db.profile.hideAzerothZeppelins) then  --Zeppelins

        nodes[947][72202222] = {
        name = L["Portal to The Emerald Dream"],
        type = "Portal",
        showInZone = true,
        }-- Portal to The Emerald Dream

        if (self.faction == "Horde") or db.show["EnemyFaction"] then
          nodes[947][77851451] = {
          name = L["Zeppelin to Orgrimmar"],
          type = "HZeppelin",
          showInZone = true,
          } -- Zeppelin from Walking Shores to Ogrimmar
        end
      end

      if (not self.db.profile.hideAzerothShips) then --Ships

        if (self.faction == "Alliance") or db.show["EnemyFaction"] then
          nodes[947][79021601] = {
          name = L["Ship to Stormwind City"],
          type = "AShip",
          showInZone = true,
          } -- Ship to Stormwind from The Walking Shores - Dragonflight
        end
      end
    end
  end



  if db.show["Continent"] then
    -- Continent Kalimdor
    if (not self.db.profile.hideKalimdor) then
    
      -- Kalimdor Dungeons
    
      if (not self.db.profile.hideDungeons) then
      
        nodes[12][52215315] = {
        id = 240,
        type = "Dungeon",
        } -- Wailing Caverns

        nodes[11][54876555] = { --minimap note
        id = 240,
        type = "Dungeon",
        } -- Wailing Caverns

        nodes[12][43913301] = {
        id = 227,
        type = "Dungeon",
        } -- Blackfathom Deeps

        nodes[12][53146914] = {
        id = 233,
        type = "Dungeon",
        } -- Razorfen Downs

        nodes[12][38395594] = {
        id = 232,
        type = "Dungeon",
        } -- Maraudon

        nodes[67][78285518] = {
        id = 232,
        type = "Dungeon",
        showInZone = true,
        hideOnContinent = true,
        } -- Maraudon Foulspore Cavern

        nodes[68][52152417] = {
        id = 232,
        type = "Dungeon",
        showInZone = true,
        hideOnContinent = true,
        } -- Maraudon Foulspore Cavern

        nodes[68][44517669] = {
        id = 232,
        type = "Dungeon",
        showInZone = true,
        hideOnContinent = true,
        } -- Maraudon Foulspore Cavern first Entrance

        nodes[12][42726722] = {
        id = 230,
        lfgid = 36,
        type = "Dungeon",
        } -- Dire Maul - Warpwood Quarter

        nodes[69][65503530] = {
        id = 230,
        lfgid = 34,
        type = "Dungeon",
        hideOnContinent = false,
        showInZone = true,
        } -- Dire Maul - Warpwood Quarter - East

        nodes[69][60323015] = {
        id = 230,
        lfgid = 36,
        type = "Dungeon",
        hideOnContinent = false,
        showInZone = true,
        } -- Dire Maul - Capital Gardens - West left Entrance

        nodes[69][60303130] = {
        id = 230,
        lfgid = 36,
        type = "Dungeon",
        hideOnContinent = false,
        showInZone = true,
        } -- Dire Maul - Capital Gardens - West right Entrance

        nodes[69][62502490] = {
        id = 230,
        lfgid = 38,
        type = "Dungeon",
        hideOnContinent = false,
        showInZone = true,
        } -- Dire Maul - Gordok Commons - North

        nodes[69][77083689] = {
        id = 230,
        lfgid = 34,
        type = "Dungeon",
        hideOnContinent = false,
        showInZone = true,
        } -- Dire Maul - Warpwood Quarter - East above Camp Mojache  

        nodes[12][54187774] = {
        id = 241,
        type = "Dungeon",
        } -- Zul'Farrak    

        nodes[75][57608260] = {
        id = 279,
        type = "Dungeon",
        } -- The Culling of Stratholme

        nodes[75][36008400] = {
        id = 255,
        type = "Dungeon",
        } -- The Black Morass

        nodes[75][26703540] = {
        id = 251,
        type = "Dungeon",
        } -- Old Hillsbrad Foothills

        nodes[75][57302920] = {
        id = 184,
        type = "Dungeon",
        } -- End Time

        nodes[75][22406430] = {
        id = 185,
        type = "Dungeon",
        } -- Well of Eternity

        nodes[75][67202930] = {
        id = 186,
        type = "Dungeon",
        } -- Hour of Twilight

        nodes[948][51102882] = {
        id = 67,
        type = "Dungeon",
        showInZone = true,
        } -- The Stonecore

        nodes[12][58304269] = {
        id = 226,
        type = "Dungeon",
        } -- Ragefire

        nodes[12][50836820] = {
        id = 234,
        type = "Dungeon",
        } -- Razorfen Kraul
        
        nodes[12][52519670] = {
        id = 68,
        type = "Dungeon",
        } -- The Vortex Pinnacle

        nodes[12][49699341] = {
        id = 69,
        type = "Dungeon",
        } -- Lost City of Tol'Vir

        nodes[12][51579122] = {
        id = 70,
        type = "Dungeon",
        } -- Halls of Origination
      end

      --Kalimdor Raids
      if (not self.db.profile.hideRaids) then

        nodes[12][45929663] = {
        id = 74,
        type = "Raid",
        } -- Throne of the Four Winds

        nodes[12][54243397] = {
        id = 78,
        type = "Raid",
        } -- Firelands

        nodes[12][56436963] = {
        id = 760,
        type = "Raid",
        } -- Onyxia's Lair

        nodes[12][42068358] = {
        id = 743,
        type = "Raid",
        } -- Ruins of Ahn'Qiraj

        nodes[12][40678358] =  {
        id = 744,
        type = "Raid",
        } -- Temple of Ahn'Qiraj
      end

      --Kalimdor Multiple
      if (not self.db.profile.hideMultiple) then

        nodes[71][65114833] = {
        id = { 187, 750, 279, 255, 251, 184, 185, 186, },
        type = "Multiple",
        showInZone = true,
        hideOnContinent = false,
        } -- Dragon Soul, The Battle for Mount Hyjal, The Culling of Stratholme, Black Morass, Old Hillsbrad Foothills, End Time, Well of Eternity, Hour of Twilight Heroic
      end

      -- Kalimdor Portals
      if (not self.db.profile.hidePortals) then

            nodes[81][41614520] = {
            name = L["Portal to Zandalar(horde)/Boralus(alliance)"],
            type = "Portal",
            showInZone = true,
            hideOnContinent = false,
            } -- Portal from Silithus to Zandalar/Boralus

          if (self.faction == "Horde") or db.show["EnemyFaction"] then     

            nodes[12][45842223] = {
            name = L["Portal to Zandalar (its only shown up ingame if your faction is currently occupying Bashal'Aran"],
            type = "HPortal",
            showInZone = true,
            hideOnContinent = false,
            } -- Portal from New Darkshore to Zandalar

            nodes[62][46243511] = {
            name = L["Portal to Zandalar (its only shown up ingame if your faction is currently occupying Bashal'Aran"],
            type = "HPortal",
            showInZone = true,
            hideOnContinent = true,
            } -- Portal from New Darkshore to Zandalar

            nodes[85][50765561] = {
            name = L["Portal to Ruins of Lordaeron, Undercity (on the tower)"],
            type = "HPortal",
            hideOnContinent = true,
            showInZone = true,
            } -- Ruins of Lordaeron

            nodes[85][55988822] = {
            name =  L["Portal to Stormwind City (inside building)"],
            type = "HPortal",
            hideOnContinent = true,
            showInZone = false,
            } -- Silvermoon City Portalroom

            nodes[85][57098737] = {
            name =  L["Portal to Valdrakken (inside portal chamber)"],
            type = "HPortal",
            hideOnContinent = true,
            showInZone = false,
            } --  Valdrakken Portalroom

            nodes[85][58308788] = {
            name = L["Portal to Oribos (inside portal chamber)"],
            type = "HPortal",
            hideOnContinent = true,
            showInZone = false,
            } -- Oribos Portalroom

            nodes[85][58858950] = {
            name = L["Portal to Azsuna (inside portal chamber)"],
            type = "HPortal",
            hideOnContinent = true,
            showInZone = false,
            } -- Azsuna Portalroom

            nodes[85][57479217] = {
            name = L["Portal to Zuldazar (inside portal chamber)"],
            type = "HPortal",
            hideOnContinent = true,
            showInZone = false,
            } -- Zuldazar Portalroom

            nodes[85][57479225] = {
            name = L["Portal to The Jade Forest (inside portal chamber)"],
            type = "HPortal",
            hideOnContinent = true,
            showInZone = false,
            } -- The Jade Forest Portalroom

            nodes[85][56249171] = {
            name = L["Portal to Dalaran, Crystalsong Forest (inside portal chamber)"],
            type = "HPortal",
            hideOnContinent = true,
            showInZone = false,
            } -- Crystalsong Forest (Old Dalaran) Portalroom

            nodes[85][57409153] = {
            name =  L["Portal to Shattrath (at basement)"],
            type = "HPortal",
            hideOnContinent = true,
            showInZone = false,
            } -- Shattrath Portalroom

            nodes[85][56399252] = {
            name = L["Portal to Caverns of Time (at basement)"],
            type = "HPortal",
            hideOnContinent = true,
            showInZone = false,
            } -- Caverns of Time Portalroom

            nodes[85][55209201] = {
            name = L["Portal to Warspear, Ashran (at basement)"],
            type = "HPortal",
            hideOnContinent = true,
            showInZone = false,
          } -- Warspear - Ashran Portalroom  
        end

          if (self.faction == "Alliance") or db.show["EnemyFaction"] then

            nodes[12][47092322] = {
            name = L["Portal to Boralus (its only shown up ingame if your faction is currently occupying Bashal'Aran"],
            type = "APortal",
            showInZone = true,
            hideOnContinent = true,
            } -- Portal from New Darkshore to Zandalar

            nodes[62][48023628] = {
            name = L["Portal to Boralus (its only shown up ingame if your faction is currently occupying Bashal'Aran"],
            type = "APortal",
            showInZone = true,
            hideOnContinent = false,
            } -- Portal from New Darkshore to Zandalar
          end
      end

      --Kalimdor Zeppelins
      if (not self.db.profile.hideZeppelins) then

        nodes[12][59814453] = {
        name = L["Zeppelin to Walking Shores, Dragon Isles"],
        type = "HZeppelin",
        showInZone = true,
        hideOnContinent = false,
        } -- Zeppelin from Durotar to Walking Shores - Dragonflight
      end

      -- Kalimdor Ships
      if (not self.db.profile.hideShips) then

        nodes[10][70177323] = { 
        name = L["Ship to Booty Bay, Stranglethorn Vale"],
        type = "Ship",
        } -- Ship from Ratchet to Booty Bay Ship

        if (self.faction == "Horde") or db.show["EnemyFaction"] then
          nodes[12][62985416] = {
          name = L["Ship to Dazar'alor, Zuldazar"],
          type = "HShip",
          } -- Ship from Echo Isles to Dazar'alor - Zandalar
        end

        if (self.faction == "Alliance") or db.show["EnemyFaction"] then
          nodes[12][59266609] = {
          name = L["Ship to Menethil Harbor, Wetlands"],
          type = "AShip",
          } -- Ship from Dustwallow Marsh to Menethil Harbor
        end
      end
    end


    -- Eastern  Kingdom
    if (not self.db.profile.hideEasternKingdom) then

      -- Eastern  Kingdom Dungeons
      if db.show["Dungeon"] then

        nodes[95][85206430] = {
        id = 77,
        type = "Dungeon",
        } -- Zul'Aman

        nodes[122][61303090] = {
        id = 249,
        type = "Dungeon",
        } -- Magisters' Terrace

        nodes[13][31796256] = {
        id = 65,
        type = "Dungeon",
        } -- Throne of Tides

        nodes[13][42397323] = {
        id = 238,
        type = "Dungeon",
        } -- The Stockade

        nodes[13][47448471] = {
        id = 76,
        type = "Dungeon",
        } -- Zul'Gurub

        nodes[13][40764187] = {
        id = 64,
        type = "Dungeon",
        } -- Shadowfang Keep

        nodes[13][46583029] = {
        id = { 311, 316 },
        type = "Dungeon",
        } -- Scarlet Halls, Monastery

        nodes[13][52176317] = { 
        id = { 1197, 239 },
        type = "Dungeon",
        } --  Legacy of Tyr Dragonflight Dungeon & Vanilla Uldaman

        nodes[13][53646537] = { 
        id = 239,
        name = "Uldaman back entrance",
        type = "Dungeon",
        } -- Uldaman (Secondary Entrance)

        nodes[13][50573677] = { 
        id = 246,
        type = "Dungeon",
        } -- Scholomance

        nodes[13][52712836] = {
        id = 236,
        lfgid = 40,
        type = "Dungeon",
        } -- Stratholme

        nodes[13][54472924] = {
        id = 236,
        lfgid = 274,
        type = "Dungeon",
        }-- Stratholme Service Entrance

        nodes[13][42915972] = {
        id = 231,
        type = "Dungeon",
        } -- Gnomeregan

        nodes[13][49428163] = {
        id = 860,
        type = "Dungeon",
        } -- Return to Karazhan

        nodes[13][53977927] = {
        id = 237,
        type = "Dungeon",
        } -- The Temple of Atal'hakkar

        nodes[13][40808194] = {
        id = 63,
        type = "Dungeon",
        } -- Deadmines    

        nodes[13][53135585] = {
        id = 71,
        type = "Dungeon",
        } -- Grim Batol
      end

      -- Eastern  Kingdom Raids
      if (not self.db.profile.hideRaids) then

        nodes[122][44304570] = {
        id = 752,
        type = "Raid",
        } -- Sunwell Plateau

        nodes[13][47546862] = {
        id = 73,
        type = "Raid",
        } -- Blackwind Descent

        nodes[13][54905899] = {
        id = 72,
        type = "Raid",
        } -- The Bastion of Twilight

        nodes[13][35565150] = {
        id = 75,
        type = "Raid",
        } -- Baradin Hold
      end

      --Eastern Kingdom Multiple
      if (not self.db.profile.hideMultiple) then

        nodes[13][46886972] = {
        id = { 741, 742, 66, 228, 229, 559 },
        type = "Multiple",
        } -- Molten Core, Blackwing Lair, Blackrock Caverns, Blackrock Depths, Lower Blackrock Spire, Upper Blackrock Spire
      
        nodes[13][49428163] = {
        id = { 745, 860 }, 
        type = "Multiple",
        } -- Karazhan, Return to Karazhan
      end

      --Eastern Kingdom Portals
      if (not self.db.profile.hidePortals) then

        if (self.faction == "Horde") or db.show["EnemyFaction"] then
          nodes[18][60735867] = {
          name = L["Portal to Orgrimmar"],
          type = "HPortal",
          showInZone = true,
          } -- Portal to Orgrimmar from Tirisfal  

          nodes[18][61905899] = {
          name = L["Portal to Stranglethorn"],
          type = "HPortal",
          showInZone = true,
          } -- Portal to Orgrimmar from Tirisfal  

          nodes[2070][59506694] = {
          name = L["Portal to Orgrimmar"],
          type = "HPortal",
          showInZone = true,
          } -- Portal to Orgrimmar from Tirisfal  

          nodes[2070][59506797] = {
          name = L["Portal to Stranglethorn"],
          type = "HPortal",
          showInZone = true,
          } -- Portal to Stranglethorn from Tirisfal  

          nodes[2070][60126689] = {
          name = L["Portal to Howling Fjord"],
          type = "HPortal",
          showInZone = true,
          } -- Portal to Howling Fjord from Tirisfal  

          nodes[50][37545099] = {
          name = L["Portal to Ruins of Lordaeron, Undercity (on the tower)"],
          type = "HPortal",
          showInZone = true,
          } -- Portal to Undercity from Grom'gol  

          nodes[224][42233253] = {
          name = L["Portal to Ruins of Lordaeron, Undercity (on the tower)"],
          type = "HPortal",
          showInZone = true,
          hideOnContinent = true,
          } -- Portal to Undercity from Grom'gol  

          nodes[13][43358708] = {
          name = L["Portal to Ruins of Lordaeron, Undercity (on the tower)"],
          type = "HPortal",
          showInZone = true,
          } -- Portal to Undercity from Grom'gol  

          nodes[94][54552795] = {
          name = L["Portal to Orgrimmar"],
          type = "HPortal",
          showInZone = true,
          hideOnContinent = false,
          } -- Portal to Orgrimmar from Silvermoon

          nodes[110][58511859] = {
          name = L["Portal to Orgrimmar"],
          type = "HPortal",
          showInZone = true,
          hideOnContinent = true,
          } -- Portal to Orgrimmar from Silvermoon

          nodes[14][27442938] = {
          name = L["Portal to Zandalar"],
          type = "HPortal",
          showInZone = true,
          hideOnContinent = false,
          } -- Portal from Arathi to Zandalar

          nodes[17][55005418] = {
          name = L["Dark Portal (Portal to Warspear, Ashran)"],
          type = "HPortal",
          showInZone = true,
          } -- Portal from Blasted Lands to Warspear
        end

        if (self.faction == "Alliance") or db.show["EnemyFaction"] then
          nodes[84][43748538] = { 
          name = L["Portal to Caverns of Time (inside portal chamber)"],
          type = "APortal",
          showInZone = false,
          hideOnContinent = true,
          } -- Portal to Caverns of Time

          nodes[84][44888577] = { 
          name = L["Portal to Shattrath (inside portal chamber)"],
          type = "APortal",
          showInZone = false,
          hideOnContinent = true,
          } -- Portal to Shattrath

          nodes[84][43638719] = { 
          name = L["Portal to Exodar (inside portal chamber)"],
          type = "APortal",
          showInZone = false,
          hideOnContinent = true,
          } -- Portal to Exodar

          nodes[84][44388868] = { 
          name = L["Portal to Dalaran, Crystalsong Forest (inside portal chamber)"],
          type = "APortal",
          showInZone = false,
          hideOnContinent = true,
          } -- Portal to Dalaran

          nodes[84][45708715] = { 
          name = L["Portal to The Jade Forest (inside portal chamber)"],
          type = "APortal",
          showInZone = false,
          hideOnContinent = true,
          } -- Portal to Jade Forest

          nodes[84][48099198] = { 
          name = L["Portal to Stormshield, Ashran (inside portal chamber)"],
          type = "APortal",
          showInZone = false,
          hideOnContinent = true,
          } -- Portal to Stormshield

          nodes[84][46869339] = { 
          name = L["Portal to Azsuna (inside portal chamber)"],
          type = "APortal",
          showInZone = false,
          hideOnContinent = true,
          } -- Portal to Azsuna

          nodes[84][47579495] = { 
          name = L["Portal to Oribos (inside portal chamber)"],
          type = "APortal",
          showInZone = false,
          hideOnContinent = true,
          } -- Portal to Oribos

          nodes[84][48849344] = { 
          name = L["Portal to Valdrakken (inside portal chamber)"],
          type = "APortal",
          showInZone = false,
          hideOnContinent = true,
          } -- Portal to Valdrakken

          nodes[84][48759519] = { 
          name = L["Portal to Boralus (inside portal chamber)"],
          type = "APortal",
          showInZone = false,
          hideOnContinent = true,
          } -- Portal to Boralus

          nodes[17][55005418] = {
          name = L["Dark Portal (Portal to Stormshield, Ashran)"],
          type = "APortal",
          showInZone = true,
          } -- Portal from Blasted Lands to Warspear
        end
      end

      --Eastern Kingdom Ships
      if (not self.db.profile.hideShips) then

        nodes[224][37037615] = { 
        name = L["Ship to Ratchet, Northern Barrens"],
        type = "Ship",
        hideOnContinent = false,
        } -- Ship from Booty Bay to Ratchet

        if (self.faction == "Alliance") or db.show["EnemyFaction"] then
          nodes[13][40937205] = { 
          name = L["Ships to Valiance Keep, Borean Tundra and to Boralus Harbor, Tiragarde Sound"],
          type = "AShip",
          showInZone = true,
          } -- Ship from Stormwind to Valiance Keep
        end
      end
    end


    -- OUTLAND
    if (not self.db.profile.hideOutland) then

      -- Outland Dungeons
      if (not self.db.profile.hideDungeons) then

        nodes[108][34306560] = {
        id = 247,
        type = "Dungeon",
        } -- Auchenai Crypts

        nodes[108][39705770] = {
        id = 250,
        type = "Dungeon",
        } -- Mana-Tombs

        nodes[108][44906560] = {
        id = 252,
        type = "Dungeon",
        } -- Sethekk Halls

        nodes[108][39607360] = {
        id = 253,
        type = "Dungeon",
        } -- Shadow Labyrinth

        nodes[109][71705500] = {
        id = 257,
        type = "Dungeon",
        } -- The Botanica

        nodes[109][70556966] = {
        id = 258,
        type = "Dungeon",
        } -- The Mechanar 

        nodes[109][74405770] = {
        id = 254,
        type = "Dungeon",
        } -- The Arcatraz


      end

      -- Outland Raids
      if (not self.db.profile.hideRaids) then

        nodes[109][73626373] = {
        id = 749,
        type = "Raid",
        } -- The Eye 

        nodes[104][71004660] = {
        id = 751,
        type = "Raid",
        } -- Black Temple

        nodes[105][69082415] = {
        id = 746,
        type = "Raid",
        } -- Gruul's Lairend
        minimap[100] = {
        [46555286] = {
        id = 747,
        type = "Raid",
        }, -- Magtheridon's Lair
      }
      end

      -- Outland Multiple
      if (not self.db.profile.hideMultiple) then

        nodes[100] = {
        [47205220] = {
        id = { 248, 256, 259, 747 },
        type = "Multiple",
        hideOnMinimap = true,
        }, -- Hellfire Ramparts, The Blood Furnace, The Shattered Halls, Magtheridon's Lair
        }

        nodes[102][50204100] = {
        id = { 748, 260, 261, 262 },
        type = "Multiple",
        showInZone = true,
        } -- Slave Pens, The Steamvault, The Underbog, Serpentshrine Cavern
      end

      -- Outland Portals
      if (not self.db.profile.hidePortals) then
        if (self.faction == "Horde") or db.show["EnemyFaction"] then
          nodes[100][88574770] = {
          name = L["Portal to Orgrimmar"],
          type = "HPortal",
          hideOnContinent = true,
          showInZone = false,
          } --  Portal from Hellfire to Orgrimmar

          nodes[100][89234945] = {
          name = L["Portal to Orgrimmar"],
          type = "HPortal",
          hideOnContinent = false,
          showInZone = true,
          } --  Portal from Hellfire to Orgrimmar
        end

        if (self.faction == "Alliance") or db.show["EnemyFaction"] then
          nodes[100][88635281] = {
          name = L["Portal to Stormwind City"],
          type = "APortal",
          hideOnContinent = true,
          showInZone = false,
          } --  Portal from Hellfire to Stormwind

          nodes[100][89215101] = {
          name = L["Portal to Stormwind City"],
          type = "APortal",
          hideOnContinent = false,
          showInZone = true,
          } --  Portal from Hellfire to Stormwind
        end
      end
    end


    -- Northrend
    if (not self.db.profile.hideNorthrend) then

      -- Northrend Dungeon
      if db.show["Dungeon"] then

        nodes[113][40595892] = {
        id = { 271, 272 },
        type = "Dungeon",
        } -- Ahn'kahet The Old Kingdom, Azjol-Nerub

        nodes[113][77707945] = {
        id = 285,
        type = "Dungeon",
        } -- Utgarde Keep, at doorway entrance

        nodes[113][77557824] = {
        id = 286,
        type = "Dungeon",
        } -- Utgarde Pinnacle

        nodes[113][41154408] = {
        id = { 276, 278, 280 },
        type = "Dungeon",
        } -- The Forge of Souls, Halls of Reflection, Pit of Saron

        nodes[113][59091507] = {
        id = 275,
        type = "Dungeon",
        } -- Halls of Lightning

        nodes[113][56911729] = {
        id = 277,
        type = "Dungeon",
        } -- Halls of Stone

        nodes[113][62405001] = {
        id = 273,
        type = "Dungeon",
        } -- Drak'Tharon Keep

        nodes[113][75113259] = {
        id = 274,
        type = "Dungeon",
        } -- Gundrak Left Entrance

        nodes[113][76533471] = {
        id = 274,
        type = "Dungeon",
        } -- Gundrak Right Entrance

        nodes[127][34154413] = {
        id = 283,
        type = "Dungeon",
        showInZone = true,
        } -- The Violet Hold
      end

      -- Northrend Raids
      if (not self.db.profile.hideRaids) then

        nodes[113][58415888] = {
        id = 754,
        type = "Raid",
        } -- Naxxramas

        nodes[113][50346038] = {
        id = { 755, 761 },
        type = "Raid",
        showInZone = true,
        } -- The Ruby Sanctum, The Obsidian Sanctum

        nodes[113][40794199] = {
        id = 758,
        type = "Raid",
      } -- Icecrown Citadel

        nodes[113][57721389] = {
        id = 759,
        type = "Raid",
        } -- Ulduar

        nodes[113][36624457] = {
        id = 753,
        type = "Raid",
        } -- Vault of Archavon
      end

      -- Northrend Multiple
      if (not self.db.profile.hideMultiple) then

        nodes[113][47652029] = {
        id = { 757, 284 },
        type = "Multiple",
        } -- Trial of the Crusader, Trial of the Champion

        nodes[113][14725757] = {
        id = { 756, 282, 281 },
        type = "Multiple",
        } -- The Eye of Eternity, The Nexus, The Oculus
      end

      if (self.faction == "Horde") or db.show["EnemyFaction"] then
        nodes[125][55322545] = {
        name = L["Portal to Orgrimmar"],
        type = "HPortal",
        hideOnContinent = false,
        showInZone = true,
        } --  Dalaran to Orgrimmar Portal

        nodes[127][31103140] = {
        name = L["Portal to Orgrimmar"],
        type = "HPortal",
        showInZone = true,
        } --  Dalaran to Orgrimmar Portal
      end

      if (self.faction == "Alliance") or db.show["EnemyFaction"] then
        nodes[125][40796326] = {
        name = L["Portal to Stormwind City"],
        type = "APortal",
        hideOnContinent = false,
        showInZone = true,
        } --  Dalaran to Stormwind City Portal

        nodes[127][26614271] = {
        name = L["Portal to Stormwind City"],
        type = "APortal",
        showInZone = true,
        } --  Dalaran to Stormwind City Portal
      end

      if (not self.db.profile.hideZeppelins) then  --Zeppelins

        if (self.faction == "Horde") or db.show["EnemyFaction"] then
          nodes[113][18766562] = {
          name = L["Zeppelin to Orgrimmar"],
          type = "HZeppelin",
          showInZone = true,
          } -- Zeppelin from Borean Tundra to Ogrimmar
        end
      end

      if (not self.db.profile.hideShips) then  --Ships

        if (self.faction == "Alliance") or db.show["EnemyFaction"] then
          nodes[113][24557044] = {
          name = L["Ship to Stormwind City"],
          type = "AShip",
          showInZone = true,
          } -- Ship to Stormwind from Borean Tundra

          nodes[113][78998350] = {
          name = L["Ship to Stormwind City"],
          type = "AShip",
          showInZone = true,
          } -- Ship to Stormwind from Borean Tundra
        end
      end
    end


    -- Pandaria
    if (not self.db.profile.hidePandaria) then

      -- Pandaria Dungeons
      if db.show["Dungeon"] then

        nodes[424][72275515] = {
        id = 313,
        type = "Dungeon",
        } -- Temple of the Jade Serpent

        nodes[424][48117132] = {
        id = 302,
        type = "Dungeon",
        } -- Stormstout Brewery 

        nodes[424][40002920] = {
        id = 312,
        type = "Dungeon",
        } -- Shado-Pan Monastery

        nodes[424][23575057] = {
        id = 324,
        type = "Dungeon",
        } -- Siege of Niuzao Temple

        nodes[424][42975779] = {
        id = 303,
        type = "Dungeon",
        } -- Gate of the Setting Sun

        nodes[424][53575100] = {
        id = 321,
        type = "Dungeon",
        } -- Mogu'shan Palace
      end

      -- Pandaria Raids
      if (not self.db.profile.hideRaids) then

        nodes[424][49152606] = {
        id = 317,
        type = "Raid",
        } -- Mogu'shan Vaults

        nodes[424][52355265] = {
        id = 369,
        type = "Raid",
        } -- Siege of Orgrimmar

        nodes[424][30076296] = {
        id = 330,
        type = "Raid",
        } -- Heart of Fear

        nodes[424][23100860] = {
        id = 362,
        type = "Raid",
        } -- Throne of Thunder  

        nodes[424][56685529] = {
        id = 320,
        type = "Raid",
        } -- Terrace of Endless Spring  
      end

      -- Pandaria Portals
      if (not self.db.profile.hidePortals) then

        nodes[388][50657339] = {
        name = L["Portal to Isle of the ThunderKing"],
        type = "Portal",
        hideOnContinent = false,
        showInZone = true,
        } -- Portal from Shado-Pan Garrison to IsleoftheThunderKing

        nodes[424][17970919] = {
        name = L["Portal to Shado-Pan Garrison, TownlongWastes"],
        type = "Portal",
        hideOnContinent = false,
        } -- Portal from IsleoftheThunderKing to Shado-Pan Garrison

        nodes[504][33223269] = {
        name = L["Portal to Shado-Pan Garrison, TownlongWastes"],
        type = "Portal",
        hideOnContinent = true,
        showInZone = true,
        } -- Portal from IsleoftheThunderKing to Shado-Pan Garrison

        if (self.faction == "Horde") or db.show["EnemyFaction"] then
          nodes[424][59733518] = {
          name = L["Portal to Orgrimmar"],
          type = "HPortal",
          showInZone = true,
          } -- Portal from Jade Forest to Orgrimmar
        end
      end
    end


    -- Draenor
    if (not self.db.profile.hideDraenor) then

      -- Draenor Dungeons
      if (not self.db.profile.hideDungeons) then

        nodes[572][34102566] = {
        id = 385,
        type = "Dungeon",
        } -- Bloodmaul Slag Mines

        nodes[572][51322183] = {
        id = 536,
        type = "Dungeon",
        } -- Grimrail Depot

        nodes[572][52932678] = {
        id = 556,
        type = "Dungeon",
        } -- The Everbloom

        nodes[572][47961477] = {
        id = 558,
        type = "Dungeon",
        } -- Iron Docks

        nodes[572][53196866] = {
        id = 537,
        type = "Dungeon",
        } -- Shadowmoon Burial Grounds

        nodes[572][42607342] = {
         id = 476,
        type = "Dungeon",
        } -- Skyreach

        nodes[572][40256374] = {
        id = 547,
        type = "Dungeon",
        } -- Auchindoun
      end

      --Draenor Raids
      if (not self.db.profile.hideRaids) then

        nodes[572][56854685] = {
        id = 669,
        type = "Raid",
        } -- Hellfire Citadel  

        nodes[572][49992014] = {
        id = 457,
        type = "Raid",
        } -- Blackrock Foundry

        nodes[572][21125032] = {
        id = 477,
        type = "Raid",
        } -- Highmaul
      end

      --Draenor Portals
      if (not self.db.profile.hidePortals) then

        if (self.faction == "Horde") or db.show["EnemyFaction"] then

          nodes[572][71343912] = {
          name = L["Portal to Orgrimmar or Vol'mar"],
          type = "HPortal",
          } --  Portal from Ashran to Orgrimmar, Vol'mar

          nodes[590][75184879] = {
          name = L["Portal to Ashran"],
          type = "HPortal",
          showInZone = true,
          } --  Portal from Garrison to Ashran

          nodes[534][61024735] = {
          name = L["Portal to Ashran"],
          type = "HPortal",
          showInZone = true,
          } --  Portal from Vol'mar to Ashran

          nodes[525][51416484] = {
          name = L["Portal to Ashran"],
          type = "HPortal",
          showInZone = true,
          } --  Portal from Garrison to Ashran

          nodes[624][60825159] = {
          name = L["Portal to Orgrimmar"],
          type = "HPortal",
          showInZone = true,
          } --  Portal from Garrison to Ashran 

          nodes[588][45001476] = {
          name = L["Portal to Orgrimmar"],
          type = "HPortal",
          showInZone = true,
          hideOnContinent = true,
          } --  Portal from Garrison to Ashran (Ashran Zone)

          nodes[624][53184384] = {
          name = L["Portal to Vol'mar"],
          type = "HPortal",
          showInZone = true,
          } --  Portal from Ashran to Vol'mar Captive

          nodes[588][42911275] = {
          name = L["Portal to Vol'mar"],
          type = "HPortal",
          showInZone = true,
          hideOnContinent = true,
          } --  Portal from Ashran to Vol'mar Captive (Ashran Zone)
        end
      end
    end


    --Broken Isles
    if (not self.db.profile.hideBrokenIsles) then

      --Broken Isles Dungeons
      if (not self.db.profile.hideDungeons) then
      
        nodes[619][47276616] = {
        id = 777,
        type = "Dungeon",
        } -- Assault on Violet Hold

        nodes[619][38805780] = {
        id = 716,
        type = "Dungeon",
        } -- Eye of Azshara

        nodes[619][34207210] = {
        id = 707,
        type = "Dungeon",
        } -- Vault of the Wardens

        nodes[619][89551352] = {
        id = 945,
        type = "Dungeon",
        } -- The Seat of the Triumvirate

        nodes[619][29403300] = {
        id = 740,
        type = "Dungeon",
        } -- Black Rook Hold

        nodes[619][59003060] = {
        id = 727,
        type = "Dungeon",
        } -- Maw of Souls

        nodes[619][47302810] = {
        id = 767,
        type = "Dungeon",
        } -- Neltharion's Lair

        nodes[619][49104970] = {
        id = 800,
        type = "Dungeon",
        } -- Court of Stars

        nodes[619][46004883] = {
        id = 726,
        type = "Dungeon",
        } -- The Arcway

        nodes[619][56416109] = {
        id = 900,
        type = "Dungeon",
         } -- Cathedral of the Night 

        nodes[619][65573821] = {
        id = 721,
        type = "Dungeon",
        } -- Halls of Valor

        nodes[619][35792725] = {
        id = 762,
        type = "Dungeon",
        } -- Darkheart Thicket  

        nodes[905][52513071] = {
        id = 945,
        type = "Dungeon",
        showInZone = true,
        } -- The Seat of the Triumvirate
      end

      --Broken Isles Raids
      if (not self.db.profile.hideRaids) then

        nodes[619][86262011] = {
        id = 946,
        type = "Raid",
        } -- Antorus, the Burning Throne

        nodes[619][46864732] = {
        id = 786,
        type = "Raid",
        } -- The Nighthold

        nodes[619][56506240] = {
        id = 875,
        type = "Raid",
        } -- Tomb of Sargeras 

        nodes[619][64553903] = {
        id = 861,
        type = "Raid",
        } -- Trial of Valor

        nodes[619][34982901] = {
        id = 768,
        type = "Raid",
        } -- The Emerald Nightmare

        nodes[905][32896084] = {
        id = 946,
        type = "Raid",
        showInZone = true,
        } -- Antorus, the Burning Throne
      end

      --Broken Isles Portals
      if (not self.db.profile.hidePortals) then

        if (self.faction == "Horde") or db.show["EnemyFaction"] then
          nodes[627][55242392] = {
          name = L["Portal to Orgrimmar"],
          type = "HPortal",
          hideOnContinent = false,
          showInZone = true,
          } --  Dalaran to Orgrimmar Portal

          nodes[619][45606186] = {
          name = L["Portal to Orgrimmar"],
          type = "HPortal",
          showInZone = true,
          } --  Dalaran to Orgrimmar Portal

          nodes[630][46654129] = {
          name = L["Portal to Orgrimmar"],
          type = "HPortal",
          showInZone = true,
          hideOnContinent = false,
          } -- Portal to Orgrimmar from Aszuna
        end

        if (self.faction == "Alliance") or db.show["EnemyFaction"] then
          nodes[627][40416378] = {
          name = L["Portal to Stormwind City"],
          type = "APortal",
          hideOnContinent = false,
          showInZone = true,
          } --  Dalaran to Stormwind City Portal

          nodes[619][45296767] = {
          name = L["Portal to Stormwind City"],
          type = "APortal",
          showInZone = false,
          } --  Portal from Dalaran to Stormwind

          nodes[630][44664143] = {
          name = L["Portal to Stormwind City"],
          type = "APortal",
          showInZone = true,
          hideOnContinent = false,
          } -- Portal to Stormwind from Aszuna

          nodes[941][43092506] = {
          name = L["Portal to Stormwind City"],
          type = "APortal",
          showInZone = false,
          } --  Portal from Krokuun - Vindikaar to Stormwind
         end
      end
    end


    --Zandalar
    if (not self.db.profile.hideZandalar) then

      --Zandalar Dungeons
      if (not self.db.profile.hideDungeons) then

        nodes[875][48865880] = {
        id = 968,
        type = "Dungeon",
        } -- Atal'Dazar

        nodes[875][45205880] = {
        id = 1041,
        type = "Dungeon",
        } -- Kings' Rest

        nodes[875][58243603] = {
        id = 1022,
        type = "Dungeon",
        } -- The Underrot

        nodes[875][40781425] = {
        id = 1030,
        type = "Dungeon",
        } -- Temple of Sethraliss
      
        if (self.faction == "Horde") or db.show["EnemyFaction"] then
          nodes[1165][44049256] = {
          id = 1012,
          type = "Dungeon",
          showInZone = true,
          } -- The MOTHERLODE HORDE
        
          nodes[862][55995989] = {
          id = 1012,
          type = "Dungeon",
          } -- The MOTHERLODE HORDE
        end
      
        if (self.faction == "Alliance") or db.show["EnemyFaction"] then
          nodes[875][45457850] = {
          id = 1012,
          type = "Dungeon",
          } -- The MOTHERLODE Alliance
        end
      end

      --Zandalar Raids
      if (not self.db.profile.hideRaids) then

        nodes[875][59413469] = {
        id = 1031,
        type = "Raid",
        } -- Uldir

        nodes[875][86731430] = { 
        id = 1179,
        type = "Raid",
        } -- The Eternal Palace
      
        if (self.faction == "Horde") or db.show["EnemyFaction"] then
        nodes[875][56005350] = {
        id = 1176,
        type = "Raid",
        } -- Battle of Dazar'alor
        end
      end

      -- Zandalar Portals
      if (not self.db.profile.hidePortals) then

        if (self.faction == "Horde") or db.show["EnemyFaction"] then

          nodes[862][58474432] = {
          name = L["Portalroom from Dazar'alor (inside building)"],
          type = "HPortal",
          showInZone = true,
          hideOnContinent = false,
          } -- Portalroom from Dazar'alor

          nodes[1165][51424583] = {
          name = L["Portalroom from Dazar'alor (inside building)"],
          type = "HPortal",
          showInZone = true,
          hideOnContinent = false,
          } -- Portalroom from Dazar'alor

          nodes[1163][73726194] = {
          name = L["Portal to Silvermoon City"],
          type = "HPortal",
          showInZone = true,
          } -- Portalroom from Dazar'alor

          nodes[1163][74006974] = {
          name = L["Portal to Orgrimmar"],
          type = "HPortal",
          showInZone = true,
          } -- Portalroom from Dazar'alor

          nodes[1163][74027739] = {
          name = L["Portal to Thunderbluff"],
          type = "HPortal",
          showInZone = true,
          } -- Portalroom from Dazar'alor

          nodes[1163][73808541] = {
          name = L["Portal to Silithus"],
          type = "HPortal",
          showInZone = true,
          } -- Portalroom from Dazar'alor

          nodes[1163][63008553] = {
          name = L["Portal to Nazjatar"],
          type = "HPortal",
          showInZone = true,
          } -- Portalroom from Dazar'alor

          nodes[1165][41838761] = {
          name = L["(Captain Krooz) will take you to Mechagon"],
          type = "TransportHelper",
          showInZone = true,
          hideOnContinent = false,
          } -- Portal from Dazar'alor to Mechagon

          nodes[1165][51929455] = {
          name = L["These portals are only active in the game if your faction is currently occupying (Ar'gorok for the Arathi Highlands portal) or (Bashal'Aran for the Darkshore portal)"],
          type = "HPortal",
          showInZone = true,
          } -- Portal from Dazar'alor to Arathi or Darkshore

          nodes[862][58486027] = {
          name = L["These portals are only active in the game if your faction is currently occupying (Ar'gorok for the Arathi Highlands portal) or (Bashal'Aran for the Darkshore portal)"],
          type = "HPortal",
          showInZone = true,
          } -- Portal from Dazar'alor to Arathi or Darkshore

          nodes[1355][47276279] = {
           name = L["Portal to Dazar'alor"],
           type = "HPortal",
           showInZone = true,
           hideOnContinent = false,
           } -- Portal from Newhome to Dazar'alor
        end
      end

      if (not self.db.profile.hideShips) then

        if (self.faction == "Horde") or db.show["EnemyFaction"] then
          nodes[875][57957497] = {
          name = L["Ship to Echo Isles, Durotar"],
          type = "HShip",
          } -- Ship from Zandalar to Echo Isles

          nodes[862][54985825] = {
          name = L["(Captain Krooz) will take you to Mechagon"],
          type = "TransportHelper",
          showInZone = true,
          hideOnContinent = false,
          } -- Ship from Dazar'alor to Mechagon

          nodes[1462][75522266] = {
          name = L["(Captain Krooz) will take you back to Zuldazar"],
          type = "TransportHelper",
          showInZone = true,
          hideOnContinent = false,
          } -- Ship from Mechagon to Zuldazar

          nodes[862][58466298] = {
            name = L["(Dread-Admiral Tattersail) will take you to Drustvar, Tiragarde Sound or Stormsong Valley"],
            type = "TransportHelper",
            showInZone = true,
            hideOnContinent = false,
            } -- Ship from Dazar'alor to Drustvar, Tiragarde Sound or Stormsong Valley
        end

        if (self.faction == "Alliance") or db.show["EnemyFaction"] then
          nodes[875][33051846] = {
          name = L["Back to Boralus"],
          type = "AShip",
          } -- Ship to Boralus from Vol'dun

          nodes[875][62402600] = {
          name = L["Back to Boralus"],
          type = "AShip",
          } -- Ship to Boralus from Nazmir

          nodes[875][47177779] = {
          name = L["Back to Boralus"],
          type = "AShip",
          } -- Ship to Boralus from Zuldazar

          nodes[1161][67952670] = {
          name = L["(Grand Admiral Jes-Tereth) will take you to Vol'Dun, Nazmir or Zuldazar"],
          type = "TransportHelper",
          showInZone = true,
          hideOnContinent = false,
          } -- Portal from Dazar'alor to Mechagon
        end
      end
    end

    -- Kul Tiras
    if (not self.db.profile.hideKulTiras) then 

      if (not self.db.profile.hideDungeons) then
        nodes[876][19872697] = { 
        id = 1178,
        type = "Dungeon",
        } -- Operation: Mechagon

        nodes[876][67018056] = {
        id = 1001,
        type = "Dungeon",
        } -- Freehold

        nodes[876][31675333] = {
        id = 1021,
        type = "Dungeon",
        } -- Waycrest Manor

        nodes[942][78932647] = {
        id = 1036,
        type = "Dungeon",
        } -- Shrine of Storm

        nodes[876][77566206] = {
        id = 1002,
        type = "Dungeon",
        } -- Tol Dagor

        if (self.faction == "Alliance") or db.show["EnemyFaction"] then
          nodes[876][61865000] = {
          id = 1023,
          type = "Dungeon",
          } -- Siege of Boralus
        end

        if (self.faction == "Horde") or db.show["EnemyFaction"] then
          nodes[876][69936482] = {
          id = 1023,
          type = "Dungeon",
          } -- Siege of Boralus
        end
      end

      --Kul Tiras Raids
      if (not self.db.profile.hideRaids) then

        nodes[876][68262354] = {
        id = 1177,
        type = "Raid",
        } -- Crucible of Storms

        nodes[876][86571446] = { 
        id = 1179,
        type = "Raid",
        } -- The Eternal Palace

        if (self.faction == "Alliance") or db.show["EnemyFaction"] then
          nodes[876][61645308] = {
          id = 1176,
          type = "Raid",
          } -- Battle of Dazar'alor
        end
      end

      -- Kul Tiras Portals
      if (not self.db.profile.hidePortals) then

        if (self.faction == "Alliance") or db.show["EnemyFaction"] then
          nodes[876][61085021] = {
          name = L["Portalroom from Boralus (inside building)"],
          type = "APortal",
          showInZone = true,
          hideOnContinent = false,
          } -- portalroom from Boralus

          nodes[1161][70351605] = {
          name = L["Portalroom from Boralus (inside building)"],
          type = "APortal",
          showInZone = true,
          hideOnContinent = false,
          } -- Portalroom from Boralus

          nodes[895][74072427] = {
          name = L["Portalroom from Boralus (inside building)"],
          type = "APortal",
          showInZone = true,
          } -- Portalroom from Boralus

          nodes[1161][69641590] = {
          name = L["Portal to Silithus"],
          type = "APortal",
          showInZone = false,
          hideOnContinent = true,
          } -- Portalroom from Boralus

          nodes[1161][70131684] = {
          name = L["Portal to Stormwind City"],
          type = "APortal",
          showInZone = false,
        } -- Portalroom from Boralus

          nodes[1161][70381499] = {
          name = L["Portal to Exodar"],
          type = "APortal",
          showInZone = false,
        } -- Portalroom from Boralus

          nodes[1161][70891536] = {
          name = L["Portal to Ironforge"],
          type = "APortal",
          showInZone = false,
        } -- Portalroom from Boralus

          nodes[1161][66202451] = {
          name = L["These portals are only active in the game if your faction is currently occupying (Ar'gorok for the Arathi Highlands portal) or (Bashal'Aran for the Darkshore portal)"],
          type = "APortal",
          showInZone = true,
        } -- Portalroom from Boralus

          nodes[1161][66202451] = {
          name = L["These portals are only active in the game if your faction is currently occupying (Ar'gorok for the Arathi Highlands portal) or (Bashal'Aran for the Darkshore portal)"],
          type = "APortal",
          showInZone = true,
        } -- Portalroom from Boralus
        end
      end

      -- Kul Tiras Ships
      if (not self.db.profile.hideShips) then

        if (self.faction == "Horde") or db.show["EnemyFaction"] then
          nodes[876][25676657] = { 
          name = L["Back to Zuldazar"],
          type = "HShip",
          } -- Portal from Drustvar to Zuldazar

          nodes[876][54391406] = { 
          name = L["Back to Zuldazar"],
          type = "HShip",
          } -- Portal from Stormsong Valley to Zuldazar

          nodes[876][68326548] = { 
          name = L["Back to Zuldazar"],
          type = "HShip",
          } -- Portal from Tiragarde Sound to Zuldazar

          nodes[876][20182395] = { 
          name = L["Back to Zuldazar"],
          type = "HShip",
          } -- Portal from Mechagon to Zuldazar
        end

        if (self.faction == "Alliance") or db.show["EnemyFaction"] then
          nodes[876][62485167] = {
          name = L["Ship to Stormwind City"],
          type = "AShip",
          } -- Ship to Stormwind
        end
      end
    end

    -- Shadowlands
    if (not self.db.profile.hideShadowlands) then

      -- Shadowlands Dungeons
      if (not self.db.profile.hideDungeons) then

        nodes[1533][40085519] = {
        id = 1182,
        type = "Dungeon",
        } -- The Necrotic Wake

        nodes[1533][58602852] = {
        id = 1186,
        type = "Dungeon",
        } -- Spires of Ascension

        nodes[1536][59306484] = {
        id = 1183,
        type = "Dungeon",
        } -- Plaguefall

        nodes[1536][53215314] = {
        id = 1187,
        type = "Dungeon",
        } -- Theater of Pain

        nodes[1565][35715421] = {
        id = 1184,
        type = "Dungeon",
        } -- Mists of Tirna Scithe

        nodes[1565][68646667] = {
        id = 1188,
        type = "Dungeon",
        } -- De Other Side

        nodes[1525][78624930] = {
        id = 1185,
        type = "Dungeon",
        } -- Halls of Atonement

        nodes[1525][51093007] = {
        id = 1189,
        type = "Dungeon",
        } -- Sanguine Depths

        nodes[1550][31957638] = {
        id = 1194,
        type = "Dungeon",
        } -- Tazavesh, the Veiled Market

        nodes[2016][88914392] = {
        id = 1194,
        type = "Dungeon",
        } -- Tazavesh, the Veiled Market
      end

      --Shadowlands Raids
      if (not self.db.profile.hideRaids) then

        nodes[1550][89067983] = {
        id = 1195,
        type = "Raid",
        } -- Sepulcher of the First Ones

        nodes[1970][80765336] = {
        id = 1195,
        type = "Raid",
        } -- Sepulcher of the First Ones

        nodes[1525][45764149] = {
        id = 1190,
        type = "Raid",
        } -- Castle Nathria 

        nodes[1550][27081359] = {
        id = 1193,
        type = "Raid",
        } -- Sanctum of Domination   

        nodes[1543][69703210] = {
        id = 1193,
        type = "Raid",
        } -- Sanctum of Domination  
      end

      -- Shadowlands Portals
      if (not self.db.profile.hidePortals) then

        if (self.faction == "Horde") or db.show["EnemyFaction"] then
          nodes[1670][20805432] = {
          name = L["Portal to Orgrimmar"],
          type = "HPortal",
          hideOnContinent = false,
          showInZone = true,
          } --  Oribos to Orgrimmar Portal

          nodes[1550][46555240] = {
          name = L["Portal to Orgrimmar"],
          type = "HPortal",
          hideOnContinent = false,
          showInZone = false,
          } --  Oribos to Orgrimmar Portal
        end

        if (self.faction == "Alliance") or db.show["EnemyFaction"] then
          nodes[1670][20654625] = {
          name = L["Portal to Stormwind City"],
          type = "APortal",
          hideOnContinent = false,
          showInZone = true,
          } --  Oribos to Stormwind City Portal

          nodes[1550][46555240] = {
          name = L["Portal to Stormwind City"],
          type = "APortal",
          hideOnContinent = false,
          showInZone = false,
          } --  Oribos to Stormwind City Portal
         end
      end
    end


    -- Dragonflight
    if (not self.db.profile.hideDragonIsles) then

      -- Dragonflight Dungeons
      if (not self.db.profile.hideDungeons) then

        nodes[1978][52884168] = {
        id = 1202,
        type = "Dungeon",
        } -- Ruby Life Pools 

        nodes[1978][42163601] = {
        id = 1199,
        type = "Dungeon",
        } -- Neltharus

        nodes[1978][43635285] = {
        id = 1198,
        type = "Dungeon",
        } -- The Nokhud Offensive

        nodes[1978][35407585] = {
        id = 1196,
        type = "Dungeon",
        } -- Brackenhide Hollow

        nodes[1978][47408261] = {
        id = 1203,
        type = "Dungeon",
        } -- The Azure Vault

        nodes[1978][63114151] = {
        id = 1201,
        type = "Dungeon",
        } -- Algeth'ar Academy

        nodes[1978][63614887] = {
        id = 1204,
        type = "Dungeon",
        } -- Halls of Infusion

        nodes[1978][64415841] = {
        id = 1209,
        type = "Dungeon",
        } -- Dawn of the Infinite
      end

      -- Dragonflight Raids
      if (not self.db.profile.hideRaids) then

        nodes[2025][73065567] = {
        id = 1200,
        type = "Raid",
        } -- Vault of the Incarnates

        nodes[1978][86737309] = {
        id = 1208,
        type = "Raid",
        }-- Aberrus, the Shadowed Crucible

        nodes[2133][48451022] = {
        id = 1208,
        type = "Raid",
        }-- Aberrus, the Shadowed Crucible

        nodes[2200][27323111] = {
        id = 1207,
        type = "Raid",
        }-- Amirdrassil, the Dream's Hope

        nodes[2023][18425233] = {
        id = 1207,
        type = "Raid",
        showInZone = false,
        hideOnContinent = true,
        }-- Amirdrassil, the Dream's Hope
      end

      -- Dragonflight Portals
      if (not self.db.profile.hidePortals) then

        nodes[2025][40656084] = {
        name = L["Portal to Nazmir, Uldum or Tiragarde Sound"],
        type = "Portal",
        hideOnContinent = false,
        showInZone = true,
        } --  Portal from Valdrakken to Nazmir, Uldum and Tiragarde Sound

        nodes[2112][53875511] = {
        uiMapId = 2025,
        name = L["Portal to Nazmir, Uldum or Tiragarde Sound"],
        type = "Portal",
        hideOnContinent = false,
        showInZone = true,
        } --  Portal from Valdrakken to Nazmir, Uldum and Tiragarde Sound

        nodes[2023][18295223] = {
        name = L["Portal to The Emerald Dream"],
        type = "Portal",
        showInZone = true,
        hideOnContinent = true,
        }-- Portal to The Emerald Dream

        nodes[1978][31195663] = {
        name = L["Portal to The Emerald Dream"],
        type = "Portal",
        showInZone = true,
        }-- Portal to The Emerald Dream

        nodes[2200][73065245] = {
        name = L["Portal to Ohn'ahran Plains"],
        type = "Portal",
        showInZone = true,
        hideOnContinent = false,
        }-- Portal The Emerald Dream to Ohn'ahran Plains

        if (self.faction == "Horde") or db.show["EnemyFaction"] then
          nodes[2112][56593828] = {
          name = L["Portal to Orgrimmar (inside building)"],
          type = "HPortal",
          hideOnContinent = false,
          showInZone = true,
          } --  Valdrakken to Orgrimmar Portal
        end

        if (self.faction == "Alliance") or db.show["EnemyFaction"] then
          nodes[2112][59804169] = {
          name = L["Portal to Stormwind City (inside building)"],
          type = "APortal",
          hideOnContinent = false,
          showInZone = true,
          } --  Valdrakken to Stormwind City Portal
        end
      end


      if (not self.db.profile.hideZeppelins) then      -- Zeppelin

        if (self.faction == "Horde") or db.show["EnemyFaction"] then
        nodes[1978][59572607] = {
        name = L["Zeppelin to Orgrimmar"],
        type = "HZeppelin",
        showInZone = true,
        } -- Zeppelin from The Walking Shores to Orgrimmar 
        end
      end

      if (not self.db.profile.hideShip) then

        if (self.faction == "Alliance") or db.show["EnemyFaction"] then
          nodes[1978][59732701] = {
          name = L["Ship to Stormwind City"],
          type = "AShip",
          showInZone = true,
          } -- Zeppelin from The Walking Shores to Stormwind
        end
      end
    end
  end
end --End of Line 596
end --HideMapNote Line

function Addon:ProcessTable()
table.wipe(lfgIDs)

lfgIDs = {

[63]=326, [64]=327, [66]=323, [65]=1150, [67]=1148, [68]=1147, [69]=1151, [70]=321, [71]=1149, [72]=316, [73]=314, [74]=318, [75]=329, [76]=334, [77]=340, [78]=362,

[186]=439, [184]=1152, [185]=437, [187]=448,

[226]=4, [227]=10, [229]=32, [231]=14, [233]=20, [234]=16, [236]=1458, [239]=22, [240]=1, [241]=24, [246]=472, [247]=178, [248]=188, [249]=1154, [250]=1013, [252]=180, [253]=181, [254]=1011, [257]=191, [258]=192, [261]=185, [271]=1016, [272]=241, [273]=215, [274]=1017, [275]=1018, [276]=256, [277]=213, [278]=1153, [279]=210, [280]=252, [281]=1019, [282]=1296, [283]=221, [284]=249, [285]=242, [286]=1020,

[302]=1466, [303]=1464, [311]=473, [312]=1468, [313]=1469, [316]=474, [317]=532, [320]=834, [321]=1467, [324]=1465, [330]=534, [369]=766, [362]=634, [385]=1005,

[457]=900, [476]=1010, [477]=897, 

[536]=1006, [537]=1009, [547]=1008, [556]=1003, [558]=1007, [559]=1004,

[669]=989,

[707]=1044, [716]=1175, [721]=1473, [726]=1190, [727]=1192, [740]=1205, [741]=48, [742]=50, [743]=160, [744]=161, [745]=175, [746]=177, [747]=176, [748]=194, [749]=193, [751]=196, [753]=240, [754]=227, [755]=238, [756]=1423, [757]=248, [758]=280, [759]=244, [760]=257, [761]=1502, [762]=1202, [767]=1207, [768]=1350, [777]=1209, [786]=1353,

[800]=1319, [861]=1439, [875]=1527,

[900]=1488

}

mapIDs = {
  
    -- Black Temple
['bt_black_temple'] = 339, ['bt_karabor_sewers'] = 340, ['bt_sanctuary_of_shadows'] = 341, ['bt_halls_of_anguish'] = 342, ['bt_gorefiends_vigil'] = 343, ['bt_den_of_mortal_delights'] = 344, ['bt_chamber_of_command'] = 345, ['bt_temple_summit'] = 346,

}

function Addon:UpdateAlter(id, name)
  if (lfgIDs[id]) then
    local lfgIDs1, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, lfgIDs2 = GetLFGDungeonInfo(lfgIDs[id])
      if (lfgIDs2 and lfgIDs1 == name) then
    	  lfgIDs1 = lfgIDs2
      end

    if (lfgIDs1) then
      if (lfgIDs1 == name) then
      else
      lfgIDs[id] = nil
      lfgIDs[name] = lfgIDs1
      end
    end
  end
end

for i,v in pairs(nodes) do
    for j,u in pairs(v) do
      self:UpdateInstanceNames(u)
    end
  end

  for i,v in pairs(minimap) do
    for j,u in pairs(v) do
      if (not u.name) then
  	    self:UpdateInstanceNames(u)
      end
    end
  end
end

function Addon:UpdateInstanceNames(node)
  local dungeonInfo = EJ_GetInstanceInfo
  local id = node.id

    if (node.lfgid) then
      dungeonInfo = GetLFGDungeonInfo
      id = node.lfgid
    end

    if (type(id) == "table") then
      for i,v in pairs(node.id) do
        local name = dungeonInfo(v)
          self:UpdateAlter(v, name)
        if (node.name) then
          node.name = node.name .. "\n" .. name
        else
          node.name = name
        end
      end
    elseif (id) then
      node.name = dungeonInfo(id)
      self:UpdateAlter(id, node.name)
    end
end

function Addon:FullUpdate()
  self:PopulateTable()
  self:PopulateMinimap()
  self:ProcessTable()
end
