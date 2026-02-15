-- [[ 1. 加载 UI 库 ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- [[ 2. 全局状态变量 ]]
-- 使用 _G 或 getgenv() 确保变量在脚本运行期间始终可访问
_G.AutoClickerRunning = false
_G.ClickDelay = 0.1

-- [[ 3. 创建界面 ]]
local Window = Rayfield:CreateWindow({
   Name = "🚀 修复版 AutoClicker",
   LoadingTitle = "正在加载系统...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("主控制面板", 4483362458)

-- [[ 4. UI 切换开关 ]]
local Toggle = MainTab:CreateToggle({
   Name = "启用连点 (Enable Clicker)",
   CurrentValue = false,
   Flag = "ClickToggle", 
   Callback = function(Value)
      _G.AutoClickerRunning = Value -- 实时更新状态
      if Value then
          print("自动点击：已激活")
      else
          print("自动点击：已停止")
      end
   end,
})

-- [[ 5. 速度调节（防卡顿） ]]
MainTab:CreateSlider({
   Name = "点击频率 (秒)",
   Range = {0.05, 1}, -- 建议最低不要低于 0.05，否则会卡死 UI
   Increment = 0.05,
   Suffix = "s",
   CurrentValue = 0.1,
   Flag = "SpeedSlider",
   Callback = function(Value)
      _G.ClickDelay = Value
   end,
})

-- [[ 6. 核心连点逻辑 - 关键修复点 ]]
-- 使用 task.spawn 将循环放在后台，不阻塞 UI 渲染
task.spawn(function()
    local VIM = game:GetService("VirtualInputManager")
    
    while true do
        -- 核心判断：只有当变量为 true 时才执行点击
        if _G.AutoClickerRunning then
            -- 模拟按下并弹起，这是一次完整的点击
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
        
        -- 强制等待：如果没有等待时间，游戏会直接崩溃
        task.wait(_G.ClickDelay) 
    end
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.X then
        _G.AutoClickerRunning = false
        Rayfield:Notify({Title = "紧急停止", Content = "已通过快捷键 X 关闭点击", Duration = 2})
    end
end)

Rayfield:Notify({
   Title = "脚本注入成功",
   Content = "如果点击太快导致无法操作，请尝试调高延迟",
   Duration = 5
})
