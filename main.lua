-- [[ Kyusuke Hub v3.8 - Console Fix ]]

-- 安全加载 Rayfield
local Success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not Success or not Rayfield then
    warn("Kyusuke Hub: Rayfield UI 加载失败，请检查执行器是否支持 loadstring")
    return
end

-- 1. 变量初始化（严格预防 nil 报错）
getgenv().AutoClick = false
getgenv().ClickDelay = 0.1
getgenv().AutoFarmMonster = false
getgenv().SelectedMonster = "None"
getgenv().WalkSpeedValue = 16

local VIM = game:GetService("VirtualInputManager")
local LP = game:GetService("Players").LocalPlayer

-- 2. UI 创建
local Window = Rayfield:CreateWindow({
    Name = "🔥 Kyusuke Hub [FIXED]",
    LoadingTitle = "正在修复控制台报错...",
    LoadingSubtitle = "by Kyusuke",
    ConfigurationSaving = { Enabled = false } -- 暂时关闭配置保存以增加稳定性
})

-- 3. 核心功能标签页
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateToggle({
    Name = "Auto Clicker",
    CurrentValue = false,
    Callback = function(Value) getgenv().AutoClick = Value end,
})

MainTab:CreateSlider({
    Name = "Click Delay",
    Range = {0.05, 1},
    Increment = 0.05,
    CurrentValue = 0.1,
    Callback = function(Value) 
        -- 修复图1中的 nil 路径错误
        getgenv().ClickDelay = Value 
    end,
})

-- 4. 自动连点逻辑
task.spawn(function()
    while true do
        if getgenv().AutoClick then
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
        task.wait(getgenv().ClickDelay)
    end
end)

Rayfield:Notify({
    Title = "修复成功",
    Content = "nil 值报错已拦截，功能已就绪",
    Duration = 5
})
