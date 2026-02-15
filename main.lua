--[[
    Kyusuke Hub - Anime Destroyers (Rayfield Fixed + Auto Farm)
    Status: UI Error Patched + Auto Farm Added
]]
-- 尝试使用兼容性最好的 Rayfield 加载源
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
local Window = Rayfield:CreateWindow({
   Name = "Kyusuke Hub | Anime Destroyers",
   LoadingTitle = "Kyusuke Hub",
   LoadingSubtitle = "by Kyusuke",
   ConfigurationSaving = {
      Enabled = false, -- 必须设为 false 以修复 Padding 报错
      FolderName = "KyusukeHub"
   },
   Discord = {
      Enabled = false
   }
})

-- 变量
getgenv().autoClick = false
getgenv().clickSpeed = 0.05

-- Auto Farm 新变量
getgenv().autoFarm = false
getgenv().selectedMonster = "None"
getgenv().farmMethod = "Nearest"  -- Nearest / Random

local LP = game:GetService("Players").LocalPlayer
local VIM = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")

local MainTab = Window:CreateTab("Main", 4483362458)

-- 点击逻辑（通用 Anime Destroyers 屏幕中心点击）
local function startClicking()
    task.spawn(function()
        while getgenv().autoClick do
            VIM:SendMouseButtonEvent(500, 500, 0, true, game, 0)
            VIM:SendMouseButtonEvent(500, 500, 0, false, game, 0)
            task.wait(getgenv().clickSpeed)
        end
    end)
end

-- UI 功能（原有）
MainTab:CreateToggle({
   Name = "Auto Clicker",
   CurrentValue = false,
   Flag = "ClickToggle",
   Callback = function(Value)
      getgenv().autoClick = Value
      if Value then
          startClicking()
      end
   end,
})

MainTab:CreateSlider({
   Name = "Click Speed",
   Range = {0.01, 1},
   Increment = 0.01,
   Suffix = "s",
   CurrentValue = 0.05,
   Flag = "SpeedSlider",
   Callback = function(Value)
      getgenv().clickSpeed = Value
   end,
})

-- 强行停止
MainTab:CreateSection("System")
MainTab:CreateButton({
   Name = "FORCE STOP",
   Callback = function()
      getgenv().autoClick = false
      getgenv().autoFarm = false
      task.wait(0.1)
      Rayfield:Destroy()
   end,
})

-- 新增 Auto Farm Tab
local FarmTab = Window:CreateTab("Auto Farm", 4483362458)

-- 扫描当前地图怪物类型
local function getMonsterTypes()
    local types = {}
    local seen = {}
    
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj ~= LP.Character and obj:FindFirstChild("Humanoid") then
            local hum = obj.Humanoid
            if hum.Health > 0 then  -- 只取活的怪物
                local name = obj.Name
                if not seen[name] then
                    seen[name] = true
                    table.insert(types, name)
                end
            end
        end
    end
    
    if #types == 0 then
        table.insert(types, "No Monsters")
    end
    table.sort(types)  -- 排序方便选
    return types
end

-- 平滑传送至怪物
local function teleportToMonster(monsterModel)
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root or not monsterModel or not monsterModel:FindFirstChild("HumanoidRootPart") then return end
    
    local targetPos = monsterModel.HumanoidRootPart.Position + Vector3.new(0, 3, 0)  -- 稍高避免卡地
    local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(root, tweenInfo, {CFrame = CFrame.new(targetPos)})
    tween:Play()
    tween.Completed:Wait()  -- 等 TP 完成再点击
end

-- Auto Farm 主循环
task.spawn(function()
    while true do
        task.wait(0.5)
        if getgenv().autoFarm and getgenv().selectedMonster ~= "None" and getgenv().selectedMonster ~= "No Monsters" then
            local char = LP.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                -- 自动开启 Clicker
                if not getgenv().autoClick then
                    getgenv().autoClick = true
                    startClicking()
                end
                
                -- 找选定怪物的候选
                local candidates = {}
                for _, obj in ipairs(workspace:GetChildren()) do
                    if obj:IsA("Model") and obj.Name == getgenv().selectedMonster 
                       and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0
                       and obj:FindFirstChild("HumanoidRootPart") then
                        table.insert(candidates, obj)
                    end
                end
                
                if #candidates > 0 then
                    local target
                    if getgenv().farmMethod == "Nearest" then
                        local rootPos = char.HumanoidRootPart.Position
                        local minDist = math.huge
                        for _, m in ipairs(candidates) do
                            local dist = (rootPos - m.HumanoidRootPart.Position).Magnitude
                            if dist < minDist then
                                minDist = dist
                                target = m
                            end
                        end
                    else  -- Random
                        target = candidates[math.random(1, #candidates)]
                    end
                    
                    if target then
                        teleportToMonster(target)
                        -- 额外点击确保击杀
                        task.wait(0.1)
                        VIM:SendMouseButtonEvent(500, 500, 0, true, game, 0)
                        VIM:SendMouseButtonEvent(500, 500, 0, false, game, 0)
                    end
                end
            end
        end
    end
end)

-- Auto Farm UI
local monsterDropdown

FarmTab:CreateToggle({
   Name = "Auto Farm Selected Monster",
   CurrentValue = false,
   Flag = "FarmToggle",
   Callback = function(Value)
      getgenv().autoFarm = Value
      if not Value then
         getgenv().selectedMonster = "None"  -- 停止时重置
      end
   end,
})

monsterDropdown = FarmTab:CreateDropdown({
   Name = "Select Monster (Refresh First!)",
   Options = getMonsterTypes(),
   CurrentOption = {"None"},
   MultipleOptions = false,
   Flag = "MonsterDrop",
   Callback = function(Option)
      getgenv().selectedMonster = Option[1]
   end,
})

FarmTab:CreateButton({
   Name = "🔄 Refresh Monster List",
   Callback = function()
      local newList = getMonsterTypes()
      monsterDropdown:Refresh(newList, true)
      Rayfield:Notify({
         Title = "Refreshed!",
         Content = #newList .. " monster types found!",
         Duration = 3
      })
   end,
})

FarmTab:CreateDropdown({
   Name = "Farm Method",
   Options = {"Nearest", "Random"},
   CurrentOption = {"Nearest"},
   MultipleOptions = false,
   Flag = "FarmMethod",
   Callback = function(Option)
      getgenv().farmMethod = Option[1]
   end,
})

FarmTab:CreateSection("Tips")
FarmTab:CreateParagraph({
   Title = "How to Use",
   Content = "1. Enter map with monsters\n2. Click Refresh\n3. Select monster type\n4. Toggle Auto Farm\nEnjoy farming! 🚀"
})

Rayfield:Notify({
   Title = "Kyusuke Hub Loaded",
   Content = "Auto Farm ready! Refresh in monster areas.",
   Duration = 5,
})
