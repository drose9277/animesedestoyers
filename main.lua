--[[
    Script: Kyusuke Hub (v3.7 - Stable Auto Farm)
    Fixes: Dropdown Refresh, Tween Safety, Monster Scanning
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- [ 变量初始化 ]
getgenv().AutoClick = false
getgenv().ClickDelay = 0.1
getgenv().KillAura = false
getgenv().AuraRadius = 25
getgenv().AntiAFKEnabled = false
getgenv().WalkSpeedValue = 16

-- Auto Farm 变量
getgenv().AutoFarmMonster = false
getgenv().SelectedMonster = "None"
getgenv().FarmMethod = "Nearest"
getgenv().TweenSpeed = 0.8

local VIM = game:GetService("VirtualInputManager")
local LP = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")

-- [ 工具函数：动态获取怪物列表 ]
local function getMonsterTypes()
    local types = {}
    local seen = {}
    -- 建议只扫描 workspace 的第一层，提高效率
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj ~= LP.Character then
            local name = obj.Name
            if not seen[name] then
                seen[name] = true
                table.insert(types, name)
            end
        end
    end
    if #types == 0 then table.insert(types, "No Monsters Found") end
    return types
end

-- [ 工具函数：平滑传送 ]
local function teleportToMonster(monsterModel)
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root or not monsterModel or not monsterModel:FindFirstChild("HumanoidRootPart") then return end
    
    local targetPos = monsterModel.HumanoidRootPart.Position + Vector3.new(0, 5, 0)
    local tweenInfo = TweenInfo.new(getgenv().TweenSpeed, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(root, tweenInfo, {CFrame = CFrame.new(targetPos)})
    
    tween:Play()
    -- 传送时防止物理干扰
    root.Velocity = Vector3.new(0,0,0)
end

-- [ 核心逻辑：Auto Farm ]
task.spawn(function()
    while true do
        task.wait(0.5)
        if getgenv().AutoFarmMonster and getgenv().SelectedMonster ~= "None" then
            local char = LP.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local candidates = {}
                for _, obj in ipairs(workspace:GetChildren()) do
                    if obj.Name == getgenv().SelectedMonster and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
                        table.insert(candidates, obj)
                    end
                end
                
                if #candidates > 0 then
                    local target
                    if getgenv().FarmMethod == "Nearest" then
                        local minDist = math.huge
                        for _, m in ipairs(candidates) do
                            local dist = (char.HumanoidRootPart.Position - m.HumanoidRootPart.Position).Magnitude
                            if dist < minDist then
                                minDist = dist
                                target = m
                            end
                        end
                    else
                        target = candidates[1]
                    end
                    
                    if target then
                        teleportToMonster(target)
                        -- 模拟攻击
                        VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                        task.wait(0.05)
                        VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                    end
                end
            end
        end
    end
end)

-- [ UI 窗口 ]
local Window = Rayfield:CreateWindow({
    Name = "🔥 Kyusuke Hub v3.7",
    LoadingTitle = "Stable Version Loading...",
    LoadingSubtitle = "by Kyusuke",
    ConfigurationSaving = { Enabled = true, FolderName = "KyusukeHub" }
})

local CombatTab = Window:CreateTab("Combat", 4483362458)
local FarmTab = Window:CreateTab("Auto Farm", 4483362458)

-- Auto Farm 控件
FarmTab:CreateToggle({
    Name = "Enable Auto Farm",
    CurrentValue = false,
    Callback = function(Value) getgenv().AutoFarmMonster = Value end,
})

local MonsterDropdown = FarmTab:CreateDropdown({
    Name = "Select Monster",
    Options = getMonsterTypes(),
    CurrentOption = "None",
    Callback = function(Option) getgenv().SelectedMonster = Option end,
})

FarmTab:CreateButton({
    Name = "Refresh List",
    Callback = function()
        local list = getMonsterTypes()
        MonsterDropdown:Refresh(list) -- 注意：Rayfield 某些版本 Refresh 只需要列表参数
        Rayfield:Notify({Title = "System", Content = "List Updated", Duration = 2})
    end,
})

FarmTab:CreateSlider({
    Name = "TP Speed",
    Range = {0.1, 2},
    Increment = 0.1,
    CurrentValue = 0.8,
    Callback = function(Value) getgenv().TweenSpeed = Value end,
})

-- [ 之前的其他功能保留（连点、ESP、移速等可按需加入） ]

Rayfield:Notify({
    Title = "Successfully Injected",
    Content = "Version v3.7 Stable is now running.",
    Duration = 5
})
