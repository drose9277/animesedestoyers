--[[
    Script: Kyusuke Hub (v3.1 Fixed)
    Features: Smooth Clicker, NPC Kill Aura, 17-min Anti-AFK
    UI Library: Rayfield
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Window Settings
local Window = Rayfield:CreateWindow({
    Name = "🔥 Kyusuke Hub",
    LoadingTitle = "Loading Kyusuke Hub...",
    LoadingSubtitle = "by Kyusuke",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "KyusukeHub_Config",
        FileName = "Settings"
    },
    KeySystem = false
})

-- Global Variables (Strictly using these to avoid nil errors)
getgenv().AutoClick = false
getgenv().ClickDelay = 0.1
getgenv().AntiAFK = false
getgenv().KillAuraEnabled = false
getgenv().KillAuraRadius = 20

local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- [ Helper: Find NPC Target ]
local function findClosestNPC(radius)
    local closestTarget = nil
    local shortestDistance = radius
    local char = LP.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end

    -- 优化扫描：只看 workspace 里的第一层模型，减少 CPU 占用
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
            if obj.Name ~= LP.Name and obj.Humanoid.Health > 0 then
                local dist = (char.HumanoidRootPart.Position - obj.HumanoidRootPart.Position).Magnitude
                if dist <= shortestDistance then
                    shortestDistance = dist
                    closestTarget = obj
                end
            end
        end
    end
    return closestTarget
end

-- [ Main Tab ]
local CombatTab = Window:CreateTab("Combat Features", 4483362458)

-- 1. Auto Clicker
local ClickToggle = CombatTab:CreateToggle({
    Name = "Auto Clicker",
    CurrentValue = false,
    Flag = "AC_Toggle",
    Callback = function(Value)
        getgenv().AutoClick = Value
        if Value then
            task.spawn(function()
                while getgenv().AutoClick do
                    VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                    task.wait(getgenv().ClickDelay)
                end
            end)
        end
    end,
})

-- 2. Click Delay (FIXED THE FIELD ERROR)
CombatTab:CreateSlider({
    Name = "Click Delay",
    Range = {0.05, 1},
    Increment = 0.05,
    Suffix = "s",
    CurrentValue = 0.1,
    Callback = function(Value) 
        getgenv().ClickDelay = Value -- 修复了之前的 getgenv().Config 报错
    end,
})

CombatTab:CreateDivider()

-- 3. NPC Kill Aura
local AuraToggle = CombatTab:CreateToggle({
    Name = "NPC Kill Aura",
    CurrentValue = false,
    Flag = "KA_Toggle",
    Callback = function(Value)
        getgenv().KillAuraEnabled = Value
        if Value then
            task.spawn(function()
                while getgenv().KillAuraEnabled do
                    local target = findClosestNPC(getgenv().KillAuraRadius)
                    if target then
                        VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                        VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                    end
                    task.wait(0.15)
                end
            end)
        end
    end,
})

CombatTab:CreateSlider({
    Name = "Aura Range",
    Range = {10, 100},
    Increment = 5,
    Suffix = "studs",
    CurrentValue = 20,
    Callback = function(Value) 
        getgenv().KillAuraRadius = Value 
    end,
})

-- [ Utility Tab ]
local UtilityTab = Window:CreateTab("Utility Features", 4483362458)

UtilityTab:CreateToggle({
    Name = "Anti-AFK (17 Min)",
    CurrentValue = false,
    Flag = "AFK_Toggle",
    Callback = function(Value)
        getgenv().AntiAFK = Value
        if Value then
            task.spawn(function()
                while getgenv().AntiAFK do
                    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                        LP.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                    Rayfield:Notify({Title = "Anti-AFK", Content = "Jump triggered.", Duration = 2})
                    task.wait(1020) -- 17 Minutes
                end
            end)
        end
    end,
})

-- [ Hotkeys ]
local HotkeyTab = Window:CreateTab("Hotkeys", 4483362458)
HotkeyTab:CreateKeybind({
    Name = "Clicker Toggle Key",
    CurrentKeybind = "R",
    HoldToInteract = false,
    Callback = function()
        local ns = not getgenv().AutoClick
        ClickToggle:Set(ns)
    end,
})

Rayfield:Notify({
    Title = "Kyusuke Hub v3.1",
    Content = "Bug Fixed & Performance Optimized",
    Duration = 5
})
