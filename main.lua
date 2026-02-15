local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local VIM = game:GetService("VirtualInputManager")

-- 全局变量
getgenv().AutoClickActive = false
getgenv().ClickSpeed = 0.1

-- [[ 1. 创建 UI 窗口 ]]
local Window = Rayfield:CreateWindow({
   Name = "🌐 虚空连点器 (防卡死版)",
   LoadingTitle = "正在配置屏幕外点击...",
   ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("控制中心", 4483362458)

-- [[ 2. 创建手机专用紧急停止按钮（智能显隐） ]]
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local StopButton = Instance.new("TextButton", ScreenGui)

StopButton.Size = UDim2.new(0, 120, 0, 50)
StopButton.Position = UDim2.new(0.5, -60, 0.1, 0)
StopButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
StopButton.Text = "🛑 停止连点"
StopButton.TextColor3 = Color3.new(1, 1, 1)
StopButton.Visible = false -- 初始隐藏
StopButton.ZIndex = 10000

StopButton.MouseButton1Click:Connect(function()
    getgenv().AutoClickActive = false
    StopButton.Visible = false
    Rayfield:Notify({Title = "已切断", Content = "连点器已安全关闭", Duration = 2})
end)

-- [[ 3. 界面功能 ]]
MainTab:CreateToggle({
   Name = "开启屏幕外连点",
   CurrentValue = false,
   Flag = "VoidClick",
   Callback = function(Value)
      getgenv().AutoClickActive = Value
      StopButton.Visible = Value -- 开启时显示红色按钮，关闭时隐藏
   end,
})

MainTab:CreateSlider({
   Name = "点击频率 (秒)",
   Range = {0.01, 1},
   Increment = 0.01,
   CurrentValue = 0.1,
   Callback = function(Value)
      getgenv().ClickSpeed = Value
   end,
})

-- [[ 4. 核心逻辑：坐标设在 (-100, -100) ]]
task.spawn(function()
    while true do
        if getgenv().AutoClickActive then
            -- 关键点：将点击坐标设在屏幕左上方外侧
            VIM:SendMouseButtonEvent(-100, -100, 0, true, game, 0)
            VIM:SendMouseButtonEvent(-100, -100, 0, false, game, 0)
            task.wait(getgenv().ClickSpeed)
        else
            task.wait(0.5) -- 停止状态下降低 CPU 占用
        end
    end
end)

-- PC 玩家保留快捷键 X
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.X then
        getgenv().AutoClickActive = false
        StopButton.Visible = false
    end
end)
