-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")


-- Variables
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local elevatorEvent = RemoteEvents:WaitForChild("ElevatorInside")
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui") 
local camera = workspace.CurrentCamera

-- GUI's
local exitButtonGui = PlayerGui:WaitForChild("exitButtonGui") 


local function showExitGui (elevator)
    exitButtonGui.TextButton.Visible = true
    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = elevator.Camera.CFrame
end

local function exitGuiPressed ()
    exitButtonGui.TextButton.Visible = false
    camera.CameraType = Enum.CameraType.Custom
    camera.CameraSubject = Player.Character.Humanoid
    elevatorEvent:FireServer()
end




----------------------- MAIN -----------------------
elevatorEvent.OnClientEvent:Connect(showExitGui)
exitButtonGui.TextButton.Activated:Connect(exitGuiPressed)

