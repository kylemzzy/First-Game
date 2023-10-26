-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
-- 

-- References
local elevator = workspace.Elevator
local playerCountGui = elevator.NumberOfPlayers.SurfaceGui.TextLabel
local countdownGui = elevator.WaitingForPlayers.SurfaceGui.TextLabel
local maxPlayers = elevator.Configs.MaxPlayers.Value


local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local RemoteEventsElevator = RemoteEvents:WaitForChild("Elevator")
local elevatorEnterLeaveEvent = RemoteEventsElevator:WaitForChild("EnterLeave")
local elevatorTeleportEvent = RemoteEventsElevator:WaitForChild("Teleporting")

-- Variables
local waitingPlayers = {}
local countdownRunning = false

----------------------- FUNCTIONS -----------------------
local function Setup()
    -- elevator initialization
    waitingPlayers = {}
    playerCountGui.Text = #waitingPlayers .. "/" .. maxPlayers .. " Players"
    countdownGui.Text = "Waiting For Players..."
end

local function UpdatePlayerCount()
    -- update text if player leaves or joins
    playerCountGui.Text = #waitingPlayers .. "/" .. maxPlayers .. " Players"
end

local function StartCountDown()
    -- prevent countdown from resetting if there is at least 1 person
    countdownRunning = true
    -- countdown every second
    for i = 5, 1, -1 do
        countdownGui.Text = "Teleporting in " .. i .. " seconds"
        task.wait(1)
        -- if everyone leaves the elevator, then we stop countdown
        if #waitingPlayers < 1 then
            countdownGui.Text = "Waiting For Players..."
            countdownRunning = false
            return
        end
    end
    -- start teleporting here
    print ("TELEPORTING....")
    -- teleport each player in the table 1 by 1
    for _, playerID in pairs(waitingPlayers) do
        -- must convert the id to get the player object
        local player = Players:GetPlayerByUserId(playerID)
        -- perform any client side teleportations here
        elevatorTeleportEvent:FireClient(player)
    end
    countdownGui.Text = "Teleporting Players..."
    countdownRunning  = false

    task.wait(1)
    Setup()
end

elevator.Entrance.Touched:Connect(function(part)
    -- check if the part that touched elevator is that of a player
    local player = Players:GetPlayerFromCharacter(part.parent)
    if not player then return end

    -- check if the player is already waiting in the table to avoid dupes
    local checkWaiting = table.find(waitingPlayers, player.UserId)
    if checkWaiting then return end

    -- if the max player is at max capacity
    if #waitingPlayers >= maxPlayers then return end
    
    -- if it is a player, then teleport them inside the elevator. store in the userID to avoid weird duplicate names scenarios
    table.insert(waitingPlayers, player.UserId)
    elevatorEnterLeaveEvent:FireClient(player, elevator) -- remoteEvent to change the camera from clients side
    player.Character.PrimaryPart.CFrame = elevator.Inside.CFrame
    -- update the players text
    UpdatePlayerCount()
    -- if the countdown isnt running then start it
    if not countdownRunning then
        StartCountDown()
    end
end)

elevatorEnterLeaveEvent.OnServerEvent:Connect(function(player)
    -- remove player from table if we find them
    local checkWaiting = table.find(waitingPlayers, player.UserId)
    if checkWaiting then
        -- when removing, we can only remove the index, we achieve by table.find
        table.remove(waitingPlayers, checkWaiting)
    end
    -- if the character for the player exists, teleport them outside of the elevator
    if player.Character then
        player.Character.PrimaryPart.CFrame = elevator.Outside.CFrame
    end
    -- update the players text
    UpdatePlayerCount()
end)

Players.PlayerRemoving:Connect(function(player)
    -- check to see if the player is in the the waiting queue upon leaving, 
    local checkWaiting = table.find(waitingPlayers, player.UserId)
    -- if they are then we remove them
    if checkWaiting then
        -- when removing, we can only remove the index, we achieve by table.find
        table.remove(waitingPlayers, checkWaiting)
    end
    UpdatePlayerCount()
end)


----------------------- MAIN -----------------------
Setup()



