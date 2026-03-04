local UtilTab = Window:CreateTab("Utility", "settings")

UtilTab:CreateSection("Interface Management")

UtilTab:CreateButton({
    Name = "Unload UI",
    Callback = function()
        Rayfield:Destroy()
    end,
})

UtilTab:CreateKeybind({
    Name = "Toggle UI",
    CurrentKeybind = "RightShift",
    HoldToInteract = false,
    Flag = "UI_Toggle",
    Callback = function(Keybind)
        -- Rayfield handles internal visibility via the window keybind setting
    end,
})
