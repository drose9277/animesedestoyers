-- [[ 1. 环境初始化 ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")

-- 使用 getgenv() 确保在整个执行环境内变量唯一且同步
getgenv().AutoClickActive = false
getgenv().ClickSpeed = 0.1

-- [[ 2. 创建 UI 窗口 ]]
local Window = Rayfield:CreateWindow({
   Name = "🛡️ 稳定版 AutoClicker",
   LoadingTitle = "注入安全防护系统...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("控制台", 4483362458)

-- [[ 3. 功能组件 ]]
local ClickToggle = MainTab:CreateToggle({
   Name = "连点开关 (点不中请按 X 键)",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(Value)
      getgenv().AutoClickActive = Value
   end,
})

MainTab:CreateSlider({
   Name = "点击延迟 (秒)",
   Range = {0.02, 1}, -- 最小值设为 0.02 预防卡死
   Increment = 0.01,
   Suffix = "s",
   CurrentValue = 0.1,
   Flag = "Slider1",
   Callback = function(Value)
      getgenv().ClickSpeed = Value
   end,
})

-- [[ 4. 紧急制动系统 (关键修复) ]]
-- 无论是否在聊天，按 X 强制停止所有逻辑
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.X then
        getgenv().AutoClickActive = false
        -- 尝试强制更新 UI 状态（如果 Rayfield 支持）
        Rayfield:Notify({Title = "!!! 紧急制动 !!!", Content = "所有自动点击已强制切断", Duration = 3})
    end
end)

-- [[ 5. 核心循环：采用防阻塞模式 ]]
task.spawn(function()
    while true do
        -- 只有在变量为 true 时才进入点击分支
        if getgenv().AutoClickActive == true then
            -- 执行一次点击
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            
            -- 动态读取延迟，防止在极速模式下无法读取到关闭信号
            task.wait(getgenv().ClickSpeed)
        else
            -- 当开关关闭时，循环进入“低功耗等待”模式，完全释放 CPU 给 UI
            task.wait(0.3) 
        end
    end
end)

Rayfield:Notify({Title = "启动成功", Content = "按 X 键可随时救命", Duration = 5})
