-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
-- local TeleportService = game:GetService("TeleportService")

-- Requries
local map = require(ServerScriptService.Server.Modules.Map)

-- References

-- Events
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local WaitForPlayersEvent = RemoteEvents:WaitForChild("WaitForPlayers")




-- Variables
local numberOfPlayers = 0
local maxPlayers = 0

------------------------------- MAIN -------------------------------
SoundService.GeneralBackground:Play()
SoundService.Crowd:Play()
-- gather all maps currently available
Players.PlayerAdded:Connect(function(player)
    numberOfPlayers +=1
    -- teleport data sent in the number of players that teleported, we can use that as max players
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
        map.Select(maxPlayers)
    end
end)

