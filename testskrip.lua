-- Anime Fruits Helper v4.2  (Coins & Gems)
local player = game:GetService("Players").LocalPlayer
local rep    = game:GetService("ReplicatedStorage")

------------------------------------------------
-- 🔍 AUTO-SCAN REMOTE BERDASARKAN NAMA
local function scanRemote(keyword)
    for _,v in pairs(rep:GetDescendants()) do
        if v:IsA("RemoteEvent") and v.Name:lower():find(keyword:lower()) then
            return v
        end
    end
    return nil
end
local coinRemote = scanRemote("coins") or scanRemote("coin") or scanRemote("gold")
local gemsRemote = scanRemote("gems") or scanRemote("gem") or scanRemote("diamond")

warn("📋 Remote ditemukan:")
warn("   Coins → " .. (coinRemote and coinRemote.Name or "Tidak ada"))
warn("   Gems  → " .. (gemsRemote and gemsRemote.Name or "Tidak ada"))

------------------------------------------------
-- GUI
local sg  = Instance.new("ScreenGui", game.CoreGui)
local main= Instance.new("Frame", sg)
main.Size     = UDim2.new(0, 300, 0, 220)
main.Position = UDim2.new(0.5, -150, 0.5, -110)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.BorderSizePixel  = 0; main.Active = true; main.Draggable = true

local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,25); top.BackgroundColor3 = Color3.fromRGB(50,50,50)
local ttl = Instance.new("TextLabel", top)
ttl.Size = UDim2.new(1,-30,1,0); ttl.BackgroundTransparency=1
ttl.Text = "💰 Add Coins & Gems v4.2"; ttl.Font=Enum.Font.SourceSansBold
ttl.TextColor3 = Color3.new(1,1,1); ttl.TextSize=16
local minBtn = Instance.new("TextButton", top)
minBtn.Size=UDim2.new(0,25,1,0); minBtn.Position=UDim2.new(1,-25,0,0)
minBtn.Text="-"; minBtn.Font=Enum.Font.SourceSansBold; minBtn.TextSize=18
minBtn.BackgroundColor3 = Color3.fromRGB(255,100,100)

-- Input Coins
local coinLbl = Instance.new("TextLabel", main)
coinLbl.Position = UDim2.new(0.05,0,0.18,0); coinLbl.Size=UDim2.new(0,80,0,20)
coinLbl.BackgroundTransparency=1; coinLbl.Text="Coins"; coinLbl.TextColor3=Color3.new(1,1,1)
local coinBox = Instance.new("TextBox", main)
coinBox.Position = UDim2.new(0.05,0,0.23,0); coinBox.Size=UDim2.new(0,80,0,25)
coinBox.ClearTextOnFocus=false; coinBox.Text="0"; coinBox.Font=Enum.Font.SourceSans
coinBox.BackgroundColor3 = Color3.fromRGB(70,70,70); coinBox.TextColor3=Color3.new(1,1,1)
local coinBtn = Instance.new("TextButton", main)
coinBtn.Position = UDim2.new(0.05,0,0.29,0); coinBtn.Size=UDim2.new(0,80,0,25)
coinBtn.BackgroundColor3=Color3.fromRGB(0,170,0); coinBtn.Text="Add"; coinBtn.Font=Enum.Font.SourceSansBold

-- Input Gems
local gemsLbl = Instance.new("TextLabel", main)
gemsLbl.Position = UDim2.new(0.55,0,0.18,0); gemsLbl.Size=UDim2.new(0,80,0,20)
gemsLbl.BackgroundTransparency=1; gemsLbl.Text="Gems"; gemsLbl.TextColor3=Color3.new(1,1,1)
local gemsBox = Instance.new("TextBox", main)
gemsBox.Position = UDim2.new(0.55,0,0.23,0); gemsBox.Size=UDim2.new(0,80,0,25)
gemsBox.ClearTextOnFocus=false; gemsBox.Text="0"; gemsBox.Font=Enum.Font.SourceSans
gemsBox.BackgroundColor3 = Color3.fromRGB(70,70,70); gemsBox.TextColor3=Color3.new(1,1,1)
local gemsBtn = Instance.new("TextButton", main)
gemsBtn.Position = UDim2.new(0.55,0,0.29,0); gemsBtn.Size=UDim2.new(0,80,0,25)
gemsBtn.BackgroundColor3=Color3.fromRGB(0,170,255); gemsBtn.Text="Add"; gemsBtn.Font=Enum.Font.SourceSansBold

-- minimize
local isMin = false
minBtn.MouseButton1Click:Connect(function()
    isMin = not isMin
    coinLbl.Visible = not isMin; coinBox.Visible = not isMin; coinBtn.Visible = not isMin
    gemsLbl.Visible = not isMin; gemsBox.Visible = not isMin; gemsBtn.Visible = not isMin
    main.Size = isMin and UDim2.new(0,300,0,25) or UDim2.new(0,300,0,220)
    minBtn.Text = isMin and "+" or "-"
end)

------------------------------------------------
-- fungsi tambah Coins / Gems
local function addCurrency(box, jenis, remote)
    local jml = tonumber(box.Text) or 0
    if jml <= 0 then return end

    if remote then
        -- pakai RemoteEvent (server-side)
        remote:FireServer(jml)
        print("✅ " .. jenis .. " +" .. jml .. " (via RemoteEvent: " .. remote.Name .. ")")
    else
        -- fallback: client-only (leaderstats)
        local leader = player:FindFirstChild("leaderstats")
        if leader then
            local target = leader:FindFirstChild(jenis)
            if target then
                target.Value = target.Value + jml
                print("✅ " .. jenis .. " +" .. jml .. " (client-only visual)")
            else
                warn("❌ " .. jenis .. " tidak ditemukan di leaderstats!")
            end
        else
            warn("❌ leaderstats tidak ada – coba pakai RemoteEvent!")
        end
    end
    box.Text = "0"
end

coinBtn.MouseButton1Click:Connect(function() addCurrency(coinBox, "Coins", coinRemote) end)
gemsBtn.MouseButton1Click:Connect(function() addCurrency(gemsBox, "Gems", gemsRemote) end)

------------------------------------------------
print("✅ v4.2 ready – Coins & Gems otomatis pakai RemoteEvent atau fallback visual.")
