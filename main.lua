-- [[ 1. 加载 UI 库 ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")

-- [[ 2. 状态初始化 ]]
getgenv().KyusukeConfig = {
    AutoClick = false,
    Speed = 0.1,
    SafeMode = true
}

-- [[ 3. 创建 UI 窗口 - 加入锁定参数 ]]
local Window = Rayfield:CreateWindow({
   Name = "🔥 Kyusuke Hub",
   LoadingTitle = "正在启动系统...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = { Enabled = false },
   -- 关键修复点：如果库版本支持，尝试通过特定参数减少交互冲突
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = true
   },
   KeySystem = false
})

-- 💡 修复“UI 跟着动”的小技巧：
-- 实际上是因为 VIM 的坐标点正好落在了 UI 窗口上。
-- 我们把点击坐标设得更远一点，彻底离开 UI 可能存在的区域。

local MainTab = Window:CreateTab("自动功能", 4483362458)

-- [[ 4. 手机紧急停止按钮 ]]
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local StopButton = Instance.new("TextButton", ScreenGui)
StopButton.Size = UDim2.new(0, 100, 0, 45)
StopButton.Position = UDim2.new(0.5, -50, 0.05, 0)
StopButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
StopButton.Text = "停止点击"
StopButton.Visible = false
StopButton.ZIndex = 10000

StopButton.MouseButton1Click:Connect(function()
    getgenv().KyusukeConfig.AutoClick = false
    StopButton.Visible = false
end)

-- [[ 5. 功能组件 ]]
MainTab:CreateToggle({
   Name = "开启自动点击",
   CurrentValue = false,
   Flag = "AutoClickToggle",
   Callback = function(Value)
      getgenv().KyusukeConfig.AutoClick = Value
      StopButton.Visible = Value
   end,
})

MainTab:CreateSlider({
   Name = "点击间隔 (秒)",
   Range = {0.01, 1},
   Increment = 0.01,
   CurrentValue = 0.1,
   Callback = function(Value)
      getgenv().KyusukeConfig.Speed = Value
   end,
})

-- [[ 6. 核心逻辑 - 优化坐标防止拖拽 UI ]]
task.spawn(function()
    while true do
        if getgenv().KyusukeConfig.AutoClick then
            -- 既然 UI 会被带动，说明坐标 (-100, -100) 在某些分辨率下还是被判定在了 UI 范围内
            -- 我们直接把坐标设为极其夸张的负数，彻底远离 UI 渲染层
            local targetX, targetY = -5000, -5000 
            
            -- 如果关闭安全模式，则点屏幕中心（由于坐标在中心，UI 窗口通常在边缘，可以减少拖拽概率）
            if not getgenv().KyusukeConfig.SafeMode then
                targetX, targetY = 500, 500
            end

            VIM:SendMouseButtonEvent(targetX, targetY, 0, true, game, 0)
            VIM:SendMouseButtonEvent(targetX, targetY, 0, false, game, 0)
            
            task.wait(getgenv().KyusukeConfig.Speed)
        else
            task.wait(0.3)
        end
    end
end)

-- 快捷键 X 停止
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.X then
        getgenv().KyusukeConfig.AutoClick = false
        StopButton.Visible = false
    end
end)

Rayfield:Notify({Title = "Kyusuke Hub", Content = "已修复 UI 跟着鼠标动的问题", Duration = 3})
