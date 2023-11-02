-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")


-- References
local RepMaps = ReplicatedStorage:WaitForChild("Maps")
local PlayArea = workspace.PlayArea
local Buildings = workspace.Buildings
local SpawnBox = Buildings.SpawnBox

local mapModulesFolder = ServerScriptService:WaitForChild("Server"):WaitForChild("Modules"):WaitForChild("AllMaps")

-- Events
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local WaitForTimerEvent = RemoteEvents:WaitForChild("WaitForGameTimer")
local SetCameraStartGameEvent = RemoteEvents:WaitForChild("SetCameraStartGame")

local MapsFolder = ReplicatedStorage:WaitForChild("Maps")
local getMaps = MapsFolder:GetChildren()

local map = {}

function map.Wait(timer, mapName)
    -- send a remote event to client to update the timer
    task.wait(2)
    WaitForTimerEvent:FireAllClients(mapName.. " starting in", timer)
    
    task.wait(timer)
end

function map.Select(maxPlayers)
    local random = math.random(1,#getMaps)
    local selectedMap = getMaps[random]
    -- TESTING DELETE LATE-- TESTING DELETE LATE-- TESTING DELETE LATE-- TESTING DELETE LATE
    local selectedMap = MapsFolder:FindFirstChild("Jump")
    -- TESTING DELETE LATE-- TESTING DELETE LATE-- TESTING DELETE LATE-- TESTING DELETE LATE
    map.Wait(3, selectedMap.Name)
    map.Spawn(selectedMap, maxPlayers)
end

function map.Spawn(selectedMap, maxPlayers)
    local getMap = RepMaps:FindFirstChild(selectedMap.Name)
    -- if we cant find a map for some reason, default to the tags map
    if not getMap then
        getMap = RepMaps:FindFirstChild("Jump")
    end

    -- REQUIRE HERE?
    ----------------------------- MODULE SCRIPT HERE ----------------------- TO CLONE THE MAPS
    local moduleMap = require(mapModulesFolder[getMap.Name])
    moduleMap.Generate(getMap, maxPlayers)
    -- clone the map into the playarea
    local clonedMap = getMap:Clone()
    clonedMap.Parent = PlayArea
    
    task.wait(10)
    PlayArea:ClearAllChildren()

    local listOfPlayers = Players:GetPlayers()
    for i, player in ipairs(listOfPlayers) do
        player.Character.PrimaryPart.CFrame = SpawnBox.Spawn.CFrame
        player.Character.Humanoid.WalkSpeed = 16
    end
    SetCameraStartGameEvent:FireAllClients(map.Camera, true)
end


return map