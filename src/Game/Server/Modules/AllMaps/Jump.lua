-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Players = game:GetService("Players")

-- Events
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")

local SetCameraStartGameEvent = RemoteEvents:WaitForChild("SetCameraStartGame")

local jump = {}

function jump.Generate(map, maxPlayers)
    print("JUMP MODULE")
    SetCameraStartGameEvent:FireAllClients(map.Camera, false)
    -- for each of the players, spawn them in 1 by one to the platform
    local listOfPlayers = Players:GetPlayers()
    for i, player in ipairs(listOfPlayers) do
        player.Character.PrimaryPart.CFrame = map.Spawns[i].CFrame
        player.Character.Humanoid.WalkSpeed = 0
    end
end

function jump.Cutscene()
    
end

return jump