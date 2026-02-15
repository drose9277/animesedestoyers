-- Kyusuke Hub: Anime Destroyers Edition
-- Fixed UI and Clicker

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Kyusuke Hub | Anime Destroyers", "Midnight")

-- Variables
getgenv().autoClick = false
getgenv().clickSpeed = 0.05

-- Main Tab
local Main = Window:NewTab("Main")
local Section = Main:NewSection("Clicker Functions")

-- Anime Destroyers 专属点击函数
local function doClick()
    task.spawn(function()
        while getgenv().autoClick do
            -- 策略 A: 尝试触发游戏内置点击事件 (最有效)
            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Click", true) or 
                           game:GetService("ReplicatedStorage"):FindFirstChild("ClickRemote", true)
            
            if remote and remote:IsA("RemoteEvent") then
                remote:FireServer()
            else
                -- 策略 B: 备选模拟点击
                local vim = game:GetService("VirtualInputManager")
                vim:SendMouseButtonEvent(500, 500, 0, true, game, 0)
                vim:SendMouseButtonEvent(500, 500, 0, false, game, 0)
            end
            task.wait(getgenv().clickSpeed)
        end
    end)
end

Section:NewToggle("Enable Auto Click", "Starts clicking automatically", function(state)
    getgenv().autoClick = state
    if state then
        doClick()
    end
end)

Section:NewSlider("Click Speed", "Lower is faster", 0.5, 0.01, function(s)
    getgenv().clickSpeed = s
end)

-- Settings Tab
local Settings = Window:NewTab("Settings")
local SettingSection = Settings:NewSection("Controls")

SettingSection:NewKeybind("Toggle UI", "Press to Hide/Show UI", Enum.KeyCode.RightControl, function()
	Library:ToggleLib()
end)

SettingSection:NewButton("FORCE STOP", "Kill all scripts", function()
    getgenv().autoClick = false
    game:GetService("CoreGui"):FindFirstChild("Kyusuke Hub | Anime Destroyers"):Destroy()
    error("Force Stopped")
end)

-- Anti-AFK
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)
