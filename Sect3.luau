local CombatTab = Window:CreateTab("Combat", "sword")

CombatTab:CreateSection("Fight Stugg")

-- [[ TRIGGERBOT SECTION: FULL LOGIC ]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")

CombatTab:CreateToggle({
    Name = "Triggerbot",
    CurrentValue = false,
    Flag = "Triggerbot_Toggle", -- Flag for configuration saving
    Callback = function(Value)
        _G.Triggerbot = Value
        
        -- Start the loop only if it's not already running
        if _G.Triggerbot and not _G.TriggerbotLoop then
            _G.TriggerbotLoop = true
            
            task.spawn(function()
                while _G.Triggerbot do
                    -- Raycast check: What is the mouse pointing at?
                    local Target = Mouse.Target
                    if Target and Target.Parent then
                        -- Check if the target is a player part (Head, Torso, etc)
                        local Character = Target.Parent
                        if Target.Parent:IsA("Accessory") then Character = Target.Parent.Parent end
                        
                        local TargetPlayer = Players:GetPlayerFromCharacter(Character)
                        
                        -- Validation: Is it a player? Are they alive? Are they an enemy?
                        if TargetPlayer and TargetPlayer ~= LocalPlayer then
                            local Hum = Character:FindFirstChildOfClass("Humanoid")
                            if Hum and Hum.Health > 0 then
                                -- TEAM CHECK (Optional: Remove if you want to FF)
                                if TargetPlayer.Team ~= LocalPlayer.Team then
                                    -- CLICK / SHOOT
                                    mouse1press()
                                    task.wait(0.05) -- Delay to prevent weapon jamming
                                    mouse1release()
                                end
                            end
                        end
                    end
                    task.wait() -- Fast check (every frame)
                end
                _G.TriggerbotLoop = false
            end)
        end
    end,
})


CombatTab:CreateButton({
    Name = "God Mode",
    Callback = function()
        local Cam = workspace.CurrentCamera
        local Char = game.Players.LocalPlayer.Character
        local Hum = Char:FindFirstChildOfClass("Humanoid")
        Hum.Name = "1"
        local NewHum = Hum:Clone()
        NewHum.Parent = Char
        NewHum.Name = "Humanoid"
        Hum:Destroy()
        Cam.CameraSubject = Char.Humanoid
    end,
})
