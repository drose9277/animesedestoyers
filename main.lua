--[[
    Script: Kyusuke Hub (v3.0)
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

-- Global Variables
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
    local shortestDistance = radius + 1
    local char = LP.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end

    -- 扫描 workspace 寻找所有 NPC
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
            if obj.Name ~= LP.Name and obj.Humanoid.Health > 0 then
                local dist = (char.HumanoidRootPart.Position - obj.HumanoidRootPart.Position).Magnitude
                if dist < shortestDistance and dist <= radius then
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

-- 1. Auto Clicker (No interference)
local ClickToggle = CombatTab:CreateToggle({
    Name = "Auto Clicker",
    CurrentValue = false,
    Flag = "AC_Toggle",
    Callback = function(Value)
        getgenv().AutoClick = Value
        if Value then
            task.spawn(function()
                while getgenv().AutoClick do
                    -- 使用偏移点击，确保不干扰鼠标物理光标
                    VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                    task.wait(getgenv().ClickDelay)
                end
            end)
        end
    end,
})

-- 2. Click Delay
CombatTab:CreateSlider({
    Name = "Click Delay",
    Range = {0.05, 1},
    Increment = 0.05,
    Suffix = "s",
    CurrentValue = 0.1,
    Callback = function(Value) getgenv().Config.ClickDelay = Value end,
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
                        -- 发送攻击信号
                        VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                        VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                    end
                    task.wait(0.15) -- 攻击频率
                end
            end)
        end
    end,
})

CombatTab:CreateSlider({
    Name = "Aura Range",
    Range = {10, 100},
