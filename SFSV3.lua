repeat wait() until game:IsLoaded()

--

if not LPH_OBFUSCATED then
    LPH_JIT_MAX = function(...) return(...) end;
    LPH_NO_VIRTUALIZE = function(...) return(...) end;
    lgVarsTbl = {}
    lgTagsTbl = {"Premium"}
end

if LPH_OBFUSCATED then
    LPH_NO_VIRTUALIZE(function()
        x = hookfunction(hookfunction, function(...)
            local args = {...}
            local first = getinfo(args[1]).name 
            
            if first == 'FireServer' or first == 'InvokeServer' then 
                while true do end
            end
            
            return x(...) 
        end)
        
        other = hookfunction(Instance.new, function(...)
            local args = {...}
            
            if checkcaller() and tostring(args[1]) == 'IntValue' then
                while true do end
            end
        
            return other(...) 
        end)
        
        for i,v in pairs(getgc(true)) do 
            if type(v) == 'table' and rawget(v, 'new') and rawget(v, 'decrementCalls') and rawget(v, 'clear') then 
                local constants = getconstants(v.new)
                
                if table.find(constants, 'blockArg') and table.find(constants, 'Instance') then 
                    the_table = v 
                    break
                end
            end
        end
        
        if the_table then 
            fac = hookfunction(the_table.incrementCalls, function(...)
                while true do end
        
                return fac(...)
            end)
        end
    end)()
end

local scriptName= lgVarsTbl['scriptName']
local hoursRemaining= lgVarsTbl['hoursRemaining']
local lastHwidResetDate= lgVarsTbl['lastHwidResetDate']
local HwidResetCounts= lgVarsTbl['HwidResetCounts']
local HWID = lgVarsTbl['HWID']
local DiscordId = lgVarsTbl['DiscordId']
local DiscordUsername = lgVarsTbl['DiscordUsername']
local DiscordAvatar = lgVarsTbl['DiscordAvatar']
local expirationDateTime= lgVarsTbl['expirationDateTime']
local WhitelistedDate= lgVarsTbl['WhitelistedDate']
local totalExecutions = lgVarsTbl['totalExecutions']
local uniqueKeyId = lgVarsTbl['key_id']

if hoursRemaining and lgNotify then
    lgNotify('Key Expires In:\n'..tostring(hoursRemaining).." Hours", 5) -- with 3 being the number of seconds to show the notification
end

--

local version = 2
local info = {
    "Welcome to Banana Hub v"..version
}
----warn(table.concat(info,"\n"))
if lgNotify then
    lgNotify(table.concat(info,"\n"), 15)
end

_G.NowLoaded = false
_G.CanTap = true
_G.Theme = "Yellow"

local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local PlayerData = Knit.GetController("DataController"):GetData("PlayerData")
local DatabaseController = Knit.GetController("DatabaseController")

pcall(function()
    local oldPos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    local Areas = DatabaseController:GetDatabase("Areas")
    
    for i,v in pairs(Areas) do
        local areaSpawnPosition = v.spawnPos
    
        if areaSpawnPosition and not game:GetService("Workspace").Resources.Spawns:FindFirstChild("Area "..v.index) then
            local amount = 0
            repeat
                pcall(function()
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(areaSpawnPosition)
                end)
                amount += 1
                task.wait(0.01)
            until game:GetService("Workspace").Resources.Spawns:FindFirstChild("Area "..v.index) or amount >= 500
            task.wait(.5)
        end
    end
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldPos
end)

local CL = loadstring(game:HttpGet("https://raw.githubusercontent.com/diepedyt/customLua/main/CSTM.lua"))()
local CTables = CL.Tables

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/diepedyt/bui/main/arrayfield(rayfield)Modified.lua'))()

---------

local configFolder = _G.ConfigFolder or ""
if not isfolder("Banana Hub"..configFolder) then
    makefolder("Banana Hub"..configFolder)
end

local Window = Rayfield:CreateWindow({
	Name = "Banana Hub",
	LoadingTitle = "Sword Fighters Simulator",
	LoadingSubtitle = "by Roge#4087",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "Banana Hub"..configFolder, -- Create a custom folder for your hub/game
		FileName = "SwordFightersSimulator"..game.Players.LocalPlayer.Name
	},
    Discord = {
        Enabled = true,
        Invite = "d8Y6HmBPvY", -- The Discord invite code, do not include discord.gg/
        RememberJoins = true -- Set this to false to make them join the discord every time they load it up
    },
	KeySystem = false, -- Set this to true to use our key system
	KeySettings = {
		Title = "Sirius Hub",
		Subtitle = "Key System",
		Note = "Join the discord (discord.gg/sirius)",
		FileName = "SiriusKey",
		SaveKey = true,
		GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
		Key = "Hello"
	}
})

local Toggles = {}
_G.SF = {}
_G.AreaDropdowns = {}
local insertedNumbers = {}
function createOptimisedToggle(Tab, Name, ValueName, DoFunction, DontSpawn, DoAfterDestroy)
    local ToggleNum = #Toggles + 1
    table.insert(Toggles, ToggleNum)
    local randomNum = 0
    repeat
        randomNum = math.random(55,22222)
        task.wait(.01)
    until not table.find(insertedNumbers, randomNum)
    table.insert(insertedNumbers, randomNum)
    --_G.SF[randomNum] = false
    return Tab:CreateToggle({
        Name = Name,
        CurrentValue = _G.Settings[ValueName],
        Flag = "Toggle"..ValueName,
        Callback = function(Value)
            _G.Settings[ValueName] = Value

            if not _G.SF[randomNum] and _G.Settings[ValueName] then
                _G.SF[randomNum] = true
                if not DontSpawn then
                    local ab = task.spawn(DoFunction)
                    --warn("SPAWNED FUNCTION")
                    repeat task.wait(.1) until not _G.Settings[ValueName]
                    task.cancel(ab)
                    _G.SF[randomNum] = false
                    --warn("REMOVED FUNCTION")
                    if DoAfterDestroy then
                        task.spawn(DoAfterDestroy)
                    end
                end
            end

        end
    })
end

local warnedAlready = false

local function clickOLD(thing)
    LPH_NO_VIRTUALIZE(function()
        if _G.Settings.ClickSpeed == 1 then
            coroutine.resume(coroutine.create(function()
                game:GetService("ReplicatedStorage").Packages.Knit.Services.ClickService.RF.Click:InvokeServer(thing)
            end))
        elseif _G.Settings.ClickSpeed > 1 then
            for i = 1, _G.Settings.ClickSpeed do 
                coroutine.resume(coroutine.create(function()
                    game:GetService("ReplicatedStorage").Packages.Knit.Services.ClickService.RF.Click:InvokeServer(thing)
                end))
            end
        end
    end)()
end

_G.ClickTarget = nil
local function click(thing) _G.ClickTarget = thing end
if not _G.ConnectionAUTOCLICK then
    _G.ConnectionAUTOCLICK = task.spawn(function()
        while task.wait() do
            if _G.Settings.AutoClick or _G.ClickTarget ~= nil then
                coroutine.resume(coroutine.create(function()
                    game:GetService("ReplicatedStorage").Packages.Knit.Services.ClickService.RF.Click:InvokeServer(_G.ClickTarget)
                end))
            end
        end
    end)
end

local function tpToMobCFrame(CFrameTO)
    local distanceInStuds = nil
    pcall(function()
        if game.Players.LocalPlayer.Character and CFrameTO then
            distanceInStuds = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - CFrameTO.Position).Magnitude
        end
    end)
    if distanceInStuds and tonumber(distanceInStuds) > 15 then
        pcall(function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameTO * CFrame.new(0,2,3)
        end)
    end
end

function MStoSeconds(MS)
    local seconds = nil
    pcall(function()
        if MS:match(":") and tonumber(MS:gsub(":",""):split(" ")[1]) then
            seconds = tonumber(MS:split(":")[2]) + tonumber(MS:split(":")[1]) * 60
        end
    end)
    if seconds then
        return seconds
    else
        return 99999
    end
end

function getStudLength(target)
    if game.Players.LocalPlayer.Character and target then
        distanceInStuds = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - target.Position).Magnitude
    end
    return distanceInStuds
end

local function SSAWNII(array)
    local outs = {}
    for i,v in pairs(array) do
        if not tonumber(v:gsub("%D","\n"):split(" ")[1]) then
            table.remove(array, table.find(array, v))
            table.insert(outs, v)
        end
    end
    table.sort(array, function(a,b)
        return tonumber(a:gsub("%D","\n"):split(" ")[1]) < tonumber(b:gsub("%D","\n"):split(" ")[1])
    end)
    for i,v in pairs(outs) do
        table.insert(array, v)
    end
    return array
end

---

--------

local petINFO = {}
local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local PlayerData = Knit.GetController("DataController"):GetData("PlayerData")
local DatabaseController = Knit.GetController("DatabaseController")
for i,v in pairs(DatabaseController:GetDatabase("Pets")) do
    petINFO[i] = v
end

local weaponINFO = {}
local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local PlayerData = Knit.GetController("DataController"):GetData("PlayerData")
local DatabaseController = Knit.GetController("DatabaseController")
for i,v in pairs(DatabaseController:GetDatabase("Weapons")) do
    weaponINFO[i] = v
end

local customPetRarities = {}
for i,v in pairs(petINFO) do
    if not table.find(customPetRarities, v.rarity) then
        table.insert(customPetRarities, v.rarity)
    end
end

local customSwordRarities = {}
for i,v in pairs(weaponINFO) do
    if not table.find(customSwordRarities, v.rarity) then
        table.insert(customSwordRarities, v.rarity)
    end
end


local worlds = CTables.GetChildrenNames(game:GetService("Workspace").Resources.Teleports)

local mobs = {
    ["Day"] = CTables.GetChildrenUniqueNames(game:GetService("Workspace").Resources.NPCSpawns.Normal),
    ["Night"] = CTables.GetChildrenUniqueNames(game:GetService("Workspace").Resources.NPCSpawns.NightEvent),
    ["Blood"] = CTables.GetChildrenUniqueNames(game:GetService("Workspace").Resources.NPCSpawns.BloodEvent)
}

local mobs = {"Sea Emperor"}
for i,v in pairs(game:GetService("Workspace").Resources.NPCSpawns:GetChildren()) do
    for i,v in pairs(v:GetChildren()) do
        if not table.find(mobs, v.Name) then
            table.insert(mobs, v.Name)
        end
    end
end

local eggs = {}
local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local PlayerData = Knit.GetController("DataController"):GetData("PlayerData")
local DatabaseController = Knit.GetController("DatabaseController")
for i,v in pairs(DatabaseController:GetDatabase("Eggs")) do
    if not table.find(eggs, v.name) then
        table.insert(eggs, v.name)
    end
end

local uis = {
    [""] = nil
}

local function getEggID(eggName)
    for eggID, v in pairs(DatabaseController:GetDatabase("Eggs")) do
        if v.name == eggName then
            return eggID
        end
    end
end

_G.RaidInformation = {}
_G.DungeonInformation = {}

game:GetService("ReplicatedStorage").Packages.Knit.Services.RaidService.RE.RaidReplicate.OnClientEvent:Connect(function(raidInfo)
    _G.RaidInformation = raidInfo
end)

game:GetService("ReplicatedStorage").Packages.Knit.Services.DungeonService.RE.DungeonReplicate.OnClientEvent:Connect(function(dungeonInfo)
    _G.DungeonInformation = dungeonInfo
    ----warn("----")
    for i,v in pairs(dungeonInfo) do
        ----print(i,v)
    end
    ----warn("----")
end)

game:GetService("ReplicatedStorage").Packages.Knit.Services.TowerService.RE.TowerReplicate.OnClientEvent:Connect(function(towerInfo)
    _G.TowerInformation = towerInfo
    ----warn("----")
    for i,v in pairs(towerInfo) do
        ----print(i,v)
    end
    ----warn("----")
end)


local function goToArea(areaName)

    local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
    local PlayerData = Knit.GetController("DataController"):GetData("PlayerData")
    local DatabaseController = Knit.GetController("DatabaseController")
    local Areas = DatabaseController:GetDatabase("Areas")

    if not Areas[areaName] then return false end

    local areaSpawnPosition = Areas[areaName].spawnPos

    pcall(function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(areaSpawnPosition)
    end)

end

local function JoinRaid(raidsToJoinArray)
    
    if _G.DoingDungeon then return false end

    local function raidRendered(raidName)

        local function foundRaid()
            for i, v in pairs(game:GetService("CollectionService"):GetTagged("RaidJoin")) do
                local v = v.Name
                if v == raidName then
                    return true
                end 
            end
        end

        local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
        local PlayerData = Knit.GetController("DataController"):GetData("PlayerData")
        local RaidTickets = PlayerData.RaidTickets
        local DatabaseController = Knit.GetController("DatabaseController")
        local Raids = DatabaseController:GetDatabase("Raids")

        if not Raids[raidName] then return false end

        local areaRaid = Raids[raidName].area

        local foundIT = false

        if not foundRaid() then
            _G.RaidSetups = true
            local oldCFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            repeat
                goToArea(areaRaid)
                task.wait(.01)
            until foundRaid()   
            pcall(function()
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldCFrame
            end)
            foundIT = foundRaid()
        end

        _G.RaidSetups = false

        return foundIT

    end

    for i,v in pairs(raidsToJoinArray) do
        raidRendered(v)
    end

    for v13, v14 in pairs(game:GetService("CollectionService"):GetTagged("RaidJoin")) do
        if (table.find(raidsToJoinArray, v14.Name) and v14:GetAttribute("CanJoin") and v14:GetAttribute("UID") and (not RaidTickets or RaidTickets > 0)) or (table.find(raidsToJoinArray, v14.Name) and game.Players.LocalPlayer:GetAttribute("Raid") == v14.Name) then
            _G.CanDoRaid = true
            --_G.DoingRaid = true
            task.wait(.5)
            game:GetService("ReplicatedStorage").Packages.Knit.Services.RaidService.RF.JoinRaid:InvokeServer(v14:GetAttribute("UID"))
            _G.Settings.SelectedRaid = v14.Name
            task.wait(3)
            if game.Players.LocalPlayer:GetAttribute("Raid") then
                return true
            elseif not game.Players.LocalPlayer:GetAttribute("Raid") then
                --_G.DoingRaid = false
                _G.CanDoRaid = false
                return false
            end
        end
    end

    _G.CanDoRaid = false
    
    _G.DoingRaid = false
    return false

end

local function goToAfkPosition(dontTp)
    --local day = math.floor(game:GetService("Lighting").ClockTime + 0.5) == 12
    --local blood = math.floor(game:GetService("Lighting").ClockTime + 0.5) == 7
    --local night = not day and not blood
    local night = workspace:GetAttribute("NIGHT_EVENT")
    local blood = workspace:GetAttribute("BLOOD_MOON_EVENT")
    local day = not night and not blood
    local requirements = not _G.DoingCorruption and not _G.DoingDungeon and not _G.DoingRaid and not _G.DoingTower
    if day or not _G.Settings.FarmingDayAndNight then
        if not dontTp and requirements then
            coroutine.resume(coroutine.create(function()
                for i = 1, 100 do
                    pcall(function()
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(table.unpack(_G.Settings.AFKPositions["Day"]:split(", ")))
                    end)
                    task.wait(.0001)
                end
            end))
        end
        return "Day"
    elseif blood then
        if not dontTp and requirements then
            coroutine.resume(coroutine.create(function()
                for i = 1, 100 do
                    pcall(function()
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(table.unpack(_G.Settings.AFKPositions["Blood"]:split(", ")))
                    end)
                    task.wait(.0001)
                end
            end))
        end
        return "Blood"
    elseif night then
        if not dontTp and requirements then
            coroutine.resume(coroutine.create(function()
                for i = 1, 100 do
                    pcall(function()
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(table.unpack(_G.Settings.AFKPositions["Night"]:split(", ")))
                    end)
                    task.wait(.0001)
                end
            end))
        end
        return "Night"
    end
end

------

_G.Settings = {
    AutoClick = false,
    AutoFarm = false,
    SelectedMobs = {
        ["Day"] = {},
        ["Night"] = {},
        ["Blood"] = {}
    },
    AutoPickRenderedMobs = false,
    MainEnabled = false,
    AutoUpgradeWorld = "",
    AutoHatchEgg = false,
    SelectedEgg = "",
    LeaveOnRoom = false,
    LeaveOnRoomRoom = 50,
    AutoCoin = false,
    TpToMobWhenNotFound = false,
    AutoAscend = false,
    AFKPositions = {
        ["Day"] = "",
        ["Night"] = "",
        ["Blood"] = ""
    },
    AutoRaid = false,
    SelectedRaids = {},
    AutoManageRelics = false,
    RelicsSelected = {},
    SellSelectedRelicsOrKeep = "Sell",
    WebhookLink = "",
    AutoWebhook = false,
    FarmingDayAndNight = false,
    EggAmount = 1,
    AutoEquipRelics = false,
    EquippingRelics = {
        ["Dungeon 1"] = "",
        ["Dungeon 2"] = "",
        ["Dungeon 3"] = "",
        ["Raid"] = "",
        ["Day Farming"] = "",
        ["Night Farming"] = "",
        ["Blood Farming"] = "",
        ["Tower"] = ""
    },
    EquippingRelicsNumberTwo = {
        ["Dungeon 1"] = "",
        ["Dungeon 2"] = "",
        ["Dungeon 3"] = "",
        ["Raid"] = "",
        ["Day Farming"] = "",
        ["Night Farming"] = "",
        ["Blood Farming"] = "",
        ["Tower"] = ""
    },
    HaveDualWield = false,
    AutoEquipRelicsFormat = "Name",
    AutoEquipWeapons = false,
    EquippingWeapons = {
        ["Dungeon"] = {
            ["One"] = "",
            ["Two"] = ""
        },
        ["Raid"] = {
            ["One"] = "",
            ["Two"] = ""
        },
        ["Day Farming"] = {
            ["One"] = "",
            ["Two"] = ""
        },
        ["Night Farming"] = {
            ["One"] = "",
            ["Two"] = ""
        },
        ["Blood Farming"] = {
            ["One"] = "",
            ["Two"] = ""
        },
        ["Tower"] = {
            ["One"] = "",
            ["Two"] = ""
        }
    },
    AutoEquipWeaponsFormat = "Name",
    AutoCollectGifts = false,
    CollectingAreas = {},
    AutoGifts = false,
    SelectedQuestArea = "",
    AutoQuest = false,
    WalkSpeed = 16,
    WebhookCooldown = 10,
    SelectedDungeons = {},
    LeaveOnRoomRooms = {
        ["Dungeon 1"] = 10,
        ["Dungeon 2"] = 10,
        ["Dungeon 3"] = 10
    },
    Priorities = {
        ["Raid"] = 10,
        ["Dungeon"] = 9,
        ["Gifts"] = 8,
        ["Corruption"] = 7,
        ["Tower"] = 6,
        ["Blood Moon"] = 5,
        ["Darkness"] = 4,
        ["HIDING"] = 100
    },
    AutoUpgradeRelics = false,
    SelectedUpgradeRelic = "",
    UpgradeEquippedRelic = false,
    RelicsGivingUp = {},
    AutoCorruption = false,
    CorruptionAreasFarming = {},
    AutoBoost = false,
    AutoBoostBuyType = {},
    AutoBuyEnableTab = false,
    AutoBuyMerchant = false,
    MerchantItemsToBuy = {},
    ClickSpeed = 2,
    AutoSwordsManage = false,
    SwordsSelected = {},
    SellSelectedSwordsOrKeep = "Sell",
    AutoPetDismantle = false,
    SelectedPets = {},
    WhatToDoWithSelectedPets = "Dismantle",
    AutoTowerLeaveRoom = 100,
    DungeonAdvWebhookLink = "",
    DungeonAdvWebhook = false,
    PetAdvWebhook = false,
    PetAdvWebhookLink = "",
    RaidAdvWebhookLink = "",
    RaidAdvWebhook = false,
    TowerAdvWebhookLink = "",
    TowerAdvWebhook = false,
    SwordAdvWebhook = false,
    SwordAdvWebhookLink = "",
    CurrentSelectedSwordEnchant = "None",
    CurrentSelectedSwordEnchantTier = "Any",
    KillAura = false,
    SelectedShinyPetsForFusion = {},
    WhatToDoWithShinySelectedPets = "Fuse",
    ShinyPetFusionRateMinimum = "50",
    SelectedCelestialPetsForFusion = {},
    WhatToDoWithCelestialSelectedPets = "Fuse",
    CelestialPetFusionRateMinimum = "50",
    AutoFuse = false,
    WhatToDoWithSelectedRelicsForAutoUpgradeRelic = "Use",
    AutoEquipLoadouts = false,
    EquippingLoadouts = {
        ["Dungeon 1"] = "",
        ["Dungeon 2"] = "",
        ["Dungeon 3"] = "",
        ["Raid"] = "",
        ["Day Farming"] = "",
        ["Night Farming"] = "",
        ["Blood Farming"] = "",
        ["Tower"] = ""
    },
    HopWhenSMClose = false,
    HopWhenSMCloseStuds = 1000,
    PetTiersSelling = {},
    WhatToDoWithSelectedPetTraits = "Dismantle",
    FarmRenderedMobsOnly = false,
    CheckForLoadoutEvery = 10,
    AutoEquipLoadoutCheckNewEvent = false
}

local function CanDoPriority(Action)

    if not _G.Settings.AutoRaid or not game.Players.LocalPlayer:GetAttribute("Raid") then
        _G.CanDoRaid = false
        _G.DoingRaid = false
    end
    if not _G.Settings.AutoDungeon then
        _G.DoingDungeon = false
    end
    if not workspace:GetAttribute("CORRUPT_EVENT") then
        _G.DoingCorruption = false
    end

    if not game.Players.LocalPlayer:GetAttribute("Tower") or not _G.Settings.AutoTower then
        _G.DoingTower = false
    elseif game.Players.LocalPlayer:GetAttribute("Tower") and _G.Settings.AutoTower then
        _G.DoingTower = true
    end

    local function doingThing(thing)
        if thing == "Raid" then
            return _G.DoingRaid or game.Players.LocalPlayer:GetAttribute("Raid") or _G.CanDoRaid
        elseif thing == "Dungeon" then
            return (tostring(_G.DungeonInformation["roomReached"]) ~= "0" and game.Players.LocalPlayer:GetAttribute("Dungeon"))
        elseif thing == "Gifts" then
            return _G.CollectingGifts
        elseif thing == "Corruption" then
            return _G.DoingCorruption
        elseif thing == "Tower" then
            return _G.DoingTower
        elseif thing == "Blood Moon" then
            return goToAfkPosition(true) == "Blood"
        elseif thing == "Darkness" then
            return goToAfkPosition(true) == "Night"
        elseif thing == "HIDING" then
            return _G.HIDING
        end
    end

    local function leaveNotDoing(thing)
        if thing == "Raid" then
            if game.Players.LocalPlayer:GetAttribute("Raid") then
                game:GetService("ReplicatedStorage").Packages.Knit.Services.RaidService.RF.LeaveRaid:InvokeServer()
            end
        elseif thing == "Dungeon" then
            if game.Players.LocalPlayer:GetAttribute("Dungeon") then
                game:GetService("ReplicatedStorage").Packages.Knit.Services.DungeonService.RF.LeaveDungeon:InvokeServer()
            end
        elseif thing == "Gifts" then
        elseif thing == "Corruption" then
        elseif thing == "Tower" then
            if game.Players.LocalPlayer:GetAttribute("Tower") then
                game:GetService("ReplicatedStorage").Packages.Knit.Services.TowerService.RF.LeaveTower:InvokeServer()
            end
        elseif thing == "HIDING" then
        end
    end

    table.sort(_G.Settings.Priorities, function(a, b)
        return Priorities[a] > Priorities[b]
    end)

    local highestAction = nil
    local highestPriority = 0
    for i,v in pairs(_G.Settings.Priorities) do
        if v > highestPriority then
            highestAction = i
            highestPriority = v
        end
    end

    local actionsOverAction = {}
    for i,v in pairs(_G.Settings.Priorities) do
        if v > _G.Settings.Priorities[Action] then
            table.insert(actionsOverAction, i)
        end
    end

    if Action == highestAction then
        coroutine.resume(coroutine.create(function()
            task.wait(5)
            if doingThing(Action) then
                for i,v in pairs(_G.Settings.Priorities) do
                    if i ~= Action then
                        ----warn(i, Action)
                        leaveNotDoing(i)
                    end
                end
            end
        end))
        return true
    end


    for i,v in pairs(_G.Settings.Priorities) do
        if table.find(actionsOverAction, i) and doingThing(i) then
            return false
        end
    end

    coroutine.resume(coroutine.create(function()
        task.wait(5)
        if doingThing(Action) then
            for i,v in pairs(_G.Settings.Priorities) do
                if i ~= Action then
                    ----warn(i, Action)
                    leaveNotDoing(i)
                end
            end
        end
    end))
    return true

end
-------



local Tab = Window:CreateTab("Auto Farm", 11642692687) -- Title, Image

local Section = Tab:CreateSection("Auto Farm")

local autoFarmToggle = createOptimisedToggle(Tab,"Auto Farm Selected Mob","AutoFarm",
function()

    if isfile and writefile then
        local data = true
        writefile("Banana Hub"..configFolder.."/MainAutoFarmToggleEnabled"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(data))
    end

    while task.wait() do

        local dayNight = goToAfkPosition(true)

        local function mobNames()
            return _G.Settings.SelectedMobs[goToAfkPosition(true)]
        end

        if not _G.HIDING and (not _G.DoingDungeon and not _G.DoingRaid and not _G.CollectingGifts and not _G.DoingQuest and not _G.RaidSetups and not _G.DoingCorruption and not _G.DoingTower) or ((goToAfkPosition(true) == "Blood" and CanDoPriority("Blood Moon")) or (goToAfkPosition(true) == "Night" and CanDoPriority("Darkness"))) then


            if _G.Settings.AFKPositions then

                local foundMob = false

                local Sucess, Error = pcall(function()
                    if _G.Settings.FarmRenderedMobsOnly then
                        for i,v in pairs(game:GetService("Workspace").Live.NPCs.Client:GetChildren()) do
                            local function mob(v)
                                return game:GetService("Workspace").Live.NPCs.Server[v.Name]
                            end
                            if table.find(mobNames(), mob(v):GetAttribute("Name")) and mob(v):GetAttribute("Health") > 0 then
                                foundMob = true
                                break
                            end
                        end
                    else
                        for i,v in pairs(game:GetService("Workspace").Live.NPCs.Server:GetChildren()) do
                            if table.find(mobNames(), v:GetAttribute("Name")) and v:GetAttribute("Health") > 0 then
                                foundMob = true
                                break
                            end
                        end
                    end

                end)
                if Error then
                    error(Error)
                end
                

                if not foundMob then

                    goToAfkPosition()

                end

            end
            
            
            local Sucess, Error = pcall(function()
                if _G.Settings.FarmRenderedMobsOnly then
                    for i,v in pairs(game:GetService("Workspace").Live.NPCs.Client:GetChildren()) do
                        local function mob(v)
                            return game:GetService("Workspace").Live.NPCs.Server[v.Name]
                        end

                        if mob(v):GetAttribute("Name") and mob(v):GetAttribute("Health") > 0 then
        
                            _G.CanTap = false
                            _G.CanNotPickMob = true
                            repeat
                                if not _G.HIDING and _G.Settings.AutoFarm and table.find(mobNames(), mob(v):GetAttribute("Name")) and dayNight == goToAfkPosition(true) and (not _G.DoingDungeon and not _G.DoingRaid and not _G.CollectingGifts and not _G.DoingQuest and not _G.RaidSetups and not _G.DoingCorruption or ((goToAfkPosition(true) == "Blood" and CanDoPriority("Blood Moon")) or (goToAfkPosition(true) == "Night" and CanDoPriority("Darkness")))) then
                                    _G.CanTap = false
                                    tpToMobCFrame(mob(v).CFrame)
                                    click(mob(v).Name)
                                    task.wait(.01)
                                else
                                    if _G.DoingDungeon or _G.DoingRaid then
                                        task.wait(.1)
                                    end
                                    break
                                end
                            until not mob(v) or not mob(v):GetAttribute("Health") or mob(v):GetAttribute("Health") <= 0
                            _G.CanNotPickMob = false
                            _G.CanTap = true

                        end
                    end
                else
                    for i,v in pairs(game:GetService("Workspace").Live.NPCs.Server:GetChildren()) do
                        if v:GetAttribute("Name") and v:GetAttribute("Health") > 0 then
        
                            _G.CanTap = false
                            _G.CanNotPickMob = true
                            repeat
                                if not _G.HIDING and _G.Settings.AutoFarm and table.find(mobNames(), v:GetAttribute("Name")) and dayNight == goToAfkPosition(true) and (not _G.DoingDungeon and not _G.DoingRaid and not _G.CollectingGifts and not _G.DoingQuest and not _G.RaidSetups and not _G.DoingCorruption or ((goToAfkPosition(true) == "Blood" and CanDoPriority("Blood Moon")) or (goToAfkPosition(true) == "Night" and CanDoPriority("Darkness")))) then
                                    _G.CanTap = false
                                    tpToMobCFrame(v.CFrame)
                                    click(v.Name)
                                    task.wait(.01)
                                else
                                    if _G.DoingDungeon or _G.DoingRaid then
                                        task.wait(.1)
                                    end
                                    break
                                end
                            until not v or not v:GetAttribute("Health") or v:GetAttribute("Health") <= 0
                            _G.CanNotPickMob = false
                            _G.CanTap = true

                        end
                    end
                end

            end)
            if Error then
                error(Error)
            end
            _G.CanTap = true

        end

        task.wait(.2)

    end

end,nil,
function()

    if isfile and writefile then
        local data = false
        writefile("Banana Hub"..configFolder.."/MainAutoFarmToggleEnabled"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(data))
    end

    _G.CanNotPickMob = false
    pcall(function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
    end)
    _G.CanTap = true

end)



_G.MobDrop = {}
for i,v in pairs(_G.Settings.SelectedMobs) do

    local Label = Tab:CreateLabel(i.." Mobs:")

    local Button = Tab:CreateButton({
        Name = "Reset List",
        Interact = 'Reset',
        Callback = function()
            _G.Settings.SelectedMobs[i] = {}
            Label:Set(i.." Mobs:")
            if isfile and writefile then
                writefile("Banana Hub"..configFolder.."/SwordFightersMobSave"..i..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.SelectedMobs[i]))
            end
        end
    })

    _G.MobDrop[i] = Tab:CreateDropdown({
        Name = "Select "..i.." Mob",
        Options = mobs,
        CurrentOption = "None",
        Flag = "Dropdown1"..i, -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(Option)
            if _G.NowLoaded then
                
                if _G.Settings.SelectedMobs[i] == nil then
                    _G.Settings.SelectedMobs[i] = {}
                end

                if table.find(_G.Settings.SelectedMobs[i], Option) then
                    table.remove(_G.Settings.SelectedMobs[i], table.find(_G.Settings.SelectedMobs[i], Option))
                else
                    table.insert(_G.Settings.SelectedMobs[i], Option)
                end

                if isfile and writefile then
                    writefile("Banana Hub"..configFolder.."/SwordFightersMobSave"..i..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.SelectedMobs[i]))
                end

                Label:Set(i.." Mobs: "..table.concat(_G.Settings.SelectedMobs[i],", "))
            end
        end
    })

    task.spawn(function()
        --repeat task.wait(.1) until _G.NowLoaded
        if isfile and readfile and isfile("Banana Hub"..configFolder.."/SwordFightersMobSave"..i..game.Players.LocalPlayer.Name..".json") then
            _G.Settings.SelectedMobs[i] = game:GetService("HttpService"):JSONDecode(readfile("Banana Hub"..configFolder.."/SwordFightersMobSave"..i..game.Players.LocalPlayer.Name..".json"))
        end
        Label:Set(i.." Mobs: "..table.concat(_G.Settings.SelectedMobs[i],", "))
    end)

end


createOptimisedToggle(Tab, "Farm Day And Night And Blood", "FarmingDayAndNight", nil, true)

createOptimisedToggle(Tab, "Auto Pick Random Rendered Mob","AutoPickRenderedMobs",
function()

    while task.wait() do
        if not _G.Settings.AutoFarm and _G.CanNotPickMob then
            _G.CanNotPickMob = false
        end
        if not _G.CanNotPickMob then
            
            local Sucess, Error = pcall(function()
                for i,v in pairs(game:GetService("Workspace").Live.NPCs.Client:GetChildren()) do
                    if v:FindFirstChild("HumanoidRootPart") and game:GetService("Workspace").Live.NPCs.Server:FindFirstChild(v.Name) and game:GetService("Workspace").Live.NPCs.Server[v.Name]:GetAttribute("Health") > 0 and not _G.CanNotPickMob then
                        
                        local abc = goToAfkPosition(true)
    
                        local mobName = game:GetService("Workspace").Live.NPCs.Server[v.Name]:GetAttribute("Name")
    
                        if mobName and not table.find(_G.Settings.SelectedMobs[abc], mobName) then
                            --table.insert(_G.Settings.SelectedMobs[abc], mobName)
                            --_G.Settings.SelectedMobs[abc] = mobName
                            _G.MobDrop[abc]:Set(mobName)
                            break
                        end
                        
    
                    end
                end
            end)
            if Error then
                error(Error)
            end

        end
        task.wait(.5)
    end

end)

local Section = Tab:CreateSection("AFK Positions")

local Paragraph = Tab:CreateParagraph({Title = "Notice", Content = "Script goes to this position after there is no mob found to fight (doesnt leave trial or anything like that)"})

if isfile and readfile and isfile("Banana Hub"..configFolder.."/SwordFightersPosSave3"..game.Players.LocalPlayer.Name..".json") then
    _G.Settings.AFKPositions = game:GetService("HttpService"):JSONDecode(readfile("Banana Hub"..configFolder.."/SwordFightersPosSave3"..game.Players.LocalPlayer.Name..".json"))
end

local Labels = {}
for i,v in pairs(_G.Settings.AFKPositions) do
    Labels[i] = Tab:CreateLabel("Current "..i.." AFK Position: "..tostring(_G.Settings.AFKPositions[i]))
end

for i,v in pairs(_G.Settings.AFKPositions) do
    Tab:CreateInput({
        Name = "Enter Position For "..i,
        PlaceholderText = "0, 0, 0",
        NumbersOnly = false, -- If the user can only type numbers.
        OnEnter = true, -- Will callback only if the user pressed ENTER while being focused.
        RemoveTextAfterFocusLost = true,
        Callback = function(Text)
            Text = tostring(Text)
            if not _G.Settings.AFKPositions[i] then
                _G.Settings.AFKPositions[i] = ""
            end
            if Labels[i] then
                _G.Settings.AFKPositions[i] = Text
                Labels[i]:Set("Current "..i.." AFK Position: "..tostring(_G.Settings.AFKPositions[i]))
                if isfile and writefile then
                    writefile("Banana Hub"..configFolder.."/SwordFightersPosSave3"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.AFKPositions))
                end
            end
        end,
    })
end

local Button = Tab:CreateButton({
   Name = "Copy Current Position",
   Interact = 'Copy',
   Callback = function()
    local MYCFrame = {math.floor(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X + 0.5),math.floor(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Y + 0.5),math.floor(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z + 0.5)}
    setclipboard(tostring(table.concat(MYCFrame,", ")))
   end
})


local Section = Tab:CreateSection("Auto Corruption")

createOptimisedToggle(Tab, "Auto Farm Corruption Events","AutoCorruption",function()

    local lastCorruption = 0

    while task.wait() do

        if _G.NowLoaded and workspace:GetAttribute("CORRUPT_EVENT") and table.find(_G.Settings.CorruptionAreasFarming, tostring(workspace:GetAttribute("CORRUPT_EVENT"))) and CanDoPriority("Corruption") and (os.time() - lastCorruption) >= 300 then

            --warn("true")

            _G.DoingCorruption = true

            local areaSpawnPos = DatabaseController:GetDatabase("Areas")[workspace:GetAttribute("CORRUPT_EVENT")].spawnPos or game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            local areaMobNames = DatabaseController:GetDatabase("Areas")[workspace:GetAttribute("CORRUPT_EVENT")].npcs or {}

            local function foundmob(v)
                local returnValue = false
                local Sucess, Error = pcall(function()
                    for i,v in pairs(game:GetService("Workspace").Live.NPCs.Server:GetChildren()) do
                        if v:GetAttribute("Name") and table.find(areaMobNames, v:GetAttribute("Name")) then
                            returnValue = true
                        end
                    end
                end)
                if Error then
                    error(Error)
                end
                return returnValue
            end

            local function foundCorruptedmob(v)
                local returnValue = false
                local Sucess, Error = pcall(function()
                    for i,v in pairs(game:GetService("Workspace").Live.NPCs.Client:GetChildren()) do
                        local function mob(v)
                            return game:GetService("Workspace").Live.NPCs.Server[v.Name]
                        end
                        local isCorrupted = (v:FindFirstChild("UpperTorso") and v.UpperTorso:FindFirstChild("Specks"))
                        if table.find(areaMobNames, mob(v):GetAttribute("Name")) and isCorrupted then
                            returnValue = true
                            break
                        end
                    end
                end)
                if Error then
                   error(Error)
                end
                return returnValue
            end
            

            if not foundmob(v) then
                local amount = 0
                repeat
                    pcall(function()
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(areaSpawnPos) * CFrame.new(0,10,0)
                    end)
                    task.wait(.1)
                    amount += 1
                until amount >= 100 or not CanDoPriority("Corruption") or foundmob(v)
            end


            if CanDoPriority("Corruption") and foundmob(v) and workspace:GetAttribute("CORRUPT_EVENT") then

                lastCorruption = os.time()
                warn("going!")
                _G.DoingCorruption = true
                repeat


                    _G.CanTap = false
                    local Success, Error = pcall(function()
                        if _G.Settings.FarmRenderedMobsOnly then
                            for i,v in pairs(game:GetService("Workspace").Live.NPCs.Client:GetChildren()) do
                                local function mob(v)
                                    return game:GetService("Workspace").Live.NPCs.Server[v.Name]
                                end
                                if mob(v):GetAttribute("Health") > 0 then
                                    _G.CanTap = false
                                    repeat
                                        _G.CanTap = false
                                        if foundCorruptedmob(mob(v)) and CanDoPriority("Corruption") then

                                            tpToMobCFrame(mob(v).CFrame)
                                            click(mob(v).Name)
                                            task.wait(.01)

                                        else
                                            break
                                        end
                                    until not mob(v) or mob(v):GetAttribute("Health") or mob(v):GetAttribute("Health") <= 0
                                    _G.CanTap = true
                                end
                            end
                        else
                            for i,v in pairs(game:GetService("Workspace").Live.NPCs.Server:GetChildren()) do
                                if v:GetAttribute("Health") > 0 then
                                    _G.CanTap = false
                                    repeat
                                        _G.CanTap = false
                                        if foundCorruptedmob(v) and CanDoPriority("Corruption") then

                                            tpToMobCFrame(v.CFrame)
                                            click(v.Name)
                                            task.wait(.01)

                                        else
                                            break
                                        end
                                    until not v or v:GetAttribute("Health") or v:GetAttribute("Health") <= 0
                                    _G.CanTap = true
                                end
                            end
                        end
                    end)
                    if Error then
                        error(Error)
                    end
                    _G.CanTap = true
                    task.wait(.1)
                until not foundCorruptedmob(v) or not CanDoPriority("Corruption")
            end

        end

        _G.DoingCorruption = false

        task.wait(.1)

    end

end,nil,function()

    _G.DoingCorruption = false
    _G.CanTap = true

end)

if isfile and readfile and isfile("Banana Hub"..configFolder.."/SwordFightersCorruptionAreasFarmingSave"..game.Players.LocalPlayer.Name..".json") then
    _G.Settings.CorruptionAreasFarming = game:GetService("HttpService"):JSONDecode(readfile("Banana Hub"..configFolder.."/SwordFightersCorruptionAreasFarmingSave"..game.Players.LocalPlayer.Name..".json"))
end

local LabelCAF = Tab:CreateLabel("Farming Corruption Areas: "..table.concat(_G.Settings.CorruptionAreasFarming,", "))

local Button = Tab:CreateButton({
    Name = "Reset List",
    Interact = 'Reset',
    Callback = function()
        _G.Settings.CorruptionAreasFarming = {}
        LabelCAF:Set("Farming Corruption Areas: "..table.concat(_G.Settings.CorruptionAreasFarming,", "))
        if isfile and writefile then
            writefile("Banana Hub"..configFolder.."/SwordFightersCorruptionAreasFarmingSave"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.CorruptionAreasFarming))
        end
    end
})

local areass = {}
for i,v in pairs(DatabaseController:GetDatabase("Areas")) do
    table.insert(areass, i)
end

Tab:CreateDropdown({
    Name = "Select Areas To Farm For Corruption",
    Options = areass,
    CurrentOption = "None",
    Flag = "DropdownDungeonSelect", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Option)
        if _G.NowLoaded and table.find(areass, Option) then

            if not table.find(_G.Settings.CorruptionAreasFarming, Option) then
                table.insert(_G.Settings.CorruptionAreasFarming, Option)
            else
                table.remove(_G.Settings.CorruptionAreasFarming, table.find(_G.Settings.CorruptionAreasFarming, Option))
            end
            
            if isfile and writefile then
                writefile("Banana Hub"..configFolder.."/SwordFightersCorruptionAreasFarmingSave"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.CorruptionAreasFarming))
            end

            LabelCAF:Set("Farming Corruption Areas: "..table.concat(_G.Settings.CorruptionAreasFarming,", "))

        end
    end
})

local Tab = Window:CreateTab("Auto Time Trial", 11642692687) -- Title, Image

local Section = Tab:CreateSection("Info")

local Label = Tab:CreateLabel("TT 1 Starts In: (Must Be In TT Hub atleast once)")
local Label2 = Tab:CreateLabel("TT 2 Starts In: (Must Be In TT Hub atleast once)")
local Label3 = Tab:CreateLabel("TT 3 Starts In: (Must Be In TT Hub atleast once)")

task.spawn(function()
    game:GetService("Workspace").Resources.Gamemodes.DungeonLobby.Timers:WaitForChild("Dungeon 1"):WaitForChild("Timer"):WaitForChild("TextLabel").Changed:Connect(function()
        Label:Set("TT 1 Starts In: "..game:GetService("Workspace").Resources.Gamemodes.DungeonLobby.Timers:WaitForChild("Dungeon 1"):WaitForChild("Timer"):WaitForChild("TextLabel").Text)
    end)
    game:GetService("Workspace").Resources.Gamemodes.DungeonLobby.Timers:WaitForChild("Dungeon 2"):WaitForChild("Timer"):WaitForChild("TextLabel").Changed:Connect(function()
        Label2:Set("TT 2 Starts In: "..game:GetService("Workspace").Resources.Gamemodes.DungeonLobby.Timers:WaitForChild("Dungeon 2"):WaitForChild("Timer"):WaitForChild("TextLabel").Text)
    end)
    game:GetService("Workspace").Resources.Gamemodes.DungeonLobby.Timers:WaitForChild("Dungeon 3"):WaitForChild("Timer"):WaitForChild("TextLabel").Changed:Connect(function()
        Label3:Set("TT 3 Starts In: "..game:GetService("Workspace").Resources.Gamemodes.DungeonLobby.Timers:WaitForChild("Dungeon 3"):WaitForChild("Timer"):WaitForChild("TextLabel").Text)
    end)
end)

local Section = Tab:CreateSection("Main")

local dungeons = {"Dungeon 1","Dungeon 2","Dungeon 3"}

createOptimisedToggle(Tab,"Auto Do Dungeon","AutoDungeon",
function()

    while task.wait() do

        pcall(function()

            if #game:GetService("Workspace").Resources.Gamemodes.DungeonLobby.Doors:GetChildren() == 0 then
                repeat task.wait() until not _G.RaidSetups
                local OLDCFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                repeat
                    for i = 1,25 do
                        pcall(function()
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2815.02637, 7.05826807, -129.52356, 0, 0, 1, 0, 1, -0, -1, 0, 0)
                            game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
                        end)
                        task.wait(.01)
                    end
                until #game:GetService("Workspace").Resources.Gamemodes.DungeonLobby.Doors:GetChildren() > 0
                task.wait(.1)
                pcall(function()
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = OLDCFrame
                    task.wait(.1)
                    game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
                end)
            end

        end)

        if not game.Players.LocalPlayer:GetAttribute("Dungeon") then
            _G.DungeonInformation = {}
            _G.DoingDungeon = false
            _G.Settings.SelectedDungeon = ""
        end

        if not game.Players.LocalPlayer:GetAttribute("Dungeon") and CanDoPriority("Dungeon") then
            for i,v in pairs(game:GetService("CollectionService"):GetTagged("DungeonJoin")) do
                if v:GetAttribute("UID") and table.find(_G.Settings.SelectedDungeons, v.Name) and not (v.Name == "Dungeon 1" and (table.find(_G.Settings.SelectedDungeons, "Dungeon 3") and table.find(_G.Settings.SelectedDungeons, "Dungeon 1"))) then
                    _G.Settings.SelectedDungeon = v.Name
                    game:GetService("ReplicatedStorage").Packages.Knit.Services.DungeonService.RF.JoinDungeon:InvokeServer(v:GetAttribute("UID"))
                    task.wait(.5)
                    break
                end
            end
        end

        if game.Players.LocalPlayer:GetAttribute("Dungeon") and CanDoPriority("Dungeon") and tostring(_G.DungeonInformation["roomReached"]) ~= "0" then

            _G.DoingDungeon = true

            game:GetService("ReplicatedStorage").Packages.Knit.Services.DungeonService.RF.ContinueDungeon:InvokeServer(game.Players.LocalPlayer:GetAttribute("Dungeon"))

            if game:GetService("Workspace").Live.Dungeons:FindFirstChild("Dungeon 1, Room "..tostring(_G.DungeonInformation["roomReached"])) then
                pcall(function()
                    local CFrameA = game:GetService("Workspace").Live.Dungeons["Dungeon 1, Room "..tostring(_G.DungeonInformation["roomReached"])]:GetModelCFrame()
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(CFrameA.X, CFrameA.Y, CFrameA.Z)
                end)
            end

            if _G.Settings.FarmRenderedMobsOnly then
                for i,v in pairs(game:GetService("Workspace").Live.NPCs.Client:GetChildren()) do
                    local function mob(v)
                        return game:GetService("Workspace").Live.NPCs.Server[v.Name]
                    end
                    if mob(v) and mob(v):GetAttribute("Health") > 0 and mob(v):GetAttribute("Gamemode") == "Dungeon" then
                        _G.CanTap = false
                        game:GetService("ReplicatedStorage").Packages.Knit.Services.DungeonService.RF.ContinueDungeon:InvokeServer(game.Players.LocalPlayer:GetAttribute("Dungeon"))
                        repeat
                            if _G.Settings.AutoDungeon and mob(v) and CanDoPriority("Dungeon") and game.Players.LocalPlayer:GetAttribute("Dungeon") then
                                _G.CanTap = false
                                tpToMobCFrame(mob(v).CFrame)
                                click(mob(v).Name)
                                task.wait(.01)
                            else
                                break
                            end
                        until not mob(v) or not mob(v):GetAttribute("Health") or mob(v):GetAttribute("Health") <= 0
                        _G.CanTap = true
                    end
                end
            else
                for i,v in pairs(game:GetService("Workspace").Live.NPCs.Server:GetChildren()) do
                    if v and v:GetAttribute("Health") > 0 and v:GetAttribute("Gamemode") == "Dungeon" then
                        _G.CanTap = false
                        game:GetService("ReplicatedStorage").Packages.Knit.Services.DungeonService.RF.ContinueDungeon:InvokeServer(game.Players.LocalPlayer:GetAttribute("Dungeon"))
                        repeat
                            if _G.Settings.AutoDungeon and v and CanDoPriority("Dungeon") and game.Players.LocalPlayer:GetAttribute("Dungeon") then
                                _G.CanTap = false
                                tpToMobCFrame(v.CFrame)
                                click(v.Name)
                                task.wait(.01)
                            else
                                break
                            end
                        until not v or not v:GetAttribute("Health") or v:GetAttribute("Health") <= 0
                        _G.CanTap = true
                    end
                end
            end

        else

            _G.DoingDungeon = false

        end

        task.wait(.5)

    end

end,nil,function()

    _G.DoingDungeon = false
    _G.EnteredDungeon = false
    _G.CanTap = true

end)

if isfile and readfile and isfile("Banana Hub"..configFolder.."/SwordFightersDungeonsSave"..game.Players.LocalPlayer.Name..".json") then
    _G.Settings.SelectedDungeons = game:GetService("HttpService"):JSONDecode(readfile("Banana Hub"..configFolder.."/SwordFightersDungeonsSave"..game.Players.LocalPlayer.Name..".json"))
end
local Paragraph = Tab:CreateParagraph({Title = "Dungeons Farming:", Content = table.concat(_G.Settings.SelectedDungeons,", ")})

local Button = Tab:CreateButton({
    Name = "Reset List",
    Interact = 'Reset',
    Callback = function()
        _G.Settings.SelectedDungeons = {}
        Paragraph:Set({Title = "Dungeons Farming:", Content = table.concat(_G.Settings.SelectedDungeons,", ")})
        if isfile and writefile then
            writefile("Banana Hub"..configFolder.."/SwordFightersDungeonsSave"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.SelectedDungeons))
        end
    end
})

Tab:CreateDropdown({
    Name = "Select Dungeons To Farm",
    Options = dungeons,
    CurrentOption = "None",
    Flag = "DropdownDungeonSelect", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Option)
        if _G.NowLoaded and table.find(dungeons, Option) then

            if not table.find(_G.Settings.SelectedDungeons, Option) then
                table.insert(_G.Settings.SelectedDungeons, Option)
            else
                table.remove(_G.Settings.SelectedDungeons, table.find(_G.Settings.SelectedDungeons, Option))
            end
            
            if isfile and writefile then
                writefile("Banana Hub"..configFolder.."/SwordFightersDungeonsSave"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.SelectedDungeons))
            end

            Paragraph:Set({Title = "Dungeons Farming:", Content = table.concat(_G.Settings.SelectedDungeons,", ")})

        end
    end
})


local Section = Tab:CreateSection("Settings")

createOptimisedToggle(Tab,"Auto Leave On Selected Room","LeaveOnRoom",
function()

    while task.wait() do
        if game.Players.LocalPlayer:GetAttribute("Dungeon") and _G.Settings.LeaveOnRoomRoom and _G.Settings.SelectedDungeon ~= nil and _G.Settings.LeaveOnRoomRooms[_G.Settings.SelectedDungeon] ~= nil then
            if _G.DungeonInformation["roomReached"] and _G.DungeonInformation["roomReached"] >= _G.Settings.LeaveOnRoomRooms[_G.Settings.SelectedDungeon] then
                game:GetService("ReplicatedStorage").Packages.Knit.Services.DungeonService.RF.LeaveDungeon:InvokeServer()
            end
        elseif not game.Players.LocalPlayer:GetAttribute("Dungeon") then
            _G.DungeonInformation = {}
        end
        task.wait(1)
    end

end)

for i,v in ipairs(dungeons) do
    local Slider = Tab:CreateSlider({
        Name = v..": Set Leave On Room",
        Range = {0, 100},
        Increment = 1,
        Suffix = "Is The Leave Room",
        CurrentValue = 10,
        Flag = "Slider"..v, -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(Value)
            _G.Settings.LeaveOnRoomRooms[v] = Value
        end
    })
end

local Tab = Window:CreateTab("Auto Raid", 11642692687) -- Title, Image

local Section = Tab:CreateSection("Info")

local infos = {
    ["RaidName"] = "",
    ["RaidMode"] = "",
    ["RaidCountdown"] = "",
    ["RaidRemaining"] = "",
    ["RaidBossName"] = "",
    ["RaidBossHealth"] = "",
    ["RaidBossMaxHealth"] = "",
    ["RaidEnemiesRemaining"] = ""
}

local function RaidINFO(dictionary)
    if _G.RaidInformation ~= {} then
        local array = {}
        for i,v in pairs(_G.RaidInformation) do
            table.insert(array, tostring(i)..": "..tostring(v))
        end
        return array
    else
        return {"No Information"}
    end
end

local Paragraph = Tab:CreateParagraph({Title = "Raid Information:", Content = table.concat(RaidINFO(),"\n")})

task.spawn(function()
    while task.wait() do
        task.wait(.5)
        Paragraph:Set({Title = "Raid Information:", Content = table.concat(RaidINFO(),"\n")})
        if not game.Players.LocalPlayer:GetAttribute("Raid") then
            _G.RaidInformation = {}
        end
    end
end)

local Section = Tab:CreateSection("Main")

createOptimisedToggle(Tab, "Auto Raid","AutoRaid",function()

    while task.wait() do
        if _G.Settings.AutoRaid and #_G.Settings.SelectedRaids > 0 and CanDoPriority("Raid") then
            if JoinRaid(_G.Settings.SelectedRaids) and _G.RaidInformation["raidMode"] and _G.RaidInformation["raidMode"] == "Active" and CanDoPriority("Raid") then

                _G.DoingRaid = true

                repeat

                        if _G.RaidInformation ~= {} and game.Players.LocalPlayer:GetAttribute("Raid") and game:GetService("Workspace").Resources.Gamemodes.Raids[_G.Settings.SelectedRaid]:FindFirstChild("Spawn") and CanDoPriority("Raid") then
                            pcall(function()
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Resources.Gamemodes.Raids[_G.Settings.SelectedRaid]:FindFirstChild("Spawn").CFrame * CFrame.new(0,10,0)
                            end)
                        end

                        if _G.RaidInformation["raidEnemiesRemaining"] and game.Players.LocalPlayer:GetAttribute("Raid") and (_G.RaidInformation["raidEnemiesRemaining"] == 0 or _G.RaidInformation["raidEnemiesRemaining"] == nil) and CanDoPriority("Raid") then
                            local Sucess, Error = pcall(function()
                                if _G.Settings.FarmRenderedMobsOnly then
                                    for i,v in pairs(game:GetService("Workspace").Live.NPCs.Client:GetChildren()) do
                                        local function mob(v)
                                            return game:GetService("Workspace").Live.NPCs.Server[v.Name]
                                        end
                                        local isBoss = mob(v):GetAttribute("Health") == _G.RaidInformation["raidBossHealth"]
                                        if mob(v):GetAttribute("Gamemode") == "Raid" and isBoss and (_G.RaidInformation["raidEnemiesRemaining"] == 0 or _G.RaidInformation["raidBossHealth"] == nil) and CanDoPriority("Raid") then
        
                                            _G.CanTap = false
                                            repeat
                                                _G.CanTap = false
                                                tpToMobCFrame(mob(v).CFrame)
                                                click(mob(v).Name)
                                                task.wait(.01)
                                            until not mob(v) or _G.RaidInformation["raidEnemiesRemaining"] ~= 0 or _G.RaidInformation["raidBossHealth"] == 0 or not mob(v):GetAttribute("Health") or mob(v):GetAttribute("Health") <= 0 or not CanDoPriority("Raid")
                                            _G.CanTap = true
        
                                        end
                                    end
                                else
                                    for i,v in pairs(game:GetService("Workspace").Live.NPCs.Server:GetChildren()) do
                                        local isBoss = v:GetAttribute("Health") == _G.RaidInformation["raidBossHealth"]
                                        if v:GetAttribute("Gamemode") == "Raid" and isBoss and (_G.RaidInformation["raidEnemiesRemaining"] == 0 or _G.RaidInformation["raidBossHealth"] == nil) and CanDoPriority("Raid") then
        
                                            _G.CanTap = false
                                            repeat
                                                _G.CanTap = false
                                                tpToMobCFrame(v.CFrame)
                                                click(v.Name)
                                                task.wait(.01)
                                            until not v or _G.RaidInformation["raidEnemiesRemaining"] ~= 0 or _G.RaidInformation["raidBossHealth"] == 0 or not v:GetAttribute("Health") or v:GetAttribute("Health") <= 0 or not CanDoPriority("Raid")
                                            _G.CanTap = true
        
                                        end
                                    end
                                end
                            end)
                            if Error then
                                error(Error)
                            end
                            _G.CanTap = true
                        end

                        if _G.RaidInformation["raidEnemiesRemaining"] and game.Players.LocalPlayer:GetAttribute("Raid") and (_G.RaidInformation["raidEnemiesRemaining"] > 0) and CanDoPriority("Raid") then
                            local Sucess, Error = pcall(function()
                                if _G.Settings.FarmRenderedMobsOnly then
                                    for i,v in pairs(game:GetService("Workspace").Live.NPCs.Client:GetChildren()) do
                                        local function mob(v)
                                            return game:GetService("Workspace").Live.NPCs.Server[v.Name]
                                        end
                                        local isBoss = mob(v):GetAttribute("Health") == _G.RaidInformation["raidBossHealth"]
                                        if mob(v):GetAttribute("Gamemode") == "Raid" and _G.RaidInformation["raidEnemiesRemaining"] and mob(v):GetAttribute("Health") > 0 and not isBoss and _G.RaidInformation["raidEnemiesRemaining"] > 0 and CanDoPriority("Raid") then
        
                                            _G.CanTap = false
                                            repeat
                                                _G.CanTap = false
                                                tpToMobCFrame(mob(v).CFrame)
                                                click(mob(v).Name)
                                                task.wait(.01)
                                            until not mob(v) or _G.RaidInformation == {} or not _G.RaidInformation["raidEnemiesRemaining"] or _G.RaidInformation["raidEnemiesRemaining"] <= 0 or _G.RaidInformation["raidBossHealth"] == 0 or mob(v):GetAttribute("Health") <= 0 or not CanDoPriority("Raid")
                                            _G.CanTap = true
                                            
                                        end
                                    end 
                                else
                                    for i,v in pairs(game:GetService("Workspace").Live.NPCs.Server:GetChildren()) do
                                        local isBoss = v:GetAttribute("Health") == _G.RaidInformation["raidBossHealth"]
                                        if v:GetAttribute("Gamemode") == "Raid" and _G.RaidInformation["raidEnemiesRemaining"] and v:GetAttribute("Health") > 0 and not isBoss and _G.RaidInformation["raidEnemiesRemaining"] > 0 and CanDoPriority("Raid") then
        
                                            _G.CanTap = false
                                            repeat
                                                _G.CanTap = false
                                                tpToMobCFrame(v.CFrame)
                                                click(v.Name)
                                                task.wait(.01)
                                            until not v or _G.RaidInformation == {} or not _G.RaidInformation["raidEnemiesRemaining"] or _G.RaidInformation["raidEnemiesRemaining"] <= 0 or _G.RaidInformation["raidBossHealth"] == 0 or v:GetAttribute("Health") <= 0 or not CanDoPriority("Raid")
                                            _G.CanTap = true
                                            
                                        end
                                    end 
                                end
                            end)
                            if Error then
                                error(Error)
                            end
                            _G.CanTap = true
                        end

                    task.wait(.1)
                until not _G.RaidInformation["raidMode"] or _G.RaidInformation == {} or _G.RaidInformation["raidMode"] ~= "Active" or not game.Players.LocalPlayer:GetAttribute("Raid") or not CanDoPriority("Raid")

                if not _G.RaidInformation["raidMode"] or _G.RaidInformation["raidMode"] ~= "Active" or not game.Players.LocalPlayer:GetAttribute("Raid") or not CanDoPriority("Raid") then
                    _G.DoingRaid = false
                end

            else
                _G.DoingRaid = false
            end
        end
        task.wait(3)
    end

end,nil,function()

    _G.DoingRaid = false
    _G.CanTap = true
    _G.RaidSetups = false
    _G.CanDoRaid = false

end)

local Label = Tab:CreateLabel("Doing Raids: "..table.concat(SSAWNII(_G.Settings.SelectedRaids),", "))

local Button = Tab:CreateButton({
    Name = "Reset List",
    Interact = 'Reset',
    Callback = function()
        _G.Settings.SelectedRaids = {}
        Label:Set("Doing Raids: "..table.concat(SSAWNII(_G.Settings.SelectedRaids),", "))
        if isfile and writefile then
            writefile("Banana Hub"..configFolder.."/SwordFightersSelectedRaidsSave1"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.SelectedRaids))
        end
    end
})

local raids = CTables.GetChildrenUniqueNames(game:GetService("Workspace").Resources.Gamemodes.Raids)

Tab:CreateDropdown({
    Name = "Select Raid To Do",
    Options = raids,
    CurrentOption = "None",
    Flag = "Dropdown6", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Option)
        if _G.NowLoaded and table.find(raids, Option) then

            if table.find(_G.Settings.SelectedRaids, Option) then
                table.remove(_G.Settings.SelectedRaids, table.find(_G.Settings.SelectedRaids, Option))
            else
                table.insert(_G.Settings.SelectedRaids, Option)
            end

            if isfile and writefile then
                writefile("Banana Hub"..configFolder.."/SwordFightersSelectedRaidsSave1"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.SelectedRaids))
            end

            Label:Set("Doing Raids: "..table.concat(SSAWNII(_G.Settings.SelectedRaids),", "))

        end
    end,
})

task.spawn(function()
    repeat task.wait(.1) until _G.NowLoaded
    if isfile and readfile and isfile("Banana Hub"..configFolder.."/SwordFightersSelectedRaidsSave1"..game.Players.LocalPlayer.Name..".json") then
        _G.Settings.SelectedRaids = game:GetService("HttpService"):JSONDecode(readfile("Banana Hub"..configFolder.."/SwordFightersSelectedRaidsSave1"..game.Players.LocalPlayer.Name..".json"))
    end
    Label:Set("Doing Raids: "..table.concat(SSAWNII(_G.Settings.SelectedRaids),", "))
end)

local Tab = Window:CreateTab("Auto Tower Farm", 11642692687) -- Title, Images

local Section = Tab:CreateSection("Main")

_G.TowerToggle = createOptimisedToggle(Tab, "Auto Tower Farm","AutoTower",function()

    local towerPOS = nil

    while task.wait() do

        if CanDoPriority("Tower") then

            if not game.Players.LocalPlayer:GetAttribute("Tower") then
                towerPOS = game:GetService("ReplicatedStorage").Packages.Knit.Services.TowerService.RF.StartTower:InvokeServer("Tower 1")
            else
                game:GetService("ReplicatedStorage").Packages.Knit.Services.TowerService.RF.ContinueTower:InvokeServer(game.Players.LocalPlayer:GetAttribute("Tower"))
            end
    
            if game.Players.LocalPlayer:GetAttribute("Tower") and CanDoPriority("Tower") then
                _G.DoingTower = true

                if towerPOS then
                    pcall(function()
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(towerPOS) * CFrame.new(0,5,0)
                    end)
                end

                if _G.Settings.FarmRenderedMobsOnly then
                    for i,v in pairs(game:GetService("Workspace").Live.NPCs.Client:GetChildren()) do
                        local function mob(v)
                            return game:GetService("Workspace").Live.NPCs.Server[v.Name]
                        end
                        if mob(v) and mob(v):GetAttribute("Health") > 0 and mob(v):GetAttribute("Gamemode") == "Tower" then
                            _G.CanTap = false
                            repeat
                                if _G.Settings.AutoTower and mob(v) and _G.DoingTower and CanDoPriority("Tower") and game.Players.LocalPlayer:GetAttribute("Tower") and mob(v):GetAttribute("Gamemode") == "Tower" then
                                    _G.CanTap = false
                                    tpToMobCFrame(mob(v).CFrame)
                                    click(mob(v).Name)
                                    task.wait(.01)
                                else
                                    break
                                end
                            until not mob(v) or mob(v) or not mob(v):GetAttribute("Health") or not mob(v):GetAttribute("Health") or mob(v):GetAttribute("Health") <= 0
                            _G.CanTap = true
                        end
                    end
                else
                    for i,v in pairs(game:GetService("Workspace").Live.NPCs.Server:GetChildren()) do
                        if v and game:GetService("Workspace").Live.NPCs.Server:FindFirstChild(v.Name) and game:GetService("Workspace").Live.NPCs.Server[v.Name]:GetAttribute("Health") > 0 and game:GetService("Workspace").Live.NPCs.Server[v.Name]:GetAttribute("Gamemode") == "Tower" then
                            _G.CanTap = false
                            repeat
                                if _G.Settings.AutoTower and game:GetService("Workspace").Live.NPCs.Server:FindFirstChild(v.Name) and _G.DoingTower and CanDoPriority("Tower") and game.Players.LocalPlayer:GetAttribute("Tower") and game:GetService("Workspace").Live.NPCs.Server[v.Name]:GetAttribute("Gamemode") == "Tower" then
                                    _G.CanTap = false
                                    tpToMobCFrame(v.CFrame)
                                    click(v.Name)
                                    task.wait(.01)
                                else
                                    break
                                end
                            until not v or not v or not v or not game:GetService("Workspace").Live.NPCs.Server:FindFirstChild(v.Name) or not game:GetService("Workspace").Live.NPCs.Server[v.Name]:GetAttribute("Health") or not game:GetService("Workspace").Live.NPCs.Server[v.Name]:GetAttribute("Health") or game:GetService("Workspace").Live.NPCs.Server[v.Name]:GetAttribute("Health") <= 0
                            _G.CanTap = true
                        end
                    end
                end
                
            else
                _G.DoingTower = false
            end

        end

        task.wait(.1)

    end

end,false,function()

    _G.DoingTower = false
    _G.CanTap = true

end)

local Section = Tab:CreateSection("Aura To Claim")

local auras = {}
for i,v in pairs(DatabaseController:GetDatabase("Auras")) do
    table.insert(auras, i)
end

Tab:CreateDropdown({
    Name = "Select Relic To You Are Aiming For",
    Options = auras,
    CurrentOption = "None",
    Flag = "DropdownRelicAimingFor", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Option)
        if table.find(auras, Option) then
            _G.Settings.AuroToClaim = Option
        end
    end
})

local Section = Tab:CreateSection("Auto Leave")

createOptimisedToggle(Tab, "Auto Leave On Room","AutoTowerLeaveEnabledOnRoom",function()

    while task.wait() do

        if game.Players.LocalPlayer:GetAttribute("Tower") and _G.TowerInformation and _G.TowerInformation.floorReached then
            if tonumber(_G.TowerInformation.floorReached) >= _G.Settings.AutoTowerLeaveRoom then
                game:GetService("ReplicatedStorage").Packages.Knit.Services.TowerService.RF.LeaveTower:InvokeServer()
            end
        end

        task.wait(.5)
        
    end

end)

local Slider = Tab:CreateSlider({
    Name = "Tower Leave Room:",
    Range = {0, 100},
    Increment = 1,
    Suffix = "Bananas",
    CurrentValue = 100,
    Flag = "SliderTowerLeaveRoom", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        _G.Settings.AutoTowerLeaveRoom = Value
    end
})


game:GetService("ReplicatedStorage").Packages.Knit.Services.AuraService.RE.DisplayAura.OnClientEvent:Connect(function(INFO)
    if _G.Settings.AutoTower and _G.Settings.AuroToClaim == INFO.newAura then
        game:GetService("ReplicatedStorage").Packages.Knit.Services.AuraService.RF.ClaimAura:InvokeServer()
        _G.TowerToggle:Set(false)
        if _G.Settings.RaidAdvWebhook and _G.Settings.AdvancedWebhook then
            local info = {
                "Got Desired Aura: **"..INFO.newAura.."**",
            }
            _G.WebHookCSM("Sword Fighters Simulator","Got Aura (Tower)",table.concat(info,"\n"),_G.Settings.TowerAdvWebhookLink)
        end
    end
end)

local Tab = Window:CreateTab("Webhook", 11642692687) -- Title, Image

if isfile and readfile and isfile("Banana Hub"..configFolder.."/SwordFightersWebhookSave"..game.Players.LocalPlayer.Name..".json") then
    _G.Settings.WebhookLink = game:GetService("HttpService"):JSONDecode(readfile("Banana Hub"..configFolder.."/SwordFightersWebhookSave"..game.Players.LocalPlayer.Name..".json"))
end

local Section = Tab:CreateSection("Main")

local Paragraph = Tab:CreateParagraph({Title = "Webhook Link", Content = tostring(_G.Settings.WebhookLink)})

local Input = Tab:CreateInput({
    Name = "Webhook Link",
    PlaceholderText = "Enter",
    NumbersOnly = false, -- If the user can only type numbers.
    OnEnter = true, -- Will callback only if the user pressed ENTER while being focused.
    RemoveTextAfterFocusLost = true,
    Callback = function(Text)
        _G.Settings.WebhookLink = Text
        if isfile and writefile then
            writefile("Banana Hub"..configFolder.."/SwordFightersWebhookSave"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.WebhookLink))
        end
        Paragraph:Set({Title = "Webhook Link", Content = tostring(_G.Settings.WebhookLink)})
    end
})

local Label = Tab:CreateLabel("Sending Webhook in: "..(_G.Settings.WebhookCooldown*60).." Seconds")

createOptimisedToggle(Tab, "Auto Webhook", "AutoWebhook",
function()

    local canSendWebhook = true

    while task.wait() do

        if canSendWebhook then
            pcall(function()
                _G.Webhook(_G.Settings.WebhookLink)
            end)
            local sent = 0
            repeat
                task.wait(1)
                sent += 1
                Label:Set("Sending Webhook in: "..(_G.Settings.WebhookCooldown*60) - (sent).." Seconds")
            until sent == (_G.Settings.WebhookCooldown*60)
            canSendWebhook = true
        end

    end

end,nil,function()

    canSendWebhook = true

end)


local Slider = Tab:CreateSlider({
    Name = "Send Webhook every",
    Range = {1, 1000},
    Increment = 1,
    Suffix = "Minutes",
    CurrentValue = 10,
    Flag = "SliderWebhookEvery", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        _G.Settings.WebhookCooldown = Value
    end,
})

local Section = Tab:CreateSection("Advanced")

--DungeonAdvWebhookLink
--DungeonAdvWebhook
--PetAdvWebhook
--PetAdvWebhookLink
--RaidAdvWebhookLink
--RaidAdvWebhook
--TowerAdvWebhookLink
--TowerAdvWebhook
--SwordAdvWebhook
--SwordAdvWebhookLink


createOptimisedToggle(Tab, "Extra Features Enabled Below","AdvancedWebhook",function()

    local Pets = {}
    for i,v in pairs(require(game:GetService("ReplicatedStorage").Packages.Knit).GetController("DataController"):GetData("PlayerData").PetInv) do
        table.insert(Pets, i)
    end

    local Weapons = {}
    for i,v in pairs(require(game:GetService("ReplicatedStorage").Packages.Knit).GetController("DataController"):GetData("PlayerData").WeaponInv) do
        table.insert(Weapons, i)
    end

    while task.wait() do

        if _G.ADVDUNGCONNECTION then
            _G.ADVDUNGCONNECTION:Disconnect()
        end
        _G.ADVDUNGCONNECTION = game:GetService("ReplicatedStorage").Packages.Knit.Services.DungeonService.RE.DungeonResult.OnClientEvent:Connect(function(dungeonResult)
            _G.LASTDUNGEONRESULTWB = dungeonResult
            if _G.Settings.DungeonAdvWebhook then

                local function transform(i,v)
                    if i == "Coins" then
                        v = require(require(game:GetService("ReplicatedStorage").Packages.Knit).Util.Utility).CurrencyEnding(tonumber(v))
                    end
                    if i:lower():match("shard") then
                        i = tostring(DatabaseController:GetDatabase("Shards")[i].name)
                    end
                    return (tostring(i)..": "..tostring(v))
                end
            

                local info = {}


                for i,v in pairs(dungeonResult.players) do
                    local ab =  "**- __Player: ||"..i.."||__**"
                    if i == game.Players.LocalPlayer.Name then
                        ab =  "**- __Player: ||"..i.."||__ !!!!!**"
                    end
                    table.insert(info, ab)
                    local abcd = 1
                    for i,v in pairs(v) do
                        local extraINFO = tostring(v)
                        if type(v) == "table" then
                            local infos = {}
                            for i,v in pairs(v) do
                                table.insert(infos, transform(i,v) )
                            end
                            extraINFO = table.concat(infos, ", \n")
                        end
                        local needthatline = "\n"
                        if extraINFO == "" then
                            needthatline = ""
                        end
                        table.insert(info, "**__"..tostring(abcd)..".__  "..tostring(i).."**: "..needthatline..extraINFO)
                        abcd += 1
                    end
                end
    
                _G.WebHookCSM("Sword Fighters Simulator","Dungeon Completed",table.concat(info,"\n"),_G.Settings.DungeonAdvWebhookLink)
            end
        end)

        if _G.ADVRAIDCONNECTION then
            _G.ADVRAIDCONNECTION:Disconnect()
        end
        _G.ADVRAIDCONNECTION = game:GetService("ReplicatedStorage").Packages.Knit.Services.RaidService.RE.RaidResult.OnClientEvent:Connect(function(raidResult)
            _G.LASTRAIDRESULTWB = raidResult
            if _G.Settings.RaidAdvWebhook then

                local function transform(abc)
                    if abc:lower():match("shard") then
                        return tostring(DatabaseController:GetDatabase("Shards")[abc].name)
                    end
                    return abc
                end
            
                local info = {}
                table.insert(info, "**Rewards:**")
                for i,v in pairs(raidResult.rewards) do
                    table.insert(info, transform(v.statType)..": "..v.amount)
                end

                _G.WebHookCSM("Sword Fighters Simulator","Raid Completed",table.concat(info,"\n"),_G.Settings.RaidAdvWebhookLink)
            end
        end)

        if _G.Settings.PetAdvWebhook then
            for i,v in pairs(require(game:GetService("ReplicatedStorage").Packages.Knit).GetController("DataController"):GetData("PlayerData").PetInv) do
                if not table.find(Pets, i) and _G.Settings["NotifyPetRarity:"..petINFO[v.name].rarity] then
                    --warn("New Pet Name: "..v.name.."\nPet Rarity: "..petINFO[v.name].rarity)
                    coroutine.resume(coroutine.create(function()
                        local info = {
                            "Pet Name: "..tostring(v.name),
                            "Pet Rarity: "..tostring(petINFO[v.name].rarity),
                            "Pet Tier: "..tostring(v.tier)
                        }
                        _G.WebHookCSM("Sword Fighters Simulator","New Pet !",table.concat(info,"\n"),_G.Settings.PetAdvWebhookLink)  
                    end))
                end
            end
        end

        if _G.Settings.SwordAdvWebhook then
            for i,v in pairs(require(game:GetService("ReplicatedStorage").Packages.Knit).GetController("DataController"):GetData("PlayerData").WeaponInv) do
                if not table.find(Weapons, i) and _G.Settings["NotifySwordRarity:"..weaponINFO[v.name].rarity] then
                    --warn("New Sword Name: "..v.name.."\nSword Rarity: "..weaponINFO[v.name].rarity)
                    coroutine.resume(coroutine.create(function()
                        local info = {
                            "Sword Name: "..tostring(v.name),
                            "Sword Rarity: "..tostring(weaponINFO[v.name].rarity),
                            "Sword Tier: "..tostring(v.tier)
                        }
                        _G.WebHookCSM("Sword Fighters Simulator","New Sword!",table.concat(info,"\n"),_G.Settings.SwordAdvWebhookLink)  
                    end))
                end
            end
        end

        Weapons = {}
        for i,v in pairs(require(game:GetService("ReplicatedStorage").Packages.Knit).GetController("DataController"):GetData("PlayerData").WeaponInv) do
            table.insert(Weapons, i)
        end

        Pets = {}
        for i,v in pairs(require(game:GetService("ReplicatedStorage").Packages.Knit).GetController("DataController"):GetData("PlayerData").PetInv) do
            table.insert(Pets, i)
        end

        task.wait(.1)


    end

end)

--dung webhook
local Section = Tab:CreateSection("Dungeon Stuff")

createOptimisedToggle(Tab, "Dungeon Web Enabled","DungeonAdvWebhook",nil,true)

if isfile and readfile and isfile("Banana Hub"..configFolder.."/SwordFightersDunWebhookLink"..game.Players.LocalPlayer.Name..".json") then
    _G.Settings.DungeonAdvWebhookLink = game:GetService("HttpService"):JSONDecode(readfile("Banana Hub"..configFolder.."/SwordFightersDunWebhookLink"..game.Players.LocalPlayer.Name..".json"))
end


local Label = Tab:CreateLabel("Webhook Link (Dungeon): ".._G.Settings.DungeonAdvWebhookLink)

local Input = Tab:CreateInput({
    Name = "Webhook Link",
    PlaceholderText = "Enter",
    NumbersOnly = false, -- If the user can only type numbers.
    OnEnter = true, -- Will callback only if the user pressed ENTER while being focused.
    RemoveTextAfterFocusLost = true,
    Callback = function(Text)
        _G.Settings.DungeonAdvWebhookLink = Text
        if isfile and writefile then
            writefile("Banana Hub"..configFolder.."/SwordFightersDunWebhookLink"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.DungeonAdvWebhookLink))
        end
        Label:Set("Webhook Link (Dungeon): ".._G.Settings.DungeonAdvWebhookLink)
    end
})

--raid webhook
local Section = Tab:CreateSection("Raid Stuff")

createOptimisedToggle(Tab, "Raid Web Enabled","RaidAdvWebhook",nil,true)

if isfile and readfile and isfile("Banana Hub"..configFolder.."/SwordFightersRaidWebhookLink"..game.Players.LocalPlayer.Name..".json") then
    _G.Settings.RaidAdvWebhookLink = game:GetService("HttpService"):JSONDecode(readfile("Banana Hub"..configFolder.."/SwordFightersRaidWebhookLink"..game.Players.LocalPlayer.Name..".json"))
end


local Label = Tab:CreateLabel("Webhook Link (Raid): ".._G.Settings.RaidAdvWebhookLink)

local Input = Tab:CreateInput({
    Name = "Webhook Link",
    PlaceholderText = "Enter",
    NumbersOnly = false, -- If the user can only type numbers.
    OnEnter = true, -- Will callback only if the user pressed ENTER while being focused.
    RemoveTextAfterFocusLost = true,
    Callback = function(Text)
        _G.Settings.RaidAdvWebhookLink = Text
        if isfile and writefile then
            writefile("Banana Hub"..configFolder.."/SwordFightersRaidWebhookLink"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.RaidAdvWebhookLink))
        end
        Label:Set("Webhook Link (Raid): ".._G.Settings.RaidAdvWebhookLink)
    end
})

--tower webhook
local Section = Tab:CreateSection("Tower Stuff")

createOptimisedToggle(Tab, "Tower Web Enabled (When got selected Aura)","TowerAdvWebhook",nil,true)

if isfile and readfile and isfile("Banana Hub"..configFolder.."/SwordFightersTowerWebhookLink"..game.Players.LocalPlayer.Name..".json") then
    _G.Settings.TowerAdvWebhookLink = game:GetService("HttpService"):JSONDecode(readfile("Banana Hub"..configFolder.."/SwordFightersTowerWebhookLink"..game.Players.LocalPlayer.Name..".json"))
end


local Label = Tab:CreateLabel("Webhook Link (Tower): ".._G.Settings.TowerAdvWebhookLink)

local Input = Tab:CreateInput({
    Name = "Webhook Link",
    PlaceholderText = "Enter",
    NumbersOnly = false, -- If the user can only type numbers.
    OnEnter = true, -- Will callback only if the user pressed ENTER while being focused.
    RemoveTextAfterFocusLost = true,
    Callback = function(Text)
        _G.Settings.TowerAdvWebhookLink = Text
        if isfile and writefile then
            writefile("Banana Hub"..configFolder.."/SwordFightersTowerWebhookLink"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.TowerAdvWebhookLink))
        end
        Label:Set("Webhook Link (Tower): ".._G.Settings.TowerAdvWebhookLink)
    end
})

--pet webhook
local Section = Tab:CreateSection("Pet Stuff")

createOptimisedToggle(Tab, "Pet Web Enabled","PetAdvWebhook",nil,true)

if isfile and readfile and isfile("Banana Hub"..configFolder.."/SwordFightersPetWebhookLink"..game.Players.LocalPlayer.Name..".json") then
    _G.Settings.PetAdvWebhookLink = game:GetService("HttpService"):JSONDecode(readfile("Banana Hub"..configFolder.."/SwordFightersPetWebhookLink"..game.Players.LocalPlayer.Name..".json"))
end


local Label = Tab:CreateLabel("Webhook Link (Pet): ".._G.Settings.PetAdvWebhookLink)

local Input = Tab:CreateInput({
    Name = "Webhook Link",
    PlaceholderText = "Enter",
    NumbersOnly = false, -- If the user can only type numbers.
    OnEnter = true, -- Will callback only if the user pressed ENTER while being focused.
    RemoveTextAfterFocusLost = true,
    Callback = function(Text)
        _G.Settings.PetAdvWebhookLink = Text
        if isfile and writefile then
            writefile("Banana Hub"..configFolder.."/SwordFightersPetWebhookLink"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.PetAdvWebhookLink))
        end
        Label:Set("Webhook Link (Pet): ".._G.Settings.PetAdvWebhookLink)
    end
})

for i,v in ipairs(customPetRarities) do
    createOptimisedToggle(Tab, "Notify About New "..v.." Pets","NotifyPetRarity:"..v,nil,true)
end

--sword webhook
local Section = Tab:CreateSection("Sword Stuff")

createOptimisedToggle(Tab, "Sword Web Enabled","SwordAdvWebhook",nil,true)

if isfile and readfile and isfile("Banana Hub"..configFolder.."/SwordFightersSwordWebhookLink"..game.Players.LocalPlayer.Name..".json") then
    _G.Settings.SwordAdvWebhook = game:GetService("HttpService"):JSONDecode(readfile("Banana Hub"..configFolder.."/SwordFightersSwordWebhookLink"..game.Players.LocalPlayer.Name..".json"))
end


local Label = Tab:CreateLabel("Webhook Link (Sword): ".._G.Settings.SwordAdvWebhookLink)

local Input = Tab:CreateInput({
    Name = "Webhook Link",
    PlaceholderText = "Enter",
    NumbersOnly = false, -- If the user can only type numbers.
    OnEnter = true, -- Will callback only if the user pressed ENTER while being focused.
    RemoveTextAfterFocusLost = true,
    Callback = function(Text)
        _G.Settings.SwordAdvWebhookLink = Text
        if isfile and writefile then
            writefile("Banana Hub"..configFolder.."/SwordFightersSwordWebhookLink"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.SwordAdvWebhookLink))
        end
        Label:Set("Webhook Link (Sword): ".._G.Settings.SwordAdvWebhookLink)
    end
})

for i,v in ipairs(customSwordRarities) do
    createOptimisedToggle(Tab, "Notify About New "..v.." Swords","NotifySwordRarity:"..v,nil,true)
end


local Tab = Window:CreateTab("Auto Stuff", 11642692687) -- Title, Image

local Section = Tab:CreateSection("Main")

createOptimisedToggle(Tab,"Enable Features Below Which Are Enabled","MainEnabled",
function()

    local canSellRelics = true
    local canClaimTickets = true
    local canEquipRelic = true
    local lastEventLoadoutEquip = "None"

    local lastShiniedAndCelestialed = os.time()

    while task.wait() do
        local upgrades = {"Power Gain","More Storage","WalkSpeed"}

        for i,v in ipairs(upgrades) do
            LPH_NO_VIRTUALIZE(function()
                if _G.Settings["AutoUpgrade"..v] and table.find(worlds, _G.Settings.AutoUpgradeWorld) then
                    game:GetService("ReplicatedStorage").Packages.Knit.Services.UpgradeService.RF.Upgrade:InvokeServer(_G.Settings.AutoUpgradeWorld,v)
                end
            end)()
        end

        if _G.Settings.AutoHatchEgg and table.find(eggs, _G.Settings.SelectedEgg) and false then
            LPH_NO_VIRTUALIZE(function()
                game:GetService("ReplicatedStorage").Packages.Knit.Services.EggService.RF.BuyEgg:InvokeServer({["eggName"] = getEggID(_G.Settings.SelectedEgg),["baseAmount"] = 1,["auto"] = false,["amount"] = _G.Settings.EggAmount})
            end)()
        end

        if _G.Settings.AutoCoin and false then
            LPH_NO_VIRTUALIZE(function()
                for i,v in pairs(game:GetService("Workspace").Live.Pickups:GetChildren()) do
                    pcall(function()
                        v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                    end)
                end
            end)()
        end

        if _G.Settings.AutoAscend then
            LPH_NO_VIRTUALIZE(function()
                game:GetService("ReplicatedStorage").Packages.Knit.Services.AscendService.RF.Ascend:InvokeServer()
            end)()
        end

        if _G.Settings.AutoPetDismantle and (#_G.Settings.SelectedPets > 0 or #_G.Settings.PetTiersSelling > 0) then

            local PetInv = require(game:GetService("ReplicatedStorage").Packages.Knit).GetController("DataController"):GetData("PlayerData").PetInv

            local petsSelected = _G.Settings.SelectedPets
            local petTraitsSelected = _G.Settings.PetTiersSelling

            local function canSellThisTrait(traitName, traitTier)

                for i,v in pairs(petTraitsSelected) do
                    local traitNameTwo = v:split("|")[1]
                    local traitTierTwo = v:split("|")[2]

                    if (traitName == traitNameTwo) and (traitTierTwo == "Any" or traitTier == traitTierTwo) then
                        return true
                    end

                end

            end

            if _G.Settings.WhatToDoWithSelectedPets == "Dismantle" then
                local dismantingPets = {}
                for petID ,v in pairs(PetInv) do
                    if table.find(petsSelected, v.name) and not v.locked then
                        table.insert(dismantingPets, petID)
                    end
                end
                game:GetService("ReplicatedStorage").Packages.Knit.Services.PetLevelingService.RF.Dismantle:InvokeServer(dismantingPets)
            elseif _G.Settings.WhatToDoWithSelectedPets == "Keep" then
                local dismantingPets = {}
                for petID ,v in pairs(PetInv) do
                    if not table.find(petsSelected, v.name) and not v.locked then
                        table.insert(dismantingPets, petID)
                    end
                end
                game:GetService("ReplicatedStorage").Packages.Knit.Services.PetLevelingService.RF.Dismantle:InvokeServer(dismantingPets)
            end

            if _G.Settings.WhatToDoWithSelectedPetTraits == "Dismantle" then
                local dismantingPets = {}
                for petID ,v in pairs(PetInv) do
                    if v.enchants then
                        for i,v in pairs(v.enchants) do
                            if canSellThisTrait(v.name, v.tier) then
                                table.insert(dismantingPets, petID)
                            end
                        end
                    end
                end
                game:GetService("ReplicatedStorage").Packages.Knit.Services.PetLevelingService.RF.Dismantle:InvokeServer(dismantingPets)
            elseif _G.Settings.WhatToDoWithSelectedPetTraits == "Keep" then
                local dismantingPets = {}
                for petID ,v in pairs(PetInv) do
                    if v.enchants then
                        for i,v in pairs(v.enchants) do
                            if not canSellThisTrait(v.name, v.tier) then
                                table.insert(dismantingPets, petID)
                            end
                        end
                    end
                end
                game:GetService("ReplicatedStorage").Packages.Knit.Services.PetLevelingService.RF.Dismantle:InvokeServer(dismantingPets)
            end
        end

        if _G.Settings.AutoSwordsManage and #_G.Settings.SwordsSelected > 0 then

            local function dictionaryEmpty(dictionary)
                for i,v in pairs(dictionary) do
                    return false
                end
                return true
            end


            local SwordInv = require(game:GetService("ReplicatedStorage").Packages.Knit).GetController("DataController"):GetData("PlayerData").WeaponInv

            local swordsEnchantsSelectedToDo = _G.Settings.SwordsSelected

            local function canSellThisEnchant(enchantName, enchantTier)

                for i,v in pairs(swordsEnchantsSelectedToDo) do
                    local enchantNameTwo = v:split("|")[1]
                    local enchantTierTwo = v:split("|")[2]

                    if (enchantName == enchantNameTwo) and (enchantTierTwo == "Any" or enchantTier == enchantTierTwo) then
                        return true
                    end

                end

            end


            if _G.Settings.SellSelectedSwordsOrKeep == "Sell" then
                for swordID ,v in pairs(SwordInv) do
                    local swordRarity = DatabaseController:GetDatabase("Weapons")[v.name].rarity
                    for i,v in pairs(v.enchants) do
                        if canSellThisEnchant(v.name, v.tier) and _G.Settings["SwordEnchantSell"..swordRarity] then
                            game:GetService("ReplicatedStorage").Packages.Knit.Services.WeaponInvService.RF.MultiSell:InvokeServer({[swordID] = true})
                        end
                    end
                end
            elseif _G.Settings.SellSelectedSwordsOrKeep == "Keep" then
                for swordID ,v in pairs(SwordInv) do
                    local swordRarity = DatabaseController:GetDatabase("Weapons")[v.name].rarity
                    if dictionaryEmpty(v.enchants) and _G.Settings["SwordEnchantSell"..swordRarity] then
                        game:GetService("ReplicatedStorage").Packages.Knit.Services.WeaponInvService.RF.MultiSell:InvokeServer({[swordID] = true})
                    else
                        for i,v in pairs(v.enchants) do
                            if not canSellThisEnchant(v.name, v.tier) and _G.Settings["SwordEnchantSell"..swordRarity] then
                                game:GetService("ReplicatedStorage").Packages.Knit.Services.WeaponInvService.RF.MultiSell:InvokeServer({[swordID] = true})
                            end
                        end
                    end
                end
            end

        end


        if _G.Settings.AutoManageRelics and #_G.Settings.RelicsSelected > 0 then

            local RelicInv = require(game:GetService("ReplicatedStorage").Packages.Knit).GetController("DataController"):GetData("PlayerData").RelicInv

            local selectedRelics = {}
            for i,v in pairs(_G.Settings.RelicsSelected) do
                table.insert(selectedRelics, v:lower())
            end

            if _G.Settings.SellSelectedRelicsOrKeep == "Sell" then
                for relicID,v in pairs(RelicInv) do
                    if table.find(selectedRelics, v.name:lower()) and not v.locked then
                        game:GetService("ReplicatedStorage").Packages.Knit.Services.RelicInvService.RF.DeleteRelic:InvokeServer(relicID)
                    end
                end
            elseif _G.Settings.SellSelectedRelicsOrKeep == "Keep" then
                for relicID,v in pairs(RelicInv) do
                    if not table.find(selectedRelics, v.name:lower()) and not v.locked then
                        game:GetService("ReplicatedStorage").Packages.Knit.Services.RelicInvService.RF.DeleteRelic:InvokeServer(relicID)
                    end
                end
            end

        end

        if _G.Settings.AutoFreeTickets and canClaimTickets then
            LPH_NO_VIRTUALIZE(function()
                local tickets = 3
                for i = 1, tickets do
                    game:GetService("ReplicatedStorage").Packages.Knit.Services.ChestService.RF.ClaimChest:InvokeServer("Free Ticket "..i)
                    task.wait(.25)
                end
            end)()
        end

        if _G.Settings.AutoClaimChests then
            LPH_NO_VIRTUALIZE(function()
                local chests = 3
                for i = 1, chests do
                    game:GetService("ReplicatedStorage").Packages.Knit.Services.ChestService.RF.ClaimChest:InvokeServer("Chest "..i)
                    task.wait(.25)
                end
            end)()
        end

        if _G.Settings.AutoEquipLoadouts then

            local loadoutToEquip = nil
            if _G.DoingDungeon and tostring(_G.Settings.SelectedDungeon):match("Dungeon ") and game.Players.LocalPlayer:GetAttribute("Dungeon") then
                loadoutToEquip = _G.Settings.EquippingLoadouts[_G.Settings.SelectedDungeon]
            elseif _G.DoingRaid then
                loadoutToEquip = _G.Settings.EquippingLoadouts["Raid"]
            elseif _G.DoingTower then
                loadoutToEquip = _G.Settings.EquippingLoadouts["Tower"]
            elseif goToAfkPosition(true) == "Day" then
                loadoutToEquip = _G.Settings.EquippingLoadouts["Day Farming"]
            elseif goToAfkPosition(true) == "Night" then
                loadoutToEquip = _G.Settings.EquippingLoadouts["Night Farming"]
            elseif goToAfkPosition(true) == "Blood" then
                loadoutToEquip = _G.Settings.EquippingLoadouts["Blood Farming"]
            end

            if not _G.Settings.AutoEquipLoadoutCheckNewEvent then
                lastEventLoadoutEquip = "None"
            end

            if loadoutToEquip ~= lastEventLoadoutEquip then

                local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
                local PlayerData = Knit.GetController("DataController"):GetData("PlayerData")
                local Loadouts = PlayerData.Loadouts
                for i,v in pairs(Loadouts) do
                    if v.Name == loadoutToEquip then
                        game:GetService("ReplicatedStorage").Packages.Knit.Services.LoadoutService.RE.EquipLoadout:FireServer(i)
                        lastEventLoadoutEquip = loadoutToEquip
                        break
                    end
                end

            end

        end

        if _G.Settings.AutoEquipRelics then

            local function getEquippedRelics()
                local equippedRelics = {}
                local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
                local PlayerData = Knit.GetController("DataController"):GetData("PlayerData")
                for i,v in pairs(PlayerData.RelicInv) do
                    if v.equipped then
                        table.insert(equippedRelics, i)
                    end
                end
                return equippedRelics
            end

            local relicToEquip = nil
            local relicToEquipNumberTwo = nil
            if _G.DoingDungeon and tostring(_G.Settings.SelectedDungeon):match("Dungeon ") and game.Players.LocalPlayer:GetAttribute("Dungeon") then
                relicToEquip = _G.Settings.EquippingRelics[_G.Settings.SelectedDungeon]
                relicToEquipNumberTwo = _G.Settings.EquippingRelicsNumberTwo[_G.Settings.SelectedDungeon]
            elseif _G.DoingRaid then
                relicToEquip = _G.Settings.EquippingRelics["Raid"]
                relicToEquipNumberTwo = _G.Settings.EquippingRelicsNumberTwo["Raid"]
            elseif _G.DoingTower then
                relicToEquip = _G.Settings.EquippingRelics["Tower"]
                relicToEquipNumberTwo = _G.Settings.EquippingRelicsNumberTwo["Tower"]
            elseif goToAfkPosition(true) == "Day" then
                relicToEquip = _G.Settings.EquippingRelics["Day Farming"]
                relicToEquipNumberTwo = _G.Settings.EquippingRelicsNumberTwo["Day Farming"]
            elseif goToAfkPosition(true) == "Night" then
                relicToEquip = _G.Settings.EquippingRelics["Night Farming"]
                relicToEquipNumberTwo = _G.Settings.EquippingRelicsNumberTwo["Night Farming"]
            elseif goToAfkPosition(true) == "Blood" then
                relicToEquip = _G.Settings.EquippingRelics["Blood Farming"]
                relicToEquipNumberTwo = _G.Settings.EquippingRelicsNumberTwo["Blood Farming"]
            end
            local nos = {" ","","None","none","abc","abcd"}
            if relicToEquip and relicToEquipNumberTwo and not table.find(nos, relicToEquip) then
                if _G.Settings.HaveDoubleRelic then
                    if not table.find(getEquippedRelics(), relicToEquip) or not table.find(getEquippedRelics(), relicToEquipNumberTwo) then
                        for i,v in pairs(getEquippedRelics()) do
                            game:GetService("ReplicatedStorage").Packages.Knit.Services.RelicInvService.RF.EquipRelic:InvokeServer(v)
                        end

                        game:GetService("ReplicatedStorage").Packages.Knit.Services.RelicInvService.RF.EquipRelic:InvokeServer(relicToEquip)

                        game:GetService("ReplicatedStorage").Packages.Knit.Services.RelicInvService.RF.EquipRelic:InvokeServer(relicToEquipNumberTwo)

                    end
                else
                    if not table.find(getEquippedRelics(), relicToEquip) then
                        for i,v in pairs(getEquippedRelics()) do
                            game:GetService("ReplicatedStorage").Packages.Knit.Services.RelicInvService.RF.EquipRelic:InvokeServer(v)
                        end
                        game:GetService("ReplicatedStorage").Packages.Knit.Services.RelicInvService.RF.EquipRelic:InvokeServer(relicToEquip)
                    end
                end

            end
            
        end

        if _G.Settings.AutoEquipWeapons then

            local function getEquippedWeapons()
                local data = {}
                local weapons = require(game:GetService("ReplicatedStorage").Packages.Knit).GetController("DataController"):GetData("PlayerData").EquippedWeapon
                if weapons then
                    for i,v in pairs(weapons) do
                        table.insert(data, v)
                    end
                end
                return data
            end

            local rightWeaponToEquip = nil
            local leftWeaponToEquip = nil
            if _G.DoingDungeon then
                rightWeaponToEquip = _G.Settings.EquippingWeapons["Dungeon"]["One"]
                leftWeaponToEquip = _G.Settings.EquippingWeapons["Dungeon"]["Two"]
            elseif _G.DoingRaid then
                rightWeaponToEquip = _G.Settings.EquippingWeapons["Raid"]["One"]
                leftWeaponToEquip = _G.Settings.EquippingWeapons["Raid"]["Two"]
            elseif _G.DoingTower then
                rightWeaponToEquip = _G.Settings.EquippingWeapons["Tower"]["One"]
                leftWeaponToEquip = _G.Settings.EquippingWeapons["Tower"]["Two"]
            elseif goToAfkPosition(true) == "Day" then
                rightWeaponToEquip = _G.Settings.EquippingWeapons["Day Farming"]["One"]
                leftWeaponToEquip = _G.Settings.EquippingWeapons["Day Farming"]["Two"]
            elseif goToAfkPosition(true) == "Night" then
                rightWeaponToEquip = _G.Settings.EquippingWeapons["Night Farming"]["One"]
                leftWeaponToEquip = _G.Settings.EquippingWeapons["Night Farming"]["Two"]
            elseif goToAfkPosition(true) == "Blood" then
                rightWeaponToEquip = _G.Settings.EquippingWeapons["Blood Farming"]["One"]
                leftWeaponToEquip = _G.Settings.EquippingWeapons["Blood Farming"]["Two"]
            end

            local noss = {" ","","None","none","abc","abcd"}
            if not table.find(noss, weaponToEquip) then

                if _G.Settings.HaveDualWield then
                    if not table.find(getEquippedWeapons(), rightWeaponToEquip) or not table.find(getEquippedWeapons(), leftWeaponToEquip) then
                        repeat
                            game:GetService("ReplicatedStorage").Packages.Knit.Services.WeaponInvService.RF.UnequipAll:InvokeServer()
                            task.wait(.25)
                            game:GetService("ReplicatedStorage").Packages.Knit.Services.WeaponInvService.RF.EquipWeapon:InvokeServer(rightWeaponToEquip)
                            task.wait(.25)
                            game:GetService("ReplicatedStorage").Packages.Knit.Services.WeaponInvService.RF.EquipWeapon:InvokeServer(leftWeaponToEquip)
                        until table.find(getEquippedWeapons(), rightWeaponToEquip) and table.find(getEquippedWeapons(), leftWeaponToEquip)
                    end
                else
                    if not table.find(getEquippedWeapons(), rightWeaponToEquip) then
                        game:GetService("ReplicatedStorage").Packages.Knit.Services.WeaponInvService.RF.EquipWeapon:InvokeServer(rightWeaponToEquip)
                    end
                end

            end
            
        end

        if _G.Settings.AutoUpgradeRelics then

            local RelicsFusing = {}
            
            local relicToUpgrade = _G.Settings.SelectedUpgradeRelic

            if _G.Settings.UpgradeEquippedRelic then
                relicToUpgrade = tostring(Knit.GetController("DataController"):GetData("PlayerData").EquippedRelic)
            end

            local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
            local PlayerData = Knit.GetController("DataController"):GetData("PlayerData")
            local RelicInv = PlayerData.RelicInv

            LPH_NO_VIRTUALIZE(function()
                for i,v in pairs(RelicInv) do
                    if _G.Settings.WhatToDoWithSelectedRelicsForAutoUpgradeRelic == "Use" then
                        if table.find(_G.Settings.RelicsGivingUp, v.name) and i ~= tostring(Knit.GetController("DataController"):GetData("PlayerData").EquippedRelic) then
                            game:GetService("ReplicatedStorage").Packages.Knit.Services.RelicLevelingService.RF.LevelUp:InvokeServer(relicToUpgrade, {i})
                        end
                    elseif _G.Settings.WhatToDoWithSelectedRelicsForAutoUpgradeRelic == "Keep" then
                        if not table.find(_G.Settings.RelicsGivingUp, v.name) and i ~= tostring(Knit.GetController("DataController"):GetData("PlayerData").EquippedRelic) then
                            game:GetService("ReplicatedStorage").Packages.Knit.Services.RelicLevelingService.RF.LevelUp:InvokeServer(relicToUpgrade, {i})
                        end
                    end
                end
            end)()

        end


        if false and _G.Settings.AutoGifts and CanDoPriority("Gifts") and not _G.RaidSetups then

            local data = {}

            local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
            local PlayerData = Knit.GetController("DataController"):GetData("PlayerData")
            local DatabaseController = Knit.GetController("DatabaseController")
            local GiftInfo = PlayerData.Christmas2022Gifts

            local function canCollectGIFT(giftID)
                local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
                local PlayerData = Knit.GetController("DataController"):GetData("PlayerData")
                local DatabaseController = Knit.GetController("DatabaseController")
                local GiftInfo = PlayerData.Christmas2022Gifts[giftID]
                return math.max(0, GiftInfo - workspace:GetAttribute("CURRENT_TIME")) == 0
            end

            for i,v in pairs(GiftInfo) do
                local GiftArea = DatabaseController:GetDatabase("Gifts2022")[i].area
                local canCollectIn = math.max(0, v - workspace:GetAttribute("CURRENT_TIME"))


                if canCollectIn == 0 and table.find(_G.Settings.CollectingAreas, GiftArea) and CanDoPriority("Gifts") and not _G.RaidSetups then

                    _G.CollectingGifts = true

                    repeat
                        pcall(function()
                            if game:GetService("Workspace").Resources.Spawns:FindFirstChild(GiftArea) then
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Resources.Spawns[GiftArea].CFrame
                            elseif game:GetService("Workspace").Resources.QuestDummy:FindFirstChild(GiftArea) then
                                for i = 1,100 do
                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Resources.QuestDummy[GiftArea]:GetModelCFrame() * CFrame.new(0,10,0)
                                    task.wait(.01)
                                end
                            end
                        end)
                        task.wait(.1)
                    until game.Players.LocalPlayer:GetAttribute("Area") == GiftArea or not _G.Settings.AutoGifts or game:GetService("Workspace").Resources.GiftSpawns:FindFirstChild(i) or not CanDoPriority("Gifts")

                    if _G.Settings.AutoGifts and game:GetService("Workspace").Resources.GiftSpawns:FindFirstChild(i) and CanDoPriority("Gifts") and not _G.RaidSetups then
                        _G.CanTap = false
                        repeat
                            _G.CanTap = false
                            pcall(function()
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Resources.GiftSpawns[i].CFrame * CFrame.new(0,10,5)
                            end)
                            --game:GetService("ReplicatedStorage").Packages.Knit.Services.ClickService.RF.Click:InvokeServer(i)
                            click(i)
                            task.wait(.001)
                        until not _G.Settings.AutoGifts or not canCollectGIFT(i) or not CanDoPriority("Gifts") or _G.RaidSetups
                        _G.CanTap = true
                    else
                        _G.CollectingGifts = false
                    end


                end
                _G.CollectingGifts = false

            end

            
        else
            _G.CollectingGifts = false

        end

        if _G.Settings.AutoQuest and not _G.DoingRaid and not _G.DoingDungeon and not _G.CollectingGifts and table.find(worlds, _G.Settings.SelectedQuestArea) then

            local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
            local PlayerData = Knit.GetController("DataController"):GetData("PlayerData")
            local DatabaseController = Knit.GetController("DatabaseController")
            local Quests = PlayerData.Quests
            local QuestsData = DatabaseController:GetDatabase("Quests")
            local Areas = DatabaseController:GetDatabase("Areas")
            
            if Quests[_G.Settings.SelectedQuestArea] then
                local QUESTID = _G.Settings.SelectedQuestArea
                game:GetService("ReplicatedStorage").Packages.Knit.Services.QuestService.RF.ActionQuest:InvokeServer(_G.Settings.SelectedQuestArea)
                if QUESTID:match("Area") then
                    local world = QUESTID:gsub("Area ","W"):split(" ")[1]
                    local questProgressionID = Quests[QUESTID].completed + 1
                    local QUESTID = world.." Quest "..questProgressionID

                    local QUESTMob = QuestsData[QUESTID].questTargets[1]
                    local amount = QuestsData[QUESTID].amount
                    local questType = QuestsData[QUESTID].questType

                    if questType == "Defeat" then

                        _G.DoingQuest = true

                        local mobArea = ""
                        for area,v in pairs(Areas) do
                            if table.find(v.npcs, QUESTMob) then
                                mobArea = area
                                break
                            end
                        end

                        local function foundMob(mobName)
                            if _G.Settings.FarmRenderedMobsOnly then
                                for i,v in pairs(game:GetService("Workspace").Live.NPCs.Client:GetChildren()) do
                                    local function mob(v)
                                        return game:GetService("Workspace").Live.NPCs.Server[v.Name]
                                    end
                                    if mob(v):GetAttribute("Name") and mob(v):GetAttribute("Name") == mobName then
                                        return true
                                    end
                                end
                            else
                                for i,v in pairs(game:GetService("Workspace").Live.NPCs.Server:GetChildren()) do
                                    if v:GetAttribute("Name") and v:GetAttribute("Name") == mobName then
                                        return true
                                    end
                                end
                            end
                            return false
                        end

                        local function getQuestProgress(quest)
                            local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
                            local PlayerData = Knit.GetController("DataController"):GetData("PlayerData")
                            local DatabaseController = Knit.GetController("DatabaseController")
                            local Quests = PlayerData.Quests
                            if Quests[quest] and Quests[quest].progress then
                                return Quests[quest].progress
                            else
                                return 0
                            end
                        end

                        local foundMobA = foundMob(QUESTMob)

                        if not foundMobA and (_G.Settings.AutoQuest and not _G.DoingRaid and not _G.DoingDungeon and not _G.CollectingGifts and table.find(worlds, _G.Settings.SelectedQuestArea)) then
                            
                            repeat
                                if _G.Settings.AutoQuest and not _G.DoingRaid and not _G.DoingDungeon and not _G.CollectingGifts then
                                    for i = 1, 100 do
                                        pcall(function()
                                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Areas[mobArea].spawnPos)
                                        end)
                                        task.wait(.01)
                                    end
                                else
                                    break
                                end
                                task.wait(1)
                            until foundMob(QUESTMob)

                            foundMobA = foundMob(QUESTMob)

                        end

                        game:GetService("ReplicatedStorage").Packages.Knit.Services.QuestService.RF.ActionQuest:InvokeServer(_G.Settings.SelectedQuestArea)

                        if foundMobA and (_G.Settings.AutoQuest and not _G.DoingRaid and not _G.DoingDungeon and not _G.CollectingGifts and table.find(worlds, _G.Settings.SelectedQuestArea)) then

                            repeat
                                if _G.Settings.AutoQuest and not _G.DoingRaid and not _G.DoingDungeon and not _G.CollectingGifts then

                                    if _G.Settings.FarmRenderedMobsOnly then
                                        for i,v in pairs(game:GetService("Workspace").Live.NPCs.Client:GetChildren()) do
                                            local function mob(v)
                                                return game:GetService("Workspace").Live.NPCs.Server[v.Name]
                                            end
                                            local mobHealth = mob(v):GetAttribute("Health")
                                            local mobNameA = mob(v):GetAttribute("Name")

                                            if mobHealth and mobName and mobNameA == QUESTMob and mobHealth > 0 then
                                                _G.CanTap = false
                                                repeat
                                                    if _G.Settings.AutoQuest and not _G.DoingRaid and not _G.DoingDungeon and not _G.CollectingGifts then
                                                        tpToMobCFrame(mob(v).CFrame)
                                                        click(mob(v).Name)
                                                        task.wait(.01)
                                                    else
                                                        break
                                                    end
                                                until not mob(v):GetAttribute("Health") or mob(v):GetAttribute("Health") <= 0
                                                _G.CanTap = true
                                            end
                                        end
                                    else
                                        for i,v in pairs(game:GetService("Workspace").Live.NPCs.Server:GetChildren()) do
                                            local mobHealth = v:GetAttribute("Health")
                                            local mobNameA = v:GetAttribute("Name")

                                            if mobHealth and mobName and mobNameA == QUESTMob and mobHealth > 0 then
                                                _G.CanTap = false
                                                repeat
                                                    if _G.Settings.AutoQuest and not _G.DoingRaid and not _G.DoingDungeon and not _G.CollectingGifts then
                                                        tpToMobCFrame(v.CFrame)
                                                        click(v.Name)
                                                        task.wait(.01)
                                                    else
                                                        break
                                                    end
                                                until not v:GetAttribute("Health") or v:GetAttribute("Health") <= 0
                                                _G.CanTap = true
                                            end
                                        end
                                    end
                                else
                                    break
                                end
                                task.wait(.1)
                            until tonumber(getQuestProgress(_G.Settings.SelectedQuestArea)) >= tonumber(amount)

                        end

                        game:GetService("ReplicatedStorage").Packages.Knit.Services.QuestService.RF.ActionQuest:InvokeServer(_G.Settings.SelectedQuestArea)

                    end

                end

            end
            
        else
            _G.DoingQuest = false
        end

        if _G.Settings.AutoFuse and (os.time() - lastShiniedAndCelestialed) > 1 then
            lastShiniedAndCelestialed = os.time()
 

            local function shinyAllShinablePets()

                local shinyRate = _G.Settings.ShinyPetFusionRateMinimum/10

                local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
                local PlayerData = Knit.GetController("DataController"):GetData("PlayerData")
                local petInv = PlayerData["PetInv"]

                local duplicateNonShinyPets = {}

                for i,v in pairs(petInv) do
                    local isShiny = v.tier == "Shiny"
                    local isCelestial = v.tier == "Celestial"

                    if (not isShiny and not isCelestial and not v.locked and (table.find(_G.Settings.SelectedShinyPetsForFusion, v.name))) and _G.Settings.WhatToDoWithShinySelectedPets == "Fuse" then
                        if not duplicateNonShinyPets[v.name] then
                            duplicateNonShinyPets[v.name] = {}
                        end
                        table.insert(duplicateNonShinyPets[v.name], i)
                    elseif (not isShiny and not isCelestial and not v.locked and (not table.find(_G.Settings.SelectedShinyPetsForFusion, v.name))) and _G.Settings.WhatToDoWithShinySelectedPets == "Keep" then
                        if not duplicateNonShinyPets[v.name] then
                            duplicateNonShinyPets[v.name] = {}
                        end
                        table.insert(duplicateNonShinyPets[v.name], i)
                    end

                end

                local splitIntoAmountMinimum = {}

                for petName,v in pairs(duplicateNonShinyPets) do
                    splitIntoAmountMinimum[petName] = {{}}
                    local split = {}
                    local rate = shinyRate
                    
                    local vs = #v
                    if vs%2 ~= 0 then
                        vs += 1
                    end

                    local howManyTablesNeedToSplit = vs/rate

                    for i = 1, howManyTablesNeedToSplit do
                        splitIntoAmountMinimum[petName][i] = {}
                    end

                    for i,petID in pairs(v) do

                        for i,v in pairs(splitIntoAmountMinimum[petName]) do
                            if #v < rate then
                                table.insert(splitIntoAmountMinimum[petName][i], petID)
                            end
                        end

                    end
                end

                local petsToShiny = {}

                for i,v in pairs(splitIntoAmountMinimum) do
                    for i,v in pairs(v) do
                        if #v == shinyRate then
                            table.insert(petsToShiny, v)
                        end
                    end
                end

                for i,v in pairs(petsToShiny) do
                    --warn(i,v)
                    game:GetService("ReplicatedStorage").Packages.Knit.Services.CraftingService.RF.Craft:InvokeServer(v)
                end
                
            end

            local function celestialAllCelestiablePets()

                    local celestialRate = (_G.Settings.CelestialPetFusionRateMinimum/10)/2

                    local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
                    local PlayerData = Knit.GetController("DataController"):GetData("PlayerData")
                    local petInv = PlayerData["PetInv"]

                    local duplicateNonCelestialPets = {}

                    for i,v in pairs(petInv) do
                        local isShiny = v.tier == "Shiny"
                        local isCelestial = v.tier == "Celestial"

                        if (isShiny and not isCelestial and not v.locked and (table.find(_G.Settings.SelectedCelestialPetsForFusion, v.name))) and _G.Settings.WhatToDoWithCelestialSelectedPets == "Fuse" then
                            if not duplicateNonCelestialPets[v.name] then
                                duplicateNonCelestialPets[v.name] = {}
                            end
                            table.insert(duplicateNonCelestialPets[v.name], i)
                        elseif (isShiny and not isCelestial and not v.locked and (not table.find(_G.Settings.SelectedCelestialPetsForFusion, v.name))) and _G.Settings.WhatToDoWithCelestialSelectedPets == "Keep" then
                            if not duplicateNonCelestialPets[v.name] then
                                duplicateNonCelestialPets[v.name] = {}
                            end
                            table.insert(duplicateNonCelestialPets[v.name], i)
                        end

                    end

                    local splitIntoAmountMinimum = {}

                    for petName,v in pairs(duplicateNonCelestialPets) do
                        splitIntoAmountMinimum[petName] = {{}}
                        local split = {}
                        local rate = celestialRate
                        
                        local vs = #v
                        if vs%2 ~= 0 then
                            vs += 1
                        end

                        local howManyTablesNeedToSplit = vs/rate

                        for i = 1, howManyTablesNeedToSplit do
                            splitIntoAmountMinimum[petName][i] = {}
                        end

                        for i,petID in pairs(v) do

                            for i,v in pairs(splitIntoAmountMinimum[petName]) do
                                if #v < rate then
                                    table.insert(splitIntoAmountMinimum[petName][i], petID)
                                end
                            end

                        end
                    end

                    local petsToCelestial = {}
                    
                    

                    for i,v in pairs(splitIntoAmountMinimum) do
                        for i,v in pairs(v) do
                            if #v == celestialRate then
                                table.insert(petsToCelestial, v)
                            end
                        end
                    end



                for i,v in pairs(petsToCelestial) do
                    ----warn(i.." Celestial")
                    for i,v in pairs(v) do
                        ----print(i,v)
                    end
                    game:GetService("ReplicatedStorage").Packages.Knit.Services.CraftingService.RF.Craft:InvokeServer(v)
                end
                
            end

            local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
            local PlayerData = Knit.GetController("DataController"):GetData("PlayerData")

            local canProceedForShiny = false
            local canProceedForCelestial = false

            local SSPFF = _G.Settings.SelectedShinyPetsForFusion
            local SCPFF = _G.Settings.SelectedCelestialPetsForFusion

            for i,v in pairs(PlayerData["PetInv"]) do
                local isShiny = v.tier == "Shiny"
                local isCelestial = v.tier == "Celestial"

                if not isShiny or not isCelestial then
                    if table.find(SSPFF, v.name) or _G.Settings.WhatToDoWithShinySelectedPets == "Keep" then
                        canProceedForShiny = true
                    end
                    if table.find(SCPFF, v.name) or _G.Settings.WhatToDoWithCelestialSelectedPets == "Keep" then
                        canProceedForCelestial = true
                    end
                end
            end
            
            if #_G.Settings.SelectedShinyPetsForFusion > 0 and canProceedForShiny then
                shinyAllShinablePets()
            end

            if #_G.Settings.SelectedCelestialPetsForFusion > 0 and canProceedForCelestial then
                celestialAllCelestiablePets()
            end

        end

        task.wait(0.1)

    end

end,nil,function()

    _G.CollectingGifts = false

end)

local Section = Tab:CreateSection("Auto Misc")

createOptimisedToggle(Tab, "Auto Tap","AutoClick",
function()

    while task.wait() do
        if _G.CanTap then
            click()
        end
    end
    
end)

createOptimisedToggle(Tab,"Auto Collect Items (Like Coins)","AutoCoin",nil,true)
game:GetService("ReplicatedStorage").Packages.Knit.Services.ItemDropService.RE.NewItem.OnClientEvent:Connect(function(thingID)
    if _G.Settings.AutoCoin then
        game:GetService("ReplicatedStorage").Packages.Knit.Services.ItemDropService.RF.ClaimItem:InvokeServer(thingID)
    end
end)

createOptimisedToggle(Tab,"Auto Ascend","AutoAscend",nil,true)

createOptimisedToggle(Tab,"Auto Claim Free Tickets","AutoFreeTickets",nil,true)

createOptimisedToggle(Tab,"Auto Claim Chests", "AutoClaimChests",nil,true)

local Slider = Tab:CreateSlider({
    Name = "Player WalkSpeed",
    Range = {0, 1000},
    Increment = 1,
    Suffix = "",
    CurrentValue = 16,
    Flag = "SliderWalkspeed", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        _G.Settings.WalkSpeed = Value
    end
 })

if false then
    local Section = Tab:CreateSection("Auto Quest")

    local Dropdown = Tab:CreateDropdown({
        Name = "Select Quest Area",
        Options = worlds,
        CurrentOption = "None",
        Flag = "DropdownQUEST1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(Option)
            if table.find(worlds, Option) then
                _G.Settings.SelectedQuestArea = Option
            end
        end,
    })

    createOptimisedToggle(Tab, "Auto Quest Selected Area","AutoQuest",nil,true,function()
        _G.DoingQuest = false
    end)

    local Section = Tab:CreateSection("Auto Gifts")

    function roundNumber(num, numDecimalPlaces)
        return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
    end

    function Format(Int)
        return string.format("%02i", Int)
    end

    function convertToHMS(Seconds)
        local Minutes = (Seconds - Seconds%60)/60
        Seconds = Seconds - Minutes*60
        local Hours = (Minutes - Minutes%60)/60
        Minutes = Minutes - Hours*60
        return Format(Hours)..":"..Format(Minutes)..":"..Format(Seconds)
    end

    local data = {}

    local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
    local PlayerData = Knit.GetController("DataController"):GetData("PlayerData")
    local DatabaseController = Knit.GetController("DatabaseController")
    local GiftInfo = PlayerData.Christmas2022Gifts

    for i,v in pairs(GiftInfo) do
        local GiftArea = DatabaseController:GetDatabase("Gifts2022")[i].area
        local canCollectIn = math.max(0, v - workspace:GetAttribute("CURRENT_TIME"))
        if canCollectIn == 0 then
            canCollectIn = "Collectable"
        else
            canCollectIn = "Can Collect In "..convertToHMS(roundNumber(canCollectIn))..""
        end
        data[#data + 1] = GiftArea.." - "..i..": "..tostring(canCollectIn)
    end

    local function giftcustomSort(array)
        table.sort(array, function(a,b)
            return tonumber(a:split(" -")[1]:gsub("Area ",""):split(" ")[1]) < tonumber(b:split(" -")[1]:gsub("Area ",""):split(" ")[1])
        end)
        return array
    end

    local Paragraph = Tab:CreateParagraph({Title = "Gift Info", Content = table.concat(giftcustomSort(data),"\n")})

    coroutine.resume(coroutine.create(function()
        if true then return nil end
        while task.wait() do
            local data = {}
            local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
            local PlayerData = Knit.GetController("DataController"):GetData("PlayerData")
            local DatabaseController = Knit.GetController("DatabaseController")
            local GiftInfo = PlayerData.Christmas2022Gifts
        
            for i,v in pairs(GiftInfo) do
                local GiftArea = DatabaseController:GetDatabase("Gifts2022")[i].area
                local canCollectIn = math.max(0, v - workspace:GetAttribute("CURRENT_TIME"))
                if canCollectIn == 0 then
                    canCollectIn = "Collectable"
                else
                    canCollectIn = "Can Collect In "..convertToHMS(roundNumber(canCollectIn))..""
                end
                data[#data + 1] = GiftArea.." - "..i..": "..tostring(canCollectIn)
            end

            Paragraph:Set({Title = "Gift Info", Content = table.concat(giftcustomSort(data),"\n")})
            
            task.wait(1)
        end
    end))

    local collectableAreas = {}
    for i,v in pairs(DatabaseController:GetDatabase("Gifts2022")) do
        if not table.find(collectableAreas, v.area) then
            table.insert(collectableAreas, v.area)
        end
    end

    if isfile and readfile and isfile("Banana Hub"..configFolder.."/SwordFightersGiftAreas"..game.Players.LocalPlayer.Name..".json") then
        _G.Settings.CollectingAreas = game:GetService("HttpService"):JSONDecode(readfile("Banana Hub"..configFolder.."/SwordFightersGiftAreas"..game.Players.LocalPlayer.Name..".json"))
    end

    local Label = Tab:CreateLabel("Areas To Collect: "..table.concat(SSAWNII(_G.Settings.CollectingAreas),", "))

    local Button = Tab:CreateButton({
        Name = "Reset List",
        Interact = 'Reset',
        Callback = function()
            _G.Settings.CollectingAreas = {}
            Label:Set("Areas To Collect: "..table.concat(SSAWNII(_G.Settings.CollectingAreas),", "))
            if isfile and writefile then
                writefile("Banana Hub"..configFolder.."/SwordFightersGiftAreas"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.CollectingAreas))
            end
        end
    })

    local Dropdown = Tab:CreateDropdown({
        Name = "Select Areas To Collect In",
        Options = collectableAreas,
        CurrentOption = "None",
        Flag = "Dropdown11", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(Option)
            if _G.NowLoaded then

                if table.find(_G.Settings.CollectingAreas, Option) then
                    table.remove(_G.Settings.CollectingAreas, table.find(_G.Settings.CollectingAreas, Option))
                else
                    table.insert(_G.Settings.CollectingAreas, Option)
                end

                if isfile and writefile then
                    writefile("Banana Hub"..configFolder.."/SwordFightersGiftAreas"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.CollectingAreas))
                end

                Label:Set("Areas To Collect: "..table.concat(SSAWNII(_G.Settings.CollectingAreas),", "))


            end

        end
    })

    createOptimisedToggle(Tab, "Auto Collect Gifts","AutoGifts",nil,true,function()

        _G.CollectingGifts = false

    end)
end

local Section = Tab:CreateSection("Auto Sword Enchant Selling")

--AutoSwordsManage 
--SwordsSelected
--SellSelectedSwordsOrKeep
--RaritiesToSellEnchantSwords
--CurrentSelectedSwordEnchant
--CurrentSelectedSwordEnchantTier

local swords = {"Smite"}
for i,v in pairs(DatabaseController:GetDatabase("Enchants")) do
    if not table.find(swords, i) then
        table.insert(swords, i)
    end
end

if isfile and readfile and isfile("Banana Hub"..configFolder.."/SwordFightersSelectedSwordsSaveSecond"..game.Players.LocalPlayer.Name..".json") then
    _G.Settings.SwordsSelected = game:GetService("HttpService"):JSONDecode(readfile("Banana Hub"..configFolder.."/SwordFightersSelectedSwordsSaveSecond"..game.Players.LocalPlayer.Name..".json"))
end

createOptimisedToggle(Tab,"Auto Sell Sword Enchants","AutoSwordsManage",nil,true)

local Label = Tab:CreateLabel("Selected Sword Enchants: "..table.concat(_G.Settings.SwordsSelected,", "))

local Button = Tab:CreateButton({
    Name = "Reset List",
    Interact = 'Reset',
    Callback = function()
        _G.Settings.SwordsSelected = {}
        Label:Set("Selected Sword Enchants: "..table.concat(_G.Settings.SwordsSelected,", "))
        if isfile and writefile then
            writefile("Banana Hub"..configFolder.."/SwordFightersSelectedSwordsSaveSecond"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.SwordsSelected))
        end
    end
})

local Dropdown = Tab:CreateDropdown({
    Name = "Select Sword Enchant",
    Options = swords,
    CurrentOption = "None",
    Flag = "DropdownSwordEnchantSelection", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Option)
        if _G.NowLoaded and table.find(swords, Option) then
            _G.CurrentSelectedSwordEnchant = Option
            _G.EnchantTierDropdown:Set("Any")
        end
    end
})

local enchantTiers = {"I","II","III","IV","V"}
table.insert(enchantTiers, "Any")

_G.EnchantTierDropdown = Tab:CreateDropdown({
    Name = "Select Enchant Tier",
    Options = enchantTiers,
    CurrentOption = "Any",
    Flag = "DropdownSwordEnchantTierSelection", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Option)
        if _G.NowLoaded and table.find(enchantTiers, Option) then
            _G.CurrentSelectedSwordEnchantTier = Option
        end
    end
})

local Button = Tab:CreateButton({
    Name = "Add/Remove Sword Enchant From List",
    Interact = '🖱️',
    Callback = function()

        local selectedSwordEnchant = _G.CurrentSelectedSwordEnchant
        local selectedSwordEnchantTier = _G.CurrentSelectedSwordEnchantTier

        if _G.NowLoaded and table.find(swords, selectedSwordEnchant) and table.find(enchantTiers, selectedSwordEnchantTier) then

            local Text = selectedSwordEnchant.."|"..selectedSwordEnchantTier

            if not table.find(_G.Settings.SwordsSelected, Text) then
                table.insert(_G.Settings.SwordsSelected, Text)
            else
                table.remove(_G.Settings.SwordsSelected, table.find(_G.Settings.SwordsSelected, Text))
            end

            if isfile and writefile then
                writefile("Banana Hub"..configFolder.."/SwordFightersSelectedSwordsSaveSecond"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.SwordsSelected))
            end

            Label:Set("Selected Sword Enchants: "..table.concat(_G.Settings.SwordsSelected,", "))

        end

    end
})

if isfile and writefile and isfile("Banana Hub"..configFolder.."/SwordFightersSelectedSwordsSave"..game.Players.LocalPlayer.Name..".json") then
    local selectedEnchantList = game:GetService("HttpService"):JSONDecode(readfile("Banana Hub"..configFolder.."/SwordFightersSelectedSwordsSave"..game.Players.LocalPlayer.Name..".json"))
    for i,v in pairs(selectedEnchantList) do

            local Text = v.."|Any"

            table.insert(_G.Settings.SwordsSelected, Text)

            Label:Set("Selected Sword Enchants: "..table.concat(_G.Settings.SwordsSelected,", "))

    end
    if isfile and writefile then
        writefile("Banana Hub"..configFolder.."/SwordFightersSelectedSwordsSave"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode({}))
    end
end

--[[
Tab:CreateDropdown({
    Name = "Add/Remove Sword Enchant From List",
    Options = swords,
    CurrentOption = "None",
    Flag = "DropdownSwordSelectEnchant", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Text)

        
        if _G.NowLoaded and table.find(swords, Text) then

            if not table.find(_G.Settings.SwordsSelected, Text) then
                table.insert(_G.Settings.SwordsSelected, Text)
            else
                table.remove(_G.Settings.SwordsSelected, table.find(_G.Settings.SwordsSelected, Text))
            end

            if isfile and writefile then
                writefile("Banana Hub"..configFolder.."/SwordFightersSelectedSwordsSave"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.SwordsSelected))
            end

            Label:Set("Selected Sword Enchants: "..table.concat(_G.Settings.SwordsSelected,", "))

        end

    end
})
]]

local Dropdown = Tab:CreateDropdown({
    Name = "What To Do With Selected Sword Enchants",
    Options = {"Sell","Keep and sell others"},
    CurrentOption = "Sell",
    Flag = "DropdownSwordSelectedWhatToDoWithEnchants", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Option)
        if Option == "Keep and sell others" then
            Option = "Keep"
        end
        _G.Settings.SellSelectedSwordsOrKeep = Option
    end,
})

local rarities = {}
for i,v in pairs(DatabaseController:GetDatabase("Weapons")) do
    if not table.find(rarities, v.rarity) then
        table.insert(rarities, v.rarity)
    end
end

for i,v in pairs(rarities) do
    createOptimisedToggle(Tab,"Sell "..v.." Swords","SwordEnchantSell"..v,nil,true)
end

local Section = Tab:CreateSection("Auto Pet Dismantler")


--AutoPetDismantle
--SelectedPets
--WhatToDoWithSelectedPets

local pets = {}
for i,v in pairs(DatabaseController:GetDatabase("Pets")) do
    if not table.find(pets, i) then
        table.insert(pets, i)
    end
end

local petTraits = {}
for i,v in pairs(DatabaseController:GetDatabase("Enchants")) do
    if not table.find(petTraits, i) then
        table.insert(petTraits, i)
    end
end

if isfile and readfile and isfile("Banana Hub/SwordFightersSelectedPetsSave"..game.Players.LocalPlayer.Name..".json") then
    _G.Settings.SelectedPets = game:GetService("HttpService"):JSONDecode(readfile("Banana Hub/SwordFightersSelectedPetsSave"..game.Players.LocalPlayer.Name..".json"))
    for i,v in pairs(_G.Settings.SelectedPets) do
        if not table.find(pets, v) then
            table.remove(_G.Settings.SelectedPets, i)
        end
    end
end

if isfile and readfile and isfile("Banana Hub/SwordFightersPetTraitTierSave"..game.Players.LocalPlayer.Name..".json") then
    _G.Settings.PetTiersSelling = game:GetService("HttpService"):JSONDecode(readfile("Banana Hub/SwordFightersPetTraitTierSave"..game.Players.LocalPlayer.Name..".json"))
end

createOptimisedToggle(Tab,"Auto Pet Dismantler","AutoPetDismantle",nil,true)

local Label2 = Tab:CreateLabel("Selected Pet Traits: "..table.concat(_G.Settings.PetTiersSelling,", "))

local Label = Tab:CreateLabel("Selected Pets: "..table.concat(_G.Settings.SelectedPets,", "))

local Button = Tab:CreateButton({
    Name = "Reset List",
    Interact = 'Reset',
    Callback = function()
        _G.Settings.PetTiersSelling = {}
        Label2:Set("Selected Pet Traits: "..table.concat(_G.Settings.PetTiersSelling,", "))
        if isfile and writefile then
            writefile("Banana Hub/SwordFightersPetTraitTierSave"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.PetTiersSelling))
        end
        _G.Settings.SelectedPets = {}
        Label:Set("Selected Pets: "..table.concat(_G.Settings.SelectedPets,", "))
        if isfile and writefile then
            writefile("Banana Hub/SwordFightersSelectedPetsSave"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.SelectedPets))
        end
    end
})

--[[
Tab:CreateDropdown({
    Name = "Add/Remove Pet Traits From List",
    Options = petTraits,
    CurrentOption = "None",
    Flag = "DropdownPetTraitSelect", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Text)

        
        if _G.NowLoaded and table.find(petTraits, Text) then

            if not table.find(_G.Settings.PetTiersSelling, Text) then
                table.insert(_G.Settings.PetTiersSelling, Text)
            else
                table.remove(_G.Settings.PetTiersSelling, table.find(_G.Settings.PetTiersSelling, Text))
            end

            if isfile and writefile then
                writefile("Banana Hub/SwordFightersPetTraitTierSave"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.PetTiersSelling))
            end

            Label2:Set("Selected Pet Traits: "..table.concat(_G.Settings.PetTiersSelling,", "))

        end
    end
})
--]]

local Dropdown = Tab:CreateDropdown({
    Name = "Select Pet Trait",
    Options = swords,
    CurrentOption = "None",
    Flag = "DropdownSwordEnchantSelection", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Option)
        if _G.NowLoaded then
            _G.CurrentSelectedSwordEnchantForPet = Option
            _G.EnchantTierDropdownPet:Set("Any")
        end
    end
})

local enchantTiers = {"I","II","III","IV","V"}
table.insert(enchantTiers, "Any")

_G.EnchantTierDropdownPet = Tab:CreateDropdown({
    Name = "Select Pet Trait Tier",
    Options = enchantTiers,
    CurrentOption = "Any",
    Flag = "DropdownSwordEnchantTierSelectionForPets", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Option)
        if _G.NowLoaded and table.find(enchantTiers, Option) then
            _G.CurrentSelectedSwordEnchantTierForPet = Option
        end
    end
})

local Button = Tab:CreateButton({
    Name = "Add/Remove Pet Trait From List",
    Interact = '🖱️',
    Callback = function()

        local selectedSwordEnchant = tostring(_G.CurrentSelectedSwordEnchantForPet)
        local selectedSwordEnchantTier = tostring(_G.CurrentSelectedSwordEnchantTierForPet)

        if _G.NowLoaded and table.find(enchantTiers, selectedSwordEnchantTier) then

            local Text = selectedSwordEnchant.."|"..selectedSwordEnchantTier

            if not table.find(_G.Settings.PetTiersSelling, Text) then
                table.insert(_G.Settings.PetTiersSelling, Text)
            else
                table.remove(_G.Settings.PetTiersSelling, table.find(_G.Settings.PetTiersSelling, Text))
            end

            if isfile and writefile then
                writefile("Banana Hub/SwordFightersPetTraitTierSave"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.PetTiersSelling))
            end

            Label2:Set("Selected Pet Traits: "..table.concat(_G.Settings.PetTiersSelling,", "))

        end

    end
})

local Dropdown = Tab:CreateDropdown({
    Name = "What To Do With Selected Pet Traits",
    Options = {"Dismantle","Keep and dismantle others"},
    CurrentOption = "Dismantle",
    Flag = "DropdownPetDismantlerSelectedPetTraitsWhatToDoWithThem", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Option)
        if Option == "Keep and dismantle others" then
            Option = "Keep"
        end
        _G.Settings.WhatToDoWithSelectedPetTraits = Option
    end
})

Tab:CreateDropdown({
    Name = "Add/Remove Pet From List",
    Options = pets,
    CurrentOption = "None",
    Flag = "DropdownPetSelect", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Text)

        
        if _G.NowLoaded and table.find(pets, Text) then

            if not table.find(_G.Settings.SelectedPets, Text) then
                table.insert(_G.Settings.SelectedPets, Text)
            else
                table.remove(_G.Settings.SelectedPets, table.find(_G.Settings.SelectedPets, Text))
            end

            if isfile and writefile then
                writefile("Banana Hub/SwordFightersSelectedPetsSave"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.SelectedPets))
            end

            Label:Set("Selected Pets: "..table.concat(_G.Settings.SelectedPets,", "))

        end
    end
})

local Dropdown = Tab:CreateDropdown({
    Name = "What To Do With Selected Pets",
    Options = {"Dismantle","Keep and dismantle others"},
    CurrentOption = "Dismantle",
    Flag = "DropdownPetDismantlerSelectedPetsWhatToDoWithThem", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Option)
        if Option == "Keep and dismantle others" then
            Option = "Keep"
        end
        _G.Settings.WhatToDoWithSelectedPets = Option
    end
})

local Section = Tab:CreateSection("Auto Fuse")

createOptimisedToggle(Tab, "Auto Fuse Enabled","AutoFuse",nil,true)

--AutoFuse
--SelectedShinyPetsForFusion
--WhatToDoWithShinySelectedPets
--ShinyPetFusionRateMinimum
--SelectedCelestialPetsForFusion
--WhatToDoWithCelestialSelectedPets
--CelestialPetFusionRateMinimum

local pets = {}
for i,v in pairs(DatabaseController:GetDatabase("Pets")) do
    if not table.find(pets, i) then
        table.insert(pets, i)
    end
end

if isfile and readfile and isfile("Banana Hub"..configFolder.."/SwordFightersSimulatorSelectedShinyPetsForFusion"..game.Players.LocalPlayer.Name..".json") then
    _G.Settings.SelectedShinyPetsForFusion = game:GetService("HttpService"):JSONDecode(readfile("Banana Hub"..configFolder.."/SwordFightersSimulatorSelectedShinyPetsForFusion"..game.Players.LocalPlayer.Name..".json"))
end

if isfile and readfile and isfile("Banana Hub"..configFolder.."/SwordFightersSimulatorSelectedCelestialPetsForFusion"..game.Players.LocalPlayer.Name..".json") then
    _G.Settings.SelectedCelestialPetsForFusion = game:GetService("HttpService"):JSONDecode(readfile("Banana Hub"..configFolder.."/SwordFightersSimulatorSelectedCelestialPetsForFusion"..game.Players.LocalPlayer.Name..".json"))
end

local Label = Tab:CreateLabel("Selected Shiny Pets: "..table.concat(_G.Settings.SelectedShinyPetsForFusion,", "))

local Button = Tab:CreateButton({
    Name = "Reset List",
    Interact = 'Reset',
    Callback = function()
        _G.Settings.SelectedShinyPetsForFusion = {}
        Label:Set("Selected Shiny Pets: "..table.concat(_G.Settings.SelectedShinyPetsForFusion,", "))
        if isfile and writefile then
            writefile("Banana Hub"..configFolder.."/SwordFightersSimulatorSelectedShinyPetsForFusion"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.SelectedShinyPetsForFusion))
        end
    end
})


Tab:CreateDropdown({
    Name = "Add/Remove Pet From Shiny List",
    Options = pets,
    CurrentOption = "None",
    Flag = "DropdownPetSelectForWhatToFuseWithShiny", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Text)

        
        if _G.NowLoaded and table.find(pets, Text) then

            if not table.find(_G.Settings.SelectedShinyPetsForFusion, Text) then
                table.insert(_G.Settings.SelectedShinyPetsForFusion, Text)
            else
                table.remove(_G.Settings.SelectedShinyPetsForFusion, table.find(_G.Settings.SelectedShinyPetsForFusion, Text))
            end

            if isfile and writefile then
                writefile("Banana Hub"..configFolder.."/SwordFightersSimulatorSelectedShinyPetsForFusion"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.SelectedShinyPetsForFusion))
            end

            Label:Set("Selected Shiny Pets: "..table.concat(_G.Settings.SelectedShinyPetsForFusion,", "))

        end
    end
})

local Dropdown = Tab:CreateDropdown({
    Name = "What To Do With Selected Shiny Pets",
    Options = {"Shiny all selected","Keep and shiny others"},
    CurrentOption = "Shiny all selected",
    Flag = "DropdownWhatToDoWithShinySelectedPets", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Option)
        if Option == "Keep and shiny others" then
            Option = "Keep"
        end
        if Option == "Shiny all selected" then
            Option = "Fuse"
        end
        _G.Settings.WhatToDoWithShinySelectedPets = Option
    end
})

local Slider = Tab:CreateSlider({
    Name = "Shiny Fusion Rate",
    Range = {10, 100},
    Increment = 10,
    Suffix = "%",
    CurrentValue = 100,
    Flag = "SliderShinyFusionMinimum", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        _G.Settings.ShinyPetFusionRateMinimum = Value
    end
})

local Label = Tab:CreateLabel("Selected Celestial Pets: "..table.concat(_G.Settings.SelectedCelestialPetsForFusion,", "))

local Button = Tab:CreateButton({
    Name = "Reset List",
    Interact = 'Reset',
    Callback = function()
        _G.Settings.SelectedCelestialPetsForFusion = {}
        Label:Set("Selected Celestial Pets: "..table.concat(_G.Settings.SelectedCelestialPetsForFusion,", "))
        if isfile and writefile then
            writefile("Banana Hub"..configFolder.."/SwordFightersSimulatorSelectedCelestialPetsForFusion"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.SelectedCelestialPetsForFusion))
        end
    end
})


Tab:CreateDropdown({
    Name = "Add/Remove Pet From Celestial List",
    Options = pets,
    CurrentOption = "None",
    Flag = "DropdownPetSelectForWhatToFuseWithCelestial", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Text)

        
        if _G.NowLoaded and table.find(pets, Text) then

            if not table.find(_G.Settings.SelectedCelestialPetsForFusion, Text) then
                table.insert(_G.Settings.SelectedCelestialPetsForFusion, Text)
            else
                table.remove(_G.Settings.SelectedCelestialPetsForFusion, table.find(_G.Settings.SelectedCelestialPetsForFusion, Text))
            end

            if isfile and writefile then
                writefile("Banana Hub"..configFolder.."/SwordFightersSimulatorSelectedCelestialPetsForFusion"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.SelectedCelestialPetsForFusion))
            end

            Label:Set("Selected Celestial Pets: "..table.concat(_G.Settings.SelectedCelestialPetsForFusion,", "))

        end
    end
})

local Dropdown = Tab:CreateDropdown({
    Name = "What To Do With Selected Celestial Pets",
    Options = {"Celestial all selected","Keep and Celestial others"},
    CurrentOption = "Celestial all selected",
    Flag = "DropdownWhatToDoWithCelestialSelectedPets", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Option)
        if Option == "Keep and Celestial others" then
            Option = "Keep"
        end
        if Option == "Celestial all selected" then
            Option = "Fuse"
        end
        _G.Settings.WhatToDoWithCelestialSelectedPets = Option
    end
})

local Slider = Tab:CreateSlider({
    Name = "Celestial Fusion Rate",
    Range = {20, 100},
    Increment = 20,
    Suffix = "%",
    CurrentValue = 100,
    Flag = "SliderCelestialFusionMinimum", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        _G.Settings.CelestialPetFusionRateMinimum = Value
    end
})

local Section = Tab:CreateSection("Auto Equip Loadouts")

createOptimisedToggle(Tab, "Auto Equip Loadouts","AutoEquipLoadouts",nil,true)

createOptimisedToggle(Tab, "Only check if need to equip loadout at the start of a new event (reduces lag heavily)","AutoEquipLoadoutCheckNewEvent",nil,true)

for i,v in pairs(_G.Settings.EquippingLoadouts) do
    if isfile and readfile and isfile("Banana Hub"..configFolder.."/SwordFightersEquippedLoadoutSave"..i..game.Players.LocalPlayer.Name..".json") then
        _G.Settings.EquippingLoadouts[i] = game:GetService("HttpService"):JSONDecode(readfile("Banana Hub"..configFolder.."/SwordFightersEquippedLoadoutSave"..i..game.Players.LocalPlayer.Name..".json"))
    end
end

for i,v in pairs(_G.Settings.EquippingLoadouts) do
    local LoadoutSelected = Tab:CreateLabel(i.." Loadout: "..v)
    local Input = Tab:CreateInput({
        Name = "Enter Loadout Name:",
        PlaceholderText = "Loadout Name",
        NumbersOnly = false, -- If the user can only type numbers.
        CharacterLimit = nil, --max character limit. Remove if none.
        OnEnter = true, -- Will callback only if the user pressed ENTER while being focused.
        RemoveTextAfterFocusLost = true,
        Callback = function(Text)
            _G.Settings.EquippingLoadouts[i] = Text
            if isfile and writefile then
                writefile("Banana Hub"..configFolder.."/SwordFightersEquippedLoadoutSave"..i..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.EquippingLoadouts[i]))
            end
            LoadoutSelected:Set(i.." Loadout: ".._G.Settings.EquippingLoadouts[i])
        end
    })
end


local Section = Tab:CreateSection("Auto Relic Manager")

local relics = {}
for i,v in pairs(DatabaseController:GetDatabase("Relics")) do
    if not table.find(relics, i) then
        table.insert(relics, i)
    end
end

if isfile and readfile and isfile("Banana Hub"..configFolder.."/SwordFightersRelicsSave"..game.Players.LocalPlayer.Name..".json") then
    _G.Settings.RelicsSelected = game:GetService("HttpService"):JSONDecode(readfile("Banana Hub"..configFolder.."/SwordFightersRelicsSave"..game.Players.LocalPlayer.Name..".json"))
    for i,v in pairs(_G.Settings.RelicsSelected) do
        if not table.find(relics, v) then
            table.remove(_G.Settings.RelicsSelected, i)
        end
    end
end

createOptimisedToggle(Tab,"Auto Sell Relics","AutoManageRelics",nil,true)

local Label = Tab:CreateLabel("Selected Relics: "..table.concat(_G.Settings.RelicsSelected,", "))

local Button = Tab:CreateButton({
    Name = "Reset List",
    Interact = 'Reset',
    Callback = function()
        _G.Settings.RelicsSelected = {}
        Label:Set("Selected Relics: "..table.concat(_G.Settings.RelicsSelected,", "))
        if isfile and writefile then
            writefile("Banana Hub"..configFolder.."/SwordFightersRelicsSave"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.RelicsSelected))
        end
    end
})

Tab:CreateDropdown({
    Name = "Add/Remove Relic From List",
    Options = relics,
    CurrentOption = "None",
    Flag = "DropdownRelicSelect", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Text)

        
        if _G.NowLoaded and table.find(relics, Text) then

            if not table.find(_G.Settings.RelicsSelected, Text) then
                table.insert(_G.Settings.RelicsSelected, Text)
            else
                table.remove(_G.Settings.RelicsSelected, table.find(_G.Settings.RelicsSelected, Text))
            end

            if isfile and writefile then
                writefile("Banana Hub"..configFolder.."/SwordFightersRelicsSave"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.RelicsSelected))
            end

            Label:Set("Selected Relics: "..table.concat(_G.Settings.RelicsSelected,", "))

        end
    end
})

local Dropdown = Tab:CreateDropdown({
    Name = "What To Do With Selected Relics",
    Options = {"Sell","Keep and sell others"},
    CurrentOption = "Sell",
    Flag = "Dropdown7", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Option)
        if Option == "Keep and sell others" then
            Option = "Keep"
        end
        _G.Settings.SellSelectedRelicsOrKeep = Option
    end,
})

local Section = Tab:CreateSection("Auto Upgrade Relics")

createOptimisedToggle(Tab,"Auto Upgrade Relics","AutoUpgradeRelics",nil,true)

if isfile and readfile and isfile("Banana Hub"..configFolder.."/SwordFightersAutoUpgradeSelectedRelicSave"..game.Players.LocalPlayer.Name..".json") then
    _G.Settings.SelectedUpgradeRelic = game:GetService("HttpService"):JSONDecode(readfile("Banana Hub"..configFolder.."/SwordFightersAutoUpgradeSelectedRelicSave"..game.Players.LocalPlayer.Name..".json"))
end

if isfile and readfile and isfile("Banana Hub"..configFolder.."/SwordFightersAutoUpgradeSellingRelicSave"..game.Players.LocalPlayer.Name..".json") then
    _G.Settings.RelicsGivingUp = game:GetService("HttpService"):JSONDecode(readfile("Banana Hub"..configFolder.."/SwordFightersAutoUpgradeSellingRelicSave"..game.Players.LocalPlayer.Name..".json"))
end

local Label = Tab:CreateLabel("Selected Relic: "..tostring(_G.Settings.SelectedUpgradeRelic))

local Label2 = Tab:CreateLabel("Relics Selected: "..table.concat(_G.Settings.RelicsGivingUp,", "))

local Button = Tab:CreateButton({
    Name = "Reset List",
    Interact = 'Reset',
    Callback = function()
        _G.Settings.RelicsGivingUp = {}
        Label2:Set("Relics Giving Up: "..table.concat(_G.Settings.RelicsGivingUp,", "))
        if isfile and writefile then
            writefile("Banana Hub"..configFolder.."/SwordFightersAutoUpgradeSellingRelicSave"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.RelicsGivingUp))
        end
    end
})

local Dropdown = Tab:CreateDropdown({
    Name = "Select Relics",
    Options = relics,
    CurrentOption = "None",
    Flag = "DropdownRelicsToFuse", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Text)
        if _G.NowLoaded and table.find(relics, Text) then

            if not table.find(_G.Settings.RelicsGivingUp, Text) then
                table.insert(_G.Settings.RelicsGivingUp, Text)
            else
                table.remove(_G.Settings.RelicsGivingUp, table.find(_G.Settings.RelicsGivingUp, Text))
            end

            if isfile and writefile then
                writefile("Banana Hub"..configFolder.."/SwordFightersAutoUpgradeSellingRelicSave"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.RelicsGivingUp))
            end

            Label2:Set("Relics Giving Up: "..table.concat(_G.Settings.RelicsGivingUp,", "))

        end
    end
})

local Dropdown = Tab:CreateDropdown({
    Name = "What To Do With Selected Relics",
    Options = {"Use as sacrifice","Keep and sacrifice others"},
    CurrentOption = "Use as sacrifice",
    Flag = "WhatToDoWithSelectedRelicsForAutoUpgradeRelic", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Option)
        if Option == "Keep and sacrifice others" then
            Option = "Keep"
        elseif Option == "Use as sacrifice" then
            Option = "Use"
        end
        _G.Settings.WhatToDoWithSelectedRelicsForAutoUpgradeRelic = Option
    end,
})

createOptimisedToggle(Tab,"Auto Upgrade Equipped Relic Instead","UpgradeEquippedRelic",nil,true)

local Input = Tab:CreateInput({
    Name = "Enter Relic ID",
    Info = "Press \"Copy Equipped Relic ID\" Below To Get It", -- Speaks for itself, Remove if none.
    PlaceholderText = "None",
    NumbersOnly = false, -- If the user can only type numbers.
    OnEnter = true, -- Will callback only if the user pressed ENTER while being focused.
    RemoveTextAfterFocusLost = true,
    Callback = function(Text)
        _G.Settings.SelectedUpgradeRelic = Text
        if isfile and writefile then
            writefile("Banana Hub"..configFolder.."/SwordFightersAutoUpgradeSelectedRelicSave"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.SelectedUpgradeRelic))
        end
        Label:Set("Selected Relic: "..tostring(_G.Settings.SelectedUpgradeRelic))
    end
})

local function getEquippedRelics()
    local equippedRelics = {}
    local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
    local PlayerData = Knit.GetController("DataController"):GetData("PlayerData")
    for i,v in pairs(PlayerData.RelicInv) do
        if v.equipped then
            table.insert(equippedRelics, i)
        end
    end
    return equippedRelics
end

local Button = Tab:CreateButton({
    Name = "Copy Equipped Relic ID Number One",
    Interact = 'Copy',
    Callback = function()
        if setclipboard then
            setclipboard(tostring(getEquippedRelics()[1]))
        end
    end
})

local Button2 = Tab:CreateButton({
    Name = "Copy Equipped Relic ID Number Two",
    Interact = 'Copy',
    Callback = function()
        if setclipboard then
            setclipboard(tostring(getEquippedRelics()[2]))
        end
    end
})

task.spawn(function()
    local function getEquippedRelicsNAMES()
        local equippedRelics = {}
        local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
        local PlayerData = Knit.GetController("DataController"):GetData("PlayerData")
        for i,v in pairs(PlayerData.RelicInv) do
            if v.equipped then
                table.insert(equippedRelics, v.name)
            end
        end
        return equippedRelics
    end
    
    while task.wait() do
        Button:Set("Copy Equipped Relic ID 1: "..tostring(getEquippedRelicsNAMES()[1]),"Copy")
        Button2:Set("Copy Equipped Relic ID 2: "..tostring(getEquippedRelicsNAMES()[2]),"Copy")
        task.wait(.1)
    end
end)

if false then
    local Section = Tab:CreateSection("Auto Equip Relics")

    createOptimisedToggle(Tab,"Auto Equip Relics","AutoEquipRelics",nil,true)
    createOptimisedToggle(Tab,"You Got Double Relic Gamepass?","HaveDoubleRelic",nil,true)

    local Button = Tab:CreateButton({
        Name = "Copy Equipped Relic ID Number One",
        Interact = 'Copy',
        Callback = function()
            if setclipboard then
                setclipboard(tostring(getEquippedRelics()[1]))
            end
        end
    })

    local Button2 = Tab:CreateButton({
        Name = "Copy Equipped Relic ID Number Two",
        Interact = 'Copy',
        Callback = function()
            if setclipboard then
                setclipboard(tostring(getEquippedRelics()[2]))
            end
        end
    })

    task.spawn(function()
        local function getEquippedRelicsNAMES()
            local equippedRelics = {}
            local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
            local PlayerData = Knit.GetController("DataController"):GetData("PlayerData")
            for i,v in pairs(PlayerData.RelicInv) do
                if v.equipped then
                    table.insert(equippedRelics, v.name)
                end
            end
            return equippedRelics
        end
        
        while task.wait() do
            Button:Set("Copy Equipped Relic ID 1: "..tostring(getEquippedRelicsNAMES()[1]),"Copy")
            Button2:Set("Copy Equipped Relic ID 2: "..tostring(getEquippedRelicsNAMES()[2]),"Copy")
            task.wait(.1)
        end
    end)

    for i,v in pairs(_G.Settings.EquippingRelics) do
        if isfile and readfile and isfile("Banana Hub"..configFolder.."/SwordFightersEquippedRelicsSave"..i..game.Players.LocalPlayer.Name..".json") then
            _G.Settings.EquippingRelics[i] = game:GetService("HttpService"):JSONDecode(readfile("Banana Hub"..configFolder.."/SwordFightersEquippedRelicsSave"..i..game.Players.LocalPlayer.Name..".json"))
        end
    end

    for i,v in pairs(_G.Settings.EquippingRelicsNumberTwo) do
        if isfile and readfile and isfile("Banana Hub"..configFolder.."/SwordFightersEquippedRelicsNumberTwoSave"..i..game.Players.LocalPlayer.Name..".json") then
            _G.Settings.EquippingRelicsNumberTwo[i] = game:GetService("HttpService"):JSONDecode(readfile("Banana Hub"..configFolder.."/SwordFightersEquippedRelicsNumberTwoSave"..i..game.Players.LocalPlayer.Name..".json"))
        end
    end

    for i,v in pairs(_G.Settings.EquippingRelics) do
        local Label = Tab:CreateLabel("1. "..i.." Relic: "..v)
        local Label2 = Tab:CreateLabel("2. "..i.." Relic: ".._G.Settings.EquippingRelicsNumberTwo[i])
        local Input = Tab:CreateInput({
            Name = "1. Relic ID For "..i,
            PlaceholderText = "",
            NumbersOnly = false, -- If the user can only type numbers.
            OnEnter = true, -- Will callback only if the user pressed ENTER while being focused.
            RemoveTextAfterFocusLost = true,
            Callback = function(Text)
                _G.Settings.EquippingRelics[i] = Text
                Label:Set("1. "..i.." Relic: ".._G.Settings.EquippingRelics[i])

                if isfile and writefile then
                    writefile("Banana Hub"..configFolder.."/SwordFightersEquippedRelicsSave"..i..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.EquippingRelics[i]))
                end

            end
        })
        local Input = Tab:CreateInput({
            Name = "2. Relic ID For "..i,
            PlaceholderText = "",
            NumbersOnly = false, -- If the user can only type numbers.
            OnEnter = true, -- Will callback only if the user pressed ENTER while being focused.
            RemoveTextAfterFocusLost = true,
            Callback = function(Text)
                _G.Settings.EquippingRelicsNumberTwo[i] = Text
                Label2:Set("2. "..i.." Relic: ".._G.Settings.EquippingRelicsNumberTwo[i])

                if isfile and writefile then
                    writefile("Banana Hub"..configFolder.."/SwordFightersEquippedRelicsNumberTwoSave"..i..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.EquippingRelicsNumberTwo[i]))
                end

            end
        })
    end
end

if false then
    local Section = Tab:CreateSection("Auto Equip Weapons")

    createOptimisedToggle(Tab,"Auto Equip Weapons","AutoEquipWeapons",nil,true)
    createOptimisedToggle(Tab, "You Have Dual Wield Gamepass?","HaveDualWield",nil,true)

    local weapons = {"Right","Left"}

    for i,v in ipairs(weapons) do
        local Button = Tab:CreateButton({
            Name = "Copy Weapon "..i.." ID",
            Info = "If you dont have dual wield GP only set weapon one\nas the weapon you want to equip", -- Speaks for itself, Remove if none.
            Interact = 'Copy',
            Callback = function()
                if require(game:GetService("ReplicatedStorage").Packages.Knit).GetController("DataController"):GetData("PlayerData").EquippedWeapon[v] then
                    setclipboard(tostring(require(game:GetService("ReplicatedStorage").Packages.Knit).GetController("DataController"):GetData("PlayerData").EquippedWeapon[v]))
                else
                    setclipboard("None")
                end
            end
        })
    end

    for i,v in pairs(_G.Settings.EquippingWeapons) do
        for a,b in ipairs({"One","Two"}) do
            if isfile and readfile and isfile("Banana Hub"..configFolder.."/SwordFightersEquippedWeaponsSave"..i..b..game.Players.LocalPlayer.Name..".json") then
                _G.Settings.EquippingWeapons[i][b] = game:GetService("HttpService"):JSONDecode(readfile("Banana Hub"..configFolder.."/SwordFightersEquippedWeaponsSave"..i..b..game.Players.LocalPlayer.Name..".json"))
            end
        end
    end

    for i,v in pairs(_G.Settings.EquippingWeapons) do
        local function info()
            local info = {
                "Weapon One: ".._G.Settings.EquippingWeapons[i]["One"],
                "Weapon Two: ".._G.Settings.EquippingWeapons[i]["Two"]
            }
            return info
        end
        local Paragraph = Tab:CreateParagraph({Title = i, Content = table.concat(info(),"\n")})
        for a,b in ipairs({"One","Two"}) do
            local Input = Tab:CreateInput({
                Name = "Weapon "..b.." ID",
                PlaceholderText = "",
                NumbersOnly = false, -- If the user can only type numbers.
                OnEnter = true, -- Will callback only if the user pressed ENTER while being focused.
                RemoveTextAfterFocusLost = true,
                Callback = function(Text)
                    _G.Settings.EquippingWeapons[i][b] = Text
                    Paragraph:Set({Title = i, Content = table.concat(info(),"\n")})
        
                    if isfile and writefile then
                        writefile("Banana Hub"..configFolder.."/SwordFightersEquippedWeaponsSave"..i..b..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.EquippingWeapons[i][b]))
                    end
        
                end
        
            })
        end
    end
end

local Section = Tab:CreateSection("Auto Egg")

createOptimisedToggle(Tab,"Auto Hatch Egg","AutoHatchEgg",
function()

    while task.wait() do
        if table.find(eggs, _G.Settings.SelectedEgg) then
            coroutine.resume(coroutine.create(function()
                game:GetService("ReplicatedStorage").Packages.Knit.Services.EggService.RF.BuyEgg:InvokeServer({["eggName"] = getEggID(_G.Settings.SelectedEgg),["baseAmount"] = 1,["auto"] = false,["amount"] = _G.Settings.EggAmount})
            end))
        end
    end

end)

local eggDrop = Tab:CreateDropdown({
    Name = "Select Egg",
    Options = eggs,
    CurrentOption = "None",
    Flag = "Dropdown4", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Option)
        if table.find(eggs, Option) then
            _G.Settings.SelectedEgg = Option
        end
    end
})

local Slider = Tab:CreateSlider({
    Name = "Select Multi-Open Egg Amount",
    Info = "Set to like 2 if you have multi-open", -- Speaks for itself, Remove if none.
    Range = {1, 25},
    Increment = 1,
    Suffix = "Eggs",
    CurrentValue = 1,
    Flag = "Slider2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        _G.Settings.EggAmount = Value
    end
})

createOptimisedToggle(Tab, "Automatically Select Closest Egg","SelectClosestEgg",function()

    while task.wait() do
        local closestEgg = nil
        local closestDist = math.huge
        for i,v in pairs(game:GetService("Workspace").Resources.Eggs:GetChildren()) do
            local distanceInStuds = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Position).Magnitude
            if distanceInStuds < closestDist then
                closestEgg = v
                closestDist = distanceInStuds
            end
        end
        eggDrop:Set(DatabaseController:GetDatabase("Eggs")[closestEgg.Name].name)
        task.wait(1)
    end

end)

local Section = Tab:CreateSection("Auto Upgrade")

Tab:CreateDropdown({
    Name = "Select Area",
    Options = worlds,
    CurrentOption = "None",
    Flag = "Dropdown2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Option)
        if table.find(worlds, Option) then
            _G.Settings.AutoUpgradeWorld = Option
        end
    end
})

local upgrades = {"Power Gain","More Storage","WalkSpeed"}

for i,v in ipairs(upgrades) do
    createOptimisedToggle(Tab,"Auto Upgrade "..v,"AutoUpgrade"..v,nil,true)
end

local Tab = Window:CreateTab("Auto Buy", 11642692687) -- Title, Image

local Section = Tab:CreateSection("Main")

createOptimisedToggle(Tab, "Enable Features Which Are Enabled Below","AutoBuyEnableTab",function()

    local function getCurrentAreaForTravellingMerchant()
        --
        for i,v in pairs(game:GetService("Workspace").Resources.LimitedShop.TravellingMerchant:GetChildren()) do
            if v:FindFirstChild("Model") and v.Model:FindFirstChild("Merchant") and v.Model.Merchant:FindFirstChild("Head") then
                if v.Model.Merchant.Head.Transparency == 0 then
                    return v.Name
                end
            end
        end
        --
        return "None"
    end 

    local function buyTravellingMerchantItem(area, itemName)

        local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
        local DatabaseController = Knit.GetController("DatabaseController")
        local boostsABC = DatabaseController:GetDatabase("Boosts")
        
        if boostsABC[itemName] then
            itemName = boostsABC[itemName].name.." Boost"
        end

        for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.LimitedShops.Background.ImageFrame.Window.Items.ItemHolder:GetChildren()) do
            local lastChar = v.Name
            lastChar = string.sub(lastChar, -1, -1)
            local thingName = v.Name
            thingName = thingName:sub(0, -2)
            if thingName:match("TravellingMerchant"..area) and v.Frame.Contents.TextLabel.Text == itemName and tonumber(lastChar) then
                game:GetService("ReplicatedStorage").Packages.Knit.Services.LimitedShopsService.RF.BuyItem:InvokeServer("TravellingMerchant", tonumber(lastChar))
                break
            end
        end

    end

    while task.wait() do

        if _G.Settings.AutoBuyMerchant then
            pcall(function()

                local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
                local DatabaseController = Knit.GetController("DatabaseController")
                
                for i,v in pairs(DatabaseController:GetDatabase("TravellingMerchant")) do
                    pcall(function()
                        for index,v in pairs(v) do
                            if i == getCurrentAreaForTravellingMerchant() and table.find(_G.Settings.MerchantItemsToBuy, v.reward.statType) then
                                --game:GetService("ReplicatedStorage").Packages.Knit.Services.LimitedShopsService.RF.BuyItem:InvokeServer("TravellingMerchant", index)
                                buyTravellingMerchantItem(i, v.reward.statType)
                            end
                        end
                    end)
                end

            end)
        end

        if _G.Settings.AutoBoost then

            local function dictionaryEmpty(dictionary)
                for i,v in pairs(dictionary) do
                    return false
                end
                return true
            end

            local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
            local PlayerData = Knit.GetController("DataController"):GetData("PlayerData")
            local DatabaseController = Knit.GetController("DatabaseController")
            local PlayerBoosts = PlayerData.Boosts
            local DungeonShop = DatabaseController:GetDatabase("DungeonShop")

            for i,v in pairs(DungeonShop) do
                if _G.Settings["Boost "..v.reward.statType.." Auto Buy"] then
                    if _G.Settings.AutoBoostBuyType[v.reward.statType] == 1 then
                        for _ = 1,5 do
                            coroutine.resume(coroutine.create(function()
                                game:GetService("ReplicatedStorage").Packages.Knit.Services.LimitedShopsService.RF.BuyItem:InvokeServer("DungeonShop",i)
                            end))
                            task.wait(.01)
                        end
                    elseif _G.Settings.AutoBoostBuyType[v.reward.statType] == 2 and dictionaryEmpty(PlayerBoosts[v.reward.statType].remaining) then
                        coroutine.resume(coroutine.create(function()
                            game:GetService("ReplicatedStorage").Packages.Knit.Services.LimitedShopsService.RF.BuyItem:InvokeServer("DungeonShop",i)
                        end))
                        task.wait(.01)
                    end
                end
            end

            local function canDoPotion(i)
                local selectedOptions = _G.Settings.EventUsingOnFor[i] or {}
                if table.find(selectedOptions, "Any") or table.find(selectedOptions, goToAfkPosition(true)) then
                   return true
                elseif ((tostring(_G.DungeonInformation["roomReached"]) ~= "0" and game.Players.LocalPlayer:GetAttribute("Dungeon")) and _G.Settings.SelectedDungeon) and (table.find(selectedOptions, _G.Settings.SelectedDungeon)) then
                    return true
                elseif game.Players.LocalPlayer:GetAttribute("Raid") and table.find(selectedOptions, "Raid") then
                    return true
                elseif game.Players.LocalPlayer:GetAttribute("Tower") and table.find(selectedOptions, "Tower") then
                    return true
                elseif _G.DoingCorruption and table.find(selectedOptions, "Corruption") then
                    return true
                end
                return false
            end

            for i,v in pairs(PlayerBoosts) do
                if v.timeLeft and v.timeLeft == 0 and not dictionaryEmpty(v.remaining) and _G.Settings["Boost "..i.." Auto Use"] then
                    if canDoPotion(i) then
                        for a,b in pairs(v.remaining) do
                            if tonumber(b) > 0 then
                                game:GetService("ReplicatedStorage").Packages.Knit.Services.BoostService.RF.UseBoost:InvokeServer(i,a)
                                break
                            end
                        end
                    end
                end
            end

        end

        task.wait(1)

    end

end)

if true then
    local Section = Tab:CreateSection("Auto Buy Travelling Merchant")

    --AutoBuyMerchant
    --MerchantItemsToBuy

    local TravellingMerchantItems = {}
    pcall(function()
        local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
        local PlayerData = Knit.GetController("DataController"):GetData("PlayerData")
        local DatabaseController = Knit.GetController("DatabaseController")
        local LimitedShops = DatabaseController:GetDatabase("LimitedShops")
        
        
        for i,v in pairs(LimitedShops) do
            if i == "TravellingMerchant" then
                local TravellingMerchantItemsCC = DatabaseController:GetDatabase(i)
                for i,v in pairs(TravellingMerchantItemsCC) do
                    pcall(function()
                        for i,v in pairs(v) do
                            for i,v in pairs(v.reward) do
                                if i == "statType" and not table.find(TravellingMerchantItems, v) then
                                    table.insert(TravellingMerchantItems, v)
                                    --warn(v)
                                end
                            end
                        end
                    end)
                end
            end
        end
    end)

    createOptimisedToggle(Tab, "Enabled","AutoBuyMerchant",nil,true)

    if isfile and readfile and isfile("Banana Hub"..configFolder.."/SwordFightersSelectedMerchantItemsToBuySave"..game.Players.LocalPlayer.Name..".json") then
        _G.Settings.MerchantItemsToBuy = game:GetService("HttpService"):JSONDecode(readfile("Banana Hub"..configFolder.."/SwordFightersSelectedMerchantItemsToBuySave"..game.Players.LocalPlayer.Name..".json"))
    end

    local Label = Tab:CreateLabel("Buying Merchant Items: "..table.concat(_G.Settings.MerchantItemsToBuy,", "))

    Tab:CreateDropdown({
        Name = "Select Merchant Items To Buy",
        Options = TravellingMerchantItems,
        CurrentOption = "None",
        Flag = "DropdownMerchantItemsToBuy", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlapsMe
        Callback = function(Option)
            if _G.NowLoaded and table.find(TravellingMerchantItems, Option) then

                if table.find(_G.Settings.MerchantItemsToBuy, Option) then
                    table.remove(_G.Settings.MerchantItemsToBuy, table.find(_G.Settings.MerchantItemsToBuy, Option))
                else
                    table.insert(_G.Settings.MerchantItemsToBuy, Option)
                end

                if isfile and writefile then
                    writefile("Banana Hub"..configFolder.."/SwordFightersSelectedMerchantItemsToBuySave"..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.MerchantItemsToBuy))
                end

                Label:Set("Buying Merchant Items: "..table.concat(_G.Settings.MerchantItemsToBuy,", "))

            end
        end,
    })
end


local Section = Tab:CreateSection("Auto Buy/Use Time Trial Things")

local boosts = {}
for i,v in pairs(DatabaseController:GetDatabase("Boosts")) do
    table.insert(boosts, i)
    _G.Settings.AutoBoostBuyType[i] = 0
    _G.Settings["Boost "..i.." Auto Use"] = false
    _G.Settings["Boost "..i.." Auto Buy"] = false
end

local events = {"Any","Day","Night","Blood","Dungeon 1","Dungeon 2","Dungeon 3","Corruption","Tower","Raid"}

createOptimisedToggle(Tab, "Enabled","AutoBoost",nil,true)

_G.Settings.EventUsingOnFor = {}

for i,v in ipairs(boosts) do
    _G.Settings.EventUsingOnFor[v] = {}
    Tab:CreateLabel("Boost Name: "..v)
    createOptimisedToggle(Tab, "Auto Use Boost When No Time-left","Boost "..v.." Auto Use",nil,true)

    if isfile and readfile and isfile("Banana Hub"..configFolder.."/SwordFightersSelectedEventUseOnFor"..v..game.Players.LocalPlayer.Name..".json") then
        _G.Settings.EventUsingOnFor[v] = game:GetService("HttpService"):JSONDecode(readfile("Banana Hub"..configFolder.."/SwordFightersSelectedEventUseOnFor"..v..game.Players.LocalPlayer.Name..".json"))
    end

    local Label = Tab:CreateLabel("Events Using On: "..table.concat(_G.Settings.EventUsingOnFor[v], ", "))

    local Dropdown = Tab:CreateDropdown({
        Name = "Select Event To Use",
        Options = events,
        CurrentOption = "Any",
        Flag = "DropdownAutoBoostUseType"..v, -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(Option)

            if _G.NowLoaded and table.find(events, Option) then

                if table.find(_G.Settings.EventUsingOnFor[v], Option) then
                    table.remove(_G.Settings.EventUsingOnFor[v], table.find(_G.Settings.EventUsingOnFor[v], Option))
                else
                    table.insert(_G.Settings.EventUsingOnFor[v], Option)
                end

                if isfile and writefile then
                    writefile("Banana Hub"..configFolder.."/SwordFightersSelectedEventUseOnFor"..v..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(_G.Settings.EventUsingOnFor[v]))
                end

                Label:Set("Events Using On: "..table.concat(_G.Settings.EventUsingOnFor[v], ", "))

            end

        end
    })
    createOptimisedToggle(Tab, "Auto Buy Boost","Boost "..v.." Auto Buy",nil,true)
    local Dropdown = Tab:CreateDropdown({
        Name = "Select Boost Buy Type",
        Options = {"Buy All Stock Of A Boost","Buy Boost Until Have Atleast 1"},
        CurrentOption = "None",
        Flag = "DropdownAutoBoostBuyType"..v, -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(Option)
            _G.Settings.AutoBoostBuyType[v] = table.find({"Buy All Stock Of A Boost","Buy Boost Until Have Atleast 1"}, Option) or 0
            --warn("Boost Type: ".._G.Settings.AutoBoostBuyType[v].."\nBoost Name: "..v)        
        end
    })
end

local others = {"RaidTickets"}
for i,v in pairs(others) do
    _G.Settings.AutoBoostBuyType[i] = 0
    _G.Settings["Item "..i.." Auto Buy"] = false
end

for i,v in pairs(others) do
    Tab:CreateLabel("Item Name: "..v)
    createOptimisedToggle(Tab, "Auto Buy Item","Item "..v.." Auto Buy",nil,true)
    local Dropdown = Tab:CreateDropdown({
        Name = "Select Item Buy Type",
        Options = {"Buy All Stock Of An Item","Buy Item Until Have Atleast 1"},
        CurrentOption = "None",
        Flag = "DropdownAutoItemBuyType"..v, -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(Option)
            _G.Settings.AutoBoostBuyType[v] = table.find({"Buy All Stock Of An Item","Buy Item Until Have Atleast 1"}, Option) or 0
            --warn("Item Type: ".._G.Settings.AutoBoostBuyType[v].."\nItem Name: "..v)        
        end
    })
end

local Tab = Window:CreateTab("Priority", 11642692687) -- Title, Image

local Section = Tab:CreateSection("Info")

local Label = Tab:CreateLabel("The Higher The Number The More It Will Be Prioritized Over The Other Options")

local Section = Tab:CreateSection("Main")

for i,v in pairs(_G.Settings.Priorities) do
    if i ~= "HIDING" then
        local Slider = Tab:CreateSlider({
            Name = i,
            Info = "The Higher The Number The Higher Prioritization It Will have", -- Speaks for itself, Remove if none.
            Range = {1, 10},
            Increment = 1,
            Suffix = "",
            CurrentValue = v,
            Flag = "SliderPrioritization"..i, -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
            Callback = function(Value)
                _G.Settings.Priorities[i] = Value
            end
        })
    end
end

local Tab = Window:CreateTab("Misc", 11642692687) -- Title, Image

local Section = Tab:CreateSection("Main")

createOptimisedToggle(Tab, "UI Toggles Enabled","UITOGGLESENABLED",function()

    while task.wait() do

        if _G.Settings.RaidResultUI then
            for i,v in pairs(getconnections(game:GetService("ReplicatedStorage").Packages.Knit.Services.RaidService.RE.RaidResult.OnClientEvent)) do
                v:Disable()
            end
        end
        if _G.Settings.DungeonResultUI then
            for i,v in pairs(getconnections(game:GetService("ReplicatedStorage").Packages.Knit.Services.DungeonService.RE.DungeonResult.OnClientEvent)) do
                v:Disable()
            end
        end
        if _G.Settings.EggOpeningUI then
            for i,v in pairs(getconnections(game:GetService("ReplicatedStorage").Packages.Knit.Services.EggService.RE.OpenEggEvent.OnClientEvent)) do
                v:Disable()
            end
        end
        

        task.wait(10)
    end

end)

local Section = Tab:CreateSection("UIs")

createOptimisedToggle(Tab, "Disable Raid Result UI","RaidResultUI",nil,true)
createOptimisedToggle(Tab, "Disable Dungeon Result UI","DungeonResultUI",nil,true)
createOptimisedToggle(Tab, "Disable Egg Opening UI","EggOpeningUI",nil,true)

local Button = Tab:CreateButton({
    Name = "Disable all UIs (can't undo need rejoin)",
    Interact = 'Click',
    Callback = function()
        for i,v in pairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
            local disabled = false
            pcall(function()
                if v.Name ~= "Rayfield" then
                    v.Enabled = false
                    disabled = true
                else 
                    disabled = true
                end
            end)
            if not disabled then
                v:Destroy()
            end
            task.wait(.01)
        end

        for i,v in pairs(game:GetService("CoreGui"):GetChildren()) do
            local disabled = false
            pcall(function()
                if v.Name ~= "Rayfield" then
                    v.Enabled = false
                    disabled = true
                else
                    disabled = true
                end
            end)
            if not disabled then
                v:Destroy()
            end
            task.wait(.01)
        end
    end
})

local Section = Tab:CreateSection("Click Speed")

_G.CPSSlider = Tab:CreateSlider({
    Name = "Click Speed",
    Info = "Increases Attack Speed/Click Speed", -- Speaks for itself, Remove if none.
    Range = {1, 250},
    Increment = 1,
    Suffix = " Speed",
    CurrentValue = 1,
    Flag = "SliderForClickSpeed", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        _G.Settings.ClickSpeed = Value
    end
})

local Section = Tab:CreateSection("Kill Aura")

createOptimisedToggle(Tab, "Auto Attack Closest Mobs","KillAura",function()

    while task.wait() do

        for i,v in pairs(game:GetService("Workspace").Live.NPCs.Client:GetChildren()) do
            local function mob(v)
                return game:GetService("Workspace").Live.NPCs.Server[v.Name]
            end
            if mob(v) and getStudLength(mob(v)) < 50 and mob(v):GetAttribute("Health") > 0 then
                click(mob(v).Name)
            end
        end

        task.wait(.1)
    end

end,false,function()

    _G.CanTap = false

end)

local Section = Tab:CreateSection("Mobs")

createOptimisedToggle(Tab, "Farm Close Range/Rendered Mobs Only","FarmRenderedMobsOnly",nil,true)

local Tab = Window:CreateTab("FPS Boost", 11642692687) -- Title, Image

local Section = Tab:CreateSection("Render")

createOptimisedToggle(Tab, "Disable 3D Rendering","THREEDRENDERDISABLE",function()
    
    while task.wait() do
        local UserInputService = game:GetService("UserInputService")
        local RunService = game:GetService("RunService")
        RunService:Set3dRenderingEnabled(false)
        task.wait(1)
    end

end,false,function()

    task.wait(.1)
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    RunService:Set3dRenderingEnabled(true)

end)

local Tab = Window:CreateTab("Teleports", 11642692687) -- Title, Image

local Section = Tab:CreateSection("Areas")

Tab:CreateDropdown({
   Name = "Select Area to TP",
   Options = worlds,
   CurrentOption = "None",
   Flag = "Dropdown3", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Option)
    if _G.NowLoaded then
        if game:GetService("Workspace").Resources.Spawns:FindFirstChild(Option) then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Resources.Spawns[Option].CFrame
        elseif game:GetService("Workspace").Resources.QuestDummy:FindFirstChild(Option) then
            for i = 1,100 do
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Resources.QuestDummy[Option]:GetModelCFrame() * CFrame.new(0,10,0)
                game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
                task.wait(.01)
            end
            task.wait(.1)
            pcall(function()
                game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
            end)
        end
    end
   end
})

local Tab = Window:CreateTab("🤫", 11642692687) -- Title, Image

--HopWhenSMClose
--HopWhenSMCloseStuds

local Section = Tab:CreateSection("Main")

createOptimisedToggle(Tab, "Tab Enabled","TabServerEnabled",function()

    while task.wait() do

        if _G.Settings.HopWhenSMClose then
            for i,v in pairs(game:GetService("Players"):GetPlayers()) do
                if v ~= game.Players.LocalPlayer then
                    pcall(function()
                        if getStudLength(v.Character.HumanoidRootPart.CFrame) < _G.Settings.HopWhenSMCloseStuds then
                            ----print(_G.Settings.HopWhenSMCloseStuds)
                            ----print(getStudLength(v.Character.HumanoidRootPart.CFrame))
                            ----warn("Hoppin...")
                            _G.HOPANDHIDE()
                        end
                    end)
                end
            end
        end


        task.wait(1)

    end

end)

local Section = Tab:CreateSection("Near")

createOptimisedToggle(Tab, "Server Hop To Low Player Server When Someone Is Within X Studs Of You","HopWhenSMClose",nil,true)

local Slider = Tab:CreateSlider({
    Name = "Studs Radius",
    Range = {0, 10000},
    Increment = 10,
    Suffix = "Studs",
    CurrentValue = 1000,
    Flag = "SliderHopWhenSMCloseStuds", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        _G.Settings.HopWhenSMCloseStuds = Value
    end
})

local Section = Tab:CreateSection("Safe")

_G.Settings.WhitelistedPlayers = {}
if isfile and readfile and isfile("Banana Hub/SwordFightersWhitelistedPlayers.json") then
    _G.Settings.WhitelistedPlayers = game:GetService("HttpService"):JSONDecode(readfile("Banana Hub/SwordFightersWhitelistedPlayers.json"))
end

local Label = Tab:CreateLabel("Whitelisted Players: "..table.concat(_G.Settings.WhitelistedPlayers,", "))

local Input = Tab:CreateInput({
    Name = "Enter Plr REAL name",
    PlaceholderText = "Enter",
    NumbersOnly = false, -- If the user can only type numbers.
    CharacterLimit = nil, --max character limit. Remove if none.
    OnEnter = true, -- Will callback only if the user pressed ENTER while being focused.
    RemoveTextAfterFocusLost = true,
    Callback = function(Text)
        
        if table.find(_G.Settings.WhitelistedPlayers, Text) then
            table.remove(_G.Settings.WhitelistedPlayers, table.find(_G.Settings.WhitelistedPlayers, Text))
        else
            table.insert(_G.Settings.WhitelistedPlayers, Text)
        end

        if isfile and writefile then
            writefile("Banana Hub/SwordFightersWhitelistedPlayers.json",game:GetService("HttpService"):JSONEncode(_G.Settings.WhitelistedPlayers))
        end

        Label:Set("Whitelisted Players: "..table.concat(_G.Settings.WhitelistedPlayers,", "))

    end
})

createOptimisedToggle(Tab, "Kick when someone else in server","kickwhensomeoneelseinserver",function()

    while task.wait() do
        if _G.Settings.kickwhensomeoneelseinserver then
            for i,v in pairs(game:GetService("Players"):GetPlayers()) do
                if v.Name ~= game.Players.LocalPlayer.Name and not table.find(_G.Settings.WhitelistedPlayers, v.Name) then
                    game.Players.LocalPlayer:Kick("Someone Else Here ONKONOONKONOKDNSKOANKODNSKOANOKDAS RUNNNNNN!!")
                end
            end
        end
        task.wait(1)
    end

end)

local Tab = Window:CreateTab("Premium", 11642692687) -- Title, Image

local Section = Tab:CreateSection("Premium")

local Label = Tab:CreateLabel("You must buy premium to use.")

createOptimisedToggle(Tab, "Unlock All Battlepass (need 2-5 levels)","AutoBattlepass",function()

    while task.wait() do


        if lgTagsTbl then
            if table.find(lgTagsTbl, 'Premium') then
                --warn("Premium Found Activating Unlock All Battlepass")
                for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Battlepass.Background.Tabs.Rewards.Main.Scroll:GetChildren()) do
                    pcall(function()
                        v.Free.ClaimButton.Visible = true
                        v.Premium.ClaimButton.Visible = true
                    end)
                end
            end
        end
        
    end

end)

createOptimisedToggle(Tab, "Infinite Stardust (Patched)","AutoStarDust",function()

    while task.wait() do


        if lgTagsTbl then
            if table.find(lgTagsTbl, 'Premium') then
                --warn("Premium Found Activating Inf Stardust")
                for i,v in pairs(require(game:GetService("ReplicatedStorage").Packages.Knit).GetController("DataController"):GetData("PlayerData").PetInv) do
                    game:GetService("ReplicatedStorage").Packages.Knit.Services.PetFeedingService.RF.Feed:InvokeServer(i, 0/0)
                end
            end
        end
        
    end

end)

_G.HOPANDHIDE = function()
    _G.HIDING = true
    task.spawn(function()
        while task.wait() do
            pcall(function()
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(100000,100000,100000)
            end)
        end
    end)
    pcall(function()
        local Http = game:GetService("HttpService")
        local TPS = game:GetService("TeleportService")
        local Api = "https://games.roblox.com/v1/games/"

        local _place = game.PlaceId
        local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=100"
        function ListServers(cursor)
        local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
        return Http:JSONDecode(Raw)
        end

        local Server, Next; repeat
        local Servers = ListServers(Next)
        Server = Servers.data[1]
        Next = Servers.nextPageCursor
        until Server

        TPS:TeleportToPlaceInstance(_place,Server.id,game.Players.LocalPlayer)
    end)
    task.spawn(function()
        task.wait(15)
        pcall(function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
        end)
    end)
end

Rayfield:LoadConfiguration()
task.wait(1)
if isfile and readfile and isfile("Banana Hub"..configFolder.."/MainAutoFarmToggleEnabled"..game.Players.LocalPlayer.Name..".json") then
    local data = game:GetService("HttpService"):JSONDecode(readfile("Banana Hub"..configFolder.."/MainAutoFarmToggleEnabled"..game.Players.LocalPlayer.Name..".json"))
    autoFarmToggle:Set(data)
end
task.wait(4)
_G.NowLoaded = true
---- anti-afk

local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function()
vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
wait(1)
vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)
game.Players.LocalPlayer.AttributeChanged:Connect(function(n)
    if n == "Idle" then
        game.Players.LocalPlayer:SetAttribute("Idle", false)
    end
end)


------------ webhooks

_G.Webhook = function(webhookLink)
    
	--pcall(function()
		local url = tostring(webhookLink)
		if url == "" then return end
			
        local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
        local PlayerData = Knit.GetController("DataController"):GetData("PlayerData")
        local DatabaseController = Knit.GetController("DatabaseController")

        local Stats = {
            "Coins: "..PlayerData["Coins"].." ("..game.Players.LocalPlayer.leaderstats.Coins.Value..")",
            "Power: "..PlayerData["Power"].." ("..game.Players.LocalPlayer.leaderstats.Power.Value..")",
            "Ascends: "..PlayerData["Ascends"],
            "Raid Tickets: "..PlayerData["RaidTickets"],
            "Reroll Tokens: "..PlayerData["RerollTokens"],
            "Total Eggs Opened: "..PlayerData["TotalEggsOpened"]
        }

        local Shards = {}
        for ShardName, ShardAmount in pairs(PlayerData["Shards"]) do
            table.insert(Shards, DatabaseController:GetDatabase("Shards")[ShardName].name..": "..ShardAmount)
        end

        local Relics = {}
        local TotalRelicsDictionary = {}
        for i,v in pairs(PlayerData["RelicInv"]) do
            local relicName = v.name
            if not TotalRelicsDictionary[relicName] then
                TotalRelicsDictionary[relicName] = 1
            else
                TotalRelicsDictionary[relicName] += 1
            end
        end
        for i,v in pairs(TotalRelicsDictionary) do
            table.insert(Relics, i..": x"..v)
        end

        local Weapons = {}
        local TotalWeaponsDictionary = {}
        for i,v in pairs(PlayerData["WeaponInv"]) do
            local WeaponName = v.name
            if not TotalWeaponsDictionary[WeaponName] then
                TotalWeaponsDictionary[WeaponName] = 1
            else
                TotalWeaponsDictionary[WeaponName] += 1
            end
        end
        for i,v in pairs(TotalWeaponsDictionary) do
            table.insert(Weapons, i..": x"..v)
        end

        local function format(number, secondMethod, secondMethodMainValue)
            if secondMethod and tonumber(secondMethodMainValue) then
                return ""
            elseif secondMethod and secondMethod:match("-") then
                return "(- "..secondMethodMainValue..")"
            elseif secondMethod and secondMethod:match("+") then
                return "(+ "..secondMethodMainValue..")"
            elseif secondMethod then
                return ""
            end
            local str = tostring(number)
            if str:match("-") then
                return "\n- "..str:split("-")[2]
            elseif str == "0" then
                return ""
            elseif tonumber(str) > 0 then
                return "\n+ "..str
            end
        end

        if _G.LastData then
            
            local function getShardID(shardName)
                for i,v in pairs(DatabaseController:GetDatabase("Shards")) do
                    if v.name == shardName then
                        return i
                    end
                end
            end

            local lastCoinsValue = _G.LastData["Stats"][1]:split(": ")[2]:split(" ")[1]
            if tonumber(lastCoinsValue) then
                local currentCoins = PlayerData["Coins"]
                local ab = format(currentCoins - tonumber(lastCoinsValue))
                local extra = format(nil, ab, require(Knit.Util.Utility).CurrencyEnding(tonumber(tostring(currentCoins - tonumber(lastCoinsValue)):gsub("-",""):split(" ")[1])))
                Stats[1] = Stats[1].." "..ab.." "..extra
            end

            local lastPowerValue = _G.LastData["Stats"][2]:split(": ")[2]:split(" ")[1]
            if tonumber(lastPowerValue) then
                local currentPower = PlayerData["Power"]
                local ab = format(currentPower - tonumber(lastPowerValue))
                local extra = format(nil, ab, require(Knit.Util.Utility).CurrencyEnding(tonumber(tostring(currentPower - tonumber(lastPowerValue)):gsub("-",""):split(" ")[1])))
                Stats[2] = Stats[2].." "..ab.." "..extra
            end

            local lastAscendsValue = _G.LastData["Stats"][3]:split(": ")[2]
            if tonumber(lastAscendsValue) then  
                local currentAscends = PlayerData["Ascends"]
                Stats[3] = Stats[3].." "..format(currentAscends - tonumber(lastAscendsValue))
            end

            local lastRaidTickets = _G.LastData["Stats"][4]:split(": ")[2]
            if tonumber(lastRaidTickets) then
                local currentRaidTickets = PlayerData["RaidTickets"]
                Stats[4] = Stats[4].." "..format(currentRaidTickets - tonumber(lastRaidTickets))
            end

            local lastRerolls = _G.LastData["Stats"][5]:split(": ")[2]
            if tonumber(lastRerolls) then
                local currentRerolls = PlayerData["RerollTokens"]
                Stats[5] = Stats[5].." "..format(currentRerolls - tonumber(lastRerolls))
            end

            local lastTotalEggs = _G.LastData["Stats"][6]:split(": ")[2]
            if tonumber(lastTotalEggs) then
                local currentTotalEggs = PlayerData["TotalEggsOpened"]
                Stats[6] = Stats[6].." "..format(currentTotalEggs - tonumber(lastTotalEggs))
            end

            for i,v in pairs(_G.LastData["Shards"]) do
                local shardName = v:split(": ")[1]
                local lastShardsValue = v:split(": ")[2]
                if tonumber(lastShardsValue) then
                    local currentShardsValue = PlayerData["Shards"][getShardID(shardName)]
                    for i,v in pairs(Shards) do
                        if v:match(shardName) then
                            Shards[i] = Shards[i].." "..format(currentShardsValue - tonumber(lastShardsValue))
                            break
                        end
                    end
                end
            end

        end

        _G.LastData = {
            ["Stats"] = Stats,
            ["Shards"] = Shards,
            ["Relics"] = Relics,
            ["Weapons"] = Weapons
        }

		local data = {
            ["username"]= "Banana Hub",
            ["avatar_url"]= "https://cdn.discordapp.com/attachments/1005254929197301761/1053328388015796264/123banana.png",
            ["content"]= "**Username: **||"..game.Players.LocalPlayer.Name.."||\n**Game: **Sword Fighters Simulator\n```diff\nStats:\n¬ "..table.concat(Stats,"\n¬ ").."\n\nShards:\n¬ "..table.concat(Shards,"\n¬ ").."\n\nRelic Inventory:\n¬ "..table.concat(Relics,"\n¬ ").."\n\nWeapon Inventory:\n¬ "..table.concat(Weapons,"\n¬ ").."\n\n```",
            ["embeds"]= {},
            ["components"]= {}
          }

		local hts = game:GetService("HttpService"):JSONEncode(data)

		local headers = {["content-type"] = "application/json"}
		request = http_request or request or HttpPost or syn.request or http.request
		local abAL = {Url = url, Body = hts, Method = "POST", Headers = headers}
		--warn("Sending webhook notification...")
		request(abAL)
	--end)
end

game:GetService("RunService").RenderStepped:Connect(function()
    pcall(function()
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = _G.Settings.WalkSpeed
    end)
end)

--

_G.WebHookCSM = LPH_JIT_MAX(function(gameName, title, info, WBLINK)
	pcall(function()
		local url = WBLINK or tostring(_G.Settings.WebhookLink)
		if not url or url == "" then return end
			
        local plr = game.Players.LocalPlayer

		local data = {
            username = "Banana Hub",
            avatar_url = "https://cdn.discordapp.com/attachments/1005254929197301761/1053328388015796264/123banana.png",
            content = "**Username:** ||"..game.Players.LocalPlayer.Name.."||\n**Game:** "..gameName.."\n",
            embeds = {
              {
                title = title,
                color = Color3.fromRGB(math.random(350),math.random(350),math.random(350)),
                description = info,
                timestamp = "",
                author = {
                  name = ""
                },
                image = {},
                thumbnail = {},
                footer = {},
                fields = {}
              }
            },
            components = {}
        }

		local hts = game:GetService("HttpService"):JSONEncode(data)

		local headers = {["content-type"] = "application/json"}
		request = http_request or request or HttpPost or syn.request or http.request
		local aba = {Url = url, Body = hts, Method = "POST", Headers = headers}
		--warn("Sending webhook..")
		request(aba)
	end)
end)

