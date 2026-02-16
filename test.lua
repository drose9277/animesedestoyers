--[[
    Script: Kyusuke Hub (v3.8 Final Stability)
    Fixes: "index nil with PlayerGui" Error
    Features: Icon Toggle, AutoClick, Anti-AFK, Xeno Support
]]

-- 确保 Rayfield 加载
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- [ 1. 核心等待逻辑：修复报错的关键 ]
local Players = game:GetService("Players")
-- 循环等待直到 LocalPlayer 存在
while not Players.LocalPlayer do task.wait(0.1) end
local LP = Players.LocalPlayer
-- 等待 PlayerGui 加载
local PlayerGui = LP:WaitForChild("PlayerGui", 10)

-- [ 2. 全局变量 ]
getgenv().AutoClick = false
getgenv().ClickDelay = 0.1
getgenv().KillAura = false
getgenv().AuraRadius = 25
getgenv().AntiAFKEnabled = false
getgenv().WalkSpeedValue = 16 

local VIM = game:GetService("VirtualInputManager")

-- [ 3. 窗口创建 ]
local Window = Rayfield:CreateWindow({
    Name = "🔥 Kyusuke Hub v3.8",
    LoadingTitle = "Xeno Stable Version",
    LoadingSubtitle = "Fixing PlayerGui Errors...",
    ConfigurationSaving = { Enabled = true, FolderName = "Kyusuke_Fix" }
})

-- [ 4. 核心功能（增加安全检查） ]
task.spawn(function()
    while true do
        if getgenv().AutoClick then
            pcall(function()
                VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            end)
        end
        task.wait(getgenv().ClickDelay)
    end
end)

-- [ 5. 带图标的悬浮球（修复 Parent 路径） ]
local ScreenGui = Instance.new("ScreenGui")
local MainToggle = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")

-- 修复逻辑：优先尝试 CoreGui，失败则用刚才等待到的 PlayerGui
local success, err = pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not success then
    ScreenGui.Parent = PlayerGui
end

ScreenGui.Name = "KyusukeIcon"
ScreenGui.ResetOnSpawn = false

MainToggle.Name = "MainToggle"
MainToggle.Parent = ScreenGui
MainToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainToggle.BackgroundTransparency = 0.2
MainToggle.Position = UDim2.new(0.05, 0, 0.15, 0)
MainToggle.Size = UDim2.new(0, 50, 0, 50)
MainToggle.Image = "rbxassetid://6031104609" -- 科技感图标
MainToggle.Draggable = true 

UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainToggle

UIStroke.Thickness = 2.5
UIStroke.Color = Color3.fromRGB(255, 170, 0)
UIStroke.Parent = MainToggle

MainToggle.MouseButton1Click:Connect(function()
    local target = game:GetService("CoreGui"):FindFirstChild("Rayfield") or PlayerGui:FindFirstChild("Rayfield")
    if target then
        target.Enabled = not target.Enabled
    end
end)

-- [ 6. UI 内容 ]
local CombatTab = Window:CreateTab("Combat", 4483362458)
local ClickToggle = CombatTab:CreateToggle({
    Name = "Auto Clicker",
    CurrentValue = false,
    Flag = "T1",
    Callback = function(Value) getgenv().AutoClick = Value end,
})

CombatTab:CreateSlider({
    Name = "Click Speed",
    Range = {0.05, 1},
    Increment = 0.05,
    CurrentValue = 0.1,
    Callback = function(Value) getgenv().ClickDelay = Value end,
})

local UtilTab = Window:CreateTab("Utility", 4483362458)
UtilTab:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = false,
    Flag = "T3",
    Callback = function(Value) getgenv().AntiAFKEnabled = Value end,
})

Rayfield:Notify({
    Title = "Kyusuke Hub",
    Content = "加载完成！点击橙色图标开关菜单。",
    Duration = 5
})
