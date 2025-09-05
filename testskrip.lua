-- Anime Fruits Speedwalk GUI v2.1
-- Bypass BodyVelocity + slider buatan sendiri
-- Delta-Executor ready

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local rs = game:GetService("RunService")

-- GUI utama
local sg = Instance.new("ScreenGui", game.CoreGui)
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 260, 0, 170)
main.Position = UDim2.new(0.5, -130, 0.5, -85)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

-- TopBar
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1, 0, 0, 25)
top.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1, -30, 1, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ Speedwalk by OASIS"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16

local minBtn = Instance.new("TextButton", top)
minBtn.Size = UDim2.new(0, 25, 1, 0)
minBtn.Position = UDim2.new(1, -25, 0, 0)
minBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
minBtn.Text = "-"
minBtn.Font = Enum.Font.SourceSansBold
minBtn.TextSize = 18

-- Label kecepatan
local speedLbl = Instance.new("TextLabel", main)
speedLbl.Size = UDim2.new(0, 200, 0, 20)
speedLbl.Position = UDim2.new(0.5, -100, 0.25, 0)
speedLbl.BackgroundTransparency = 1
speedLbl.Text = "Speed: 50"
speedLbl.TextColor3 = Color3.new(1, 1, 1)
speedLbl.Font = Enum.Font.SourceSans
speedLbl.TextSize = 14

-- Area slider (track)
local track = Instance.new("Frame", main)
track.Size = UDim2.new(0, 200, 0, 10)
track.Position = UDim2.new(0.5, -100, 0.4, 0)
track.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
track.BorderSizePixel = 0

-- Thumb (dragable)
local thumb = Instance.new("Frame", track)
thumb.Size = UDim2.new(0, 12, 0, 18)
thumb.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
thumb.BorderSizePixel = 0

-- Toggle ON/OFF
local tgl = Instance.new("TextButton", main)
tgl.Size = UDim2.new(0, 80, 0, 30)
tgl.Position = UDim2.new(0.5, -40, 0.6, 0)
tgl.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
tgl.Text = "ON"
tgl.Font = Enum.Font.SourceSansBold
tgl.TextSize = 16

------------------------------------------------
-- logika slider
local minVal, maxVal = 16, 100
local currentVal = 50
local dragging = false

local function updateThumb()
    local ratio = (currentVal - minVal) / (maxVal - minVal)
    thumb.Position = UDim2.new(ratio, -6, 0, -4)
    speedLbl.Text = "Speed: " .. math.floor(currentVal)
end
updateThumb()

track.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
    end
end)
rs.Heartbeat:Connect(function()
    if dragging then
        local rel = mouse.X - track.AbsolutePosition.X
        local ratio = math.clamp(rel / track.AbsoluteSize.X, 0, 1)
        currentVal = minVal + ratio * (maxVal - minVal)
        updateThumb()
    end
end)
mouse.Button1Up:Connect(function() dragging = false end)

------------------------------------------------
-- BodyVelocity speedwalk
local bv
local active = false
local function setSpeed(spd)
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    if active then
        if not bv or not bv.Parent then
            bv = Instance.new("BodyVelocity", root)
            bv.MaxForce = Vector3.new(100000, 0, 100000)
        end
        bv.Velocity = root.CFrame.LookVector * spd
    elseif bv then bv:Destroy(); bv = nil end
end
tgl.MouseButton1Click:Connect(function()
    active = not active
    tgl.Text = active and "OFF" or "ON"
    tgl.BackgroundColor3 = active and Color3.fromRGB(170, 0, 0) or Color3.fromRGB(0, 170, 0)
    setSpeed(currentVal)
end)

------------------------------------------------
-- minimize
local min = false
minBtn.MouseButton1Click:Connect(function()
    min = not min
    track.Visible = not min
    speedLbl.Visible = not min
    tgl.Visible = not min
    main.Size = min and UDim2.new(0, 260, 0, 25) or UDim2.new(0, 260, 0, 170)
    minBtn.Text = min and "+" or "-"
end)

------------------------------------------------
-- handler respawn
player.CharacterAdded:Connect(function(ch)
    wait(0.4)
    if active then setSpeed(currentVal) end
end)

print("✅ Speedwalk GUI v2.1 siap! Drag thumb untuk atur kecepatan.")
