-- [ 手机端专用：带图标的 UI 切换悬浮球 ] 
-- 已修复 LP 未定义问题 + 更安全的 Parent 放置逻辑
-- 适用于 Xeno 等执行器，Rayfield UI 切换按钮

local LP = game.Players.LocalPlayer  -- 修复关键：定义 LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
local MainToggle = Instance.new("ImageButton")  -- 改为图片按钮
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")

-- 优先尝试放入 CoreGui（大多数执行器支持），失败则放入 PlayerGui（手机端更稳定）
local success, err = pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)

if not success then
    if LP and LP:FindFirstChild("PlayerGui") then
        ScreenGui.Parent = LP.PlayerGui
    else
        warn("无法放置 ScreenGui：CoreGui 和 PlayerGui 都不可用")
        return  -- 彻底失败就停止执行
    end
end

ScreenGui.Name = "Kyusuke_Mobile_Icon"
ScreenGui.ResetOnSpawn = false

-- 设置图片按钮属性
MainToggle.Name = "MainToggle"
MainToggle.Parent = ScreenGui
MainToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainToggle.BackgroundTransparency = 0.2  -- 半透明效果
MainToggle.Position = UDim2.new(0.05, 0, 0.15, 0)
MainToggle.Size = UDim2.new(0, 50, 0, 50)

-- 图标 ID（白色科技感齿轮，可自行替换）
MainToggle.Image = "rbxassetid://6031104609" 
MainToggle.ImageColor3 = Color3.fromRGB(255, 255, 255)
MainToggle.ScaleType = Enum.ScaleType.Fit
MainToggle.ImageTransparency = 0.1

MainToggle.Draggable = true  -- 支持拖拽（Xeno 等执行器有效）

UICorner.CornerRadius = UDim.new(0, 15)  -- 圆角
UICorner.Parent = MainToggle

-- 漂亮的渐变边框
UIStroke.Thickness = 2.5
UIStroke.Color = Color3.fromRGB(255, 170, 0)  -- 橙金色边框
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainToggle

-- 点击逻辑：切换 Rayfield UI 显示状态
MainToggle.MouseButton1Click:Connect(function()
    -- 同时在 CoreGui 和 PlayerGui 查找 Rayfield（兼容不同执行器）
    local RayfieldGui = game:GetService("CoreGui"):FindFirstChild("Rayfield") 
        or (LP and LP.PlayerGui:FindFirstChild("Rayfield"))
    
    if RayfieldGui then
        RayfieldGui.Enabled = not RayfieldGui.Enabled
        
        -- 点击时的缩放动画
        MainToggle:TweenSize(UDim2.new(0, 45, 0, 45), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true)
        task.wait(0.1)
        MainToggle:TweenSize(UDim2.new(0, 50, 0, 50), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true)
    else
        warn("未找到 Rayfield UI，请先加载 Rayfield 脚本")
    end
end)

print("手机端悬浮球加载成功！可拖拽按钮切换 Rayfield UI")
