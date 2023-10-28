-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

-- References













------------------------------- MAIN -------------------------------
-- gather all maps currently available
local MapsFolder = ReplicatedStorage:WaitForChild("Maps")
local getMaps = MapsFolder:GetChildren()

-- get a number between 1 and all avaialble maps
local random = math.random(1,#getMaps)
print(getMaps[random].Name)



-- idea. require the module script that we need