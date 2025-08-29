--// Loader.lua - SuttannHub vStable
--// Fitur: Intro GUI + Sound + Key System + FPS Boost + Auto Save per Device

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

-- File simpan key
local keyFile = "SuttannHubKey.txt"

-- HWID unik (per device)
local HWID = (gethwid and gethwid()) or tostring(game:GetService("RbxAnalyticsService"):GetClientId())

-- Ambil daftar key dari Pastebin baru
local success, ValidKeyData = pcall(function()
    return game:HttpGet("https://pastebin.com/raw/c7DnMX7z")
end)
if not success then
    warn("⚠️ Gagal ambil key data dari Pastebin!")
    ValidKeyData = ""
end

-- Fungsi cek key
local function CheckKey(inputKey)
    for key in string.gmatch(ValidKeyData, "[^\r\n]+") do
        if inputKey == key then
            return true
        end
    end
    return false
end

-- Simpan key
local function SaveKey(k)
    if writefile then
        writefile(keyFile, k .. "||" .. HWID)
    end
end

-- Load key
local function LoadKey()
    if isfile and isfile(keyFile) then
        local data = readfile(keyFile)
        local savedKey, savedHWID = unpack(string.split(data, "||"))
        if savedKey and savedHWID == HWID then
            return savedKey
        end
    end
    return nil
end

--// GUI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

-- INTRO
local IntroFrame = Instance.new("Frame", ScreenGui)
IntroFrame.Size = UDim2.new(1,0,1,0)
IntroFrame.BackgroundColor3 = Color3.fromRGB(10,10,15)
IntroFrame.BackgroundTransparency = 1

local Glow = Instance.new("ImageLabel", IntroFrame)
Glow.AnchorPoint = Vector2.new(0.5,0.5)
Glow.Position = UDim2.new(0.5,0,0.5,0)
Glow.Size = UDim2.new(0,600,0,600)
Glow.Image = "rbxassetid://5028857472"
Glow.ImageColor3 = Color3.fromRGB(0, 170, 255)
Glow.ImageTransparency = 0.6
Glow.BackgroundTransparency = 1

local IntroText = Instance.new("TextLabel", IntroFrame)
IntroText.AnchorPoint = Vector2.new(0.5,0.5)
IntroText.Position = UDim2.new(0.5,0,0.5,0)
IntroText.Size = UDim2.new(0,500,0,60)
IntroText.Text = "🌌 SuttannHub 🌌"
IntroText.TextColor3 = Color3.fromRGB(255,255,255)
IntroText.TextTransparency = 1
IntroText.TextScaled = true
IntroText.Font = Enum.Font.GothamBold
IntroText.BackgroundTransparency = 1

-- Sounds
local Ambient = Instance.new("Sound", IntroFrame)
Ambient.SoundId = "rbxassetid://5410086212"
Ambient.Volume = 0.6
Ambient.Looped = true
Ambient:Play()

local Whoosh = Instance.new("Sound", IntroFrame)
Whoosh.SoundId = "rbxassetid://9127401354"
Whoosh.Volume = 1

-- Fade in
TweenService:Create(IntroFrame, TweenInfo.new(1.5), {BackgroundTransparency = 0}):Play()
TweenService:Create(IntroText, TweenInfo.new(1.5), {TextTransparency = 0}):Play()

-- Glow animasi
task.spawn(function()
    while Glow.Parent do
        TweenService:Create(Glow, TweenInfo.new(2), {Size=UDim2.new(0,700,0,700), ImageTransparency=0.3}):Play()
        task.wait(2)
        TweenService:Create(Glow, TweenInfo.new(2), {Size=UDim2.new(0,600,0,600), ImageTransparency=0.6}):Play()
        task.wait(2)
    end
end)

wait(4.5)

-- Fade out + whoosh
Ambient:Stop()
Whoosh:Play()
TweenService:Create(IntroFrame, TweenInfo.new(1.5), {BackgroundTransparency=1}):Play()
TweenService:Create(IntroText, TweenInfo.new(1.5), {TextTransparency=1}):Play()
TweenService:Create(Glow, TweenInfo.new(1.5), {ImageTransparency=1}):Play()
wait(1.6)
IntroFrame:Destroy()

-- KEY GUI
local Frame = Instance.new("Frame", ScreenGui)
Frame.AnchorPoint = Vector2.new(0.5,0.5)
Frame.Position = UDim2.new(0.5,0,0.5,0)
Frame.Size = UDim2.new(0,340,0,220)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0,10)

local UIStroke = Instance.new("UIStroke", Frame)
UIStroke.Color = Color3.fromRGB(0,200,255)
UIStroke.Thickness = 2

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,40)
Title.Text = "🔑 Enter your Key"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22

local KeyBox = Instance.new("TextBox", Frame)
KeyBox.Position = UDim2.new(0.1,0,0.35,0)
KeyBox.Size = UDim2.new(0.8,0,0.2,0)
KeyBox.PlaceholderText = "Masukkan Key..."
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.fromRGB(0,0,0)
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 18
KeyBox.BackgroundColor3 = Color3.fromRGB(255,255,255)

local SubmitButton = Instance.new("TextButton", Frame)
SubmitButton.Position = UDim2.new(0.3,0,0.65,0)
SubmitButton.Size = UDim2.new(0.4,0,0.15,0)
SubmitButton.Text = "Submit"
SubmitButton.Font = Enum.Font.GothamBold
SubmitButton.TextSize = 18
SubmitButton.TextColor3 = Color3.fromRGB(255,255,255)
SubmitButton.BackgroundColor3 = Color3.fromRGB(0,170,255)
local UICornerBtn = Instance.new("UICorner", SubmitButton)

local Notif = Instance.new("TextLabel", Frame)
Notif.Size = UDim2.new(1,0,0,30)
Notif.Position = UDim2.new(0,0,0.85,0)
Notif.Text = ""
Notif.TextColor3 = Color3.fromRGB(255,80,80)
Notif.BackgroundTransparency = 1
Notif.Font = Enum.Font.Gotham
Notif.TextSize = 16

-- FPS Boost Button
local FPSButton = Instance.new("TextButton", Frame)
FPSButton.Position = UDim2.new(0.3,0,0.5,0)
FPSButton.Size = UDim2.new(0.4,0,0.1,0)
FPSButton.Text = "⚡ FPS Boost"
FPSButton.Font = Enum.Font.GothamBold
FPSButton.TextSize = 16
FPSButton.TextColor3 = Color3.fromRGB(255,255,255)
FPSButton.BackgroundColor3 = Color3.fromRGB(255,170,0)
local UICornerFPS = Instance.new("UICorner", FPSButton)

FPSButton.MouseButton1Click:Connect(function()
    -- FPS Boost bypass aman
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 100000
    Lighting.Brightness = 1

    local Terrain = workspace:FindFirstChildOfClass("Terrain")
    if Terrain then
        Terrain.WaterWaveSize = 0
        Terrain.WaterWaveSpeed = 0
        Terrain.WaterReflectance = 0
        Terrain.WaterTransparency = 0
    end

    for i,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
            v.Material = Enum.Material.Plastic
            v.CastShadow = false
        end
    end

    Notif.Text = "⚡ FPS Boost aktif!"
    Notif.TextColor3 = Color3.fromRGB(80,255,80)
end)

-- Event submit key
SubmitButton.MouseButton1Click:Connect(function()
    Notif.Text = "⏳ Mengecek key..."
    Notif.TextColor3 = Color3.fromRGB(255,255,255)
    task.wait(0.5)

    local InputKey = KeyBox.Text
    if CheckKey(InputKey) then
        SaveKey(InputKey)
        Notif.Text = "✅ Key benar & tersimpan!"
        Notif.TextColor3 = Color3.fromRGB(80,255,80)
        task.wait(1)
        ScreenGui:Destroy()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Mereeeecuf/Scriptbro/refs/heads/main/SuttannHubV3"))()
        end)
    else
        Notif.Text = "❌ Key salah!"
        Notif.TextColor3 = Color3.fromRGB(255,80,80)
        task.wait(1.5)
        LocalPlayer:Kick("Key salah!")
    end
end)
