--[[
    Kyusuke Hub - Universal Auto Clicker
    UI Library: Rayfield
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Kyusuke Hub | Shipping Lanes",
   LoadingTitle = "Kyusuke Hub Loading...",
   LoadingSubtitle = "by Kyusuke",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "KyusukeHubConfig",
      FileName = "MainConfig"
   }
})

-- Global Variables
getgenv().autoClick = false
getgenv().clickSpeed = 0.01 -- Extremely fast

local MainTab = Window:CreateTab("Main Hacks", 4483362458)

-- Auto Click Logic using VirtualUser (Higher speed)
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    vu:CaptureController()
    vu:ClickButton2(Vector2.new())
end)

local function startClicking()
    task.spawn(function()
        while getgenv().autoClick do
            -- Fast Click Execution
            vu:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(getgenv().clickSpeed)
            vu:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end
    end)
end

-- UI Elements
MainTab:CreateToggle({
   Name = "Enable Fast Auto-Click",
   CurrentValue = false,
   Flag = "AutoClickToggle",
   Callback = function(Value)
      getgenv().autoClick = Value
      if Value then
          startClicking()
      end
   end,
})

MainTab:CreateSlider({
   Name = "Click Delay (Seconds)",
   Info = "Lower = Faster",
   Range = {0.001, 0.5},
   Increment = 0.005,
   Suffix = "s",
   CurrentValue = 0.01,
   Flag = "SpeedSlider",
   Callback = function(Value)
      getgenv().clickSpeed = Value
   end,
})

MainTab:CreateSection("Emergency Controls")

MainTab:CreateButton({
   Name = "FORCE STOP (Kill Script)",
   Callback = function()
      getgenv().autoClick = false
      Rayfield:Destroy()
      -- Kill any remaining loops
      error("Script Forcefully Stopped by User")
   end,
})

Rayfield:Notify({
   Title = "Kyusuke Hub Loaded",
   Content = "Ready to dominate Shipping Lanes!",
   Duration = 5,
   Image = 4483362458,
})
