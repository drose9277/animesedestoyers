--[[
    Script: Kyusuke Hub (v3.9 Stable + Keybind)
    Fixes: Restored 'R' Keybind to toggle AutoClick
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- [ 1. 核心等待逻辑 ]
local Players = game:GetService("Players")
while not Players.LocalPlayer do task.wait(0.1) end
local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui", 10)

-- [ 2. 全局变量 ]
getgenv().AutoClick = false
getgenv().ClickDelay = 0.1
getgenv().AntiAFKEnabled = false

local VIM = game:GetService("VirtualInputManager")

-- [ 3. 窗口创建 ]
local Window = Rayfield:CreateWindow({
    Name = "🔥 Kyusuke Hub v3.9",
    LoadingTitle = "Keybind Restored",
    LoadingSubtitle = "Press 'R' to Toggle AC",
    ConfigurationSaving = { Enabled = true, FolderName = "Kyusuke_Xeno" }
})

-- [ 4. 核心循环 ]
task.spawn(function()
    while true do
        if getgenv().AutoClick then
            pcall(function()
                VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            end)
        end
        task.wait(getgenv().ClickDelay)
    end
end)

-- [ 5. UI 标签页与 R 键绑定 ]
local CombatTab = Window:CreateTab("Combat", 4483362458)

local ClickToggle = CombatTab:CreateToggle({
    Name = "Auto Clicker",
    CurrentValue = false,
    Flag = "AutoClickFlag",
    Callback = function(Value) getgenv().AutoClick = Value end,
})

-- 重新加入 R 键绑定
CombatTab:CreateKeybind({
    Name = "Clicker Hotkey (R)",
    CurrentKeybind = "R",
    HoldToInteract = false,
    Callback = function(Keybind)
        getgenv().AutoClick = not getgenv().AutoClick
        ClickToggle:Set(getgenv().AutoClick) -- 同步 UI 上的开关状态
        
        -- 可选：通知反馈
        Rayfield:Notify({
            Title = "AutoClick Status",
            Content = getgenv().AutoClick and "已开启 (ON)" or "已关闭 (OFF)",
            Duration = 2
        })
    end,
})

-- [ 6. 图标悬浮球 (保持不变) ]
local ScreenGui = Instance.new("ScreenGui")
local MainToggle = Instance.new("ImageButton")
local success, err = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not success then ScreenGui.Parent = PlayerGui end

ScreenGui.Name = "KyusukeIcon"
MainToggle.Parent = ScreenGui
MainToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainToggle.Position = UDim2.new(0.05, 0, 0.15, 0)
MainToggle.Size = UDim2.new(0, 50, 0, 50)
MainToggle.Image = "rbxassetid://6031104609"
MainToggle.Draggable = true
Instance.new("UICorner", MainToggle).CornerRadius = UDim.new(0, 15)

MainToggle.MouseButton1Click:Connect(function()
    local target = game:GetService("CoreGui"):FindFirstChild("Rayfield") or PlayerGui:FindFirstChild("Rayfield")
    if target then target.Enabled = not target.Enabled end
end)

Rayfield:Notify({
    Title = "系统就绪",
    Content = "R 键和悬浮球均已生效！",
    Duration = 5
})
