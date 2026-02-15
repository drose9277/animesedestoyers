--[[
    Script: Kyusuke Hub (v3.6 Official)
    Integrated: AutoClick, NPC Aura, ESP, WalkSpeed, Anti-AFK
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 1. 变量初始化 (防止 nil 报错)
getgenv().AutoClick = false
getgenv().ClickDelay = 0.1
getgenv().KillAura = false
getgenv().AuraRadius = 25
getgenv().AntiAFKEnabled = false
getgenv().WalkSpeedValue = 16
getgenv().ESPEnabled = false -- 核心修复：初始化 ESP 开关

local VIM = game:GetService("VirtualInputManager")
local LP = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local ESPObjects = {}

-- 2. ESP 核心工具函数
local function ClearESP(player)
    if ESPObjects[player] then
        if ESPObjects[player].Box then ESPObjects[player].Box:Remove() end
        if ESPObjects[player].NameTag then ESPObjects[player].NameTag:Remove() end
        ESPObjects[player] = nil
    end
end

local function CreateESP(player)
    if player == LP or not Drawing then return end
    local Box = Drawing.new("Square")
    Box.Thickness = 2
    Box.Color = Color3.fromRGB(255, 0, 0)
    local NameTag = Drawing.new("Text")
    NameTag.Size = 14
    NameTag.Center = true
    NameTag.Outline = true
    NameTag.Color = Color3.fromRGB(255, 255, 255)
    ESPObjects[player] = {Box = Box, NameTag = NameTag}
end

-- 窗口创建
local Window = Rayfield:CreateWindow({
    Name = "🔥 Kyusuke Hub",
    LoadingTitle = "Loading Kyusuke Suite...",
    LoadingSubtitle = "by Kyusuke",
    ConfigurationSaving = { Enabled = true, FolderName = "KyusukeHub" }
})

-- [ 标签页：视觉 (Visuals) ]
local VisualTab = Window:CreateTab("Visuals", 4483362458)

VisualTab:CreateToggle({
    Name = "Player ESP (Box)",
    CurrentValue = false,
    Flag = "ESP_T",
    Callback = function(Value) getgenv().ESPEnabled = Value end,
})

-- [ 标签页：战斗 (Combat) ]
local CombatTab = Window:CreateTab("Combat", 4483362458)

local ClickToggle = CombatTab:CreateToggle({
    Name = "Auto Clicker",
    CurrentValue = false,
    Callback = function(Value) getgenv().AutoClick = Value end,
})

-- [ 循环逻辑：ESP 更新 ]
RunService.RenderStepped:Connect(function()
    for player, esp in pairs(ESPObjects) do
        if getgenv().ESPEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                esp.Box.Size = Vector2.new(2000 / screenPos.Z, 3000 / screenPos.Z)
                esp.Box.Position = Vector2.new(screenPos.X - esp.Box.Size.X / 2, screenPos.Y - esp.Box.Size.Y / 2)
                esp.Box.Visible = true
                esp.NameTag.Text = player.Name
                esp.NameTag.Position = Vector2.new(screenPos.X, screenPos.Y - esp.Box.Size.Y / 2 - 15)
                esp.NameTag.Visible = true
            else
                esp.Box.Visible = false
                esp.NameTag.Visible = false
            end
        else
            esp.Box.Visible = false
            esp.NameTag.Visible = false
        end
    end
end)

-- 初始化监听
for _, p in pairs(game.Players:GetPlayers()) do CreateESP(p) end
game.Players.PlayerAdded:Connect(CreateESP)
game.Players.PlayerRemoving:Connect(ClearESP)

Rayfield:Notify({
    Title = "Kyusuke Hub v3.6",
    Content = "ESP and Combat modules injected!",
    Duration = 5
})
