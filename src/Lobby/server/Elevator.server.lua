-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
-- 

-- variables
local elevator = workspace.Elevator
local waitingPlayers = {}

local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local elevatorEvent = RemoteEvents:WaitForChild("ElevatorInside")

-- constants
local WAITING_MAX_PLAYERS = 4

local function touchedElevator(part)
    -- check if the part that touched elevator is that of a player
    local player = Players:GetPlayerFromCharacter(part.parent)
    if not player then return end

    -- check if the player is already waiting in the table to avoid dupes
    local checkWaiting = table.find(waitingPlayers, player.UserId)
    if checkWaiting then return end
    
    -- if it is a player, then teleport them inside the elevator. store in the userID to avoid weird duplicate names scenarios
    table.insert(waitingPlayers, player.UserId)
    print(waitingPlayers)
    elevatorEvent:FireClient(player, elevator)
    player.Character.PrimaryPart.CFrame = elevator.Inside.CFrame
end

local function playerLeavesElevator(player)
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
end



----------------------- MAIN -----------------------
elevator.Entrance.Touched:Connect(touchedElevator)
elevatorEvent.OnServerEvent:Connect(playerLeavesElevator)

