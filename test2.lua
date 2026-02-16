-- 【完整一键脚本：Rayfield 库加载 + 示例菜单 + 手机端悬浮球切换】
-- 使用 Sirius 最新版 Rayfield（最稳定，广泛使用）
-- 执行此脚本后会出现悬浮球，点击即可显示/隐藏 Rayfield 菜单
-- 默认菜单只有一个示例按钮，你可以自行在此基础上添加功能

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 创建 Rayfield 窗口（必须先创建才有界面）
local Window = Rayfield:CreateWindow({
    Name = "手机端 Rayfield 示例",
    LoadingTitle = "Rayfield 加载中",
    LoadingSubtitle = "专为手机优化",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MobileRayfieldExample"  -- 配置保存文件夹
    },
    -- KeySystem = false,  -- 如果不需要钥匙系统可取消注释
})

-- 创建一个示例 Tab 和按钮（你可以在这里继续添加你的功能）
local MainTab = Window:CreateTab("主功能", nil)  -- 图标可填 asset id

MainTab:CreateButton({
    Name = "示例按钮 - 打印 Hello",
    Description = "点击测试按钮是否正常工作",
    Callback = function()
        Rayfield:Notify({
            Title = "按钮触发",
            Content = "Hello World! 你点击了示例按钮",
            Duration = 5,
        })
        print("示例按钮被点击了！")
    end,
})

MainTab:CreateLabel("欢迎使用手机端 Rayfield！")
MainTab:CreateParagraph({Title = "说明", Content = "使用左上角悬浮球切换菜单显示/隐藏。\n你可以继续在此添加 Tab、Slider、Toggle 等功能。"})

-- ==================== 手机端悬浮球代码 ====================
local LP = game.Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
local MainToggle = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")

-- 优先放 CoreGui，失败放 PlayerGui
local success = pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not success then
    if LP and LP:FindFirstChild("PlayerGui") then
        ScreenGui.Parent = LP.PlayerGui
    else
        warn("无法放置悬浮球 ScreenGui")
        return
    end
end

ScreenGui.Name = "Kyusuke_Mobile_Icon"
ScreenGui.ResetOnSpawn = false

MainToggle.Name = "MainToggle"
MainToggle.Parent = ScreenGui
MainToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainToggle.BackgroundTransparency = 0.2
MainToggle.Position = UDim2.new(0.05, 0, 0.15, 0)
MainToggle.Size = UDim2.new(0, 50, 0, 50)

-- 图标（白色齿轮，可自行替换 ID）
MainToggle.Image = "rbxassetid://6031104609"
MainToggle.ImageColor3 = Color3.fromRGB(255, 255, 255)
MainToggle.ScaleType = Enum.ScaleType.Fit
MainToggle.ImageTransparency = 0.1

MainToggle.Draggable = true  -- 支持拖拽

UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainToggle

UIStroke.Thickness = 2.5
UIStroke.Color = Color3.fromRGB(255, 170, 0)  -- 橙金边框
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainToggle

-- 点击切换 Rayfield 显示状态
MainToggle.MouseButton1Click:Connect(function()
    local RayfieldGui = game:GetService("CoreGui"):FindFirstChild("Rayfield")
        or (LP and LP.PlayerGui:FindFirstChild("Rayfield"))
    
    if RayfieldGui then
        RayfieldGui.Enabled = not RayfieldGui.Enabled
        
        -- 点击动画
        MainToggle:TweenSize(UDim2.new(0, 45, 0, 45), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true)
        task.wait(0.1)
        MainToggle:TweenSize(UDim2.new(0, 50, 0, 50), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true)
    else
        warn("Rayfield 界面未找到（可能加载失败）")
    end
end)

print("手机端 Rayfield + 悬浮球加载成功！点击左上角图标切换菜单")
Rayfield:Notify({
    Title = "加载成功",
    Content = "悬浮球已就绪，点击左上角图标打开菜单",
    Duration = 8,
})
