--[[
    Script: Kyusuke Hub (v4.1 Ultimate Stable)
    Fixes: 
    - Forced wait for PlayerGui (Fixes First Screenshot error)
    - Deep search for Rayfield UI (Fixes Second Screenshot error)
]]

-- 0. 启动前置：死等玩家加载
if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local LP = Players.LocalPlayer or Players.PlayerAdded:Wait()
local PlayerGui = LP:WaitForChild("PlayerGui", 20) -- 最多等20秒

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- [ 1. 全局变量 ]
getgenv().AutoClick = false
getgenv().ClickDelay = 0.1

-- [ 2. 窗口创建 ]
local Window = Rayfield:CreateWindow({
    Name = "🔥 Kyusuke Hub v4.1",
    LoadingTitle = "Xeno Stable System",
    LoadingSubtitle = "Fixing All Errors...",
    ConfigurationSaving = { Enabled = true, FolderName = "Kyusuke_Xeno" }
})

-- [ 3. 连点器逻辑 ]
task.spawn(function()
    local VIM = game:GetService("VirtualInputManager")
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

-- [ 4. UI 内容 ]
local CombatTab = Window:CreateTab("Combat", 4483362458)
local ClickToggle = CombatTab:CreateToggle({
    Name = "Auto Clicker",
    CurrentValue = false,
    Flag = "AC_Flag",
    Callback = function(Value) getgenv().AutoClick = Value end,
})

CombatTab:CreateKeybind({
    Name = "Hotkey (R)",
    CurrentKeybind = "R",
    HoldToInteract = false,
    Callback = function()
        getgenv().AutoClick = not getgenv().AutoClick
        ClickToggle:Set(getgenv().AutoClick)
    end,
})

-- [ 5. 悬浮图标：深度切换逻辑 ]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Kyusuke_Toggle"
ScreenGui.ResetOnSpawn = false
-- Xeno 环境特殊处理
local success, err = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not success then ScreenGui.Parent = PlayerGui end

local MainToggle = Instance.new("ImageButton")
MainToggle.Parent = ScreenGui
MainToggle.Size = UDim2.new(0, 50, 0, 50)
MainToggle.Position = UDim2.new(0, 10, 0.5, -25)
MainToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainToggle.Image = "rbxassetid://6031104609"
MainToggle.Draggable = true 
Instance.new("UICorner", MainToggle).CornerRadius = UDim.new(0, 15)
local Stroke = Instance.new("UIStroke", MainToggle)
Stroke.Thickness = 2
Stroke.Color = Color3.fromRGB(255, 170, 0)

-- 核心修复：点击切换函数
MainToggle.MouseButton1Click:Connect(function()
    -- 尝试多种路径寻找 Rayfield 界面
    local RF = game:GetService("CoreGui"):FindFirstChild("Rayfield") 
               or PlayerGui:FindFirstChild("Rayfield")
               or (game:GetService("CoreGui"):FindFirstChild("RayfieldGui")) -- 适配不同版本

    if RF then
        RF.Enabled = not RF.Enabled
        Stroke.Color = RF.Enabled and Color3.fromRGB(255, 170, 0) or Color3.fromRGB(100, 100, 100)
    else
        -- 如果找不到，尝试通过通知查找
        print("警告：正在尝试强制定位 Rayfield 界面...")
        for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
            if v:IsA("ScreenGui") and (v:FindFirstChild("Main") or v:FindFirstChild("Container")) then
                v.Enabled = not v.Enabled
                return
            end
        end
    end
end)

Rayfield:Notify({Title = "优化成功", Content = "错误已修复，悬浮球已激活！", Duration = 5})
