-- Anime Fruits Speedwalk GUI v2.0
-- Bypass menggunakan BodyVelocity (anti-cheat safe)
-- Optimized for Delta Executor

-- [[ ANTI-CHEAT BYPASS ]]
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

-- [[ GUI CREATION ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "SpeedwalkGUI"

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 150)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 25)
TopBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ Speedwalk v2.0"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.Parent = TopBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 25, 1, 0)
MinimizeBtn.Position = UDim2.new(1, -25, 0, 0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.new(1, 1, 1)
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.TextSize = 18
MinimizeBtn.Parent = TopBar

local SpeedSlider = Instance.new("Slider")
SpeedSlider.Size = UDim2.new(0, 200, 0, 20)
SpeedSlider.Position = UDim2.new(0.5, -100, 0.4, 0)
SpeedSlider.MinValue = 16
SpeedSlider.MaxValue = 100
SpeedSlider.Value = 50
SpeedSlider.Parent = MainFrame

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0, 200, 0, 20)
SpeedLabel.Position = UDim2.new(0.5, -100, 0.25, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Speed: 50"
SpeedLabel.TextColor3 = Color3.new(1, 1, 1)
SpeedLabel.Font = Enum.Font.SourceSans
SpeedLabel.TextSize = 14
SpeedLabel.Parent = MainFrame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 80, 0, 30)
ToggleBtn.Position = UDim2.new(0.5, -40, 0.6, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
ToggleBtn.Text = "ON"
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 16
ToggleBtn.Parent = MainFrame

-- [[ SPEED CONTROL ]]
local bodyVel = nil
local isActive = false
local currentSpeed = 50

-- [[ FUNCTIONS ]]
local function updateSpeed()
    if isActive and rootPart then
        if not bodyVel or not bodyVel.Parent then
            bodyVel = Instance.new("BodyVelocity")
            bodyVel.MaxForce = Vector3.new(100000, 0, 100000)
            bodyVel.Parent = rootPart
        end
        bodyVel.Velocity = rootPart.CFrame.LookVector * currentSpeed
    elseif bodyVel then
        bodyVel:Destroy()
        bodyVel = nil
    end
end

ToggleBtn.MouseButton1Click:Connect(function()
    isActive = not isActive
    ToggleBtn.Text = isActive and "OFF" or "ON"
    ToggleBtn.BackgroundColor3 = isActive and Color3.fromRGB(170, 0, 0) or Color3.fromRGB(0, 170, 0)
    updateSpeed()
end)

SpeedSlider.Changed:Connect(function()
    currentSpeed = SpeedSlider.Value
    SpeedLabel.Text = "Speed: " .. currentSpeed
    updateSpeed()
end)

-- [[ MINIMIZE FUNCTION ]]
local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    SpeedSlider.Visible = not isMinimized
    SpeedLabel.Visible = not isMinimized
    ToggleBtn.Visible = not isMinimized
    MainFrame.Size = isMinimized and UDim2.new(0, 250, 0, 25) or UDim2.new(0, 250, 0, 150)
    MinimizeBtn.Text = isMinimized and "+" or "-"
end)

-- [[ CHARACTER RESET HANDLER ]]
player.CharacterAdded:Connect(function(char)
    character = char
    rootPart = character:WaitForChild("HumanoidRootPart")
    if isActive then
        wait(0.5)
        updateSpeed()
    end
end)

print("✅ Speedwalk GUI aktif! Gunakan slider untuk atur kecepatan.")
