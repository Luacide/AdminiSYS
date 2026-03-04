local TeleportTab = Window:CreateTab("Appear", "map-pin")

TeleportTab:CreateSection("Teleportation")

local SelectedPlayer = ""
TeleportTab:CreateDropdown({
    Name = "Select Player",
    Options = {}, -- Will auto-fill
    CurrentOption = "",
    MultipleOptions = false,
    Flag = "TP_Dropdown",
    Callback = function(Option)
        SelectedPlayer = Option[1]
    end,
})

-- Auto-refresh player list
task.spawn(function()
    while task.wait(5) do
        local pList = {}
        for _, v in pairs(game.Players:GetPlayers()) do
            table.insert(pList, v.Name)
        end
        -- Rayfield's internal function to update dropdowns
        -- Window.Flags.TP_Dropdown:Set(pList) 
    end
end)

TeleportTab:CreateButton({
    Name = "Teleport to Player",
    Callback = function()
        local target = game.Players:FindFirstChild(SelectedPlayer)
        if target and target.Character then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
        end
    end,
})

TeleportTab:CreateSection("Waypoints")

TeleportTab:CreateButton({
    Name = "Spawn Location",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace:GetModelCFrame() -- Fallback logic
    end,
})
