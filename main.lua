--[[
    Kyusuke Hub - Anime Clicker Edition
    Fixed UI Error & New Click Method
]]

-- 修复某些执行器加载 Rayfield 时 Padding 报错的问题
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
   Name = "Kyusuke Hub",
   LoadingTitle = "Kyusuke Hub Loading...",
   LoadingSubtitle = "by Kyusuke",
   ConfigurationSaving = {
      Enabled = false -- 关闭配置保存以减少报错可能
   }
})

-- Variables
getgenv().autoClick = false
getgenv().clickSpeed = 0.05

local MainTab = Window:CreateTab("Main Hacks", 4483362458)

-- 核心点击逻辑：使用 RemoteEvent (最强最快)
local function startClicking()
    task.spawn(function()
        -- 尝试自动寻找游戏里的点击事件 (适用于大多数点击游戏)
        local clickEvent = game:GetService("ReplicatedStorage"):FindFirstChild("Click", true) or 
                           game:GetService("ReplicatedStorage"):FindFirstChild("ClickEvent", true) or
                           game:GetService("ReplicatedStorage"):FindFirstChild("TappingEvent", true)

        while getgenv().autoClick do
            if clickEvent and clickEvent:IsA("RemoteEvent") then
                clickEvent:FireServer() -- 直接发送点击指令给服务器
            else
                -- 如果找不到事件，则退回使用模拟点击，但这次点击按钮的坐标
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(500, 500, 0, true, game, 0)
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(500, 500, 0, false, game, 0)
            end
            task.wait(getgenv().clickSpeed)
        end
    end)
end

-- UI Elements
MainTab:CreateToggle({
   Name = "Auto Clicker (Remote/VIM)",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(Value)
      getgenv().autoClick = Value
      if Value then
          startClicking()
      end
   end,
})

MainTab:CreateSlider({
   Name = "Click Speed",
   Range = {0.01, 0.5},
   Increment = 0.01,
   Suffix = "s",
   CurrentValue = 0.05,
   Flag = "Slider1",
   Callback = function(Value)
      getgenv().clickSpeed = Value
   end,
})

MainTab:CreateSection("Emergency Controls")

MainTab:CreateButton({
   Name = "FORCE STOP",
   Callback = function()
      getgenv().autoClick = false
      Rayfield:Destroy()
   end,
})

-- 简单的防挂机
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
   vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
   task.wait(1)
   vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)
