-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")


-- References
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local RemoteEventsElevator = RemoteEvents:WaitForChild("Elevator")
local elevatorEnterLeaveEvent = RemoteEventsElevator:WaitForChild("EnterLeave")

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui") 

local camera = workspace.CurrentCamera

local exitButtonGui = PlayerGui:WaitForChild("exitButtonGui") 


----------------------- FUNCTIONS -----------------------
elevatorEnterLeaveEvent.OnClientEvent:Connect(function(elevator)
    -- set the exit gui button visible and change camera to view from outside
    exitButtonGui.TextButton.Visible = true
    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = elevator.Camera.CFrame
end)
    

exitButtonGui.TextButton.Activated:Connect(function()
    -- set camera back to normal, and teleport the player from server side
    exitButtonGui.TextButton.Visible = false
    camera.CameraType = Enum.CameraType.Custom
    camera.CameraSubject = Player.Character.Humanoid
    elevatorEnterLeaveEvent:FireServer()
end)




----------------------- MAIN -----------------------

