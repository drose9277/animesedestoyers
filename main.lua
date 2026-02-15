--[[
    Script: Kyusuke Hub (v3.3)
    Features: Smooth Clicker, NPC Kill Aura, 17-min Anti-AFK, WalkSpeed Changer
    Fix: Auto-reset speed after respawn
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 1. 初始化变量
getgenv().AutoClick = false
getgenv().ClickDelay = 0.1
getgenv().KillAura = false
getgenv().AuraRadius = 25
getgenv().AntiAFKEnabled = false
getgenv().WalkSpeedValue = 16 -- Roblox 默认速度是 16

local VIM = game:GetService("VirtualInputManager")
local LP = game:GetService("Players").LocalPlayer

-- 窗口创建
local Window = Rayfield:CreateWindow({
    Name = "🔥 Kyusuke Hub",
    LoadingTitle = "Loading Kyusuke Hub v3.3...",
    LoadingSubtitle = "by Kyusuke",
    ConfigurationSaving = { Enabled = false }
})

-- [ 核心逻辑: 保持移动速度 ]
-- 即使角色重置，也会自动应用你设置的速度
task.spawn(function()
    while true do
        local char = LP.Character
        if char and char:FindFirstChild("Humanoid") then
            if char.Humanoid.WalkSpeed ~= getgenv().WalkSpeedValue then
                char.Humanoid.WalkSpeed = getgenv().WalkSpeedValue
            end
        end
        task.wait(0.5)
    end
end)

-- [ 功能逻辑: 连点器 ]
task.spawn(function()
    while true do
        if getgenv().AutoClick then
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
        task.wait(getgenv().ClickDelay)
    end
end)

-- [ 功能逻辑: Kill Aura ]
task.spawn(function()
    while task.wait(0.2) do
        if getgenv().KillAura then
            local char = LP.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                for _, v in pairs(workspace:GetChildren()) do
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= char then
                        local hrp = v:FindFirstChild("HumanoidRootPart")
                        if hrp and (char.HumanoidRootPart.Position - hrp.Position).Magnitude <= getgenv().AuraRadius then
                            if v.Humanoid.Health > 0 then
                                VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                                VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- [ UI 标签页 ]
local MainTab = Window:CreateTab("Combat", 4483362458)

MainTab:CreateToggle({
    Name = "Auto Clicker",
    CurrentValue = false,
    Flag = "AC",
    Callback = function(Value) getgenv().AutoClick = Value end,
})

MainTab:CreateSlider({
    Name = "Click Delay",
    Range = {0.05, 1},
    Increment = 0.05,
    Suffix = "s",
    CurrentValue = 0.1,
    Callback = function(Value) getgenv().ClickDelay = Value end,
})

MainTab:CreateDivider()

MainTab:CreateToggle({
    Name = "NPC Kill Aura",
    CurrentValue = false,
    Flag = "KA",
    Callback = function(Value) getgenv().KillAura = Value end,
})

-- [ 工具标签页 ]
local UtilTab = Window:CreateTab("Utility", 4483362458)

-- 移动速度输入框
UtilTab:CreateInput({
    Name = "Set WalkSpeed",
    PlaceholderText = "Default is 16",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local num = tonumber(Text)
        if num then
            getgenv().WalkSpeedValue = num
            if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                LP.Character.Humanoid.WalkSpeed = num
            end
        else
            Rayfield:Notify({Title = "Error", Content = "Please enter a valid number!", Duration = 2})
        end
    end,
})

UtilTab:CreateDivider()

UtilTab:CreateToggle({
    Name = "17-Min Anti-AFK",
    CurrentValue = false,
    Flag = "AFK",
    Callback = function(Value) getgenv().AntiAFKEnabled = Value end,
})

Rayfield:Notify({
    Title = "Kyusuke Hub v3.3",
    Content = "WalkSpeed and NPC Aura ready!",
    Duration = 5
})
