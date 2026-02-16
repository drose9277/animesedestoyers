--[[
    Script: Kyusuke Hub (v3.6 Optimized)
    Optimizations: 
    - Fixed CoreGui Permissions (Added PlayerGui Fallback)
    - Optimized Task Loops (Using task.wait for performance)
    - Added Safety Checks for Nil Values
]]

-- 0. 环境检测与初始化
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
if not Rayfield then 
    warn("Rayfield UI 库加载失败，请检查网络或执行器！")
    return 
end

-- 全局变量初始化
getgenv().AutoClick = false
getgenv().ClickDelay = 0.1
getgenv().KillAura = false
getgenv().AuraRadius = 25
getgenv().AntiAFKEnabled = false
getgenv().WalkSpeedValue = 16 

local VIM = game:GetService("VirtualInputManager")
local LP = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- 1. 窗口创建
local Window = Rayfield:CreateWindow({
    Name = "🔥 Kyusuke Hub v3.6",
    LoadingTitle = "正在初始化优化版...",
    LoadingSubtitle = "by Kyusuke | Stability Update",
    ConfigurationSaving = { Enabled = true, FolderName = "KyusukeHub_Opt" }
})

-- 2. 核心逻辑优化 (使用更轻量级的循环)

-- [ 优化连点器 ]
task.spawn(function()
    while true do
        if getgenv().AutoClick then
            -- 使用 VIM 模拟点击，增加 pcall 防止 API 缺失崩溃
            pcall(function()
                VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            end)
        end
        task.wait(getgenv().ClickDelay)
    end
end)

-- [ 优化 NPC Kill Aura ]
task.spawn(function()
    while true do
        if getgenv().KillAura then
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                -- 仅遍历特定文件夹以节省性能 (视游戏而定，此处保持 workspace 遍历但增加频率限制)
                for _, v in pairs(workspace:GetChildren()) do
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= char then
                        local targetHrp = v:FindFirstChild("HumanoidRootPart")
                        if targetHrp and (hrp.Position - targetHrp.Position).Magnitude <= getgenv().AuraRadius then
                            if v.Humanoid.Health > 0 then
                                pcall(function()
                                    VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                                    VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                                end)
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.3) -- 适当增加延迟防止游戏卡顿
    end
end)

-- [ 优化移速维持 ]
RunService.Stepped:Connect(function()
    local char = LP.Character
    local hum = char and char:FindFirstChild("Humanoid")
    if hum and hum.Health > 0 then
        if hum.WalkSpeed ~= getgenv().WalkSpeedValue then
            hum.WalkSpeed = getgenv().WalkSpeedValue
        end
    end
end)

-- [ 优化 Anti-AFK ]
task.spawn(function()
    while true do
        if getgenv().AntiAFKEnabled then
            pcall(function()
                game:GetService("VirtualUser"):CaptureController()
                game:GetService("VirtualUser"):ClickButton2(Vector2.new(0,0))
            end)
        end
        task.wait(60) -- 每分钟模拟一次操作即可，无需 17 分钟
    end
end)

---
-- 3. UI 界面
local CombatTab = Window:CreateTab("Combat", 4483362458)

local ClickToggle = CombatTab:CreateToggle({
    Name = "Auto Clicker",
    CurrentValue = false,
    Flag = "T1",
    Callback = function(Value) getgenv().AutoClick = Value end,
})

CombatTab:CreateKeybind({
    Name = "Clicker Hotkey (R)",
    CurrentKeybind = "R",
    HoldToInteract = false,
    Callback = function()
        getgenv().AutoClick = not getgenv().AutoClick
        ClickToggle:Set(getgenv().AutoClick)
    end,
})

CombatTab:CreateSlider({
    Name = "Click Speed",
    Range = {0.05, 1},
    Increment = 0.05,
    Suffix = "s",
    CurrentValue = 0.1,
    Callback = function(Value) getgenv().ClickDelay = Value end,
})

local UtilTab = Window:CreateTab("Utility", 4483362458)

UtilTab:CreateInput({
    Name = "Custom WalkSpeed",
    PlaceholderText = "16",
    Callback = function(Text)
        local num = tonumber(Text)
        if num then getgenv().WalkSpeedValue = num end
    end,
})

UtilTab:CreateToggle({
    Name = "Anti-AFK System",
    CurrentValue = false,
    Flag = "T3",
    Callback = function(Value) getgenv().AntiAFKEnabled = Value end,
})

---
-- 4. 优化后的悬浮 Hotbar (解决 CoreGui 报错)
local TargetParent = nil
local success, err = pcall(function()
    TargetParent = game:GetService("CoreGui")
end)
if not success or not TargetParent then
    TargetParent = LP:WaitForChild("PlayerGui") -- 如果 CoreGui 不行，退而求其次使用 PlayerGui
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KyusukeHotbar_New"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = TargetParent

local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ToggleButton.Position = UDim2.new(0, 15, 0.4, 0)
ToggleButton.Size = UDim2.new(0, 60, 0, 60)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "AC: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 12
ToggleButton.Active = true
ToggleButton.Draggable = true -- 注意：部分新版 Roblox 环境可能需要手动写拖拽逻辑

UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    getgenv().AutoClick = not getgenv().AutoClick
    ClickToggle:Set(getgenv().AutoClick)
end)

-- 颜色更新逻辑
task.spawn(function()
    while task.wait(0.2) do
        if getgenv().AutoClick then
            ToggleButton.Text = "AC: ON"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        else
            ToggleButton.Text = "AC: OFF"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
        end
    end
end)

Rayfield:Notify({
    Title = "加载成功",
    Content = "Kyusuke Hub 优化版已就绪！",
    Duration = 5
})
