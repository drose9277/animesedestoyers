-- [ 手机端专用：带图标的 UI 切换悬浮球 ]
local ScreenGui = Instance.new("ScreenGui")
local MainToggle = Instance.new("ImageButton") -- 改为图片按钮
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")

-- 确保在 Xeno 环境下能放入正确的路径
local success, err = pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not success then
    ScreenGui.Parent = LP:WaitForChild("PlayerGui")
end

ScreenGui.Name = "Kyusuke_Mobile_Icon"
ScreenGui.ResetOnSpawn = false

-- 设置图片按钮属性
MainToggle.Name = "MainToggle"
MainToggle.Parent = ScreenGui
MainToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainToggle.BackgroundTransparency = 0.2 -- 半透明效果
MainToggle.Position = UDim2.new(0.05, 0, 0.15, 0)
MainToggle.Size = UDim2.new(0, 50, 0, 50)

-- 这里是关键：设置图案 ID (你可以换成你喜欢的图标 ID)
-- 下面这个 ID 是一个通用的白色科技感齿轮图标
MainToggle.Image = "rbxassetid://6031104609" 
MainToggle.ImageColor3 = Color3.fromRGB(255, 255, 255)
MainToggle.ScaleType = Enum.ScaleType.Fit
MainToggle.ImageTransparency = 0.1

MainToggle.Draggable = true -- Xeno 拖拽支持

UICorner.CornerRadius = UDim.new(0, 15) -- 圆角
UICorner.Parent = MainToggle

-- 漂亮的渐变边框
UIStroke.Thickness = 2.5
UIStroke.Color = Color3.fromRGB(255, 170, 0) -- 橙金色边框
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainToggle

-- 点击逻辑：切换 Rayfield UI 显示状态
MainToggle.MouseButton1Click:Connect(function()
    local RayfieldGui = game:GetService("CoreGui"):FindFirstChild("Rayfield") or LP.PlayerGui:FindFirstChild("Rayfield")
    if RayfieldGui then
        RayfieldGui.Enabled = not RayfieldGui.Enabled
        
        -- 点击时的小动画：缩放一下按钮
        MainToggle:TweenSize(UDim2.new(0, 45, 0, 45), "Out", "Quad", 0.1, true)
        task.wait(0.1)
        MainToggle:TweenSize(UDim2.new(0, 50, 0, 50), "Out", "Quad", 0.1, true)
    end
end)
