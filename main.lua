local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "🔥 Kyusuke Hub | Optimized",
    LoadingTitle = "Loading Professional Suite...",
    LoadingSubtitle = "by Kyusuke",
    ConfigurationSaving = { Enabled = true, FolderName = "KyusukeHub" }
})

-- Services
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")

-- States
getgenv().Config = {
    AutoClick = false,
    ClickDelay = 0.1,
    AntiAFK = false
}

-- [Core Function: Clicking]
-- 使用 task.spawn 确保它在后台运行，不阻塞 UI
task.spawn(function()
    while true do
        if getgenv().Config.AutoClick then
            -- 发送逻辑点击，不干扰物理鼠标操作 UI
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
        task.wait(getgenv().Config.ClickDelay)
    end
end)

-- [Core Function: Anti-AFK]
local VirtualUser = game:GetService("VirtualUser")
LocalPlayer = game:GetService("Players").LocalPlayer
LocalPlayer.Idled:Connect(function()
    if getgenv().Config.AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

local MainTab = Window:CreateTab("Main", 4483362458)

local ClickToggle = MainTab:CreateToggle({
    Name = "Auto Clicker",
    CurrentValue = false,
    Flag = "AC_Toggle",
    Callback = function(Value)
        getgenv().Config.AutoClick = Value
    end,
})

MainTab:CreateKeybind({
    Name = "Toggle Hotkey",
    CurrentKeybind = "R",
    HoldToInteract = false,
    Flag = "Keybind1",
    Callback = function()
        -- 切换状态并更新 UI 按钮显示
        getgenv().Config.AutoClick = not getgenv().Config.AutoClick
        ClickToggle:Set(getgenv().Config.AutoClick)
    end,
})

MainTab:CreateSlider({
    Name = "Click Speed",
    Range = {0.01, 0.5},
    Increment = 0.01,
    Suffix = "s",
    CurrentValue = 0.1,
    Flag = "Slider1",
    Callback = function(Value)
        getgenv().Config.ClickDelay = Value
    end,
})

local UtilsTab = Window:CreateTab("Utils", 4483362458)

UtilsTab:CreateToggle({
    Name = "Anti-AFK (Stay Online)",
    CurrentValue = false,
    Flag = "AFK_Toggle",
    Callback = function(Value)
        getgenv().Config.AntiAFK = Value
    end,
})

Rayfield:Notify({
    Title = "Kyusuke Hub Ready",
    Content = "The script is running in background threads for zero lag.",
    Duration = 5
})
