-- [[ 1. 加载 Orion UI 库 ]]
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")

-- [[ 2. 初始化变量 ]]
getgenv().AutoClick = false
getgenv().ClickSpeed = 0.1

-- [[ 3. 创建窗口 ]]
local Window = OrionLib:MakeWindow({
    Name = "🔥 Kyusuke Hub", 
    HidePremium = true, 
    SaveConfig = false, 
    IntroText = "Kyusuke 系统启动中..."
})

-- [[ 4. 手机专用紧急停止（防止 UI 卡死） ]]
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local StopButton = Instance.new("TextButton", ScreenGui)
StopButton.Size = UDim2.new(0, 100, 0, 45)
StopButton.Position = UDim2.new(0.5, -50, 0, 10)
StopButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
StopButton.Text = "🛑 停止"
StopButton.TextColor3 = Color3.new(1, 1, 1)
StopButton.Visible = false
StopButton.ZIndex = 999

StopButton.MouseButton1Click:Connect(function()
    getgenv().AutoClick = false
    StopButton.Visible = false
    OrionLib:MakeNotification({
        Name = "已停止",
        Content = "连点器已关闭",
        Time = 2
    })
end)

-- [[ 5. 主菜单 ]]
local Tab = Window:MakeTab({
    Name = "自动功能",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

Tab:AddToggle({
    Name = "开启自动点击",
    Default = false,
    Callback = function(Value)
        getgenv().AutoClick = Value
        StopButton.Visible = Value -- 开启时显示红色按钮
    end    
})

Tab:AddSlider({
    Name = "点击延迟 (秒)",
    Min = 0.01,
    Max = 1,
    Default = 0.1,
    Color = Color3.fromRGB(255,255,255),
    Increment = 0.01,
    ValueName = "sec",
    Callback = function(Value)
        getgenv().ClickSpeed = Value
    end    
})

-- [[ 6. 核心逻辑：强制分离点击点 ]]
task.spawn(function()
    while true do
        if getgenv().AutoClick then
            -- 坐标设为 -5000, -5000。
            -- 如果 UI 还会动，尝试改为屏幕中心 (500, 500) 看看是否有差异
            VIM:SendMouseButtonEvent(-5000, -5000, 0, true, game, 0)
            VIM:SendMouseButtonEvent(-5000, -5000, 0, false, game, 0)
            task.wait(getgenv().ClickSpeed)
        else
            task.wait(0.5)
        end
    end
end)

-- [[ 7. PC 快捷键 ]]
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.X then
        getgenv().AutoClick = false
        StopButton.Visible = false
    end
end)

OrionLib:Init()
