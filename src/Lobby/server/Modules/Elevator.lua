-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

-- Requires
-- local RepModules = ReplicatedStorage:WaitForChild("Modules")
local FailedTeleports = require(ServerScriptService.Shared.Modules.FailedTeleports)
local dataManager = require(ServerScriptService.Shared.Modules.SavingData.DataManager)


-- References
local ObjectOrientatedModels = ReplicatedStorage:WaitForChild("ObjectOrientatedModels")

local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local RemoteEventsElevator = RemoteEvents:WaitForChild("Elevator")
local elevatorEnterLeaveEvent = RemoteEventsElevator:WaitForChild("EnterLeave")
local elevatorTeleportEvent = RemoteEventsElevator:WaitForChild("Teleporting")

-- module function start
local elevator = {}

function elevator.TeleportPlayers(waitingPlayers)
    -- teleport players and reserve servers
    local reservedServerCode = TeleportService:ReserveServer(15148385760)
    local options = Instance.new("TeleportOptions")
    local gameAreaPlaceID = 15148385760
    options.ReservedServerAccessCode = reservedServerCode
    -- pass data to teleport, the number of players
    options:SetTeleportData({
        ["MaxPlayers"] = #waitingPlayers
    })
    -------------------POSSIBLE PROBLEM, lock players from rejoining -------------------
    -- roblox provided module script to handle failed teleports
    FailedTeleports(gameAreaPlaceID, waitingPlayers, options)
end

function elevator.StartCountDown(countdownGui, waitingPlayers, maxPlayers, playerCountGui)
    -- countdown every second
    for i = 5, 1, -1 do
        countdownGui.Text = "Teleporting in " .. i .. " seconds"
        task.wait(1)
        -- if everyone leaves the elevator, then we stop countdown
        if #waitingPlayers < 1 then
            countdownGui.Text = "Waiting For Players..."
            return false
        end
    end
    -- start teleporting here
    print ("TELEPORTING....")
    -- teleport each player in the table 1 by 1
    for _, player in pairs(waitingPlayers) do
        -- perform any client side teleportations here
        elevatorTeleportEvent:FireClient(player)
    end
    countdownGui.Text = "Teleporting Players..."
    elevator.TeleportPlayers(waitingPlayers)
    task.wait(1)
    elevator.Setup(maxPlayers, waitingPlayers, playerCountGui, countdownGui)
    return false
end

function elevator.UpdatePlayerCount(playerCountGui, waitingPlayers, maxPlayers)
    -- update text if player leaves or joins
    playerCountGui.Text = #waitingPlayers .. "/" .. maxPlayers .. " Players"
end

function elevator.Setup(maxPlayers, waitingPlayers, playerCountGui, countdownGui)
    waitingPlayers = {}

    -- edit gui text here
    playerCountGui.Text = #waitingPlayers .. "/" .. maxPlayers .. " Players"
    countdownGui.Text = "Waiting For Players..."
end

function elevator.New(template)
    -- search for the elevator name in the models folder in rep Storage
    local templateElevatorModel = ObjectOrientatedModels.Elevators:FindFirstChild(template.Name)
    if not templateElevatorModel then return end
    -- position the elevator to the workspace template
    local elevatorModel = templateElevatorModel:Clone()
    elevatorModel.Parent = workspace.Map.Elevators
    elevatorModel:PivotTo(template.CFrame)

    -- elevator initialization
    local playerCountGui = elevatorModel.NumberOfPlayers.SurfaceGui.TextLabel
    local countdownGui = elevatorModel.WaitingForPlayers.SurfaceGui.TextLabel
    local maxPlayers = elevatorModel.Configs.MaxPlayers.Value
    local waitingPlayers = {}
    local countdownRunning = false
    
    -- call the setup here
    elevator.Setup(maxPlayers, waitingPlayers,  playerCountGui, countdownGui)
    -- listen event to teleport inside 
    elevatorModel.Entrance.Touched:Connect(function(part)
        -- check if the part that touched elevator is that of a player
        local player = Players:GetPlayerFromCharacter(part.parent)
        if not player then return end
    
        -- check if the player is already waiting in the table to avoid dupes
        local checkWaiting = table.find(waitingPlayers, player)
        if checkWaiting then return end
        
        -- if the max player is at max capacity
        if #waitingPlayers >= maxPlayers then return end
        
        -- if it is a player, then teleport them inside the elevator. store in the userID to avoid weird duplicate names scenarios
        table.insert(waitingPlayers, player)
        elevatorEnterLeaveEvent:FireClient(player, elevatorModel) -- remoteEvent to change the camera from clients side
        player.Character.PrimaryPart.CFrame = elevatorModel.Inside.CFrame
        -- update the players text
        elevator.UpdatePlayerCount(playerCountGui, waitingPlayers, maxPlayers)
        -- if the countdown isnt running then start it
        if not countdownRunning then
            countdownRunning = true
            countdownRunning = elevator.StartCountDown(countdownGui, waitingPlayers, maxPlayers, playerCountGui)
        end
    end)
    -- event for if player leaves 
    elevatorEnterLeaveEvent.OnServerEvent:Connect(function(player)
        -- remove player from table if we find them
        local checkWaiting = table.find(waitingPlayers, player)
        if not checkWaiting then return end
        -- due to OOP, decide which elevator we want to teleport to based on where the player is at
        table.remove(waitingPlayers, checkWaiting)
        -- if the character for the player exists, teleport them outside of the elevator
        if player.Character then
            print(elevatorModel.Name)
            player.Character.PrimaryPart.CFrame = elevatorModel.Outside.CFrame
        end
        -- update the players text
        elevator.UpdatePlayerCount(playerCountGui, waitingPlayers, maxPlayers)

        ------------------------------- TEMP --------------------------------- 
        local data = dataManager:Get(player)
        -- if data does not exist
        if data == nil then
            print(Players.Name .. " data not loaded or non existant in elevator")
            return
        end
        data.softCurrency += 10
        -- show it on leaderstats
        player.leaderstats.Soft.Value = data.softCurrency
        print (player.Name .. " has: " .. data.softCurrency ) 
    end)

    -- destroy the template placeholder
    template:Destroy()
end

return elevator