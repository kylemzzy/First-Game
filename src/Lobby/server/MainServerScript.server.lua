-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- Requires
local elevator = require(ServerScriptService.Server.Modules.Elevator)

-- References
local getElevators = workspace.Map.Elevators








----------------------- MAIN -----------------------
-- spawn in elevators. Loop through all the elevators in the workspace and for each of the elevators, call the module functions
local templates = getElevators:GetChildren()
for _, part in ipairs(templates) do
    elevator.New(part)
end