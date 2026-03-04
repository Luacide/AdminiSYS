local AnticheatAPI = {}

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")

-- Config (can be overridden before calling AnticheatAPI.Init())
AnticheatAPI.CONFIG = {
    ALLOWED_PLACE_ID = 123456,
    MAX_SPEED = 50,
    MAX_FLAGS_BEFORE_KICK = 3,
    MAX_FLAGS_BEFORE_BAN = 6,
    BAN_DATASTORE = "BannedPlayers",
    LOG_TO_CONSOLE = true,
}

-- Internal state
local FlaggedPlayers = {}
local LastPositions = {}
local LastTimestamps = {}
local BanStore

-----------------------------------------
-- LOGGING
-----------------------------------------
local function Log(msg, level)
    if not AnticheatAPI.CONFIG.LOG_TO_CONSOLE then return end
    print(string.format("[ANTICHEAT][%s] %s", level or "INFO", msg))
end

-----------------------------------------
-- CORE API
-----------------------------------------

function AnticheatAPI.Flag(player, reason)
    local uid = player.UserId
    FlaggedPlayers[uid] = (FlaggedPlayers[uid] or 0) + 1
    local flags = FlaggedPlayers[uid]

    Log(string.format("%s flagged (%d) — %s", player.Name, flags, reason), "WARN")

    if flags >= AnticheatAPI.CONFIG.MAX_FLAGS_BEFORE_BAN then
        AnticheatAPI.Ban(player, reason)
    elseif flags >= AnticheatAPI.CONFIG.MAX_FLAGS_BEFORE_KICK then
        AnticheatAPI.Kick(player, reason)
    end
end

function AnticheatAPI.Kick(player, reason)
    Log("Kicking " .. player.Name .. " — " .. reason, "KICK")
    player:Kick("Anticheat: " .. reason)
end

function AnticheatAPI.Ban(player, reason)
    Log("Banning " .. player.Name .. " — " .. reason, "BAN")
    pcall(function()
        BanStore:SetAsync(tostring(player.UserId), {
            banned = true,
            reason = reason,
            timestamp = os.time()
        })
    end)
    player:Kick("Banned: " .. reason)
end

function AnticheatAPI.Unban(userId)
    pcall(function()
        BanStore:RemoveAsync(tostring(userId))
    end)
    Log("Unbanned UserId: " .. tostring(userId))
end

function AnticheatAPI.IsBanned(player)
    local ok, data = pcall(function()
        return BanStore:GetAsync(tostring(player.UserId))
    end)
    if ok and data and data.banned then
        return true, data.reason
    end
    return false, nil
end

function AnticheatAPI.GetFlags(player)
    return FlaggedPlayers[player.UserId] or 0
end

function AnticheatAPI.ClearFlags(player)
    FlaggedPlayers[player.UserId] = 0
    Log("Cleared flags for " .. player.Name)
end

-----------------------------------------
-- BUILT-IN CHECKS
-----------------------------------------

local function CheckPlaceId()
    if game.PlaceId ~= AnticheatAPI.CONFIG.ALLOWED_PLACE_ID then
        Log("Wrong PlaceId: " .. tostring(game.PlaceId), "ERROR")
        for _, p in ipairs(Players:GetPlayers()) do
            AnticheatAPI.Kick(p, "Unauthorized place.")
        end
    end
end

local function StartSpeedCheck()
    RunService.Heartbeat:Connect(function()
        local now = tick()
        for _, player in ipairs(Players:GetPlayers()) do
            local uid = player.UserId
            local char = player.Character
            if not char then continue end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then continue end

            local lastPos = LastPositions[uid]
            local lastTime = LastTimestamps[uid]

            if lastPos and lastTime then
                local elapsed = now - lastTime
                if elapsed > 0 then
                    local speed = (root.Position - lastPos).Magnitude / elapsed
                    if speed > AnticheatAPI.CONFIG.MAX_SPEED then
                        AnticheatAPI.Flag(player, string.format("Speed hack (%.1f studs/s)", speed))
                    end
                end
            end

            LastPositions[uid] = root.Position
            LastTimestamps[uid] = now
        end
    end)
end

local function StartFlyCheck()
    task.spawn(function()
        while true do
            task.wait(2)
            for _, player in ipairs(Players:GetPlayers()) do
                local char = player.Character
                if not char then continue end
                local root = char:FindFirstChild("HumanoidRootPart")
                local humanoid = char:FindFirstChildWhichIsA("Humanoid")
                if not root or not humanoid then continue end

                local rayResult = workspace:Raycast(root.Position, Vector3.new(0, -20, 0))
                if not rayResult and humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then
                    AnticheatAPI.Flag(player, "Possible flight/noclip")
                end
            end
        end
    end)
end

-----------------------------------------
-- PLAYER LIFECYCLE
-----------------------------------------

local function SetupPlayerListeners()
    Players.PlayerAdded:Connect(function(player)
        local banned, reason = AnticheatAPI.IsBanned(player)
        if banned then
            player:Kick("You are banned: " .. (reason or "Unknown"))
            return
        end
        FlaggedPlayers[player.UserId] = 0
        Log(player.Name .. " passed ban check.")
    end)

    Players.PlayerRemoving:Connect(function(player)
        local uid = player.UserId
        FlaggedPlayers[uid] = nil
        LastPositions[uid] = nil
        LastTimestamps[uid] = nil
    end)
end

-----------------------------------------
-- INIT
-----------------------------------------

function AnticheatAPI.Init(configOverrides)
    -- Allow overriding config before init
    if configOverrides then
        for k, v in pairs(configOverrides) do
            AnticheatAPI.CONFIG[k] = v
        end
    end

    BanStore = DataStoreService:GetDataStore(AnticheatAPI.CONFIG.BAN_DATASTORE)

    CheckPlaceId()
    StartSpeedCheck()
    StartFlyCheck()
    SetupPlayerListeners()

    Log("Anticheat API v1.0 initialized.")
end

return AnticheatAPI
