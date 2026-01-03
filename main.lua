local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Variables de Control
local MasterSwitch = false 
local CamlockKey = Enum.KeyCode.Q -- Cambiado a Q por tu preferencia
local MenuKey = Enum.KeyCode.Insert
local TargetPart = "Head"
local Visible = true

-- VARIABLE CRUCIAL: El objetivo actual
local LockedTarget = nil 

-- Interfaz Principal (Diseño Koda.cc)
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local MainFrame = Instance.new("Frame", ScreenGui)
local TopBar = Instance.new("Frame", MainFrame)
local LineaAzul = Instance.new("Frame", MainFrame)
local ContentFrame = Instance.new("Frame", MainFrame)

-- Estética idéntica a la imagen
MainFrame.Size = UDim2.new(0, 450, 0, 300)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(11, 14, 17)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true

TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TopBar.BorderSizePixel = 0

LineaAzul.Size = UDim2.new(1, 0, 0, 2)
LineaAzul.Position = UDim2.new(0, 0, 0, 30)
LineaAzul.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
LineaAzul.BorderSizePixel = 0

local Title = Instance.new("TextLabel", TopBar)
Title.Text = "  ▼  Koda.cc"
Title.Font = Enum.Font.Code
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 1, 0)
Title.TextXAlignment = Enum.TextXAlignment.Left

ContentFrame.Size = UDim2.new(1, -20, 1, -50)
ContentFrame.Position = UDim2.new(0, 10, 0, 45)
ContentFrame.BackgroundTransparency = 1
local layout = Instance.new("UIListLayout", ContentFrame)
layout.Padding = UDim.new(0, 5)

-- Lógica de Arrastre
local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

-- Funciones del Menú
local function CreateToggle(text, callback)
    local btn = Instance.new("TextButton", ContentFrame)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(20, 25, 30)
    btn.Text = "  [ OFF ] " .. text
    btn.TextColor3 = Color3.new(0.6, 0.6, 0.6)
    btn.Font = Enum.Font.Code
    btn.TextXAlignment = Enum.TextXAlignment.Left
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = enabled and "  [ ON ]  " .. text or "  [ OFF ] " .. text
        btn.TextColor3 = enabled and Color3.fromRGB(0, 170, 255) or Color3.new(0.6, 0.6, 0.6)
        callback(enabled)
    end)
end

local function CreateKeybind(text, defaultKey, callback)
    local btn = Instance.new("TextButton", ContentFrame)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(20, 25, 30)
    btn.Text = "  " .. text .. ": " .. defaultKey.Name
    btn.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    btn.Font = Enum.Font.Code
    btn.TextXAlignment = Enum.TextXAlignment.Left
    local listening = false
    btn.MouseButton1Click:Connect(function() listening = true; btn.Text = "  " .. text .. ": [...]" end)
    UserInputService.InputBegan:Connect(function(input)
        if listening and input.UserInputType == Enum.UserInputType.Keyboard then
            listening = false; btn.Text = "  " .. text .. ": " .. input.KeyCode.Name
            callback(input.KeyCode)
        end
    end)
end

-- Función para buscar al enemigo más cercano AL MOUSE una sola vez
local function GetClosestTarget()
    local target = nil
    local shortestDist = math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(TargetPart) then
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(v.Character[TargetPart].Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if dist < shortestDist then
                    target = v.Character[TargetPart]
                    shortestDist = dist
                end
            end
        end
    end
    return target
end

-- Lógica de Teclas
local IsKeyDown = false
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == CamlockKey and MasterSwitch then
        IsKeyDown = true
        LockedTarget = GetClosestTarget() -- BUSCA UN SOLO OBJETIVO AL PRESIONAR
    end
    if input.KeyCode == MenuKey then
        Visible = not Visible
        MainFrame.Visible = Visible
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == CamlockKey then
        IsKeyDown = false
        LockedTarget = nil -- LIBERA EL OBJETIVO AL SOLTAR
    end
end)

-- Motor del Camlock (Fijado en LockedTarget)
RunService.RenderStepped:Connect(function()
    if MasterSwitch and IsKeyDown and LockedTarget then
        -- Verificar que el objetivo siga vivo y exista
        if LockedTarget.Parent and LockedTarget.Parent:FindFirstChild("Humanoid") and LockedTarget.Parent.Humanoid.Health > 0 then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, LockedTarget.Position)
        else
            LockedTarget = nil -- Si muere, dejamos de apuntar
        end
    end
end)

-- Crear Opciones
CreateToggle("Enable Camlock System", function(s) MasterSwitch = s end)
CreateKeybind("Lock Key", CamlockKey, function(k) CamlockKey = k end)
