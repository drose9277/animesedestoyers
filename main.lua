-- Roblox AutoClicker 基础脚本
local Active = false
local UIS = game:GetService("UserInputService")

-- 设置快捷键来开启/关闭 (这里设定为键盘上的 'V' 键)
UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.V then
        Active = not Active
        if Active then
            print("AutoClicker: 开启")
        else
            print("AutoClicker: 关闭")
        end
    end
end)

-- 循环点击逻辑
task.spawn(function()
    while task.wait(0.1) do -- 每0.1秒点击一次，可以根据需要调整速度
        if Active then
            -- 模拟鼠标左键点击
            local VirtualInputManager = game:GetService("VirtualInputManager")
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
    end
end)
