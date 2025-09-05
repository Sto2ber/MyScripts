-- Anime Fruits Speedwalk + Auto-Attack + Auto-Skill GUI v3.0
-- Delta-Executor | BodyVelocity bypass
local player   = game.Players.LocalPlayer
local mouse    = player:GetMouse()
local uis      = game:GetService("UserInputService")
local rs       = game:GetService("RunService")

-- //// GUI ////////////////////////////////////
local sg  = Instance.new("ScreenGui", game.CoreGui)
local main= Instance.new("Frame", sg)
main.Size     = UDim2.new(0, 280, 0, 260)
main.Position = UDim2.new(0.5, -140, 0.5, -130)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.BorderSizePixel  = 0
main.Active = true; main.Draggable = true

-- top bar
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,25)
top.BackgroundColor3 = Color3.fromRGB(50,50,50)
local ttl = Instance.new("TextLabel", top)
ttl.Size = UDim2.new(1,-30,1,0); ttl.BackgroundTransparency=1
ttl.Text = "⚡ Anime Fruits Helper v3.0"; ttl.Font=Enum.Font.SourceSansBold
ttl.TextColor3 = Color3.new(1,1,1); ttl.TextSize=16
local minBtn = Instance.new("TextButton", top)
minBtn.Size=UDim2.new(0,25,1,0); minBtn.Position=UDim2.new(1,-25,0,0)
minBtn.Text="-"; minBtn.Font=Enum.Font.SourceSansBold; minBtn.TextSize=18
minBtn.BackgroundColor3 = Color3.fromRGB(255,100,100)

-- speed label
local spdLbl = Instance.new("TextLabel", main)
spdLbl.Position = UDim2.new(0.5,-100,0.15,0)
spdLbl.Size     = UDim2.new(0,200,0,20)
spdLbl.BackgroundTransparency=1
spdLbl.Text="Speed: 50"; spdLbl.TextColor3=Color3.new(1,1,1); spdLbl.Font=Enum.Font.SourceSans

-- track slider
local track = Instance.new("Frame", main)
track.Position = UDim2.new(0.5,-100,0.25,0)
track.Size     = UDim2.new(0,200,0,10)
track.BackgroundColor3 = Color3.fromRGB(70,70,70)
local thumb = Instance.new("Frame", track)
thumb.Size = UDim2.new(0,12,0,18); thumb.Position=UDim2.new(0,-6,0,-4)
thumb.BackgroundColor3 = Color3.fromRGB(0,170,255); thumb.BorderSizePixel=0
-- overlay button (drag area)
local dragBtn = Instance.new("TextButton", track)
dragBtn.BackgroundTransparency=1
dragBtn.Size = UDim2.new(1,0,1,0); dragBtn.Text=""

-- toggle speed
local speedTgl = Instance.new("TextButton", main)
speedTgl.Position = UDim2.new(0.5,-40,0.35,0)
speedTgl.Size     = UDim2.new(0,80,0,30)
speedTgl.BackgroundColor3=Color3.fromRGB(0,170,0); speedTgl.Text="ON"
speedTgl.Font=Enum.Font.SourceSansBold

-- auto-attack toggle
local atkLbl = Instance.new("TextLabel", main)
atkLbl.Position = UDim2.new(0.05,0,0.50,0); atkLbl.Size=UDim2.new(0,100,0,20)
atkLbl.BackgroundTransparency=1; atkLbl.Text="Auto Attack"; atkLbl.TextColor3=Color3.new(1,1,1)
local atkTgl = Instance.new("TextButton", main)
atkTgl.Position = UDim2.new(0.05,0,0.55,0); atkTgl.Size=UDim2.new(0,80,0,25)
atkTgl.BackgroundColor3=Color3.fromRGB(170,0,0); atkTgl.Text="OFF"

-- auto-skill toggle
local skLbl = Instance.new("TextLabel", main)
skLbl.Position = UDim2.new(0.55,0,0.50,0); skLbl.Size=UDim2.new(0,100,0,20)
skLbl.BackgroundTransparency=1; skLbl.Text="Auto Skill"; skLbl.TextColor3=Color3.new(1,1,1)
local skTgl = Instance.new("TextButton", main)
skTgl.Position = UDim2.new(0.55,0,0.55,0); skTgl.Size=UDim2.new(0,80,0,25)
skTgl.BackgroundColor3=Color3.fromRGB(170,0,0); skTgl.Text="OFF"

------------------------------------------------
-- logic variabel
local minVal, maxVal = 16, 100
local speedVal = 50
local speedOn  = false
local atkOn    = false
local skOn     = false
local bv; local atkConn; local skConn

------------------------------------------------
-- slider drag
dragBtn.MouseButton1Down:Connect(function() dragSlider = true end)
uis.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragSlider = false end
end)

rs.Heartbeat:Connect(function()
    if dragSlider then
        local rel = mouse.X - track.AbsolutePosition.X
        local ratio = math.clamp(rel / track.AbsoluteSize.X, 0, 1)
        speedVal = minVal + ratio*(maxVal-minVal)
        thumb.Position = UDim2.new(ratio,-6,0,-4)
        spdLbl.Text = "Speed: "..math.floor(speedVal)
        if speedOn then setSpeed(speedVal) end
    end
end)

------------------------------------------------
-- fungsi BodyVelocity
function setSpeed(val)
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    if speedOn then
        if not bv or not bv.Parent then
            bv = Instance.new("BodyVelocity", root)
            bv.MaxForce = Vector3.new(100000,0,100000)
        end
        bv.Velocity = root.CFrame.LookVector*val
    else
        if bv then bv:Destroy(); bv=nil end
    end
end

------------------------------------------------
-- toggle speed
speedTgl.MouseButton1Click:Connect(function()
    speedOn = not speedOn
    speedTgl.Text = speedOn and "OFF" or "ON"
    speedTgl.BackgroundColor3 = speedOn and Color3.fromRGB(170,0,0) or Color3.fromRGB(0,170,0)
    setSpeed(speedVal)
end)

------------------------------------------------
-- auto-attack (klik kiri berulang)
function toggleAtk()
    if atkOn then
        atkConn = rs.Heartbeat:Connect(function()
            if not atkOn then return end
            -- simulasikan mouse1 pada HumanoidRootPart (bisa disesuaikan)
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                -- ini contoh pakai virtual input; kalau game pakai RemoteEvent ganti ke remote
                mouse1press(); mouse1release()
            end
        end)
    else
        if atkConn then atkConn:Disconnect(); atkConn=nil end
    end
end
atkTgl.MouseButton1Click:Connect(function()
    atkOn = not atkOn
    atkTgl.Text = atkOn and "ON" or "OFF"
    atkTgl.BackgroundColor3 = atkOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
    toggleAtk()
end)

------------------------------------------------
-- auto-skill (tekan 1-2-3-4 berurutan)
function toggleSkill()
    if skOn then
        local idx = 0
        skConn = rs.Heartbeat:Connect(function()
            if not skOn then return end
            idx = idx % 4 + 1
            -- contoh: tekan 1,2,3,4
            -- kalau game pakai RemoteEvent, ganti ke fireserver(remote)
            local key = tostring(idx)
            -- virtual press
            keypress(0x30 + idx); keyrelease(0x30 + idx)
            wait(0.4) -- interval antar skill
        end)
    else
        if skConn then skConn:Disconnect(); skConn=nil end
    end
end
skTgl.MouseButton1Click:Connect(function()
    skOn = not skOn
    skTgl.Text = skOn and "ON" or "OFF"
    skTgl.BackgroundColor3 = skOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
    toggleSkill()
end)

------------------------------------------------
-- minimize
local isMin = false
minBtn.MouseButton1Click:Connect(function()
    isMin = not isMin
    track.Visible = not isMin; spdLbl.Visible = not isMin
    speedTgl.Visible = not isMin; atkLbl.Visible = not isMin
    atkTgl.Visible = not isMin; skLbl.Visible = not isMin
    skTgl.Visible = not isMin
    main.Size = isMin and UDim2.new(0,280,0,25) or UDim2.new(0,280,0,260)
    minBtn.Text = isMin and "+" or "-"
end)

------------------------------------------------
-- respawn handler
player.CharacterAdded:Connect(function()
    wait(0.4)
    if speedOn then setSpeed(speedVal) end
end)

------------------------------------------------
print("✅ Helper v3.0 aktif – drag thumb untuk speed, toggle attack/skill sesuka kamu!")
