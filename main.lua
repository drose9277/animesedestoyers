--[[
    Kyusuke Hub - Shipping Lanes Edition (Fixed Clicker)
    Optimized for: Compatibility & Speed (0.05s)
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Kyusuke Hub | Shipping Lanes",
   LoadingTitle = "Fixing Clicker Input...",
   LoadingSubtitle = "by Kyusuke",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "KyusukeHubConfig",
      FileName = "MainConfig"
   }
})

-- Variables
getgenv().autoClick = false
getgenv().clickSpeed = 0.05
local vim = game:GetService("VirtualInputManager")

local MainTab = Window:CreateTab("Main Hacks", 4483362458)

-- New Clicking Logic using VirtualInputManager
local function startClicking()
    task.spawn(function()
        while getgenv().autoClick do
            -- 获取屏幕中心位置进行点击
            local viewportSize = workspace.CurrentCamera.ViewportSize
            local x = viewportSize.X / 2
            local y = viewportSize.Y / 2
            
            -- 模拟鼠标左键按下与弹起
            vim:SendMouseButtonEvent(x, y, 0, true, game, 0)
            task.wait(0.01) -- 极短的按下延迟确保游戏识别
            vim:SendMouseButtonEvent(x, y, 0, false, game, 0)
            
            task.wait(getgenv().clickSpeed)
        end
    end)
end

-- UI Toggle
MainTab:CreateToggle({
   Name = "Enable Auto-Click (Fixed)",
   CurrentValue = false,
   Flag = "AutoClickToggle",
   Callback = function(Value)
      getgenv().autoClick = Value
      if Value then
          Rayfield:Notify({Title = "Auto-Click Active", Content = "Using VirtualInputManager", Duration = 2})
          startClicking()
      end
   end,
})

-- Slider
MainTab:CreateSlider({
   Name = "Click Delay",
   Info = "Default 0.05s",
   Range = {0.01, 1},
   Increment = 0.01,
   Suffix = "s",
   CurrentValue = 0.05,
   Flag = "SpeedSlider",
   Callback = function(Value)
      getgenv().clickSpeed = Value
   end,
})

MainTab:CreateSection("Emergency Controls")

-- Force Stop
MainTab:CreateButton({
   Name = "FORCE STOP & CLOSE UI",
   Callback = function()
      getgenv().autoClick = false
      task.wait(0.1)
      Rayfield:Destroy()
      error("Kyusuke Hub: Force Closed")
   end,
})

Rayfield:Notify({
   Title = "Kyusuke Hub Ready",
   Content = "If it still fails, try re-equipping your tool.",
   Duration = 5,
})
