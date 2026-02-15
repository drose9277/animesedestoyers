-- [[ 1. 基础设置 ]]
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

getgenv().AutoClick = false
getgenv().ClickSpeed = 0.1

-- 清理旧 UI (防止多次运行叠加)
if CoreGui:FindFirstChild("KyusukeMobile") then
    CoreGui.KyusukeMobile:Destroy()
end

-- [[ 2. 创建极简原生 UI (避开第三方库的 Bug) ]]
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "KyusukeMobile"

-- 主面板
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Position = UDim2.new(0.5, -100, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true -- 这个版本允许你手动拖动到角落

-- 标题
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "🔥 Kyusuke Hub"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

-- 开关按钮
local ToggleBtn = Instance.new("TextButton", MainFrame)
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 40)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
ToggleBtn.Text = "开启连点 (OFF)"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)

-- 速度调节按钮 (简单点，点一次加/减)
local SpeedBtn = Instance.new("TextButton", MainFrame)
SpeedBtn.Size = UDim2.new(0.8, 0, 0, 30)
SpeedBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
SpeedBtn.Text = "当前延迟: 0.1s"
SpeedBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SpeedBtn.TextColor3 = Color3.new(1, 1, 1)

-- [[ 3. 核心逻辑修复 ]]

-- 切换开关
ToggleBtn.MouseButton1Click:Connect(function()
    getgenv().AutoClick = not getgenv().AutoClick
    if getgenv().AutoClick then
        ToggleBtn.Text = "运行中 (按 X 或再点我停止)"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        -- 💡 关键：开启后轻微透明，防止干扰
        MainFrame.BackgroundTransparency = 0.5
    else
        ToggleBtn.Text = "开启连点 (OFF)"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        MainFrame.BackgroundTransparency = 0
    end
end)

-- 调节速度
SpeedBtn.MouseButton1Click:Connect(function()
    if getgenv().ClickSpeed <= 0.05 then
        getgenv().ClickSpeed = 0.5
    else
        getgenv().ClickSpeed = getgenv().ClickSpeed - 0.05
    end
    SpeedBtn.Text = "当前延迟: " .. string.format("%.2f", getgenv().ClickSpeed) .. "s"
end)

-- 连点循环
task.spawn(function()
    while true do
        if getgenv().AutoClick then
            -- 采用“绝对安全坐标”：点屏幕最右下角边缘
            -- 这样即使它想拉动 UI，也因为在边缘拉不动
            VIM:SendMouseButtonEvent(10, 10, 0, true, game, 0)
            VIM:SendMouseButtonEvent(10, 10, 0, false, game, 0)
            task.wait(getgenv().ClickSpeed)
        else
            task.wait(0.3)
        end
    end
end)

-- PC 快捷键
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.X then
