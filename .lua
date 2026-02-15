local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🚀 极速自动化工具箱",
   LoadingTitle = "正在加载脚本...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "GeminiScripts", 
      FileName = "AutoClickerConfig"
   }
})

-- 变量定义
local _G = {
    AutoClick = false,
    ClickDelay = 0.1
}

-- 核心逻辑：自动点击
task.spawn(function()
    while true do
        task.wait(_G.ClickDelay)
        if _G.AutoClick then
            local VIM = game:GetService("VirtualInputManager")
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
    end
end)

-- 创建 Tab
local MainTab = Window:CreateTab("主要功能", 4483362458) -- 图标 ID

-- 1. 自动点击开关
local Toggle = MainTab:CreateToggle({
   Name = "开启自动点击 (Auto Clicker)",
   CurrentValue = false,
   Flag = "Toggle1", 
   Callback = function(Value)
      _G.AutoClick = Value
      Rayfield:Notify({
         Title = "状态更新",
         Content = Value and "自动点击已开启" or "自动点击已关闭",
         Duration = 2,
         Image = 4483362458,
      })
   end,
})

-- 2. 点击速度调节
local Slider = MainTab:CreateSlider({
   Name = "点击延迟 (秒)",
   Range = {0.01, 1},
   Increment = 0.01,
   Suffix = "s",
   CurrentValue = 0.1,
   Flag = "Slider1",
   Callback = function(Value)
      _G.ClickDelay = Value
   end,
})

-- 3. 信息展示
local Section = MainTab:CreateSection("设置")

MainTab:CreateButton({
   Name = "销毁 UI (Destroy)",
   Callback = function()
      Rayfield:Destroy()
   end,
})

Rayfield:Notify({
   Title = "加载成功!",
   Content = "按 V 键可以快速切换（如果你手动绑定了键位的话）",
   Duration = 5,
   Image = 4483362458,
})
