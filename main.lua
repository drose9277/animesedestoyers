-- [[ Kyusuke Hub V6 - 极致稳定版 ]]

-- 1. 初始化 (防止 nil)
local Success, Error = pcall(function()
    getgenv().AutoClickRunning = false
    
    local UIS = game:GetService("UserInputService")
    local VIM = game:GetService("VirtualInputManager")
    local CoreGui = game:GetService("CoreGui")

    -- 清理旧 UI
    if CoreGui:FindFirstChild("KyusukeUI") then
        CoreGui.KyusukeUI:Destroy()
    end

    -- 2. 创建极简 UI
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "KyusukeUI"

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 150, 0, 70)
    Main.Position = UDim2.new(0.5, -75, 0, 50) -- 放在顶部中间偏下
    Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Main.Active = true
    Main.Draggable = true -- 允许你把它拖到角落

    local Button = Instance.new("TextButton", Main)
    Button.Size = UDim2.new(0.9, 0, 0.8, 0)
    Button.Position = UDim2.new(0.05, 0, 0.1, 0)
    Button.Text = "START (V6)"
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.TextSize = 20
    Button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)

    -- 3. 核心点击逻辑 (防卡死模式)
    task.spawn(function()
        while true do
            if getgenv().AutoClickRunning then
                -- 坐标设在远离 UI 的负数位置
                VIM:SendMouseButtonEvent(-2000, -2000, 0, true, game, 0)
                VIM:SendMouseButtonEvent(-2000, -2000, 0, false, game, 0)
                task.wait(0.1) 
            else
                task.wait(0.5)
            end
        end
    end)

    -- 4. 按钮交互
    Button.MouseButton1Click:Connect(function()
        getgenv().AutoClickRunning = not getgenv().AutoClickRunning
        if getgenv().AutoClickRunning then
            Button.Text = "RUNNING"
            Button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        else
            Button.Text = "START (V6)"
            Button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        end
    end)

    -- 5. 快捷键 X 停止
    UIS.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.X then
            getgenv().AutoClickRunning = false
            Button.Text = "START (V6)"
            Button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        end
    end)
end)

if not Success then
    warn("Kyusuke Hub 加载失败: " .. tostring(Error))
end
