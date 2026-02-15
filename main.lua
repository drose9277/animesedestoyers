--[[
    Script: Kyusuke Hub (v3.5 Final - Optimized)
    Features: Smooth Clicker, NPC Kill Aura, 17-min Anti-AFK, WalkSpeed, Floating Hotbar, Auto Farm
    优化点：
    - 添加玩家过滤（避免误伤玩家）
    - Kill Aura 性能大幅提升（只检测是否有目标即可疯狂点击，早停循环）
    - Auto Farm 搜索更精准（优先 HumanoidRootPart / PrimaryPart，只搜索有效敌人）
    - 减少不必要遍历，提高整体流畅度
    - 角色死亡/重生处理更稳健
    - UI 完全不变
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 服务 & 变量
local Players = game:GetService("Players")
local VIM = game:GetService("VirtualInputManager")
local LP = Players.LocalPlayer

getgenv().AutoClick = false
getgenv().ClickDelay = 0.1
getgenv().KillAura = false
getgenv().AuraRadius = 25
getgenv().AntiAFKEnabled = false
getgenv().WalkSpeedValue = 16

-- 新增 Auto Farm 变量
getgenv().AutoFarm = false
getgenv().FarmRadius = 200
getgenv().MinDistanceToAttack = 10

-- 窗口创建（不变）
local Window = Rayfield:CreateWindow({
    Name = "🔥 Kyusuke Hub",
    LoadingTitle = "Loading Kyusuke Hub v3.5...",
    LoadingSubtitle = "by Kyusuke",
    ConfigurationSaving = { Enabled = true, FolderName = "KyusukeHub" }
})

-- [ 优化连点器 ]（逻辑不变，仅保持高效）
task.spawn(function()
    while true do
        if getgenv().AutoClick then
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
        task.wait(getgenv().ClickDelay)
    end
end)

-- [ 优化 Kill Aura：更快、更省资源、避免玩家 ]
task.spawn(function()
    while task.wait(0.1) do  -- 更快响应
        if not getgenv().KillAura then continue end
        
        local char = LP.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
        
        local root = char.HumanoidRootPart
        local hasTarget = false
        
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Model") and v ~= char and Players:GetPlayerFromCharacter(v) == nil then
                local hum = v:FindFirstChildOfClass("Humanoid")
                local hrp = v:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health > 0 then
                    if (root.Position - hrp.Position).Magnitude <= getgenv().AuraRadius then
                        hasTarget = true
                        break  -- 找到一个目标就足够，不必继续遍历
                    end
                end
            end
        end
        
        if hasTarget then
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
    end
end)

-- [ 移速维持 ]（不变）
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

-- [ Anti-AFK ]（不变）
task.spawn(function()
    while true do
        if getgenv().AntiAFKEnabled then
            local char = LP.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
        task.wait(1020)
    end
end)

-- [ UI 界面 ]（完全不变）
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

-- [ 优化 Auto Farm：精准找怪、避免玩家、自动开关 Aura ]
UtilTab:CreateToggle({
    Name = "Auto Farm - 自動找怪打",
    CurrentValue = false,
    Callback = function(v)
        getgenv().AutoFarm = v
        if not v then getgenv().KillAura = false end
    end,
})

task.spawn(function()
    while task.wait(0.35) do
        if not getgenv().AutoFarm then continue end
        
        local char = LP.Character or LP.CharacterAdded:Wait()
        if not char then continue end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if not root or not hum or hum.Health <= 0 then continue end
        
        local closestPart = nil
        local minDist = getgenv().FarmRadius
        
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Model") and Players:GetPlayerFromCharacter(v) == nil then
                local targetHum = v:FindFirstChildOfClass("Humanoid")
                local targetPart = v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart
                if targetHum and targetPart and targetHum.Health > 0 then
                    local dist = (root.Position - targetPart.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        closestPart = targetPart
                    end
                end
            end
        end
        
        if closestPart then
            hum:MoveTo(closestPart.Position)
            getgenv().KillAura = (minDist <= getgenv().MinDistanceToAttack)
        else
            getgenv().KillAura = false
        end
    end
end)

-- [ 悬浮 Hotbar 按钮 ]（不变）
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

ToggleButton.MouseButton1Click:Connect(function()
    getgenv().AutoClick = not getgenv().AutoClick
    ClickToggle:Set(getgenv().AutoClick)
end)

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
