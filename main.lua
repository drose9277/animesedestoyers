local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "🔥 Kyusuke Hub | NPC Edition",
    LoadingTitle = "Loading NPC Slayer...",
    LoadingSubtitle = "by Kyusuke",
    ConfigurationSaving = { Enabled = true, FolderName = "KyusukeHub" }
})

-- 服务
local VIM = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- 配置
getgenv().Config = {
    AutoClick = false,
    ClickDelay = 0.1,
    KillAura = false,
    AuraRange = 25,
    AntiAFK = true
}

-- [ 核心：无干扰连点器 ]
-- 使用 task.spawn 独立运行，不占用主线程，UI 依然丝滑
task.spawn(function()
    while true do
        if getgenv().Config.AutoClick then
            -- 模拟逻辑层点击，不会抢占物理鼠标的控制权
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
        task.wait(getgenv().Config.Config.ClickDelay)
    end
end)

-- [ 核心：NPC Kill Aura ]
-- 这个逻辑会扫描 Workspace 里的所有 NPC
task.spawn(function()
    while task.wait(0.2) do
        if getgenv().Config.KillAura then
            local char = LP.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                -- 扫描整个场景寻找 NPC
                for _, v in pairs(workspace:GetDescendants()) do
                    -- 判断标准：是一个模型 + 有血量 + 不是你自己
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                        if v.Name ~= LP.Name and v.Humanoid.Health > 0 then
                            local dist = (char.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                            if dist <= getgenv().Config.AuraRange then
                                -- 执行点击攻击
                                VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                                VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                                -- 如果游戏需要按 E 或其他键攻击，可以在这里添加 VIM:SendKeyEvent
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- [ 核心：防挂机 ]
LP.Idled:Connect(function()
    if getgenv().Config.AntiAFK then
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end
end)

-- UI 设计 (英文)
local CombatTab = Window:CreateTab("Combat", 4483362458)

local ClickToggle = CombatTab:CreateToggle({
    Name = "Auto Clicker",
    CurrentValue = false,
    Flag = "AC_Toggle",
    Callback = function(Value) getgenv().Config.AutoClick = Value end,
})

CombatTab:CreateKeybind({
    Name = "Clicker Hotkey",
    CurrentKeybind = "R",
    HoldToInteract = false,
    Callback = function()
        getgenv().Config.AutoClick = not getgenv().Config.AutoClick
        ClickToggle:Set(getgenv().Config.AutoClick)
    end,
})

CombatTab:CreateDivider()

local AuraToggle = CombatTab:CreateToggle({
    Name = "NPC Kill Aura",
    CurrentValue = false,
    Flag = "KA_Toggle",
    Callback = function(Value) getgenv().Config.KillAura = Value end,
})

CombatTab:CreateSlider({
    Name = "Aura Range (Studs)",
    Range = {10, 100},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 25,
    Callback = function(Value) getgenv().Config.AuraRange = Value end,
})

local SettingsTab = Window:CreateTab("Settings", 4483362458)

SettingsTab:CreateSlider({
    Name = "Click Interval",
    Range = {0.05, 1},
    Increment = 0.05,
    Suffix = "s",
    CurrentValue = 0.1,
    Callback = function(Value) getgenv().Config.ClickDelay = Value end,
})

SettingsTab:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = true,
    Callback = function(Value) getgenv().Config.AntiAFK = Value end,
})

Rayfield:Notify({
    Title = "Kyusuke Hub Ready",
    Content = "NPC Aura & Smooth Clicker Loaded!",
    Duration = 5
})
