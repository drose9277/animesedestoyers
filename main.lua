-- 防止重复运行
if getgenv().KyusukeExecuted then return end
getgenv().KyusukeExecuted = true

local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- 状态设置
getgenv().Running = false
getgenv().Delay = 0.1

-- [[ 创建极简控制台 ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KyusukeV4"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Main.BackgroundTransparency = 0.4
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.5, -60, 0, 10) -- 屏幕顶部正中央
Main.Size = UDim2.new(0, 120, 0, 80)
Main.Active = true
Main.Draggable = true -- 允许你手动拖走

local Toggle = Instance.new("TextButton")
Toggle.Name = "Toggle"
Toggle.Parent = Main
Toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Toggle.Size = UDim2.new(1, 0, 0.6, 0)
Toggle.Font = Enum.Font.SourceSansBold
Toggle.Text = "START"
Toggle.TextColor3 = Color3.new(1, 1, 1)
Toggle.TextSize = 24

local Info = Instance.new("TextLabel")
Info.Name = "Info"
Info.Parent = Main
Info.Position = UDim2.new(0, 0, 0.6, 0)
Info.Size = UDim2.new(1, 0, 0.4, 0)
Info.BackgroundTransparency = 1
Info.Text = "Speed: 0.1s (X Stop)"
Info.TextColor3 = Color3.new(1, 1, 1)
Info.TextSize = 14

-- [[ 核心逻辑 ]]

Toggle.MouseButton1Click:Connect(function()
    getgenv().Running = not getgenv().Running
    if getgenv().Running then
        Toggle.Text = "STOPPING..."
        Toggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    else
        Toggle.Text = "START"
        Toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- 快捷键停止
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.X then
        getgenv().Running = false
        Toggle.Text = "START"
        Toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- 连点循环 (使用最底层的 Spawn)
spawn(function()
    while true do
        if getgenv().Running then
            -- 坐标 (-100, -100) 如果无效，请尝试改回 (500, 500)
            VIM:SendMouseButtonEvent(-100, -100, 0, true, game, 0)
            VIM:SendMouseButtonEvent(-100, -100, 0, false, game, 0)
            task.wait(getgenv().Delay)
        else
            task.wait(0.5)
        end
    end
end)

print("Kyusuke Hub V4 已注入")
