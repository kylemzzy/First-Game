-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- References
local RepMaps = ReplicatedStorage:WaitForChild("Maps")
local PlayArea = workspace.PlayArea
local SpawnBox = workspace.SpawnBox

local mapModulesFolder = ServerScriptService:WaitForChild("Server"):WaitForChild("Modules"):WaitForChild("AllMaps")

-- Events
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local WaitForTimerEvent = RemoteEvents:WaitForChild("WaitForGameTimer")

local MapsFolder = ReplicatedStorage:WaitForChild("Maps")
local getMaps = MapsFolder:GetChildren()

local map = {}

function map.Wait(timer, mapName)
    -- send a remote event to client to update the timer
    task.wait(2)
    WaitForTimerEvent:FireAllClients(mapName.. " starting in", timer)
    
    task.wait(timer)
end

function map.Select()
    local random = math.random(1,#getMaps)
    local selectedMap = getMaps[random]
    map.Wait(10, selectedMap.Name)
    map.Spawn(selectedMap)
end

function map.Spawn(selectedMap)
    local getMap = RepMaps:FindFirstChild(selectedMap.Name)
    -- if we cant find a map for some reason, default to the tags map
    if not getMap then
        getMap = RepMaps:FindFirstChild("Jump")
    end

    -- REQUIRE HERE?
    ----------------------------- MODULE SCRIPT HERE ----------------------- TO CLONE THE MAPS
    local moduleMap = require(mapModulesFolder[getMap.Name])
    moduleMap.Generate()
    -- clone the map into the playarea
    local clonedMap = getMap:Clone()
    clonedMap.Parent = PlayArea

    -- disable the platform in the spawnBox
    -- CASE IS WHAT IF THIS DOES NOT EXIST? then just teleport the . do later
    SpawnBox.Floor.Transparency = 1
    SpawnBox.Floor.CanCollide = false
end


return map