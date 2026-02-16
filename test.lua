--[[
    Script: Kyusuke Hub (v4.0 Mobile Full-Clear)
    Fix: Fully hides all Rayfield UI elements on Mobile
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
    Name = "🔥 Kyusuke Hub v4.0",
    LoadingTitle = "Mobile Stability Patch",
    LoadingSubtitle = "Icon Toggle Fixed",
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

-- [ 5. UI 内容与 R 键 ]
local CombatTab = Window:CreateTab("Combat", 4483362458)
local ClickToggle = CombatTab:CreateToggle({
    Name = "Auto Clicker",
    CurrentValue = false,
    Flag = "AC_Flag",
    Callback = function(Value) getgenv().AutoClick = Value end,
})

CombatTab:CreateKeybind({
    Name = "Hotkey (R)",
    CurrentKeybind = "R",
    HoldToInteract = false,
    Callback = function()
        getgenv().AutoClick = not getgenv().AutoClick
        ClickToggle:Set(getgenv().AutoClick)
    end,
})

-- [ 6. 手机专用：彻底隐藏切换器 ]
local ScreenGui = Instance.new("ScreenGui")
local MainToggle = Instance.new("ImageButton")
local success, err = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not success then ScreenGui.Parent = PlayerGui end

ScreenGui.Name = "Kyusuke_Toggle_System"
MainToggle.Parent = ScreenGui
MainToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainToggle.BackgroundTransparency = 0.3
MainToggle.Position = UDim2.new(0, 10, 0.5, -25) -- 放在左边中间
MainToggle.Size = UDim2.new(0, 50, 0, 50)
MainToggle.Image = "rbxassetid://6031104
