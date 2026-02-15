-- [[ Kyusuke Hub V5 - 稳定版 ]]

-- 1. 彻底清理旧变量
getgenv().AutoClickRunning = false

local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")

-- 2. 检查并清理旧 UI
if CoreGui:FindFirstChild("KyusukeUI") then
    CoreGui.KyusukeUI:Destroy()
end

-- 3. 创建原生 UI (不依赖任何外部链接)
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "KyusukeUI"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 150, 0, 100)
Main.Position = UDim2.new(0.5, -75, 0.1, 0) -- 放在屏幕顶部，远离中心
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 2

local Button = Instance.new("TextButton", Main)
Button.Size = UDim2.new(1, 0, 1, 0)
Button.Text = "START"
Button.TextColor3 = Color3.new(1, 1, 1)
Button.TextSize = 25
Button.BackgroundColor3 = Color3.fromRGB(180, 0, 0)

-- 4. 核心连点逻辑 (改用 task.spawn 避开 nil 报错)
task.spawn(function()
    while true do
        if getgenv().AutoClickRunning then
            -- 坐标设在屏幕外 (-500) 彻底解决 UI 跟着动的问题
            VIM:SendMouseButtonEvent(-500, -500, 0, true, game, 0)
            VIM:SendMouseButtonEvent(-500, -500, 0, false, game, 0)
            task.wait(0.1) -- 建议不要太快，0.1s 很稳
        else
            task.wait(0.5)
        end
    end
end)

-- 5. 交互逻辑
Button.MouseButton1Click:Connect(function()
    getgenv().AutoClickRunning = not getgenv().AutoClickRunning
    if getgenv().AutoClickRunning then
        Button.Text = "STOP"
        Button.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    else
        Button.Text = "START"
        Button.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    end
end)

-- PC 快捷键 X 停止
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.X then
        getgenv().AutoClickRunning = false
        Button.Text = "START"
        Button.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    end
end)

print("Kyusuke Hub V5 加载成功，已解决 nil 报错")
