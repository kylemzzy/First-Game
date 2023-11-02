-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Players = game:GetService("Players")

-- Events
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")

local SetCameraStartGameEvent = RemoteEvents:WaitForChild("SetCameraStartGame")
local GameExplainCutscene = RemoteEvents:WaitForChild("GameExplainEvent")

local jump = {}

function jump.Generate(map, maxPlayers)
    print("JUMP MODULE")
    -- SetCameraStartGameEvent:FireAllClients(map.Camera, false)
    jump.Cutscene()
    -- for each of the players, spawn them in 1 by one to the platform
    local listOfPlayers = Players:GetPlayers()
    for i, player in ipairs(listOfPlayers) do
        -- player.Character.PrimaryPart.CFrame = map.Spawns[i].CFrame
        player.Character.Humanoid.WalkSpeed = 0
    end
end

function jump.Cutscene()
    -- create a table of words to use for the cutscene and send it in
    local dialogue = {}
    print("WOOOOO")
    SetCameraStartGameEvent:FireAllClients(workspace.Buildings.Stadium.BigGuy.Camera, false)
    GameExplainCutscene:FireAllClients()
end

return jump