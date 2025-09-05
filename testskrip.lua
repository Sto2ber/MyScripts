-- Anime Fruits Helper v4.1  (scan remote & fallback)
local player = game:GetService("Players").LocalPlayer
local rep    = game:GetService("ReplicatedStorage")

------------------------------------------------
-- 🔍 AUTO-SCAN REMOTE (tepat di bawah)
local function scanRemote()
    local list = {}
    for _,v in pairs(rep:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local name = v.Name:lower()
            if name:find("coin") or name:find("gold") or name:find("diamond") or name:find("gem") then
                table.insert(list, v.Name)
            end
        end
    end
    warn("📋 RemoteEvent ditemukan: " .. table.concat(list, ", "))
    return list
end
local REMOTE_LIST = scanRemote()

------------------------------------------------
-- GUI (ringkas, hanya input + tombol)
local sg  = Instance.new("ScreenGui", game.CoreGui)
local main= Instance.new("Frame", sg)
main.Size     = UDim2.new(0, 300, 0, 240)
main.Position = UDim2.new(0.5, -150, 0.5, -120)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.BorderSizePixel  = 0; main.Active = true; main.Draggable = true

local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,25); top.BackgroundColor3 = Color3.fromRGB(50,50,50)
local ttl = Instance.new("TextLabel", top)
ttl.Size = UDim2.new(1,-30,1,0); ttl.BackgroundTransparency=1
ttl.Text = "💰 Add Coin/Diamond v4.1"; ttl.Font=Enum.Font.SourceSansBold
ttl.TextColor3 = Color3.new(1,1,1); ttl.TextSize=16
local minBtn = Instance.new("TextButton", top)
minBtn.Size=UDim2.new(0,25,1,0); minBtn.Position=UDim2.new(1,-25,0,0)
minBtn.Text="-"; minBtn.Font=Enum.Font.SourceSansBold; minBtn.TextSize=18
minBtn.BackgroundColor3 = Color3.fromRGB(255,100,100)

-- Input nominal Coin
local coinLbl = Instance.new("TextLabel", main)
coinLbl.Position = UDim2.new(0.05,0,0.18,0); coinLbl.Size=UDim2.new(0,80,0,20)
coinLbl.BackgroundTransparency=1; coinLbl.Text="Coin"; coinLbl.TextColor3=Color3.new(1,1,1)
local coinBox = Instance.new("TextBox", main)
coinBox.Position = UDim2.new(0.05,0,0.23,0); coinBox.Size=UDim2.new(0,80,0,25)
coinBox.ClearTextOnFocus=false; coinBox.Text="0"; coinBox.Font=Enum.Font.SourceSans
coinBox.BackgroundColor3 = Color3.fromRGB(70,70,70); coinBox.TextColor3=Color3.new(1,1,1)
local coinBtn = Instance.new("TextButton", main)
coinBtn.Position = UDim2.new(0.05,0,0.29,0); coinBtn.Size=UDim2.new(0,80,0,25)
coinBtn.BackgroundColor3=Color3.fromRGB(0,170,0); coinBtn.Text="Add"; coinBtn.Font=Enum.Font.SourceSansBold

-- Input nominal Diamond
local dmdLbl = Instance.new("TextLabel", main)
dmdLbl.Position = UDim2.new(0.55,0,0.18,0); dmdLbl.Size=UDim2.new(0,80,0,20)
dmdLbl.BackgroundTransparency=1; dmdLbl.Text="Diamond"; dmdLbl.TextColor3=Color3.new(1,1,1)
local dmdBox = Instance.new("TextBox", main)
dmdBox.Position = UDim2.new(0.55,0,0.23,0); dmdBox.Size=UDim2.new(0,80,0,25)
dmdBox.ClearTextOnFocus=false; dmdBox.Text="0"; dmdBox.Font=Enum.Font.SourceSans
dmdBox.BackgroundColor3 = Color3.fromRGB(70,70,70); dmdBox.TextColor3=Color3.new(1,1,1)
local dmdBtn = Instance.new("TextButton", main)
dmdBtn.Position = UDim2.new(0.55,0,0.29,0); dmdBtn.Size=UDim2.new(0,80,0,25)
dmdBtn.BackgroundColor3=Color3.fromRGB(0,170,255); dmdBtn.Text="Add"; dmdBtn.Font=Enum.Font.SourceSansBold

-- Input nama remote (optional)
local remoteLbl = Instance.new("TextLabel", main)
remoteLbl.Position = UDim2.new(0.05,0,0.38,0); remoteLbl.Size=UDim2.new(0,200,0,20)
remoteLbl.BackgroundTransparency=1; remoteLbl.Text="Remote Name (kosongkan = client)"; remoteLbl.TextColor3=Color3.new(1,1,1); remoteLbl.TextSize=14
local remoteBox = Instance.new("TextBox", main)
remoteBox.Position = UDim2.new(0.05,0,0.43,0); remoteBox.Size=UDim2.new(0,200,0,25)
remoteBox.ClearTextOnFocus=false; remoteBox.Text=""; remoteBox.Font=Enum.Font.SourceSans
remoteBox.BackgroundColor3 = Color3.fromRGB(50,50,50); remoteBox.TextColor3=Color3.new(1,1,1)

-- minimize
local isMin = false
minBtn.MouseButton1Click:Connect(function()
    isMin = not isMin
    coinLbl.Visible = not isMin; coinBox.Visible = not isMin; coinBtn.Visible = not isMin
    dmdLbl.Visible = not isMin; dmdBox.Visible = not isMin; dmdBtn.Visible = not isMin
    remoteLbl.Visible = not isMin; remoteBox.Visible = not isMin
    main.Size = isMin and UDim2.new(0,300,0,25) or UDim2.new(0,300,0,240)
    minBtn.Text = isMin and "+" or "-"
end)

------------------------------------------------
-- fungsi tambah coin/diamond
local function addCurrency(box, jenis)
    local jml = tonumber(box.Text) or 0
    if jml <= 0 then return end
    local remoteName = remoteBox.Text
    local remote = nil
    if remoteName ~= "" then
        remote = rep:FindFirstChild(remoteName) or rep:FindFirstChild(remoteName:sub(1,1):upper()..remoteName:sub(2))
        if not remote then
            warn("❌ Remote '"..remoteName.."' tidak ditemukan!")
            return
        end
    end

    if remote then
        -- pakai remote (server-side)
        remote:FireServer(jml)
        print("✅ "..jenis.." +" .. jml .. " (via RemoteEvent)")
    else
        -- fallback: client-only (visual di leaderboard)
        local leader = player:FindFirstChild("leaderstats")
        if leader then
            local target = leader:FindFirstChild(jenis) or leader:FindFirstChild(jenis:sub(1,1):upper()..jenis:sub(2))
            if target then
                target.Value = target.Value + jml
                print("✅ "..jenis.." +" .. jml .. " (client-only visual)")
            else
                warn("❌ "..jenis.." tidak ditemukan di leaderstats!")
            end
        else
            warn("❌ leaderstats tidak ada – coba pakai RemoteEvent!")
        end
    end
    box.Text = "0"
end

coinBtn.MouseButton1Click:Connect(function() addCurrency(coinBox, "Coin") end)
dmdBtn.MouseButton1Click:Connect(function() addCurrency(dmdBox, "Diamond") end)

------------------------------------------------
print("✅ v4.1 ready – scan remote di atas, lalu ketik nama RemoteEvent jika perlu.")
