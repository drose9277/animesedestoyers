--[[
    Script: Kyusuke Hub
    Features: AutoClicker with Keybind Toggle
    UI Library: Rayfield
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 窗口设置
local Window = Rayfield:CreateWindow({
    Name = "🔥 Kyusuke Hub",
    LoadingTitle = "正在载入 Kyusuke Hub...",
    LoadingSubtitle = "by Kyusuke",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "KyusukeHub_Config", 
        FileName = "Settings"
    },
    KeySystem = false
})

-- 全局变量
getgenv().AutoClick = false
getgenv().ClickDelay = 0.1
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")

-- 主标签页
local MainTab = Window:CreateTab("战斗功能", 4483362458)

-- 1. 自动点击逻辑函数
local function toggleClick(state)
    getgenv().AutoClick = state
    if state then
        task.spawn(function()
            while getgenv().AutoClick do
                -- 模拟鼠标左键点击
                VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                task.wait(getgenv().ClickDelay)
            end
        end)
        Rayfield:Notify({Title = "Kyusuke Hub", Content = "自动点击已【开启】", Duration = 2})
    else
        Rayfield:Notify({Title = "Kyusuke Hub", Content = "自动点击已【关闭】", Duration = 2})
    end
end

-- 2. UI 开关
local ClickToggle = MainTab:CreateToggle({
    Name = "开启自动点击",
    CurrentValue = false,
    Flag = "AutoClickFlag",
    Callback = function(Value)
        if Value ~= getgenv().AutoClick then -- 避免重复触发
            toggleClick(Value)
        end
    end,
})

-- 3. 快捷键监听 (默认 R 键)
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end -- 如果正在打字则不触发
    
    if input.KeyCode == Enum.KeyCode.R then -- 你可以在这里把 R 改成其他按键
        local newState = not getgenv().AutoClick
        ClickToggle:Set(newState) -- 这会自动触发上面的 Callback
    end
end)

-- 4. 速度调节
MainTab:CreateSlider({
    Name = "点击延迟 (秒)",
    Range = {0.01, 1},
    Increment = 0.05,
    Suffix = "s",
    CurrentValue = 0.1,
    Flag = "DelaySlider",
    Callback = function(Value)
        getgenv().ClickDelay = Value
    end,
})

-- 5. 提示标签
MainTab:CreateLabel("按键盘 [ R ] 键可快速开关点击器")

-- 其他功能
local OtherTab = Window:CreateTab("其他", 4483362458)
OtherTab:CreateButton({
    Name = "销毁 UI",
    Callback = function()
        Rayfield:Destroy()
    end,
})

Rayfield:Notify({
    Title = "Kyusuke Hub 已注入",
    Content = "按 R 键开启你的点击之旅！",
    Duration = 5
})
