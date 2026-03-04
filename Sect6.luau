local GoofyTab = Window:CreateTab("Fun thingies", "party-popper") -- Lucide: party-popper

GoofyTab:CreateSection("Fun Stuff to mess with")

-- 1. SPAM JUMP (Noodle Legs)
GoofyTab:CreateToggle({
    Name = "Boinggg",
    CurrentValue = false,
    Flag = "Goofy_Jump",
    Callback = function(Value)
        _G.GoofyJump = Value
        task.spawn(function()
            while _G.GoofyJump do
                local Hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if Hum then Hum.Jump = true end
                task.wait(0.01)
            end
        end)
    end,
})

-- 2. GRAVITY SLIDER (Moon Walk)
GoofyTab:CreateSlider({
    Name = "Flying santa into earth",
    Range = {0, 196},
    Increment = 1,
    Suffix = " gravity",
    CurrentValue = 196,
    Callback = function(Value)
        workspace.Gravity = Value
    end,
})

-- 3. SPIN BOT (Beyblade Mode)
GoofyTab:CreateToggle({
    Name = "HELLICOPTEAR HELLICOPTEAR",
    CurrentValue = false,
    Flag = "Goofy_Spin",
    Callback = function(Value)
        _G.Spinning = Value
        local HumRoot = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        
        if _G.Spinning then
            local AV = Instance.new("AngularVelocity", HumRoot)
            AV.Name = "GoofySpin"
            AV.MaxTorque = math.huge
            AV.AngularVelocity = Vector3.new(0, 50, 0) -- Adjust 50 for speed
            AV.Attachment0 = HumRoot:FindFirstChildOfClass("Attachment") or Instance.new("Attachment", HumRoot)
        else
            if HumRoot:FindFirstChild("GoofySpin") then
                HumRoot.GoofySpin:Destroy()
            end
        end
    end,
})

-- 4. DEEP FRIED (Visual Chaos)
GoofyTab:CreateButton({
    Name = "Mr bombastic bombo fantastic",
    Callback = function()
        local Lighting = game:GetService("Lighting")
        local ColorCorr = Instance.new("ColorCorrectionEffect", Lighting)
        ColorCorr.Saturation = 5
        ColorCorr.Contrast = 2
        ColorCorr.Brightness = 1
        
        local Bloom = Instance.new("BloomEffect", Lighting)
        Bloom.Intensity = 10
        
        Rayfield:Notify({
            Title = "EYES BLEEDING?",
            Content = "You've successfully deep-fried your GPU.",
            Duration = 5,
            Image = "flame", -- Lucide: flame
        })
    end,
})

-- 5. TRIP CHARACTER
GoofyTab:CreateButton({
    Name = "imagine falling couldnt be me",
    Callback = function()
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Physics)
    end,
})
