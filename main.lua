--[[
    Kyusuke Hub - Anime Destroyers Special Edition
    Optimized for: Anime Destroyers (Direct Remote Firing)
    Fixed: Padding UI Error & Click Issue
]]

-- 使用更稳定的 Rayfield 加载源，修复 Padding 报错
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
   Name = "Kyusuke Hub | Anime Destroyers",
   LoadingTitle = "Loading Kyusuke Hub...",
   LoadingSubtitle = "by Kyusuke",
   ConfigurationSaving = {
      Enabled = false -- 彻底禁用配置以防加载崩溃
   }
})

-- 全局控制变量
getgenv().autoClick = false
getgenv().clickSpeed = 0.05

local MainTab = Window:CreateTab("Main Hacks", 4483362458)

-- Anime Destroyers 专属点击逻辑
local function doClick()
    task.spawn(function()
        -- 在此类游戏中，通常点击事件位于 ReplicatedStorage
        local clickRemote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes", true) 
                            and game:GetService("ReplicatedStorage").Remotes:FindFirstChild("Click") 
                            or game:GetService("ReplicatedStorage"):FindFirstChild("ClickRemote")

        while getgenv().autoClick do
            -- 如果找到了游戏的点击远程事件，直接触发（最有效）
            if clickRemote then
                clickRemote:FireServer()
            else
                -- 备选方案：如果找不到特定 Event，尝试对所有装备的工具调用激活
                local character = game.Players.LocalPlayer.Character
                if character then
                    local tool = character:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                end
                -- 同时补一个屏幕中心模拟点击
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(500, 500, 0, true, game, 0)
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(500, 500, 0, false, game, 0)
            end
            
            task.wait(getgenv().clickSpeed)
        end
    end)
end

-- UI 切换开关
MainTab:CreateToggle({
   Name = "Fast Auto Clicker",
   CurrentValue = false,
   Flag = "ClickToggle",
   Callback = function(Value)
      getgenv().autoClick = Value
      if Value then
          Rayfield:Notify({Title = "Status", Content = "Auto Clicker Started", Duration = 2})
          doClick()
      end
   end,
})

-- 速度调节
MainTab:CreateSlider({
   Name = "Click Delay",
   Range = {0.01, 1},
   Increment = 0.01,
   Suffix = "s",
   CurrentValue = 0.05,
   Flag = "Speed
