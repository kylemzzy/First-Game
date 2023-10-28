-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SoundService = game:GetService("SoundService")
-- References
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local RemoteEventsElevator = RemoteEvents:WaitForChild("Elevator")
local elevatorEnterLeaveEvent = RemoteEventsElevator:WaitForChild("EnterLeave")
local elevatorTeleportEvent = RemoteEventsElevator:WaitForChild("Teleporting")


local buttonClick = SoundService.ButtonPress
local enterElevator = SoundService.Woosh

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui") 

local camera = workspace.CurrentCamera

local exitButtonGui = PlayerGui:WaitForChild("exitButtonGui") 


----------------------- FUNCTIONS -----------------------
elevatorEnterLeaveEvent.OnClientEvent:Connect(function(elevator)
    enterElevator:Play()
    -- set the exit gui button visible and change camera to view from outside
    exitButtonGui.TextButton.Visible = true
    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = elevator.Camera.CFrame
end)

elevatorTeleportEvent.OnClientEvent:Connect(function()
    exitButtonGui.TextButton.Visible = false
end)
    

exitButtonGui.TextButton.Activated:Connect(function()
    elevatorEnterLeaveEvent:FireServer()
    task.wait(.04)
    buttonClick:Play()
    -- set camera back to normal, and teleport the player from server side
    exitButtonGui.TextButton.Visible = false
    camera.CameraSubject = Player.Character.Humanoid
    camera.CameraType = Enum.CameraType.Custom
end)




----------------------- MAIN -----------------------

