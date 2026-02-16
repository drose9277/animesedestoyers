--[[
    Script: Kyusuke Hub (v3.5 Final)
    Features: Smooth Clicker, NPC Kill Aura, 17-min Anti-AFK, WalkSpeed, Floating Hotbar
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 1. 初始化变量
getgenv().AutoClick = false
getgenv().ClickDelay = 0.1
getgenv().KillAura = false
getgenv().AuraRadius = 25
getgenv().AntiAFKEnabled = false
getgenv().WalkSpeedValue = 16 

local VIM = game:GetService("VirtualInputManager")
local LP = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")

-- 窗口创建
local Window = Rayfield:CreateWindow({
    Name = "🔥 Kyusuke Hub",
    LoadingTitle = "Loading Kyusuke Hub v3.5...",
    LoadingSubtitle = "by Kyusuke",
    ConfigurationSaving = { Enabled = true, FolderName = "KyusukeHub" }
})

-- [ 逻辑: 连点器 ]
task.spawn(function()
    while true do
        if getgenv().AutoClick then
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
        task.wait(getgenv().ClickDelay)
    end
end)

-- [ 逻辑: NPC Kill Aura ]
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

-- [ 逻辑: 移速维持 ]
task.spawn(function()
    while true do
        local char = LP.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if hum and hum.Health > 0 then
            if hum.WalkSpeed ~= getgenv().WalkSpeedValue then
                hum.WalkSpeed = getgenv().WalkSpeedValue
            end
        end
        task.wait(0.5)
    end
end)

-- [ 逻辑: Anti-AFK ]
task.spawn(function()
    while true do
        if getgenv().AntiAFKEnabled then
            if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                LP.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
        task.wait(1020) -- 17分钟
    end
end)

-- [ UI 界面 ]
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

CombatTab:CreateDivider()

CombatTab:CreateToggle({
    Name = "NPC Kill Aura",
    CurrentValue = false,
    Flag = "T2",
    Callback = function(Value) getgenv().KillAura = Value end,
})

CombatTab:CreateSlider({
    Name = "Aura Range",
    Range = {10, 100},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 25,
    Callback = function(Value) getgenv().AuraRadius = Value end,
})

local UtilTab = Window:CreateTab("Utility", 4483362458)

UtilTab:CreateInput({
    Name = "Custom WalkSpeed",
    PlaceholderText = "Default: 16",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local num = tonumber(Text)
        if num then getgenv().WalkSpeedValue = num end
    end,
})

UtilTab:CreateToggle({
    Name = "17-Min Anti-AFK",
    CurrentValue = false,
    Flag = "T3",
    Callback = function(Value) getgenv().AntiAFKEnabled = Value end,
})

-- [ 悬浮 Hotbar 按钮创建 ]
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "KyusukeHotbar"

ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ToggleButton.Position = UDim2.new(0, 15, 0.5, 0)
ToggleButton.Size = UDim2.new(0, 55, 0, 55)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "AC: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 12
ToggleButton.Draggable = true -- 启用旧版简单拖拽

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = ToggleButton

-- 悬浮按钮点击同步逻辑
ToggleButton.MouseButton1Click:Connect(function()
    getgenv().AutoClick = not getgenv().AutoClick
    ClickToggle:Set(getgenv().AutoClick) -- 同步主 UI 开关
end)

-- 监听全局变量实时改变按钮颜色和文字
task.spawn(function()
    while task.wait(0.1) do
        if getgenv().AutoClick then
            ToggleButton.Text = "AC: ON"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        else
            ToggleButton.Text = "AC: OFF"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        end
    end
end)

Rayfield:Notify({
    Title = "Kyusuke Hub v3.5",
    Content = "Floating Button Loaded! You can drag it anywhere.",
    Duration = 5
})
