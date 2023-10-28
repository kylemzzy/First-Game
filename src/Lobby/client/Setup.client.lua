-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")


-- References
local Player = game.Players.LocalPlayer

local PlayerGui = Player:WaitForChild("PlayerGui") 
local StartGame = PlayerGui:WaitForChild("StartGame")
local blurGui = StartGame:WaitForChild("ScreenGui")

local buttonClick = SoundService.ButtonPress

local camera = workspace.CurrentCamera
local introPart = workspace.Map.StartScreen

-- Variables
local saveWalkSpeed = 16




------------------------------------------- MAIN -------------------------------------------
-- play music
SoundService.LobbyBM:Play()

-- GUI's here
blurGui.Enabled = true
blurGui.TextButton.Visible = true
-- load camera for ariel view
camera.CameraType = Enum.CameraType.Scriptable
camera.CFrame = introPart.CFrame

-- Blur temporary effect here
local blur = Instance.new("BlurEffect")
blur.Parent = Lighting
blur.Size = 10
-- grab previous walkspeed
local playerHumanoid = Player.Character:WaitForChild("Humanoid")

if playerHumanoid then
    saveWalkSpeed = playerHumanoid.WalkSpeed
end
playerHumanoid.WalkSpeed = 0

blurGui.TextButton.Activated:Connect(function()
    buttonClick:Play()
    -- short transition blur without tweening
    for i=10, 1, -1 do
        blur.Size = i
        task.wait(.05)
    end
    -- Destroy blur as we do not need it
    blur:Destroy()
    blurGui.Enabled = false
    -- revert camera and movement
    camera.CameraType = Enum.CameraType.Custom
    camera.CameraSubject = Player.Character.Humanoid
    playerHumanoid.WalkSpeed = saveWalkSpeed 
    introPart:Destroy()
end)