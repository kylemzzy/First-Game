local players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local dataManager = require(ReplicatedStorage.Modules.SavingData.DataManager)

-- WE DONT NEED THIS CAUSE WE SHOW LEADERSTATS ON DATA MANAGER
local function updateLeaderStats(player)
    -- task.wait(2)
    -- local data = dataManager:Get(player)
    -- -- if data does not exist
    -- if not data then 
    --     print ("LEADERSTTS TELLO???")    
    -- end
end

players.PlayerAdded:Connect(updateLeaderStats)