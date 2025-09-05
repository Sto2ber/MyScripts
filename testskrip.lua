-- Anime Fruits Helper v4.0
-- Speedwalk + Add Coin/Diamond (Android, Delta Executor)
local player = game:GetService("Players").LocalPlayer
local mouse  = player:GetMouse()
local uis    = game:GetService("UserInputService")
local rs     = game:GetService("RunService")
local rep    = game:GetService("ReplicatedStorage")

------------------------------------------------
-- GUI utama
local sg  = Instance.new("ScreenGui", game.CoreGui)
local main= Instance.new("Frame", sg)
main.Size     = UDim2.new(0, 300, 0, 320)
main.Position = UDim2.new(0.5, -150, 0.5, -160)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.BorderSizePixel  = 0
main.Active = true; main.Draggable = true

-- top bar
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,25); top.BackgroundColor3 = Color3.fromRGB(50,50,50)
local ttl = Instance.new("TextLabel", top)
ttl.Size = UDim2.new(1,-30,1,0); ttl.BackgroundTransparency=1
ttl.Text = "⚡ Anime Fruits by.Oasis"; ttl.Font=Enum.Font.SourceSansBold
ttl.TextColor3 = Color3.new(1,1,1); ttl.TextSize=16
local minBtn = Instance.new("TextButton", top)
minBtn.Size=UDim2.new(0,25,1,0); minBtn.Position=UDim2.new(1,-25,0,0)
minBtn.Text="-"; minBtn.Font=Enum.Font.SourceSansBold; minBtn.TextSize=18
minBtn.BackgroundColor3 = Color3.fromRGB(255,100,100)

-- speed label
local spdLbl = Instance.new("TextLabel", main)
spdLbl.Position = UDim2.new(0.5,-100,0.10,0)
spdLbl.Size     = UDim2.new(0,200,0,20); spdLbl.BackgroundTransparency=1
spdLbl.Text="Speed: 50"; spdLbl.TextColor3=Color3.new(1,1,1); spdLbl.Font=Enum.Font.SourceSans

-- track slider
local track = Instance.new("Frame", main)
track.Position = UDim2.new(0.5,-100,0.18,0); track.Size = UDim2.new(0,200,0,10)
track.BackgroundColor3 = Color3.fromRGB(70,70,70)
local thumb = Instance.new("Frame", track)
thumb.Size = UDim2.new(0,12,0,18); thumb.Position=UDim2.new(0,-6,0,-4)
thumb.BackgroundColor3 = Color3.fromRGB(0,170,255); thumb.BorderSizePixel=0
-- overlay button (drag area)
local dragBtn = Instance.new("TextButton", track)
dragBtn.BackgroundTransparency=1; dragBtn.Size = UDim2.new(1,0,1,0); dragBtn.Text=""

-- toggle speed
local speedTgl = Instance.new("TextButton", main)
speedTgl.Position = UDim2.new(0.5,-40,0.26,0); speedTgl.Size=UDim2.new(0,80,0,30)
speedTgl.BackgroundColor3=Color3.fromRGB(0,170,0); speedTgl.Text="ON"
speedTgl.Font=Enum.Font.SourceSansBold

-- Input Coin
local coinLbl = Instance.new("TextLabel", main)
coinLbl.Position = UDim2.new(0.05,0,0.38,0); coinLbl.Size=UDim2.new(0,80,0,20)
coinLbl.BackgroundTransparency=1; coinLbl.Text="Add Coin"; coinLbl.TextColor3=Color3.new(1,1,1)
local coinBox = Instance.new("TextBox", main)
coinBox.Position = UDim2.new(0.05,0,0.43,0); coinBox.Size=UDim2.new(0,80,0,25)
coinBox.ClearTextOnFocus=false; coinBox.Text="0"; coinBox.Font=Enum.Font.SourceSans
coinBox.BackgroundColor3 = Color3.fromRGB(70,70,70); coinBox.TextColor3=Color3.new(1,1,1)
local coinBtn = Instance.new("TextButton", main)
coinBtn.Position = UDim2.new(0.05,0,0.49,0); coinBtn.Size=UDim2.new(0,80,0,25)
coinBtn.BackgroundColor3=Color3.fromRGB(0,170,0); coinBtn.Text="Add"; coinBtn.Font=Enum.Font.SourceSansBold

-- Input Diamond
local dmdLbl = Instance.new("TextLabel", main)
dmdLbl.Position = UDim2.new(0.55,0,0.38,0); dmdLbl.Size=UDim2.new(0,80,0,20)
dmdLbl.BackgroundTransparency=1; dmdLbl.Text="Add Diamond"; dmdLbl.TextColor3=Color3.new(1,1,1)
local dmdBox = Instance.new("TextBox", main)
dmdBox.Position = UDim2.new(0.55,0,0.43,0); dmdBox.Size=UDim2.new(0,80,0,25)
dmdBox.ClearTextOnFocus=false; dmdBox.Text="0"; dmdBox.Font=Enum.Font.SourceSans
dmdBox.BackgroundColor3 = Color3.fromRGB(70,70,70); dmdBox.TextColor3=Color3.new(1,1,1)
local dmdBtn = Instance.new("TextButton", main)
dmdBtn.Position = UDim2.new(0.55,0,0.49,0); dmdBtn.Size=UDim2.new(0,80,0,25)
dmdBtn.BackgroundColor3=Color3.fromRGB(0,170,255); dmdBtn.Text="Add"; dmdBtn.Font=Enum.Font.SourceSansBold

------------------------------------------------
-- variabel
local minVal, maxVal = 16, 100
local speedVal = 50
local speedOn  = false
local bv; local dragSlider = false

------------------------------------------------
-- slider drag (Android-friendly)
dragBtn.MouseButton1Down:Connect(function() dragSlider = true end)
dragBtn.TouchPan:Connect(function() dragSlider = true end)
uis.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
        dragSlider = false
    end
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
-- BodyVelocity speedwalk
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
speedTgl.MouseButton1Click:Connect(function()
    speedOn = not speedOn
    speedTgl.Text = speedOn and "OFF" or "ON"
    speedTgl.BackgroundColor3 = speedOn and Color3.fromRGB(170,0,0) or Color3.fromRGB(0,170,0)
    setSpeed(speedVal)
end)

------------------------------------------------
-- TAMBAH COIN
coinBtn.MouseButton1Click:Connect(function()
    local jml = tonumber(coinBox.Text) or 0
    -- coba lewat remote
    local coinRemote = rep:FindFirstChild("AddCoin") or rep:FindFirstChild("CoinEvent") or nil
    if coinRemote then
        coinRemote:FireServer(jml)          -- server-side
    else
        -- fallback: client-only (visual saja)
        local leader = player:FindFirstChild("leaderstats")
        if leader then
            local coin = leader:FindFirstChild("Coin") or leader:FindFirstChild("Coins") or leader:FindFirstChild("Gold")
            if coin then coin.Value = coin.Value + jml end
        end
    end
    coinBox.Text = "0"
    print("✅ Coin +" .. jml)
end)

------------------------------------------------
-- TAMBAH DIAMOND
dmdBtn.MouseButton1Click:Connect(function()
    local jml = tonumber(dmdBox.Text) or 0
    local dmdRemote = rep:FindFirstChild("AddDiamond") or rep:FindFirstChild("DiamondEvent") or nil
    if dmdRemote then
        dmdRemote:FireServer(jml)
    else
        local leader = player:FindFirstChild("leaderstats")
        if leader then
            local dmd = leader:FindFirstChild("Diamond") or leader:FindFirstChild("Diamonds") or leader:FindFirstChild("Gem")
            if dmd then dmd.Value = dmd.Value + jml end
        end
    end
    dmdBox.Text = "0"
    print("✅ Diamond +" .. jml)
end)

------------------------------------------------
-- minimize
local isMin = false
minBtn.MouseButton1Click:Connect(function()
    isMin = not isMin
    track.Visible = not isMin; spdLbl.Visible = not isMin; speedTgl.Visible = not isMin
    coinLbl.Visible = not isMin; coinBox.Visible = not isMin; coinBtn.Visible = not isMin
    dmdLbl.Visible = not isMin; dmdBox.Visible = not isMin; dmdBtn.Visible = not isMin
    main.Size = isMin and UDim2.new(0,300,0,25) or UDim2.new(0,300,0,320)
    minBtn.Text = isMin and "+" or "-"
end)

------------------------------------------------
-- respawn handler
player.CharacterAdded:Connect(function()
    wait(0.4)
    if speedOn then setSpeed(speedVal) end
end)

------------------------------------------------
print("✅ Helper v4.0 Android ready – Speedwalk + Add Coin/Diamond")
