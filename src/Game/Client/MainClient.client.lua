local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Events
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local WaitForTimerEvent = RemoteEvents:WaitForChild("WaitForGameTimer")



WaitForTimerEvent.OnClientEvent:Connect(function(message)
    print(message)
end)