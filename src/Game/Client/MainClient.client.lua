local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- References
local Player = game.Players.LocalPlayer

-- GUI's
local PlayerGui = Player:WaitForChild("PlayerGui") 
local TimerGui = PlayerGui:WaitForChild("Timer")
local TimerTextLabel = TimerGui:WaitForChild("TextLabel")


-- Events
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local WaitForTimerEvent = RemoteEvents:WaitForChild("WaitForGameTimer")
local WaitForPlayersEvent = RemoteEvents:WaitForChild("WaitForPlayers")




WaitForTimerEvent.OnClientEvent:Connect(function(message, timer)
    print(message, timer)
    for i = timer-1, 0, -1 do
        task.wait(1)
        TimerTextLabel.Text = message .. " " .. i .. " seconds"
    end
end)

WaitForPlayersEvent.OnClientEvent:Connect(function(numberOfPlayers, maxPlayers)
    TimerTextLabel.Text = "Waiting for players: ".. numberOfPlayers .. "/" .. maxPlayers
end)