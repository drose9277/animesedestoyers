-- [[ 1. 加载 UI 库 ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- [[ 2. 初始化全局变量 ]]
getgenv().AutoClickerEnabled = false
getgenv().ClickDelay = 0.1

-- [[ 3. 创建 UI 窗口 ]]
local Window = Rayfield:CreateWindow({
   Name = "🚢 Shipping Lanes 助手",
   LoadingTitle = "正在注入...",
   LoadingSubtitle = "by YourName",
   ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("自动功能", 4483362458)

-- [[ 4. UI 组件：开关 ]]
MainTab:CreateToggle({
   Name = "启用自动点击",
   CurrentValue = false,
   Flag = "AutoClickToggle",
   Callback = function(Value)
      getgenv().AutoClickerEnabled = Value
   end,
})

-- [[ 5. UI 组件：延迟调节 ]]
MainTab:CreateSlider({
   Name = "点击速度 (秒)",
   Range = {0.01, 1},
   Increment = 0.01,
   Suffix = "s",
   CurrentValue = 0.1,
   Flag = "DelaySlider",
   Callback = function(Value)
      getgenv().ClickDelay = Value
   end,
})

-- [[ 6. 核心逻辑 (死循环检测) ]]
-- 使用 task.spawn 确保循环不会卡住 UI 的加载
task.spawn(function()
    while true do
        if getgenv().AutoClickerEnabled then
            -- 模拟鼠标点击逻辑
            local VIM = game:GetService("VirtualInputManager")
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
        task.wait(getgenv().ClickDelay)
    end
end)

Rayfield:Notify({
   Title = "脚本已就绪",
   Content = "请在菜单中开启功能",
   Duration = 3
})
