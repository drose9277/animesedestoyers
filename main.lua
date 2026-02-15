--[[
    Kyusuke Hub - Anime Destroyers (Auto-Farm Edition)
    Status: UI Error Patched + Auto Farm Added
]]

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
   Name = "Kyusuke Hub | Anime Destroyers",
   LoadingTitle = "Kyusuke Hub",
   LoadingSubtitle = "by Kyusuke",
   ConfigurationSaving = {
      Enabled = false
   }
})

-- 全局变量
getgenv().autoClick = false
getgenv().autoFarm = false
getgenv().selectedMob = "None"
getgenv().clickSpeed = 0.05

local MainTab = Window:CreateTab("Main", 4483362458)
local FarmTab = Window:CreateTab("Mob Farm", 4483362458) -- 新增刷怪标签页

-- [点击逻辑]
local function startClicking()
    task.spawn(function()
        while getgenv().autoClick do
            local vim = game:GetService("VirtualInputManager")
            vim:SendMouseButtonEvent(500, 500, 0, true, game, 0)
            vim:SendMouseButtonEvent(500, 500, 0, false, game, 0)
            task.wait(getgenv().clickSpeed)
        end
    end)
end

-- [自动刷怪逻辑]
local function startFarm()
    task.spawn(function()
        while getgenv().autoFarm do
            pcall(function()
                if getgenv().selectedMob ~= "None" then
                    -- 这里的路径 "Workspace.Enemies" 需要根据游戏的实际名称修改
                    -- 脚本会尝试在 Workspace 里寻找名字匹配的怪物
                    for _, mob in pairs(workspace:GetDescendants()) do
                        if mob.Name == getgenv().selectedMob and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                            -- 传送玩家到怪物位置 (保持一点上方距离防止掉进地板)
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                            
                            -- 传送时自动点击攻击
                            local vim = game:GetService("VirtualInputManager")
                            vim:SendMouseButtonEvent(500, 500, 0, true, game, 0)
                            vim:SendMouseButtonEvent(500, 500, 0, false, game, 0)
                            
                            break -- 锁定一个目标，直到它死亡
                        end
                    end
                end
            end)
            task.wait(0.1)
        end
    end)
end

-- --- UI 功能 ---

-- Main Tab 内容
MainTab:CreateToggle({
   Name = "Auto Clicker",
   CurrentValue = false,
   Flag = "ClickToggle",
   Callback = function(Value)
      getgenv().autoClick = Value
      if Value then startClicking() end
   end,
})

MainTab:CreateSlider({
   Name = "Click Speed",
   Range = {0.01, 1},
   Increment = 0.01,
   Suffix = "s",
   CurrentValue = 0.05,
   Flag = "SpeedSlider",
   Callback = function(Value) getgenv().clickSpeed = Value end,
})

-- Farm Tab 内容
local MobDropdown = FarmTab:CreateDropdown({
   Name = "Select Monster (怪物选择)",
   Options = {"None"}, -- 初始为空
   CurrentOption = "None",
   Callback = function(Option)
      getgenv().selectedMob = Option
   end,
})

FarmTab:CreateButton({
   Name = "Refresh Monsters (刷新附近怪物)",
   Callback = function()
      local mobs = {}
      -- 扫描附近的 Model 寻找带有血条的对象
      for _, v in pairs(workspace:GetDescendants()) do
          if v:IsA("Model") and v:FindFirstChild("Humanoid") and not game.Players:GetPlayerFromCharacter(v) then
              if not table.find(mobs, v.Name) then
                  table.insert(mobs, v.Name)
              end
          end
      end
      MobDropdown:Set(mobs) -- 更新下拉菜单
      Rayfield:Notify({Title = "Updated", Content = "Monster list refreshed!", Duration = 2})
   end,
})

FarmTab:CreateToggle({
   Name = "Auto Teleport Farm (自动传送刷怪)",
   CurrentValue = false,
   Flag = "FarmToggle",
   Callback = function(Value)
      getgenv().autoFarm = Value
      if Value then 
          if getgenv().selectedMob == "None" then
              Rayfield:Notify({Title = "Error", Content = "Please select a monster first!", Duration = 3})
          else
              startFarm() 
          end
      end
   end,
})

-- 系统设置
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
