-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")


-- References

-- Variables
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui") 


------------------------------------------- MAIN -------------------------------------------
-- play music
SoundService.LobbyBM:Play()

-- GUI's here