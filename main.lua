--[[
    Script: Kyusuke Hub (v3.6 Fixed)
    Fix: 修复了扫描不到怪物的问题，优化了瞬移逻辑
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 1. 初始化变量
getgenv().AutoFarm = false
getgenv().KillAura = false
getgenv().TargetName = "" -- 为空则打所有怪
getgenv().ClickDelay = 0.1
getgenv().WalkSpeedValue = 16

local VIM = game:GetService("VirtualInputManager")
local LP = game:GetService("Players").LocalPlayer

-- 窗口创建
local Window = Rayfield:CreateWindow({
    Name = "🔥 Kyusuke Hub v3.6 (Fixed)",
    LoadingTitle = "Fixing Auto Farm...",
    LoadingSubtitle = "Scanning Workspace...",
    ConfigurationSaving = { Enabled = true, FolderName = "KyusukeHub" }
})

-- [ 核心逻辑: 深度扫描刷怪 ]
task.spawn(function()
    while task.wait(0.5) do
        if getgenv().AutoFarm then
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            
            if hrp then
                local target = nil
                local dist = math.huge
                
                -- 使用 GetDescendants 深度遍历，解决怪物在文件夹里的问题
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Humanoid") and v.Parent ~= char and v.Health > 0 then
                        local m_hrp = v.Parent:FindFirstChild("HumanoidRootPart")
                        if m_hrp then
                            -- 名字过滤
                            local nameMatch = false
                            if getgenv().TargetName == "" or string.find(string.lower(v.Parent.Name), string.lower(getgenv().TargetName)) then
                                nameMatch = true
                            end

                            if nameMatch then
                                local d = (hrp.Position - m_hrp.Position).Magnitude
                                if d < dist then
                                    dist = d
                                    target = m_hrp
                                end
                            end
                        end
                    end
                end
                
                -- 执行瞬移
                if target then
                    -- 传送到怪物头顶上方 4 格，防止卡进地里或被撞飞
                    hrp.CFrame = target.CFrame * CFrame.new(0, 4, 0)
                end
            end
        end
    end
end)

-- [ 逻辑: 攻击触发 ]
task.spawn(function()
    while true do
        if getgenv().AutoFarm or getgenv().KillAura then
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
        task.wait(getgenv().ClickDelay)
    end
end)

-- [ UI 界面 ]
local CombatTab = Window:CreateTab("Combat", 4483362458)

CombatTab:CreateToggle({
    Name = "Auto Farm (Deep Scan)",
    CurrentValue = false,
    Flag = "T_Farm",
    Callback = function(Value) getgenv().AutoFarm = Value end,
})

CombatTab:CreateInput({
    Name = "Monster Name (Must Match!)",
    PlaceholderText = "e.g. Bandit",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text) getgenv().TargetName = Text end,
})

CombatTab:CreateSlider({
    Name = "Attack Speed",
    Range = {0.01, 1},
    Increment = 0.05,
    CurrentValue = 0.1,
    Callback = function(Value) getgenv().ClickDelay = Value end,
})

local UtilTab = Window:CreateTab("Utility", 4483362458)
UtilTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 200},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(v) getgenv().WalkSpeedValue = v end,
})

-- 移速维持
task.spawn(function()
    while task.wait(0.5) do
        pcall(function() LP.Character.Humanoid.WalkSpeed = getgenv().WalkSpeedValue end)
    end
end)
