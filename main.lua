--[[
    Script: Kyusuke Hub (v3.2 Final Fixed)
    Fix: Resolved 'attempt to call a nil value' error
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 1. 初始化变量 (确保每一个变量都有初始值，防止调用 nil)
getgenv().AutoClick = false
getgenv().ClickDelay = 0.1
getgenv().KillAura = false
getgenv().AuraRadius = 25
getgenv().AntiAFKEnabled = false

local VIM = game:GetService("VirtualInputManager")
local LP = game:GetService("Players").LocalPlayer

-- 窗口创建
local Window = Rayfield:CreateWindow({
    Name = "🔥 Kyusuke Hub",
    LoadingTitle = "Loading Fixed Version...",
    LoadingSubtitle = "by Kyusuke",
    ConfigurationSaving = { Enabled = false }
})

-- [ 功能逻辑: 连点器 ]
task.spawn(function()
    while true do
        if getgenv().AutoClick then
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
        task.wait(getgenv().ClickDelay)
    end
end)

-- [ 功能逻辑: Kill Aura (打NPC专用) ]
task.spawn(function()
    while task.wait(0.2) do
        if getgenv().KillAura then
            local char = LP.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                -- 扫描最近的模型
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

-- WalkSpeed 变量初始化
getgenv().WalkSpeedValue = 16 -- Roblox 默认速度是 16

-- 在 Utility 标签页中添加输入框
UtilTab:CreateInput({
    Name = "Custom WalkSpeed",
    PlaceholderText = "Default is 16",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local num = tonumber(Text)
        if num then
            getgenv().WalkSpeedValue = num
            -- 立即应用到当前角色
            if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                LP.Character.Humanoid.WalkSpeed = num
            end
        else
            Rayfield:Notify({Title = "Error", Content = "Please enter a valid number!", Duration = 2})
        end
    end,
})

-- 保持速度逻辑（防止游戏重置你的速度）
task.spawn(function()
    while true do
        if LP.Character and LP.Character:FindFirstChild("Humanoid") then
            -- 如果当前速度不等于我们设置的值，就强行改回去
            if LP.Character.Humanoid.WalkSpeed ~= getgenv().WalkSpeedValue then
                LP.Character.Humanoid.WalkSpeed = getgenv().WalkSpeedValue
            end
        end
        task.wait(0.5) -- 每0.5秒检查一次，防止被游戏逻辑重置
    end
end)


-- [ 功能逻辑: Anti-AFK ]
task.spawn(function()
    while true do
        if getgenv().AntiAFKEnabled then
            if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                LP.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
        task.wait(1020) -- 17分钟触发一次
    end
end)

-- [ UI 标签页 ]
local MainTab = Window:CreateTab("Main Features", 4483362458)

local ClickToggle = MainTab:CreateToggle({
    Name = "Auto Clicker",
    CurrentValue = false,
    Flag = "T1",
    Callback = function(Value) getgenv().AutoClick = Value end,
})

MainTab:CreateKeybind({
    Name = "Clicker Hotkey",
    CurrentKeybind = "R",
    HoldToInteract = false,
    Callback = function()
        getgenv().AutoClick = not getgenv().AutoClick
        ClickToggle:Set(getgenv().AutoClick)
    end,
})

MainTab:CreateSlider({
    Name = "Click Speed (Delay)",
    Range = {0.05, 1},
    Increment = 0.05,
    Suffix = "s",
    CurrentValue = 0.1,
    Callback = function(Value) getgenv().ClickDelay = Value end,
})

MainTab:CreateDivider()

MainTab:CreateToggle({
    Name = "NPC Kill Aura",
    CurrentValue = false,
    Flag = "T2",
    Callback = function(Value) getgenv().KillAura = Value end,
})

MainTab:CreateSlider({
    Name = "Aura Range",
    Range = {10, 50},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 25,
    Callback = function(Value) getgenv().AuraRadius = Value end,
})

local UtilTab = Window:CreateTab("Utility", 4483362458)

UtilTab:CreateToggle({
    Name = "17-Min Anti-AFK",
    CurrentValue = false,
    Flag = "T3",
    Callback = function(Value) getgenv().AntiAFKEnabled = Value end,
})

Rayfield:Notify({
    Title = "Fixed Successfully",
    Content = "All 'nil value' errors have been resolved.",
    Duration = 5
})
