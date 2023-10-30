local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

-- References
local Player = game.Players.LocalPlayer
local tickingSound = SoundService.tickingSound
local startGameSound = SoundService.startGameSound


-- GUI's
local PlayerGui = Player:WaitForChild("PlayerGui") 
local TimerGui = PlayerGui:WaitForChild("Timer")
local TimerTextLabel = TimerGui:WaitForChild("TextLabel")

local camera = workspace.CurrentCamera


-- Events
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local WaitForTimerEvent = RemoteEvents:WaitForChild("WaitForGameTimer")
local WaitForPlayersEvent = RemoteEvents:WaitForChild("WaitForPlayers")

local SetCameraStartGameEvent = RemoteEvents:WaitForChild("SetCameraStartGame")

-- set the camera to the view of the map when game starts
SetCameraStartGameEvent.OnClientEvent:Connect(function(cameraCFrame, spawn)
    if spawn then
        camera.CameraSubject = Player.Character.Humanoid
        camera.CameraType = Enum.CameraType.Custom
    else
        camera.CameraType = Enum.CameraType.Scriptable
        camera.CFrame = cameraCFrame.CFrame
    end
    
end)

WaitForTimerEvent.OnClientEvent:Connect(function(message, timer)
    -- timer to start game, update the client Gui
    for i = timer-1, 0, -1 do
        task.wait(1)
        -- have a ticking sound play when <= 5 seconds
        if i <= 5 and i > 0 then
            tickingSound:Play()
        end
        if i == 0 then
            startGameSound:Play()
        end
        TimerTextLabel.Text = message .. " " .. i .. " seconds"
    end
    TimerTextLabel.Visible = false
end)
-- initial loading, where we wait for all players to load
WaitForPlayersEvent.OnClientEvent:Connect(function(numberOfPlayers, maxPlayers)
    TimerTextLabel.Text = "Waiting for players: ".. numberOfPlayers .. "/" .. maxPlayers
end)