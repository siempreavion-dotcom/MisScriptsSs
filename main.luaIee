--[[
    EJECUTOR: XENO
    PROPIETARIO: BLADIS
    MODO: HOOD CUSTOM PRO
]]

local Settings = {
    OwnerName = "TU_USUARIO_AQUI", -- <<< PON TU NOMBRE DE USUARIO DE ROBLOX AQUÍ
    Prediction = 0.135,
    WalkSpeedValue = 16,
    CamlockKey = Enum.KeyCode.Q,
    SpeedKey = Enum.KeyCode.X,
    TargetPart = "UpperTorso",
    Smoothness = 0.15
}

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local IsLocked = false
local SpeedEnabled = false
local LockedTarget = nil
local Visible = true
local ListeningKey = false

-- [ GUI PRINCIPAL ]
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Size = UDim2.new(0, 380, 0, 260)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -130)
MainFrame.BorderSizePixel = 0

-- Barra Superior
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -10, 1, 0); Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "BLADIS - PRIVATE"; Title.TextColor3 = Color3.new(1,1,1); Title.Font = Enum.Font.GothamBold; Title.TextXAlignment = "Left"; Title.BackgroundTransparency = 1

-- Tabs System
local TabContainer = Instance.new("Frame", MainFrame)
TabContainer.Size = UDim2.new(0, 80, 1, -30); TabContainer.Position = UDim2.new(0,0,0,30); TabContainer.BackgroundColor3 = Color3.fromRGB(20,20,20); TabContainer.BorderSizePixel = 0

local Content = Instance.new("Frame", MainFrame)
Content.Size = UDim2.new(1, -90, 1, -40); Content.Position = UDim2.new(0, 85, 0, 35); Content.BackgroundTransparency = 1

local Tabs = {Camlock = Instance.new("Frame", Content), Misc = Instance.new("Frame", Content), Info = Instance.new("Frame", Content)}
for _, v in pairs(Tabs) do v.Size = UDim2.new(1,0,1,0); v.Visible = false; v.BackgroundTransparency = 1 end
Tabs.Camlock.Visible = true

local function CreateTabBtn(name, pos, target)
    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(1, 0, 0, 35); btn.Position = UDim2.new(0, 0, 0, pos)
    btn.Text = name; btn.BackgroundColor3 = Color3.fromRGB(25,25,25); btn.TextColor3 = Color3.new(1,1,1); btn.Font = "Code"
    btn.MouseButton1Click:Connect(function()
        for _, v in pairs(Tabs) do v.Visible = false end
        target.Visible = true
    end)
end
CreateTabBtn("Aim", 0, Tabs.Camlock); CreateTabBtn("Misc", 35, Tabs.Misc); CreateTabBtn("Info", 70, Tabs.Info)

-- [ SECCIÓN CAMLOCK ]
local BindBtn = Instance.new("TextButton", Tabs.Camlock)
BindBtn.Size = UDim2.new(1, 0, 0, 35); BindBtn.Text = "Keybind: " .. Settings.CamlockKey.Name; BindBtn.BackgroundColor3 = Color3.fromRGB(30,30,30); BindBtn.TextColor3 = Color3.new(0, 0.6, 1)
BindBtn.MouseButton1Click:Connect(function() 
    BindBtn.Text = "..."; ListeningKey = true 
end)

local PredBox = Instance.new("TextBox", Tabs.Camlock)
PredBox.Size = UDim2.new(1, 0, 0, 35); PredBox.Position = UDim2.new(0,0,0,45); PredBox.Text = "Prediction: "..Settings.Prediction; PredBox.BackgroundColor3 = Color3.fromRGB(30,30,30); PredBox.TextColor3 = Color3.new(1,1,1)
PredBox.FocusLost:Connect(function() Settings.Prediction = tonumber(PredBox.Text) or Settings.Prediction end)

-- [ SECCIÓN MISC ]
local SpeedToggle = Instance.new("TextButton", Tabs.Misc)
SpeedToggle.Size = UDim2.new(1, 0, 0, 35); SpeedToggle.Text = "Speed: OFF [X]"; SpeedToggle.BackgroundColor3 = Color3.fromRGB(30,30,30); SpeedToggle.TextColor3 = Color3.new(1,1,1)

-- [ SECCIÓN INFO (TU AVATAR) ]
local AvatarImg = Instance.new("ImageLabel", Tabs.Info)
AvatarImg.Size = UDim2.new(0, 100, 0, 100); AvatarImg.Position = UDim2.new(0.5, -50, 0, 10)
AvatarImg.BackgroundColor3 = Color3.fromRGB(30,30,30)
-- Obtiene tu foto automáticamente
local Success, UserId = pcall(function() return Players:GetUserIdFromNameAsync(Settings.OwnerName) end)
if Success then
    AvatarImg.Image = "rbxthumb://type=AvatarHeadShot&id="..UserId.."&w=150&h=150"
end

local OwnerText = Instance.new("TextLabel", Tabs.Info)
OwnerText.Position = UDim2.new(0,0,0,120); OwnerText.Size = UDim2.new(1,0,0,30); OwnerText.BackgroundTransparency = 1
OwnerText.Text = "OWNER: " .. Settings.OwnerName:upper(); OwnerText.TextColor3 = Color3.new(0, 0.7, 1); OwnerText.Font = "GothamBold"

-- [ LÓGICA DE FUNCIONAMIENTO ]
local function GetClosest()
    local t = nil; local d = math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(Settings.TargetPart) then
            local p, vis = Camera:WorldToViewportPoint(v.Character[Settings.TargetPart].Position)
            if vis then
                local m = (Vector2.new(p.X, p.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if m < d then t = v.Character[Settings.TargetPart]; d = m end
            end
        end
    end
    return t
end

UserInputService.InputBegan:Connect(function(input, proc)
    if proc then return end
    if ListeningKey then
        Settings.CamlockKey = input.KeyCode
        BindBtn.Text = "Keybind: " .. input.KeyCode.Name
        ListeningKey = false
    elseif input.KeyCode == Settings.CamlockKey then
        IsLocked = not IsLocked
        LockedTarget = IsLocked and GetClosest() or nil
    elseif input.KeyCode == Settings.SpeedKey then
        SpeedEnabled = not SpeedEnabled
        SpeedToggle.Text = SpeedEnabled and "Speed: ON [X]" or "Speed: OFF [X]"
    elseif input.KeyCode == Enum.KeyCode.Insert then
        Visible = not Visible; MainFrame.Visible = Visible
    end
end)

RunService.RenderStepped:Connect(function()
    if IsLocked and LockedTarget then
        local tPos = LockedTarget.Position + (LockedTarget.Velocity * Settings.Prediction)
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, tPos), Settings.Smoothness)
    end
    if SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if LocalPlayer.Character.Humanoid.MoveDirection.Magnitude > 0 then
            LocalPlayer.Character:TranslateBy(LocalPlayer.Character.Humanoid.MoveDirection * (Settings.WalkSpeedValue/100))
        end
    end
end)

-- Draggable
local d, s, p; TopBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true; s = i.Position; p = MainFrame.Position end end)
UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - s; MainFrame.Position = UDim2.new(p.X.Scale, p.X.Offset + delta.X, p.Y.Scale, p.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(i) d = false end)
