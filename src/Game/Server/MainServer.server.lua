-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local map = require(ReplicatedStorage.Modules.Map)

-- References
local RepMaps = ReplicatedStorage:WaitForChild("Maps")
local PlayArea = workspace.PlayArea
local SpawnBox = workspace.SpawnBox

-- Events
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local WaitForTimerEvent = RemoteEvents:WaitForChild("WaitForGameTimer")
local WaitForPlayersEvent = RemoteEvents:WaitForChild("WaitForPlayers")








-- Functions
local function SpawnMap(map)
    local getMap = RepMaps:FindFirstChild(map.Name)
    -- if we cant find a map for some reason, default to the tags map
    if not getMap then
        getMap = RepMaps:FindFirstChild("Tag")
    end

    -- REQUIRE HERE?
    ----------------------------- MODULE SCRIPT HERE -----------------------

    -- clone the map into the playarea
    local clonedMap = getMap:Clone()
    clonedMap.Parent = PlayArea

    -- disable the platform in the spawnBox
    -- CASE IS WHAT IF THIS DOES NOT EXIST? then just teleport the . do later
    SpawnBox.Floor.Transparency = 1
    SpawnBox.Floor.CanCollide = false
end

-- end game remote event here
-- Remote Events

local function WaitForGame(timer)
    -- send a remote event to client to update the timer
    task.wait(2)
    WaitForTimerEvent:FireAllClients("passing to client", timer)
    
    task.wait(timer)
    print("SERVER")
end


------------------------------- MAIN -------------------------------
-- gather all maps currently available
local MapsFolder = ReplicatedStorage:WaitForChild("Maps")
local getMaps = MapsFolder:GetChildren()

local numberOfPlayers = 0
local maxPlayers = 0
Players.PlayerAdded:Connect(function(player)
    numberOfPlayers +=1
    local teleportData = player:GetJoinData().TeleportData
    if teleportData then
        maxPlayers = teleportData.MaxPlayers
    else
        -- this means we are in roblox studio, we can set number of players to uhh 1
        maxPlayers = 1
    end
    -- send Gui Update to everyone
    WaitForPlayersEvent:FireAllClients(numberOfPlayers, maxPlayers)
    if numberOfPlayers >= maxPlayers then
        -- ACTUALLY, CREATE A NEW TABLE THAT FITS IN WITH THE AMOUNT OF PLAYERS THERE ARE.

        -- CHECK NOW AND CHECK AGAIN BEFORE MAP SELECTIONS TO SEE IF A PLAYER LEAVES

        WaitForGame(10)
        -- get a number between 1 and all avaialble maps
        local random = math.random(1,#getMaps)
        local selectedMap = getMaps[random]

        -- SEND A REMOTE EVENT TO CLIENT AND ADD THE RANDOM MAP SELECTOR HERE. 2nd priority

        print(selectedMap)
        -- idea. require the module script that we need
        -- hard code for now, after this we can spawn in the map into the workspace 
        SpawnMap(selectedMap)
    end
end)

