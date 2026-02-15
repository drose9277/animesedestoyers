-- Kyusuke Hub: Anime Destroyers (Native UI Version)
-- No external library needed = No more Nil/Padding Errors

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ClickToggle = Instance.new("TextButton")
local FarmToggle = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")

-- GUI 基础设置
ScreenGui.Name = "KyusukeHubNative"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 250)
MainFrame.Active = true
MainFrame.Draggable = true -- 允许鼠标拖动界面

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Kyusuke Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- 变量
getgenv().autoClick = false
getgenv().autoFarm = false

-- 自动点击函数
local function doClick()
    task.spawn(function()
        while getgenv().autoClick do
            local vim = game:GetService("VirtualInputManager")
            vim:SendMouseButtonEvent(500, 500, 0, true, game, 0)
            vim:SendMouseButtonEvent(500, 500, 0, false, game, 0)
            task.wait(0.05)
        end
    end)
end

-- 自动刷怪函数 (自动找最近的怪)
local function doFarm()
    task.spawn(function()
        while getgenv().autoFarm do
            pcall(function()
                local player = game.Players.LocalPlayer
                local target = nil
                local dist = math.huge
                
                -- 寻找最近的怪
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and not game.Players:GetPlayerFromCharacter(v) then
                        local d = (player.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                        if d < dist then
                            dist = d
                            target = v
                        end
                    end
                end
                
                if target then
                    player.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                end
            end)
            task.wait(0.1)
        end
    end)
end

-- UI 按钮设置
ClickToggle.Parent = MainFrame
ClickToggle.Position = UDim2.new(0.1, 0, 0.2, 0)
ClickToggle.Size = UDim2.new(0.8, 0, 0, 40)
ClickToggle.Text = "Auto Click: OFF"
ClickToggle.MouseButton1Click:Connect(function()
    getgenv().autoClick = not getgenv().autoClick
    ClickToggle.Text = getgenv().autoClick and "Auto Click: ON" or "Auto Click: OFF"
    ClickToggle.BackgroundColor3 = getgenv().autoClick and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    if getgenv().autoClick then doClick() end
end)

FarmToggle.Parent = MainFrame
FarmToggle.Position = UDim2.new(0.1, 0, 0.45, 0)
FarmToggle.Size = UDim2.new(0.8, 0, 0, 40)
FarmToggle.Text = "Auto Farm: OFF"
FarmToggle.MouseButton1Click:Connect(function()
    getgenv().autoFarm = not getgenv().autoFarm
    FarmToggle.Text = getgenv().autoFarm and "Auto Farm: ON" or "Auto Farm: OFF"
    FarmToggle.BackgroundColor3 = getgenv().autoFarm and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    if getgenv().autoFarm then doFarm() end
end)

StatusLabel.Parent = MainFrame
StatusLabel.Position = UDim2.new(0, 0, 0.8, 0)
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Text = "Status: Native UI Ready"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.BackgroundTransparency = 1
