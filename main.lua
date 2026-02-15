local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local VIM = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera

-- 全局变量
getgenv().AutoClickActive = false
getgenv().ClickSpeed = 0.2

-- [[ 1. 创建手机专用红色紧急按钮 ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "SafetyStopSystem"

local StopButton = Instance.new("TextButton")
StopButton.Parent = ScreenGui
StopButton.Size = UDim2.new(0, 120, 0, 45)
StopButton.Position = UDim2.new(0.5, -60, 0.05, 0) -- 放在屏幕上方中间
StopButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
StopButton.Text = "停止连点 (STOP)"
StopButton.TextColor3 = Color3.new(1, 1, 1)
StopButton.Font = Enum.Font.SourceSansBold
StopButton.TextSize = 18
StopButton.Visible = false -- 默认隐藏，只有开启连点时才显示

StopButton.MouseButton1Click:Connect(function()
    getgenv().AutoClickActive = false
    StopButton.Visible = false
    Rayfield:Notify({Title = "安全停止", Content = "已切断连点循环", Duration = 2})
end)

-- [[ 2. 创建主 UI ]]
local Window = Rayfield:CreateWindow({
   Name = "🚀 智能适配连点器",
   LoadingTitle = "检测屏幕分辨率中...",
   ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("连点设置", 4483362458)

MainTab:CreateToggle({
   Name = "开启自动点击",
   CurrentValue = false,
   Flag = "SmartToggle",
   Callback = function(Value)
      getgenv().AutoClickActive = Value
      StopButton.Visible = Value -- 同步显示/隐藏手机停止按钮
   end,
})

MainTab:CreateSlider({
   Name = "点击速度",
   Range = {0.02, 1},
   Increment = 0.01,
   CurrentValue = 0.2,
   Callback = function(Value)
      getgenv().ClickSpeed = Value
   end,
})

-- [[ 3. 核心点击逻辑：动态计算坐标 ]]
task.spawn(function()
    while true do
        if getgenv().AutoClickActive then
            -- 实时获取屏幕中心点，防止屏幕旋转或分辨率改变导致的范围溢出
            local screenWidth = Camera.ViewportSize.X
            local screenHeight = Camera.ViewportSize.Y
            
            local centerX = screenWidth / 2
            local centerY = screenHeight / 2

            -- 执行点击 (0,0 表示相对于窗口的偏移，这里直接传入中心坐标)
            VIM:SendMouseButtonEvent(centerX, centerY, 0, true, game, 0)
            VIM:SendMouseButtonEvent(centerX, centerY, 0, false, game, 0)
            
            task.wait(getgenv().ClickSpeed)
        else
            task.wait(0.5) -- 待机模式
        end
    end
end)

Rayfield:Notify({Title = "就绪", Content = "点击中心区域已锁定", Duration = 3})
