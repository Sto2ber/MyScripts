-- Anime Fruits Helper v4.4  (scan + force ubah nilai)
local player = game:GetService("Players").LocalPlayer
local sg  = Instance.new("ScreenGui", game.CoreGui)
local main= Instance.new("Frame", sg)
main.Size     = UDim2.new(0, 350, 0, 400)
main.Position = UDim2.new(0.5, -175, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.BorderSizePixel  = 0; main.Active = true; main.Draggable = true

local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,25); top.BackgroundColor3 = Color3.fromRGB(50,50,50)
local ttl = Instance.new("TextLabel", top)
ttl.Size = UDim2.new(1,-30,1,0); ttl.BackgroundTransparency=1
ttl.Text = "🔍 Scan & Force Coins/Gems v4.4"; ttl.Font=Enum.Font.SourceSansBold
ttl.TextColor3 = Color3.new(1,1,1); ttl.TextSize=16
local minBtn = Instance.new("TextButton", top)
minBtn.Size=UDim2.new(0,25,1,0); minBtn.Position=UDim2.new(1,-25,0,0)
minBtn.Text="-"; minBtn.Font=Enum.Font.SourceSansBold; minBtn.TextSize=18
minBtn.BackgroundColor3 = Color3.fromRGB(255,100,100)

-- hasil scan
local scroll = Instance.new("ScrollingFrame", main)
scroll.Position = UDim2.new(0.05,0,0.15,0)
scroll.Size = UDim2.new(0,320,0,200)
scroll.BackgroundColor3 = Color3.fromRGB(40,40,40)
scroll.BorderSizePixel=0; scroll.ScrollBarThickness=5
local uiList = Instance.new("UIListLayout", scroll); uiList.Padding = UDim.new(0,3)

-- input force
local forceLbl = Instance.new("TextLabel", main)
forceLbl.Position = UDim2.new(0.05,0,0.73,0); forceLbl.Size=UDim2.new(0,80,0,20)
forceLbl.BackgroundTransparency=1; forceLbl.Text="Nominal"; forceLbl.TextColor3=Color3.new(1,1,1)
local forceBox = Instance.new("TextBox", main)
forceBox.Position = UDim2.new(0.05,0,0.78,0); forceBox.Size=UDim2.new(0,80,0,25)
forceBox.ClearTextOnFocus=false; forceBox.Text="0"; forceBox.Font=Enum.Font.SourceSans
forceBox.BackgroundColor3 = Color3.fromRGB(70,70,70); forceBox.TextColor3=Color3.new(1,1,1)
local forceBtn = Instance.new("TextButton", main)
forceBtn.Position = UDim2.new(0.05,0,0.84,0); forceBtn.Size=UDim2.new(0,80,0,25)
forceBtn.BackgroundColor3=Color3.fromRGB(0,170,0); forceBtn.Text="Force Add"; forceBtn.Font=Enum.Font.SourceSansBold

-- pilihan dropdown (ComboBox sederhana)
local pickLbl = Instance.new("TextLabel", main)
pickLbl.Position = UDim2.new(0.35,0,0.73,0); pickLbl.Size=UDim2.new(0,100,0,20)
pickLbl.BackgroundTransparency=1; pickLbl.Text="Pilih field:"; pickLbl.TextColor3=Color3.new(1,1,1)
local pickBox = Instance.new("TextBox", main)
pickBox.Position = UDim2.new(0.35,0,0.78,0); pickBox.Size=UDim2.new(0,150,0,25)
pickBox.ClearTextOnFocus=false; pickBox.Text=""; pickBox.Font=Enum.Font.SourceSans
pickBox.BackgroundColor3 = Color3.fromRGB(50,50,50); pickBox.TextColor3=Color3.new(1,1,1)

-- minimize
local isMin = false
minBtn.MouseButton1Click:Connect(function()
    isMin = not isMin
    scroll.Visible = not isMin; forceLbl.Visible = not isMin
    forceBox.Visible = not isMin; forceBtn.Visible = not isMin
    pickLbl.Visible = not isMin; pickBox.Visible = not isMin
    main.Size = isMin and UDim2.new(0,350,0,25) or UDim2.new(0,350,0,400)
    minBtn.Text = isMin and "+" or "-"
end)

------------------------------------------------
-- scan SEMUA nilai numeric di PlayerGui & CoreGui
local refList = {}  -- simpan referensi objek
local function scanAll()
    -- clear dulu
    for _,v in pairs(scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    table.clear(refList)

    -- scan PlayerGui
    for _,desc in pairs(player.PlayerGui:GetDescendants()) do
        if desc:IsA("IntValue") or desc:IsA("NumberValue") then
            local name = desc.Name:lower()
            if name:find("coin") or name:find("gems") or name:find("gold") or name:find("diamond") or name:find("gem") then
                local btn = Instance.new("TextButton", scroll)
                btn.Size = UDim2.new(1,0,0,25)
                btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
                btn.Text = desc.Name .. " = " .. tostring(desc.Value)
                btn.Font = Enum.Font.SourceSans
                btn.TextColor3 = Color3.new(1,1,1)
                btn.MouseButton1Click:Connect(function()
                    pickBox.Text = desc.Name
                end)
                table.insert(refList, desc)
            end
        end
    end

    -- scan CoreGui (kadang game taro di sini)
    for _,desc in pairs(game.CoreGui:GetDescendants()) do
        if desc:IsA("IntValue") or desc:IsA("NumberValue") then
            local name = desc.Name:lower()
            if name:find("coin") or name:find("gems") or name:find("gold") or name:find("diamond") or name:find("gem") then
                local btn = Instance.new("TextButton", scroll)
                btn.Size = UDim2.new(1,0,0,25)
                btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
                btn.Text = "CoreGui." .. desc.Name .. " = " .. tostring(desc.Value)
                btn.Font = Enum.Font.SourceSans
                btn.TextColor3 = Color3.new(1,1,1)
                btn.MouseButton1Click:Connect(function()
                    pickBox.Text = desc.Name
                end)
                table.insert(refList, desc)
            end
        end
    end

    if #refList == 0 then
        local lbl = Instance.new("TextLabel", scroll)
        lbl.Size = UDim2.new(1,0,0,30)
        lbl.BackgroundTransparency = 1
        lbl.Text = "Tidak ada field Coins/Gems ditemukan"
        lbl.TextColor3 = Color3.new(1,1,1)
        lbl.Font = Enum.Font.SourceSans
    end
end
scanAll()  -- scan awal
-- scan ulang setiap 5 detik (kalau GUI berubah)
while true do wait(5); scanAll() end

------------------------------------------------
-- FORCE UBAH NILAI + update teks GUI
forceBtn.MouseButton1Click:Connect(function()
    local targetName = pickBox.Text
    local jml = tonumber(forceBox.Text) or 0
    if jml <= 0 or targetName == "" then return end

    for _,obj in pairs(refList) do
        if obj.Name == targetName then
            -- 1. ubah nilai
            obj.Value = obj.Value + jml
            -- 2. update teks di GUI game (TextLabel yang memantau nilai ini)
            for _,desc in pairs(player.PlayerGui:GetDescendants()) do
                if desc:IsA("TextLabel") and desc.Text:match(tostring(obj.Value - jml)) then
                    desc.Text = tostring(obj.Value)
                end
            end
            print("✅ " .. targetName .. " +" .. jml .. " (forced)")
            break
        end
    end
    forceBox.Text = "0"
end)

------------------------------------------------
print("✅ v4.4 ready – klik field di daftar, lalu tekan Force Add.")
