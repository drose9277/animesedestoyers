-- [[ 1. 环境初始化 ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")

-- 全局变量
getgenv().AutoClickActive = false
getgenv().ClickSpeed = 0.2 

-- [[ 2. 创建窗口 ]]
local Window = Rayfield:CreateWindow({
   Name = "🔥 Kyusuke Hub",
   LoadingTitle = "正在载入 Kyusuke 系统...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("连点功能", 4483362458)

-- [[ 3. 手机端紧急按钮 - 深度优化 ]]
local ScreenGui = Instance.new("ScreenGui")
local StopButton = Instance.new("TextButton")

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "KyusukeEmergencyStop"

StopButton.Parent = ScreenGui
StopButton.Size = UDim2.new(0, 120, 0, 45)
StopButton.Position = UDim2.new(0.5, -60, 0.02, 0) -- 顶部居中
StopButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
StopButton.Text = "🛑 紧急停止"
StopButton.TextColor3 = Color3.new(1, 1, 1)
StopButton.Font = Enum.Font.SourceSansBold
StopButton.TextSize = 18
StopButton.Visible = false -- 默认隐藏，只有开启时才显示

-- 圆角修饰
local UICorner = Instance.new("UICorner", StopButton)
UICorner.CornerRadius = UDim.new(0, 8)

-- 点击逻辑
StopButton.MouseButton1Click:Connect(function()
    getgenv().AutoClickActive = false
    StopButton.Visible = false
    Rayfield:Notify({Title = "Kyusuke Hub", Content = "自动点击已强制切断", Duration = 2})
end)

-- [[ 4. UI 交互组件 ]]
local Toggle = MainTab:CreateToggle({
   Name = "启用自动连点",
   CurrentValue = false,
   Flag = "AutoClickToggle",
   Callback = function(Value)
      getgenv().AutoClickActive = Value
      StopButton.Visible = Value -- 同步紧急按钮状态
   end,
})

MainTab:CreateSlider({
   Name = "点击间隔 (建议 > 0.05)",
   Range = {0.01, 1},
   Increment = 0.01,
   CurrentValue = 0.2,
   Flag = "SpeedSlider",
   Callback = function(Value)
      getgenv().ClickSpeed = Value
   end,
})

-- [[ 5. 核心逻辑：虚空点击模式 ]]
task.spawn(function()
    while true do
        if getgenv().AutoClickActive == true then
            -- 🛠️ 关键优化：将坐标设在屏幕外 (-100, -100)
            -- 这样点击就不会触发 UI 的任何交互，彻底解决“UI 跟着动”的 Bug
            VIM:SendMouseButtonEvent(-100, -100, 0, true, game, 0)
            VIM:SendMouseButtonEvent(-100, -100, 0, false, game, 0)
            task.wait(getgenv().ClickSpeed)
        else
            task.wait(0.5)
        end
    end
end)

-- PC 玩家快捷键 X 停止
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.X then
        getgenv().AutoClickActive = false
        StopButton.Visible = false
    end
end)

Rayfield:Notify({Title = "加载成功", Content = "Kyusuke Hub 已准备就绪", Duration = 3})
