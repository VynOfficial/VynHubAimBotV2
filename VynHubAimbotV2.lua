--[[
Aimbot Universal - VynOfficial
Exodus 20:15 "You shall not steal."
]]

-- Services
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local cam = workspace.CurrentCamera
local lp = players.LocalPlayer
local mouse = lp:GetMouse()

-- Config
local settings = {
    Aimbot = false,
    TeamCheck = false,
    WallCheck = false,
    AimAssist = false,
    FOVVisible = true,
    FOVSize = 100,
    AimPart = "Head",
}

-- GUI
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "AimbotGUI"

-- Draggable Frame
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 200, 0, 250)
frame.Position = UDim2.new(0, 100, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- Scrolling
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, 0, 1, 0)
scroll.CanvasSize = UDim2.new(0, 0, 0, 400)
scroll.ScrollBarThickness = 4
scroll.BackgroundTransparency = 1

-- Title
local title = Instance.new("TextLabel", scroll)
title.Text = "Aimbot Universal"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- Add toggle function
local function addToggle(name, default)
    local toggle = Instance.new("TextButton", scroll)
    toggle.Size = UDim2.new(1, -10, 0, 30)
    toggle.Position = UDim2.new(0, 5, 0, #scroll:GetChildren() * 30)
    toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Font = Enum.Font.Gotham
    toggle.TextSize = 14
    toggle.Text = name .. ": " .. (default and "ON" or "OFF")
    toggle.MouseButton1Click:Connect(function()
        settings[name] = not settings[name]
        toggle.Text = name .. ": " .. (settings[name] and "ON" or "OFF")
    end)
    settings[name] = default
end

-- Add dropdown for AimPart
local dropdown = Instance.new("TextButton", scroll)
dropdown.Size = UDim2.new(1, -10, 0, 30)
dropdown.Position = UDim2.new(0, 5, 0, #scroll:GetChildren() * 30)
dropdown.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
dropdown.Font = Enum.Font.Gotham
dropdown.TextSize = 14
dropdown.Text = "AimPart: Head"
dropdown.MouseButton1Click:Connect(function()
    settings.AimPart = settings.AimPart == "Head" and "Torso" or "Head"
    dropdown.Text = "AimPart: " .. settings.AimPart
end)

-- Add toggles
addToggle("Aimbot", true)
addToggle("TeamCheck", false)
addToggle("WallCheck", true)
addToggle("AimAssist", true)
addToggle("FOVVisible", true)

-- FOV circle
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = settings.FOVVisible
fovCircle.Radius = settings.FOVSize
fovCircle.Thickness = 2
fovCircle.Filled = false
fovCircle.Position = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)

-- RGB cycle
local hue = 0

-- Aimbot core (FIXED AIM HERE)
runService.RenderStepped:Connect(function()
    fovCircle.Visible = settings.FOVVisible
    fovCircle.Position = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
    fovCircle.Color = Color3.fromHSV(hue, 1, 1)
    hue = (hue + 0.005) % 1

    if settings.Aimbot then
        local closest = nil
        local shortest = math.huge
        for _, player in pairs(players:GetPlayers()) do
            if player ~= lp and player.Character and player.Character:FindFirstChild(settings.AimPart) then
                if settings.TeamCheck and player.Team == lp.Team then continue end
                if settings.WallCheck then
                    local ray = Ray.new(cam.CFrame.Position, (player.Character[settings.AimPart].Position - cam.CFrame.Position).Unit * 999)
                    local part = workspace:FindPartOnRay(ray, lp.Character, false, true)
                    if part and not player.Character:IsAncestorOf(part) then continue end
                end
                local pos, visible = cam:WorldToViewportPoint(player.Character[settings.AimPart].Position)
                if visible then
                    local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)).Magnitude
                    if distance < settings.FOVSize and distance < shortest then
                        shortest = distance
                        closest = player
                    end
                end
            end
        end
        if closest and closest.Character and closest.Character:FindFirstChild(settings.AimPart) then
            local targetPosition = closest.Character[settings.AimPart].Position
            local direction = (targetPosition - cam.CFrame.Position).Unit
            local newCFrame = CFrame.new(cam.CFrame.Position, cam.CFrame.Position + direction)
            cam.CFrame = cam.CFrame:Lerp(newCFrame, 0.2)
        end
    end
end)

-- OPEN MENU Button
local openBtn = Instance.new("TextButton", screenGui)
openBtn.Size = UDim2.new(0, 100, 0, 30)
openBtn.Position = UDim2.new(0, 10, 0, 10)
openBtn.Text = "Open Menu"
openBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
openBtn.TextColor3 = Color3.new(1, 1, 1)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 14
openBtn.Active = true
openBtn.Draggable = true

local open = true
openBtn.MouseButton1Click:Connect(function()
    open = not open
    frame.Visible = open
end)

-- Rodapé com assinatura
local footer = Instance.new("TextLabel", scroll)
footer.Text = "by VynOfficial"
footer.TextColor3 = Color3.fromRGB(100, 100, 100)
footer.Size = UDim2.new(1, 0, 0, 20)
footer.Position = UDim2.new(0, 0, 0, 370)
footer.BackgroundTransparency = 1
footer.Font = Enum.Font.Gotham
footer.TextSize = 12
footer.TextXAlignment = Enum.TextXAlignment.Center