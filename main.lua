--[[
    Script: Kyusuke Hub
    Features: AutoClicker, Anti-AFK, Kill Aura with Keybind Toggle
    UI Library: Rayfield
    Language: English
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Window Settings
local Window = Rayfield:CreateWindow({
    Name = "🔥 Kyusuke Hub",
    LoadingTitle = "Loading Kyusuke Hub...",
    LoadingSubtitle = "by Kyusuke",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "KyusukeHub_Config",
        FileName = "Settings"
    },
    KeySystem = false
})

-- Global Variables
getgenv().AutoClick = false
getgenv().ClickDelay = 0.1
getgenv().AntiAFK = false
getgenv().KillAuraEnabled = false
getgenv().KillAuraRadius = 20 -- Default radius for Kill Aura

local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Helper function to find closest enemy (simple example)
local function findClosestTarget(radius)
    local closestTarget = nil
    local shortestDistance = radius + 1

    for i, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local distance = (RootPart.Position - targetRoot.Position).Magnitude
                if distance < shortestDistance and distance <= radius then
                    shortestDistance = distance
                    closestTarget = player.Character
                end
            end
        end
    end
    return closestTarget
end

-- Main Tab: Combat Features
local CombatTab = Window:CreateTab("Combat Features", 4483362458)

-- Auto Click Logic
local function toggleClick(state)
    getgenv().AutoClick = state
    if state then
        task.spawn(function()
            while getgenv().AutoClick do
                VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                task.wait(getgenv().ClickDelay)
            end
        end)
        Rayfield:Notify({Title = "Kyusuke Hub", Content = "Auto Click [ON]", Duration = 2})
    else
        Rayfield:Notify({Title = "Kyusuke Hub", Content = "Auto Click [OFF]", Duration = 2})
    end
end

-- 1. Auto Click Toggle
local ClickToggle = CombatTab:CreateToggle({
    Name = "Auto Clicker",
    CurrentValue = false,
    Flag = "AutoClickFlag",
    Callback = function(Value)
        if Value ~= getgenv().AutoClick then
            toggleClick(Value)
        end
    end,
})

-- 2. Click Delay Slider
CombatTab:CreateSlider({
    Name = "Click Delay (seconds)",
    Range = {0.01, 1},
    Increment = 0.05,
    Suffix = "s",
    CurrentValue = 0.1,
    Flag = "DelaySlider",
    Callback = function(Value)
        getgenv().ClickDelay = Value
    end,
})

-- Kill Aura Logic
local function toggleKillAura(state)
    getgenv().KillAuraEnabled = state
    if state then
        task.spawn(function()
            while getgenv().KillAuraEnabled do
                local target = findClosestTarget(getgenv().KillAuraRadius)
                if target and target:FindFirstChild("Humanoid") then
                    -- This is a very basic attack. In many games, you might need to:
                    -- 1. Equip a tool/weapon.
                    -- 2. Call a specific remote event for attacking.
                    -- 3. Move towards the target before attacking.
                    
                    -- Simple example: Teleport to target and click (not recommended, easily detected)
                    -- RootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3) 
                    
                    -- More common: Simulate mouse click when near target, assuming an auto-attack system
                    VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                end
                task.wait(0.1) -- Attack speed for Kill Aura
            end
        end)
        Rayfield:Notify({Title = "Kyusuke Hub", Content = "Kill Aura [ON]", Duration = 2})
    else
        Rayfield:Notify({Title = "Kyusuke Hub", Content = "Kill Aura [OFF]", Duration = 2})
    end
end

-- 3. Kill Aura Toggle
local KillAuraToggle = CombatTab:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = false,
    Flag = "KillAuraFlag",
    Callback = function(Value)
        if Value ~= getgenv().KillAuraEnabled then
            toggleKillAura(Value)
        end
    end,
})

-- 4. Kill Aura Radius Slider
CombatTab:CreateSlider({
    Name = "Kill Aura Radius",
    Range = {5, 100},
    Increment = 5,
    Suffix = "studs",
    CurrentValue = getgenv().KillAuraRadius,
    Flag = "KillAuraRadius",
    Callback = function(Value)
        getgenv().KillAuraRadius = Value
    end,
})


-- Main Tab: Utility Features
local UtilityTab = Window:CreateTab("Utility Features", 4483362458)

-- Anti-AFK Logic
local function toggleAntiAFK(state)
    getgenv().AntiAFK = state
    if state then
        task.spawn(function()
            while getgenv().AntiAFK do
                -- Simulate a jump
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                task.wait(math.random(10, 20)) -- Jump every 10-20 seconds
            end
        end)
        Rayfield:Notify({Title = "Kyusuke Hub", Content = "Anti-AFK [ON]", Duration = 2})
    else
        Rayfield:Notify({Title = "Kyusuke Hub", Content = "Anti-AFK [OFF]", Duration = 2})
    end
end

-- 1. Anti-AFK Toggle
local AntiAFKToggle = UtilityTab:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = false,
    Flag = "AntiAFKFlag",
    Callback = function(Value)
        if Value ~= getgenv().AntiAFK then
            toggleAntiAFK(Value)
        end
    end,
})

-- Hotkey Management Tab
local HotkeyTab = Window:CreateTab("Hotkeys", 4483362458)

-- Hotkey: Auto Clicker (R key)
HotkeyTab:CreateLabel("Auto Clicker: Press [ R ]")

-- Hotkey: Kill Aura (T key)
HotkeyTab:CreateLabel("Kill Aura: Press [ T ]")

-- Hotkey: Anti-AFK (Y key)
HotkeyTab:CreateLabel("Anti-AFK: Press [ Y ]")


-- Global Hotkey Listener
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    -- Auto Clicker Hotkey (R)
    if input.KeyCode == Enum.KeyCode.R then
        local newState = not getgenv().AutoClick
        ClickToggle:Set(newState)
    end

    -- Kill Aura Hotkey (T)
    if input.KeyCode == Enum.KeyCode.T then
        local newState = not getgenv().KillAuraEnabled
        KillAuraToggle:Set(newState)
    end

    -- Anti-AFK Hotkey (Y)
    if input.KeyCode == Enum.KeyCode.Y then
        local newState = not getgenv().AntiAFK
        AntiAFKToggle:Set(newState)
    end
end)


-- Other Settings Tab
local OtherTab = Window:CreateTab("Other", 4483362458)
OtherTab:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        Rayfield:Destroy()
        -- Stop all running loops
        getgenv().AutoClick = false
        getgenv().AntiAFK = false
        getgenv().KillAuraEnabled = false
    end,
})

Rayfield:Notify({
    Title = "Kyusuke Hub Injected",
    Content = "Welcome to Kyusuke Hub! Check Hotkeys tab.",
    Duration = 5
})

antiafk 跳的时间增加到17分钟跳一次
