local VisualsTab = Window:CreateTab("Visuals", "eye")

VisualsTab:CreateSection("Rendering")

VisualsTab:CreateToggle({
    Name = "Player Highlights (ESP)",
    CurrentValue = false,
    Callback = function(Value)
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer and v.Character then
                local Highlight = v.Character:FindFirstChild("Highlight") or Instance.new("Highlight", v.Character)
                Highlight.Enabled = Value
            end
        end
    end,
})

VisualsTab:CreateButton({
    Name = "Fullbright",
    Callback = function()
        game:GetService("Lighting").Brightness = 2
        game:GetService("Lighting").ClockTime = 14
        game:GetService("Lighting").GlobalShadows = false
        game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end,
})
