--[[
    Script: Kyusuke Hub ESP Module
    Version: v3.6 (Blox Strike Optimized)
    Warning: Requires executor with Drawing Lib support.
]]

-- 1. 初始化变量
getgenv().ESPEnabled = false -- 默认关闭，由 UI 控制

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local ESPObjects = {}

-- 2. 清理函数 (防止内存泄漏)
local function ClearESP(player)
    if ESPObjects[player] then
        if ESPObjects[player].Box then ESPObjects[player].Box:Remove() end
        if ESPObjects[player].NameTag then ESPObjects[player].NameTag:Remove() end
        ESPObjects[player] = nil
    end
end

-- 3. 创建绘制对象
local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local Box = Drawing.new("Square")
    Box.Thickness = 2
    Box.Filled = false
    Box.Transparency = 1
    Box.Color = Color3.fromRGB(255, 50, 50) -- 明显的红色
    
    local NameTag = Drawing.new("Text")
    NameTag.Size = 14
    NameTag.Center = true
    NameTag.Outline = true
    NameTag.Color = Color3.fromRGB(255, 255, 255)
    
    ESPObjects[player] = {Box = Box, NameTag = NameTag}
end

-- 4. 核心逻辑循环
RunService.RenderStepped:Connect(function()
    if not getgenv().ESPEnabled then
        -- 如果功能关闭，隐藏所有对象
        for _, esp in pairs(ESPObjects) do
            esp.Box.Visible = false
            esp.NameTag.Visible = false
        end
        return
    end

    for player, esp in pairs(ESPObjects) do
        local char = player.Character
        local lpChar = LocalPlayer.Character
        
        -- 安全检查：确保目标和自己都活着
        if char and char:FindFirstChild("HumanoidRootPart") and lpChar and lpChar:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            local hum = char:FindFirstChild("Humanoid")
            
            local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            
            if onScreen and hum and hum.Health > 0 then
                -- 计算高度和宽度 (根据距离动态缩放)
                local headWorld = hrp.Position + Vector3.new(0, 3, 0)
                local legWorld = hrp.Position - Vector3.new(0, 3.5, 0)
                local headScreen = Camera:WorldToViewportPoint(headWorld)
                local legScreen = Camera:WorldToViewportPoint(legWorld)
                
                local height = math.abs(headScreen.Y - legScreen.Y)
                local width = height * 0.6
                
                -- 更新方框
                esp.Box.Size = Vector2.new(width, height)
                esp.Box.Position = Vector2.new(screenPos.X - width / 2, screenPos.Y - height / 2)
                esp.Box.Visible = true
                
                -- 更新文字 (名字 + 血量 + 距离)
                local dist = math.floor((lpChar.HumanoidRootPart.Position - hrp.Position).Magnitude)
                esp.NameTag.Text = string.format("%s\n[%d HP] %dm", player.Name, math.floor(hum.Health), dist)
                esp.NameTag.Position = Vector2.new(screenPos.X, screenPos.Y - height / 2 - 25)
                esp.NameTag.Visible = true
            else
                esp.Box.Visible = false
                esp.NameTag.Visible = false
            end
        else
            esp.Box.Visible = false
            esp.NameTag.Visible = false
        end
    end
end)

-- 5. 玩家监听
for _, player in pairs(Players:GetPlayers()) do
    CreateESP(player)
end
Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(ClearESP)

-- 6. UI 联动提示 (整合进 Rayfield)
Rayfield:Notify({
    Title = "Kyusuke Hub ESP",
    Content = "ESP System initialized. Ready to toggle.",
    Duration = 3
})
