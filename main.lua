local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "🔥 Kyusuke Hub",
    LoadingTitle = "Loading Kyusuke Hub...",
    LoadingSubtitle = "by Kyusuke",
    ConfigurationSaving = { Enabled = true, FolderName = "KyusukeHub" }
})

-- 服务引用
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

-- 全局配置
getgenv().Config = {
    AutoClick = false,
    ClickDelay = 0.05,
    KillAura = false,
    AuraRange = 20,
    AntiAFK = true
}

-- [ 核心功能：兼容性连点器 ]
task.spawn(function()
    while task.wait() do
        if getgenv().Config.AutoClick then
            -- 使用 mouse1press 模拟更真实的物理点击
            mouse1press()
            task.wait(getgenv().Config.ClickDelay)
            mouse1release()
        end
    end
end)

-- [ 核心功能：Kill Aura ]
task.spawn(function()
    while task.wait(0.1) do
        if getgenv().Config.KillAura then
            local char = LP.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (char.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                        if dist <= getgenv().Config.AuraRange then
                            -- 自动点击敌人（假设点击即攻击）
                            mouse1click()
                        end
                    end
                end
            end
        end
    end
end)

-- [ 核心功能：Anti-AFK ]
if getgenv().Config.AntiAFK then
    LP.Idled:Connect(function()
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end)
end

--- UI 界面设计 ---

local MainTab = Window:CreateTab("Combat", 4483362458)

-- 连点器开关
local ClickToggle = MainTab:CreateToggle({
    Name = "Auto Clicker",
    CurrentValue = false,
    Flag = "AC_Toggle",
    Callback = function(Value)
        getgenv().Config.AutoClick = Value
    end,
})

-- 连点器快捷键 (R)
MainTab:CreateKeybind({
    Name = "Auto Click Hotkey",
    CurrentKeybind = "R",
    HoldToInteract = false,
    Flag = "AC_Key",
    Callback = function()
        getgenv().Config.AutoClick = not getgenv().Config.AutoClick
        ClickToggle:Set(getgenv().Config.AutoClick)
    end,
})

MainTab:CreateDivider()

-- Kill Aura 开关
local AuraToggle = MainTab:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = false,
    Flag = "KA_Toggle",
    Callback = function(Value)
        getgenv().Config.KillAura = Value
    end,
})

-- Kill Aura 范围滑块
MainTab:CreateSlider({
    Name = "Aura Range",
    Range = {10, 100},
    Increment = 5,
    Suffix = "Studs",
    CurrentValue = 20,
    Flag = "Aura_Slider",
    Callback = function(Value)
        getgenv().Config.AuraRange = Value
    end,
})

local SettingTab = Window:CreateTab("Settings", 4483362458)

SettingTab:CreateSlider({
    Name = "Click Speed (Delay)",
    Range = {0.01, 1},
    Increment = 0.01,
    Suffix = "s",
    CurrentValue = 0.05,
    Flag = "Delay_Slider",
    Callback = function(Value)
        getgenv().Config.ClickDelay = Value
    end,
})

SettingTab:CreateButton({
    Name = "Destroy UI",
    Callback = function() Rayfield:Destroy() end,
})

Rayfield:Notify({
    Title = "Loaded Successfully",
    Content = "Kyusuke Hub is active. Press R to Toggle Clicker.",
    Duration = 5
})
