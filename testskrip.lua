-- Anime Fruits Helper v4.3  (force client-side)
-- Tambah Coins & Gems langsung di leaderstats + GUI game
local player = game:GetService("Players").LocalPlayer

------------------------------------------------
-- GUI
local sg  = Instance.new("ScreenGui", game.CoreGui)
local main= Instance.new("Frame", sg)
main.Size     = UDim2.new(0, 300, 0, 200)
main.Position = UDim2.new(0.5, -150, 0.5, -100)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.BorderSizePixel  = 0; main.Active = true; main.Draggable = true

local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,25); top.BackgroundColor3 = Color3.fromRGB(50,50,50)
local ttl = Instance.new("TextLabel", top)
ttl.Size = UDim2.new(1,-30,1,0); ttl.BackgroundTransparency=1
ttl.Text = "💰 Force Add Coins & Gems v4.3"; ttl.Font=Enum.Font.SourceSansBold
ttl.TextColor3 = Color3.new(1,1,1); ttl.TextSize=16
local minBtn = Instance.new("TextButton", top)
minBtn.Size=UDim2.new(0,25,1,0); minBtn.Position=UDim2.new(1,-25,0,0)
minBtn.Text="-"; minBtn.Font=Enum.Font.SourceSansBold; minBtn.TextSize=18
minBtn.BackgroundColor3 = Color3.fromRGB(255,100,100)

-- Input Coins
local coinLbl = Instance.new("TextLabel", main)
coinLbl.Position = UDim2.new(0.05,0,0.20,0); coinLbl.Size=UDim2.new(0,80,0,20)
coinLbl.BackgroundTransparency=1; coinLbl.Text="Coins"; coinLbl.TextColor3=Color3.new(1,1,1)
local coinBox = Instance.new("TextBox", main)
coinBox.Position = UDim2.new(0.05,0,0.25,0); coinBox.Size=UDim2.new(0,80,0,25)
coinBox.ClearTextOnFocus=false; coinBox.Text="0"; coinBox.Font=Enum.Font.SourceSans
coinBox.BackgroundColor3 = Color3.fromRGB(70,70,70); coinBox.TextColor3=Color3.new(1,1,1)
local coinBtn = Instance.new("TextButton", main)
coinBtn.Position = UDim2.new(0.05,0,0.31,0); coinBtn.Size=UDim2.new(0,80,0,25)
coinBtn.BackgroundColor3=Color3.fromRGB(0,170,0); coinBtn.Text="Add"; coinBtn.Font=Enum.Font.SourceSansBold

-- Input Gems
local gemsLbl = Instance.new("TextLabel", main)
gemsLbl.Position = UDim2.new(0.55,0,0.20,0); gemsLbl.Size=UDim2.new(0,80,0,20)
gemsLbl.BackgroundTransparency=1; gemsLbl.Text="Gems"; gemsLbl.TextColor3=Color3.new(1,1,1)
local gemsBox = Instance.new("TextBox", main)
gemsBox.Position = UDim2.new(0.55,0,0.25,0); gemsBox.Size=UDim2.new(0,80,0,25)
gemsBox.ClearTextOnFocus=false; gemsBox.Text="0"; gemsBox.Font=Enum.Font.SourceSans
gemsBox.BackgroundColor3 = Color3.fromRGB(70,70,70); gemsBox.TextColor3=Color3.new(1,1,1)
local gemsBtn = Instance.new("TextButton", main)
gemsBtn.Position = UDim2.new(0.55,0,0.31,0); gemsBtn.Size=UDim2.new(0,80,0,25)
gemsBtn.BackgroundColor3=Color3.fromRGB(0,170,255); gemsBtn.Text="Add"; gemsBtn.Font=Enum.Font.SourceSansBold

-- minimize
local isMin = false
minBtn.MouseButton1Click:Connect(function()
    isMin = not isMin
    coinLbl.Visible = not isMin; coinBox.Visible = not isMin; coinBtn.Visible = not isMin
    gemsLbl.Visible = not isMin; gemsBox.Visible = not isMin; gemsBtn.Visible = not isMin
    main.Size = isMin and UDim2.new(0,300,0,25) or UDim2.new(0,300,0,200)
    minBtn.Text = isMin and "+" or "-"
end)

------------------------------------------------
-- fungsi UBAH LANGSUNG (client-side)
local function forceAdd(box, jenis)
    local jml = tonumber(box.Text) or 0
    if jml <= 0 then return end

    -- 1. Ubah leaderstats
    local leader = player:FindFirstChild("leaderstats")
    if not leader then
        -- buat leaderstats kalau belum ada
        leader = Instance.new("Folder", player); leader.Name = "leaderstats"
    end

    local target = leader:FindFirstChild(jenis)
    if not target then
        -- buat IntValue kalau belum ada
        target = Instance.new("IntValue", leader); target.Name = jenis
    end
    target.Value = target.Value + jml

    -- 2. Cari GUI utama game (contoh: TextLabel di Coin/Gems)
    --    Biasanya ada di PlayerGui atau CoreGui game
    for _,desc in pairs(player.PlayerGui:GetDescendants()) do
        if desc:IsA("TextLabel") and desc.Text:match(tostring(target.Value - jml)) then
            -- update teks agar sesuai
            desc.Text = tostring(target.Value)
        end
    end

    print("✅ " .. jenis .. " +" .. jml .. " (client-side forced)")
    box.Text = "0"
end

coinBtn.MouseButton1Click:Connect(function() forceAdd(coinBox, "Coins") end)
gemsBtn.MouseButton1Click:Connect(function() forceAdd(gemsBox, "Gems") end)

------------------------------------------------
print("✅ v4.3 ready – force tambah Coins & Gems (client-only).")
