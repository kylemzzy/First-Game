-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

-- References
local RepMaps = ReplicatedStorage:WaitForChild("Maps")
local PlayArea = workspace.PlayArea
local SpawnBox = workspace.SpawnBox

-- Events
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local WaitForTimerEvent = RemoteEvents:WaitForChild("WaitForGameTimer")

local map = {}


return map