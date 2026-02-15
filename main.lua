--[[
    Kyusuke Hub - Shipping Lanes Edition
    Updated: Click Speed 0.05s
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Kyusuke Hub | Shipping Lanes",
   LoadingTitle = "Kyusuke Hub Loading...",
   LoadingSubtitle = "by Kyusuke",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "KyusukeHubConfig",
      FileName = "MainConfig"
   }
})

-- 全局变量设置
getgenv().autoClick = false
getgenv().clickSpeed = 0.05 -- 按照要求修改为 0.05s

local MainTab = Window:CreateTab("Main Hacks", 4483362458)

-- 自动点击逻辑
local function startClicking()
    task.spawn(function()
        local vu = game:GetService("VirtualUser")
        while getgenv().autoClick do
            -- 模拟点击
            vu:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(getgenv().clickSpeed)
            vu:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            
            -- 额外的安全等待，确保不会因为频率太高导致脚本卡死
            if not getgenv().autoClick then break end
        end
    end)
end

-- UI 控件
MainTab:CreateToggle({
   Name = "Enable Auto-Click (0.05s)",
   CurrentValue = false,
   Flag = "AutoClickToggle",
   Callback = function(Value)
      getgenv().autoClick = Value
      if Value then
          Rayfield:Notify({Title = "Auto-Click On", Content = "Speed set to 0.05s", Duration = 2})
          startClicking()
      else
          Rayfield:Notify({Title = "Auto-Click Off", Content = "Stopped clicking", Duration = 2})
      end
   end,
})

-- 速度调节滑块 (默认设为 0.05)
MainTab:CreateSlider({
   Name = "Adjust Click Speed",
   Info = "Default is 0.05s",
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

-- 强行停止按钮
MainTab:CreateButton({
   Name = "FORCE STOP & CLOSE UI",
   Callback = function()
      getgenv().autoClick = false
      Rayfield:Notify({Title = "Emergency", Content = "Script Terminated!", Duration = 2})
      task.wait(0.2)
      Rayfield:Destroy()
      -- 强制终止所有当前脚本线程
      error("Kyusuke Hub: Manual termination")
   end,
})

-- 防挂机功能
local Players = game:GetService("Players")
Players.LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

Rayfield:Notify({
   Title = "Kyusuke Hub Loaded",
   Content = "Click speed is set to 0.05s",
   Duration = 5,
})
