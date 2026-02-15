local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 全局变量控制
getgenv().AutoClickSpeed = 0.01 -- 默认间隔 (秒)
getgenv().Clicking = false

local Window = Rayfield:CreateWindow({
   Name = "🚀 极速点击器 Pro",
   LoadingTitle = "正在载入脚本...",
   ConfigurationSaving = { Enabled = false }
})

local Tab = Window:CreateTab("核心功能", 4483362458)

-- 极速点击函数
local function startClicking()
    task.spawn(function()
        while getgenv().Clicking do
            -- 使用 VirtualInputManager 模拟硬件级点击
            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 0)
            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 0)
            
            -- 使用 task.wait() 比 wait() 更精准且不容易崩溃
            task.wait(getgenv().AutoClickSpeed)
        end
    end)
end

-- UI 控件：速度调节
Tab:CreateSlider({
   Name = "点击间隔 (秒)",
   Info = "数值越小点击越快",
   Range = {0.001, 1},
   Increment = 0.01,
   Suffix = "s",
   CurrentValue = 0.01,
   Flag = "SpeedSlider",
   Callback = function(Value)
      getgenv().AutoClickSpeed = Value
   end,
})

-- UI 控件：开关与强行停止
Tab:CreateToggle({
   Name = "开启极速点击",
   CurrentValue = false,
   Flag = "ClickToggle",
   Callback = function(Value)
      getgenv().Clicking = Value
      if Value then
          startClicking()
      else
          -- 强行停止逻辑：由于 while 循环检查 getgenv().Clicking，设置为 false 后会立即退出循环
          Rayfield:Notify({Title = "已停止", Content = "点击脚本已安全关闭", Duration = 2})
      end
   end,
})

-- 强行销毁 UI 按钮
Tab:CreateButton({
   Name = "完全卸载脚本 (Emergency Stop)",
   Callback = function()
       getgenv().Clicking = false -- 先停逻辑
       Rayfield:Destroy() -- 再关 UI
   end,
})
