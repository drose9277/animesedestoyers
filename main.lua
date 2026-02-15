--[[
    Kyusuke Hub - Anime Destroyers (Rayfield Fixed)
    Status: UI Error Patched
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

local MainTab = Window:CreateTab("Main", 4483362458)

-- 点击逻辑
local function startClicking()
    task.spawn(function()
        while getgenv().autoClick do
            -- 模拟屏幕中心点击（Anime Destroyers 通用）
            local vim = game:GetService("VirtualInputManager")
            vim:SendMouseButtonEvent(500, 500, 0, true, game, 0)
            vim:SendMouseButtonEvent(500, 500, 0, false, game, 0)
            
            task.wait(getgenv().clickSpeed)
        end
    end)
end

-- UI 功能
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
      task.wait(0.1)
      Rayfield:Destroy()
   end,
})

Rayfield:Notify({
   Title = "Kyusuke Hub Loaded",
   Content = "Enjoy your game!",
   Duration = 5,
})
