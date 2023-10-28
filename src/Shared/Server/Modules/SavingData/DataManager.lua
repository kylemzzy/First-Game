local players = game:GetService("Players")
-- local Workspace = game:GetService("Workspace")
local profileService = require(script.Parent.ProfileService)

local profiles = {}
-- name of the module is dataManager, and as per modules we have to return it
-- purpose :: load profiles via data manager and give it to other scripts when they need it 
-- store the profiles in the profiles table
local dataManager = {}

-- pass in the player, and a template of what we want to store on that player
local template = {
    softCurrency = 0,
    hardCurrency = 0
}

local profileStore = profileService.GetProfileStore("Player", template)

local function createLeaderStats(player, data)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local soft = Instance.new("IntValue")
    soft.Name = "Soft"
    soft.Parent = leaderstats
    soft.Value = data.softCurrency

    local hard = Instance.new("IntValue")
    hard.Name = "Hard"
    hard.Parent = leaderstats
    hard.Value = data.hardCurrency
end

local function onPlayerAdded(player)
    -- we need 2 things: Player and a Toggle if we want to lock server session "yes" to prevent item duping
    print("DataManager player added...")
    local profile = profileStore:LoadProfileAsync(
        "Player_" .. player.UserId,
        "ForceLoad"
    )
    -- check if the profile doesnt exist, we then kick
    if profile == nil then
        player:Kick()
        return
    end 
    -- reconcile this will look for any update in template
    profile:Reconcile("Player", template)
    -- have alisten event that will constnatly listen. we need this to know when 
    -- a profile gets released so we can remove it from the table
    profile:ListenToRelease(function()
        profiles[player] = nil
        player:Kick()
    end)
    -- since loading profile takes time, players can leave during this
    -- we need to check if the player is still in the game
    if player:IsDescendantOf(players) then
        profiles[player] = profile;
    else 
        -- if player 
        profile:Release()
        return
    end

    -- insert leaderstats here this is after we set the players table in descentant checking
    createLeaderStats(player, profiles[player].Data)
end
-- when the player leaves, we would want to remove the profile from the table
local function onPlayerRemoving(player)
    -- checks if player exists in the table
    local profile = profiles[player]
    -- if it does then release it. we already have a listen to release
    if profile then
        profile:Release()
    end
end

players.PlayerAdded:Connect(onPlayerAdded)
players.PlayerRemoving:Connect(onPlayerRemoving)

-- make a function to get the profiles via a player
-- i think that we this is our own function we will call "named get" 
function dataManager:Get(player)
    -- set the profile?
    -- in luea we could search for said item by indexing
    local profile = profiles[player]
    -- if found then return it, else do nothing
    if profile then
        return profile.Data
    end
end
-- return module script
return dataManager