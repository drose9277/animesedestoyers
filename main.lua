-- [[ 1. 加载 UI 库 ]]
-- 如果加载失败，请确保你的执行器网络可以访问 sirius.menu
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- [[ 2. 状态初始化 ]]
getgenv().KyusukeConfig = {
    AutoClick = false,
    Speed = 0.1,
    SafeMode = true -- 默认开启屏幕外点击
}

local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")

-- [[ 3. 创建 UI 窗口 ]]
local Window = Rayfield:CreateWindow({
   Name = "🔥 Kyusuke Hub",
   LoadingTitle = "正在启动 Kyusuke 系统...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "KyusukeHubData",
      FileName = "Settings"
   }
})

local MainTab = Window:CreateTab("自动功能", 4483362458)

-- [[ 4. 手机紧急停止按钮（原生渲染，优先级最高） ]]
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local StopButton = Instance.new("TextButton", ScreenGui)

StopButton.Name = "KyusukeStopBtn"
StopButton.Size = UDim2.new(0, 100, 0, 45)
StopButton.Position = UDim2.new(0.5, -50, 0.05, 0)
StopButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
StopButton.Text = "停止点击"
StopButton.TextColor3 = Color3.new(1, 1, 1)
StopButton.Visible = false -- 开启连点时才会显示
StopButton.ZIndex = 10000

StopButton.MouseButton1Click:Connect(function()
    getgenv().KyusukeConfig.AutoClick = false
    StopButton.Visible = false
end)

-- [[ 5. UI 组件配置 ]]
MainTab:CreateToggle({
   Name = "开启自动点击",
   CurrentValue = false,
   Flag = "AutoClickToggle",
   Callback = function(Value)
      getgenv().KyusukeConfig.AutoClick = Value
      StopButton.Visible = Value -- 手机端的救命按钮
   end,
})

MainTab:CreateSlider({
   Name = "点击间隔 (秒)",
   Range = {0.01, 1},
   Increment = 0.01,
   Suffix = "s",
   CurrentValue = 0.1,
   Flag = "ClickSpeed",
   Callback = function(Value)
      getgenv().KyusukeConfig.Speed = Value
   end,
})

MainTab:CreateToggle({
   Name = "屏幕外点击 (防卡死模式)",
   CurrentValue = true,
   Flag = "SafeMode",
   Callback = function(Value)
      getgenv().KyusukeConfig.SafeMode = Value
   end,
})

-- [[ 6. 核心逻辑循环 ]]
task.spawn(function()
    while true do
        if getgenv().KyusukeConfig.AutoClick then
            local x, y = 500, 500 -- 默认屏幕中心
            
            if getgenv().KyusukeConfig.SafeMode then
                x, y = -100, -100 -- 屏幕外位置
            end
            
            VIM:SendMouseButtonEvent(x, y, 0, true, game, 0)
            VIM:SendMouseButtonEvent(x, y, 0, false, game, 0)
            
            task.wait(getgenv().KyusukeConfig.Speed)
        else
            task.wait(0.3) -- 待机模式
        end
    end
end)

-- [[ 7. PC 玩家快捷键 X ]]
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.X then
        getgenv().KyusukeConfig.AutoClick = false
        StopButton.Visible = false
        Rayfield:Notify({Title = "Kyusuke Hub", Content = "已按下 X 键紧急停止", Duration = 2})
    end
end)

Rayfield:Notify({
   Title = "加载成功",
   Content = "欢迎使用 Kyusuke Hub！",
   Duration = 5
})
