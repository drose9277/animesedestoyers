--[[
    Script: Kyusuke Hub (v3.5 Final - Optimized Aura)
    Features: Smooth Clicker, NPC Kill Aura (optimized), 17-min Anti-AFK, WalkSpeed, Floating Hotbar
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 1. 初始化變數
getgenv().AutoClick = false
getgenv().ClickDelay = 0.1
getgenv().KillAura = false
getgenv().AuraRadius = 25
getgenv().AntiAFKEnabled = false
getgenv().WalkSpeedValue = 16

local VIM = game:GetService("VirtualInputManager")
local LP = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")

-- 新增：優化後的目標搜尋函數
local function getNearbyTargets()
    local rootPart = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return {} end
    
    local targets = {}
    local radiusSq = getgenv().AuraRadius * getgenv().AuraRadius  -- 使用平方距離，避免開根號
    
    -- 只遍歷 workspace 的子物件（避免 GetDescendants 過於深入）
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj ~= LP.Character then
            local hrp = obj:FindFirstChild("HumanoidRootPart")
            local hum = obj:FindFirstChild("Humanoid")
            
            if hrp and hum and hum.Health > 0 then
                local distSq = (rootPart.Position - hrp.Position).MagnitudeSquared
                if distSq <= radiusSq then
                    table.insert(targets, obj)
                end
            end
        end
    end
    
    return targets
end

-- [ 邏輯: 連點器 ]
task.spawn(function()
    while true do
        if getgenv().AutoClick then
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
        task.wait(getgenv().ClickDelay)
    end
end)

-- [ 邏輯: NPC Kill Aura ] ── 使用優化後的 getNearbyTargets
task.spawn(function()
    while task.wait(0.2) do
        if getgenv().KillAura then
            local char = LP.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local targets = getNearbyTargets()
                
                for _, npc in ipairs(targets) do
                    -- 這裡直接模擬點擊（你也可以改成其他攻擊方式）
                    VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                end
            end
        end
    end
end)

-- [ 邏輯: 移速維持 ]
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

-- [ 邏輯: Anti-AFK ]
task.spawn(function()
    while true do
        if getgenv().AntiAFKEnabled then
            if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                LP.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
        task.wait(1020) -- 17分鐘
    end
end)

-- 窗口創建
local Window = Rayfield:CreateWindow({
    Name = "🔥 Kyusuke Hub",
    LoadingTitle = "Loading Kyusuke Hub v3.5...",
    LoadingSubtitle = "by Kyusuke",
    ConfigurationSaving = { Enabled = true, FolderName = "KyusukeHub" }
})

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

-- [ 懸浮 Hotbar 按鈕創建 ]
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
ToggleButton.Draggable = true

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = ToggleButton

-- 懸浮按鈕點擊同步邏輯
ToggleButton.MouseButton1Click:Connect(function()
    getgenv().AutoClick = not getgenv().AutoClick
    ClickToggle:Set(getgenv().AutoClick)
end)

-- 監聽全局變數即時改變按鈕顏色與文字
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
