local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🚀 自动点击辅助器",
   LoadingTitle = "正在加载脚本...",
   LoadingSubtitle = "by YourName",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "MyScriptConfig",
      FileName = "AutoClickerConfig"
   }
})

local Tab = Window:CreateTab("主要功能", 4483362458) -- 图标 ID

-- 变量定义
getgenv().autoClick = false

-- 自动点击逻辑
local function doAutoClick()
    spawn(function()
        while getgenv().autoClick do
            -- 这里模拟点击操作，具体路径需根据游戏内的按钮修改
            -- 下面是通用的虚拟激活示例
            local VirtualInputManager = game:GetService("VirtualInputManager")
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            
            task.wait(0.1) -- 点击间隔
        end
    end)
end

-- UI 切换开关
local Toggle = Tab:CreateToggle({
   Name = "开启自动点击 (Auto Click)",
   CurrentValue = false,
   Flag = "AutoClickFlag",
   Callback = function(Value)
      getgenv().autoClick = Value
      if Value then
          Rayfield:Notify({Title = "已开启", Content = "自动点击正在运行", Duration = 2})
          doAutoClick()
      end
   end,
})

-- 标签页
local Label = Tab:CreateLabel("请确保你在需要点击的区域上方")

Rayfield:Notify({Title = "加载成功", Content = "脚本已准备就绪！", Duration = 5})
