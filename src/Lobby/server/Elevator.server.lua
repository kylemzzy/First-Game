local Players = game:GetService("Players")
-- 

-- variables
local elevator = workspace.Elevator
local waitingPlayers = {}

-- constants
local WAITING_MAX_PLAYERS = 4

local function touchedElevator(part)
    -- check if the part that touched elevator is that of a player
    local player = Players:GetPlayerFromCharacter(part.parent)
    if not player then return end

    -- check if the player is already waiting in the table to avoid dupes
    local checkWaiting = table.find(waitingPlayers, player.UserId)
    if checkWaiting then return end
    
    print("INSERTED ")

    -- if it is a player, then teleport them inside the elevator. store in the userID to avoid weird duplicate names scenarios
    table.insert(waitingPlayers, player.UserId)
    print(waitingPlayers)
    player.Character.PrimaryPart.CFrame = elevator.Inside.CFrame
end



----------------------- MAIN -----------------------
elevator.Entrance.Touched:Connect(touchedElevator)


