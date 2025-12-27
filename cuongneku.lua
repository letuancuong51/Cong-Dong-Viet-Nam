-- RENX HUB PREMIUM - FULL SOURCE GỐC
-- Đã xóa local r0_106 và các biến phức tạp

-- ============================================
-- EMOTE SYSTEM
-- ============================================
local function EmoteSystem()
    if _G.EmotesGUIRunning then
        getgenv().Notify({
            Title = "RENX Hub | Emote",
            Content = "✅ Emotes đã chạy",
            Duration = 5,
        })
        return
    end
    _G.EmotesGUIRunning = true
    
    loadstring(game:HttpGet("https://raw.githubusercontent.com/7yd7/Menu-7yd7/refs/heads/Script/GUIS/Off-site/Notify.lua"))()
    
    getgenv().Notify({
        Title = "RENX Hub | Emote",
        Content = "🔄 Script loading...",
        Duration = 5,
    })
    
    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local Humanoid = Character:WaitForChild("Humanoid")
    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")
    
    local emotes = {}
    local favoriteEmotes = {}
    local isFavoriteMode = false
    local emoteFreeze = false
    local speedEmote = false
    local currentPage = 1
    local emoteMode = "emote"
    
    -- Emote data
    local emoteList = {
        {id = 3360686498, name = "Stadium"},
        {id = 3360692915, name = "Tilt"},
        {id = 3576968026, name = "Shrug"},
        {id = 3360689775, name = "Salute"},
        {id = 3360687534, name = "Point"},
        {id = 3360692337, name = "Dance"},
        {id = 3360690763, name = "Wave"},
        {id = 3360693044, name = "Laugh"}
    }
    
    -- Load emotes từ web
    local function LoadEmotes()
        local success, data = pcall(function()
            local response = game:HttpGet("https://raw.githubusercontent.com/7yd7/sniper-Emote/refs/heads/test/EmoteSniper.json")
            if response and response ~= "" then
                return HttpService:JSONDecode(response).data or {}
            end
            return nil
        end)
        
        if success and data then
            emotes = data
            getgenv().Notify({
                Title = "RENX Hub | Emote",
                Content = "✅ Load Thành Công! Total Emotes: " .. #emotes,
                Duration = 5,
            })
        else
            emotes = emoteList
            getgenv().Notify({
                Title = "RENX Hub | Emote",
                Content = "✅ Load emotes mặc định",
                Duration = 5,
            })
        end
    end
    
    -- UI Functions
    local function CreateEmoteUI()
        -- Tạo GUI cho emotes
        local emoteGUI = Instance.new("ScreenGui")
        emoteGUI.Name = "RENX_EmoteGUI"
        emoteGUI.Parent = CoreGui
        
        local mainFrame = Instance.new("Frame")
        mainFrame.Size = UDim2.new(0, 300, 0, 400)
        mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
        mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        mainFrame.Parent = emoteGUI
        
        Instance.new("UICorner", mainFrame)
        
        local title = Instance.new("TextLabel")
        title.Text = "RENX EMOTES"
        title.Size = UDim2.new(1, 0, 0, 40)
        title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        title.TextColor3 = Color3.new(1, 1, 1)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 18
        title.Parent = mainFrame
        
        Instance.new("UICorner", title)
        
        local emoteGrid = Instance.new("ScrollingFrame")
        emoteGrid.Size = UDim2.new(1, -20, 1, -100)
        emoteGrid.Position = UDim2.new(0, 10, 0, 50)
        emoteGrid.BackgroundTransparency = 1
        emoteGrid.Parent = mainFrame
        
        local uiList = Instance.new("UIGridLayout", emoteGrid)
        uiList.CellSize = UDim2.new(0, 80, 0, 80)
        uiList.CellPadding = UDim2.new(0, 5, 0, 5)
        
        -- Thêm emotes vào grid
        for i, emote in ipairs(emotes) do
            if i <= 20 then -- Giới hạn 20 emote
                local emoteButton = Instance.new("ImageButton")
                emoteButton.Size = UDim2.new(0, 80, 0, 80)
                emoteButton.Image = "rbxthumb://type=Asset&id=" .. emote.id .. "&w=420&h=420"
                emoteButton.Parent = emoteGrid
                
                Instance.new("UICorner", emoteButton)
                
                local emoteName = Instance.new("TextLabel")
                emoteName.Text = emote.name
                emoteName.Size = UDim2.new(1, 0, 0, 20)
                emoteName.Position = UDim2.new(0, 0, 1, -20)
                emoteName.BackgroundTransparency = 0.5
                emoteName.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                emoteName.TextColor3 = Color3.new(1, 1, 1)
                emoteName.TextSize = 10
                emoteName.Font = Enum.Font.Gotham
                emoteName.Parent = emoteButton
                
                emoteButton.MouseButton1Click:Connect(function()
                    -- Chạy emote
                    if Character and Humanoid then
                        local humanoidDescription = Humanoid.HumanoidDescription
                        if humanoidDescription then
                            humanoidDescription:SetEmotes({[emote.name] = {emote.id}})
                            humanoidDescription:SetEquippedEmotes({emote.name})
                        end
                    end
                end)
            end
        end
        
        local closeButton = Instance.new("TextButton")
        closeButton.Text = "Đóng"
        closeButton.Size = UDim2.new(0, 100, 0, 30)
        closeButton.Position = UDim2.new(0.5, -50, 1, -40)
        closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        closeButton.TextColor3 = Color3.new(1, 1, 1)
        closeButton.Font = Enum.Font.GothamBold
        closeButton.Parent = mainFrame
        
        Instance.new("UICorner", closeButton)
        
        closeButton.MouseButton1Click:Connect(function()
            emoteGUI:Destroy()
        end)
        
        return emoteGUI
    end
    
    LoadEmotes()
    
    renx.Emotes:AddButton({
        Title = "Mở Emote Menu",
        Description = "Mở menu emotes đầy đủ",
        Callback = function()
            CreateEmoteUI()
        end,
    })
    
    renx.Emotes:AddButton({
        Title = "Lọ Vương R6",
        Description = "Kích hoạt Lọ Vương cho nhân vật R6",
        Callback = function()
            loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))()
        end,
    })
    
    renx.Emotes:AddButton({
        Title = "Lọ Vương R15",
        Description = "Kích hoạt Lọ Vương cho nhân vật R15",
        Callback = function()
            loadstring(game:HttpGet("https://pastefy.app/YZoglOyJ/raw"))()
        end,
    })
end

-- ============================================
-- MAIN SCRIPT
-- ============================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local CurrentCamera = Workspace.CurrentCamera
local Backpack = LocalPlayer:WaitForChild("Backpack")

-- Tải Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Cấu hình window
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local windowSize = isMobile and UDim2.fromScale(0.6, 0.8) or UDim2.fromOffset(500, 350)

-- Tạo window chính
local RenxWindow = Fluent:CreateWindow({
    Title = "RENX HUB | PREMIUM",
    SubTitle = "by rez",
    TabWidth = 140,
    Theme = "Darker",
    Acrylic = false,
    Size = windowSize,
    MinimizeKey = Enum.KeyCode.J,
})

-- ========== CÁC TAB RENX ==========
local renx = {}

renx.Heal = RenxWindow:AddTab({
    Title = "Heal",
    Icon = "heart",
})

renx.PVP = RenxWindow:AddTab({
    Title = "PvP",
    Icon = "sword",
})

renx.Boss = RenxWindow:AddTab({
    Title = "Boss",
    Icon = "axe",
})

renx.Player = RenxWindow:AddTab({
    Title = "Người Chơi",
    Icon = "user",
})

renx.Player2 = RenxWindow:AddTab({
    Title = "Người Khác",
    Icon = "user",
})

renx.TP = RenxWindow:AddTab({
    Title = "Trang Phục",
    Icon = "leaf",
})

renx.Roles = RenxWindow:AddTab({
    Title = "Roles",
    Icon = "star",
})

renx.Emotes = RenxWindow:AddTab({
    Title = "Emotes",
    Icon = "activity",
})

renx.Money = RenxWindow:AddTab({
    Title = "Tiền",
    Icon = "banknote",
})

renx.Teleport = RenxWindow:AddTab({
    Title = "Dịch Chuyển",
    Icon = "map",
})

renx.Fixlag = RenxWindow:AddTab({
    Title = "FixLag",
    Icon = "cpu",
})

renx.Settings = RenxWindow:AddTab({
    Title = "Settings",
    Icon = "settings",
})

-- ========== DISCORD BUTTON ==========
renx.TP:AddParagraph({
    Title = "📢 Discord Support",
    Content = "Tham gia Discord để được hỗ trợ và cập nhật",
})

renx.TP:AddButton({
    Title = "Copy Discord Link",
    Description = "Nhấn để copy link Discord",
    Callback = function()
        setclipboard("https://discord.gg/NAyGX2Q7d6")
        Fluent:Notify({
            Title = "✅ Đã sao chép!",
            Content = "Link Discord đã được copy vào clipboard.",
            Duration = 3,
        })
    end,
})

-- ========== HEAL FEATURES ==========
local SelectedWeapon = nil
local AutoEquipEnabled = false
local AutoHealEnabled = false
local AutoBuyBandageEnabled = false

renx.Heal:AddButton({
    Title = "Chọn Vũ Khí",
    Description = "Chọn vũ khí từ balo",
    Callback = function()
        local weapons = {}
        for _, tool in ipairs(Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                table.insert(weapons, {
                    Title = tool.Name,
                    Callback = function()
                        SelectedWeapon = tool.Name
                        Fluent:Notify({
                            Title = "✅ Thành công",
                            Content = "Đã chọn vũ khí: " .. tool.Name,
                            Duration = 3,
                        })
                    end,
                })
            end
        end
        
        if #weapons == 0 then
            table.insert(weapons, {
                Title = "❌ Không có vũ khí",
                Callback = function() end,
            })
        end
        
        table.insert(weapons, {
            Title = "Thoát",
            Callback = function() end,
        })
        
        RenxWindow:Dialog({
            Title = "Chọn Vũ Khí",
            Content = "Chọn một vũ khí từ balo:",
            Buttons = weapons,
        })
    end,
})

renx.Heal:AddToggle("AutoEquip", {
    Title = "Auto Equip (5s)",
    Description = "Tự trang bị vũ khí đã chọn",
    Default = false,
    Callback = function(value)
        AutoEquipEnabled = value
    end,
})

task.spawn(function()
    while task.wait(5) do
        if AutoEquipEnabled and SelectedWeapon then
            local char = LocalPlayer.Character
            if char then
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                if backpack then
                    local weapon = backpack:FindFirstChild(SelectedWeapon)
                    if weapon then
                        weapon.Parent = char
                    end
                end
            end
        end
    end
end)

renx.Heal:AddToggle("AutoHeal", {
    Title = "Auto Heal < 80 HP",
    Description = "Tự động heal khi máu thấp",
    Default = false,
    Callback = function(value)
        AutoHealEnabled = value
    end,
})

task.spawn(function()
    while task.wait(0.5) do
        if AutoHealEnabled and Character and Humanoid then
            if Humanoid.Health < 80 then
                local bandage = Character:FindFirstChild("băng gạc") or Backpack:FindFirstChild("băng gạc")
                if bandage then
                    if not Character:FindFirstChild("băng gạc") then
                        bandage.Parent = Character
                        task.wait(0.2)
                    end
                    
                    if bandage:FindFirstChild("RemoteEvent") then
                        bandage.RemoteEvent:FireServer()
                    else
                        bandage:Activate()
                    end
                    
                    task.wait(1)
                    if SelectedWeapon then
                        local weapon = Backpack:FindFirstChild(SelectedWeapon)
                        if weapon then
                            weapon.Parent = Character
                        end
                    end
                end
            end
        end
    end
end)

local function BuyBandage()
    if not ReplicatedStorage:FindFirstChild("KnitPackages") then return end
    
    local inventoryService = ReplicatedStorage.KnitPackages._Index["sleitnick_knit@1.7.0"].knit.Services.InventoryService.RE
    inventoryService:WaitForChild("updateInventory"):FireServer("refresh")
    inventoryService:WaitForChild("updateInventory"):FireServer("eue", "băng gạc")
    
    local shopService = ReplicatedStorage.KnitPackages._Index["sleitnick_knit@1.7.0"].knit.Services.ShopService.RE
    shopService:WaitForChild("buyItem"):FireServer("băng gạc", 5)
    
    print("[RENX] Đã mua 5 băng gạc")
end

renx.Heal:AddToggle("AutoBuyBandage", {
    Title = "Auto Mua Băng (30s)",
    Description = "Tự động mua băng gạc",
    Default = false,
    Callback = function(value)
        AutoBuyBandageEnabled = value
        if value then
            task.spawn(function()
                while AutoBuyBandageEnabled do
                    BuyBandage()
                    task.wait(30)
                end
            end)
        end
    end,
})

-- ========== PLAYER FEATURES ==========
local WalkSpeedValue = 16
local JumpPowerValue = 50
local FlyEnabled = false
local FlySpeedValue = 60
local NoclipEnabled = false
local SpinEnabled = false
local SpinSpeedValue = 50
local InfJumpEnabled = false
local CamFOVValue = 70

renx.Player:AddSlider("WalkSpeed", {
    Title = "Tốc chạy",
    Default = 16,
    Min = 16,
    Max = 120,
    Rounding = 0,
    Callback = function(value)
        WalkSpeedValue = value
        if Humanoid then
            Humanoid.WalkSpeed = value
        end
    end,
})

RunService.RenderStepped:Connect(function(dt)
    if Humanoid and Humanoid.MoveDirection.Magnitude > 0 then
        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Humanoid.MoveDirection * (WalkSpeedValue - 16) * dt
    end
end)

renx.Player:AddToggle("InfJump", {
    Title = "Nhảy Vô Hạn",
    Default = false,
    Callback = function(value)
        InfJumpEnabled = value
        if value then
            local connection = UserInputService.JumpRequest:Connect(function()
                if Humanoid then
                    Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    end,
})

renx.Player:AddSlider("JumpPower", {
    Title = "Nhảy Cao",
    Default = 50,
    Min = 50,
    Max = 200,
    Rounding = 1,
    Callback = function(value)
        JumpPowerValue = value
        if Humanoid then
            Humanoid.UseJumpPower = true
            Humanoid.JumpPower = value
        end
    end,
})

local flyBodyGyro, flyBodyVelocity
renx.Player:AddToggle("Fly", {
    Title = "Bật Fly",
    Default = false,
    Callback = function(value)
        FlyEnabled = value
        
        if value then
            flyBodyGyro = Instance.new("BodyGyro", HumanoidRootPart)
            flyBodyVelocity = Instance.new("BodyVelocity", HumanoidRootPart)
            flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            flyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            
            RunService.RenderStepped:Connect(function()
                if FlyEnabled and HumanoidRootPart then
                    local direction = Vector3.zero
                    local camCF = CurrentCamera.CFrame
                    
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        direction = direction + camCF.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        direction = direction - camCF.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        direction = direction - camCF.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        direction = direction + camCF.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        direction = direction + camCF.UpVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        direction = direction - camCF.UpVector
                    end
                    
                    if direction.Magnitude > 0 then
                        flyBodyVelocity.Velocity = direction.Unit * FlySpeedValue
                    else
                        flyBodyVelocity.Velocity = Vector3.zero
                    end
                    flyBodyGyro.CFrame = camCF
                end
            end)
        else
            if flyBodyGyro then flyBodyGyro:Destroy() end
            if flyBodyVelocity then flyBodyVelocity:Destroy() end
        end
    end,
})

renx.Player:AddSlider("FlySpeed", {
    Title = "Tốc Độ Bay",
    Default = 60,
    Min = 10,
    Max = 200,
    Rounding = 1,
    Callback = function(value)
        FlySpeedValue = value
    end,
})

renx.Player:AddToggle("Noclip", {
    Title = "Xuyên Tường",
    Default = false,
    Callback = function(value)
        NoclipEnabled = value
        if value then
            RunService.Stepped:Connect(function()
                if NoclipEnabled and Character then
                    for _, part in pairs(Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    end,
})

renx.Player:AddToggle("AutoSpin", {
    Title = "Auto Xoay",
    Default = false,
    Callback = function(value)
        SpinEnabled = value
    end,
})

renx.Player:AddSlider("SpinSpeed", {
    Title = "Tốc độ xoay",
    Default = 50,
    Min = 10,
    Max = 1000,
    Rounding = 0,
    Callback = function(value)
        SpinSpeedValue = value
    end,
})

local spinAngle = 0
RunService.Heartbeat:Connect(function(dt)
    if SpinEnabled and HumanoidRootPart then
        spinAngle = spinAngle + dt * SpinSpeedValue
        HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position) * CFrame.Angles(0, spinAngle, 0)
    end
end)

renx.Player:AddSlider("CamFOV", {
    Title = "Độ rộng camera",
    Default = 70,
    Min = 70,
    Max = 120,
    Rounding = 0,
    Callback = function(value)
        CurrentCamera.FieldOfView = value
    end,
})

-- FPS và Ping Display
local FPSLabel = Drawing.new("Text")
local PingLabel = Drawing.new("Text")
local ShowFPS = true
local ShowPing = true

FPSLabel.Size = 16
FPSLabel.Position = Vector2.new(CurrentCamera.ViewportSize.X - 100, 10)
FPSLabel.Color = Color3.fromRGB(0, 255, 0)
FPSLabel.Outline = true
FPSLabel.Center = false
FPSLabel.Visible = ShowFPS

PingLabel.Size = 16
PingLabel.Position = Vector2.new(CurrentCamera.ViewportSize.X - 100, 30)
PingLabel.Color = Color3.fromRGB(0, 255, 0)
PingLabel.Outline = true
PingLabel.Center = false
PingLabel.Visible = ShowPing

local frameCount = 0
local lastTime = tick()

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    
    local currentTime = tick()
    if currentTime - lastTime >= 1 then
        if ShowFPS then
            FPSLabel.Visible = true
            FPSLabel.Text = "FPS: " .. frameCount
        else
            FPSLabel.Visible = false
        end
        
        if ShowPing then
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            PingLabel.Text = "Ping: " .. ping .. " ms"
            if ping <= 120 then
                PingLabel.Color = Color3.fromRGB(100, 245, 158)
            else
                PingLabel.Color = Color3.fromRGB(255, 0, 0)
            end
            PingLabel.Visible = true
        else
            PingLabel.Visible = false
        end
        
        lastTime = currentTime
        frameCount = 0
    end
end)

renx.Fixlag:AddToggle("ShowFPS", {
    Title = "Hiện FPS",
    Default = true,
    Callback = function(value)
        ShowFPS = value
        FPSLabel.Visible = value
    end,
})

renx.Fixlag:AddToggle("ShowPing", {
    Title = "Hiện Ping",
    Default = true,
    Callback = function(value)
        ShowPing = value
        PingLabel.Visible = value
    end,
})

renx.Fixlag:AddButton({
    Title = "Tăng FPS",
    Callback = function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 100
        Lighting.Brightness = 0
        
        for _, effect in pairs(Lighting:GetDescendants()) do
            if effect:IsA("PostEffect") then
                effect.Enabled = false
            end
        end
        
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                obj.Enabled = false
            elseif obj:IsA("Texture") or obj:IsA("Decal") then
                obj.Transparency = 1
            elseif obj:IsA("BasePart") then
                obj.CastShadow = false
            end
        end
        
        Fluent:Notify({
            Title = "✅ Thành công",
            Content = "Đã tăng FPS tối đa!",
            Duration = 3,
        })
    end,
})

-- ========== PVP FEATURES ==========
local AimLockEnabled = false
local AutoHitEnabled = false
local HitboxESPEnabled = false
local ShowPlayerHealthEnabled = false
local WeaponFXEnabled = false
local WeaponFXColor = Color3.fromRGB(255, 150, 50)
local AutoPickChair = false

renx.PVP:AddToggle("AimLock", {
    Title = "Aim Lock",
    Description = "Tự động nhắm vào người gần nhất",
    Default = false,
    Callback = function(value)
        AimLockEnabled = value
    end,
})

RunService.RenderStepped:Connect(function()
    if AimLockEnabled and HumanoidRootPart then
        local closestPlayer = nil
        local closestDistance = math.huge
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    local distance = (HumanoidRootPart.Position - targetRoot.Position).Magnitude
                    if distance < closestDistance and distance < 50 then
                        closestDistance = distance
                        closestPlayer = targetRoot
                    end
                end
            end
        end
        
        if closestPlayer then
            HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position, closestPlayer.Position)
        end
    end
end)

renx.PVP:AddToggle("AutoHit", {
    Title = "Auto Đánh",
    Description = "Tự động đánh liên tục",
    Default = false,
    Callback = function(value)
        AutoHitEnabled = value
        if value then
            task.spawn(function()
                while AutoHitEnabled do
                    local tool = Character:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                    end
                    task.wait(0.1)
                end
            end)
        end
    end,
})

renx.PVP:AddToggle("HitboxESP", {
    Title = "Hitbox ESP",
    Description = "Hiển thị hitbox người chơi",
    Default = false,
    Callback = function(value)
        HitboxESPEnabled = value
        if not value then
            for _, obj in pairs(CoreGui:GetChildren()) do
                if obj.Name == "HitboxESP" then
                    obj:Destroy()
                end
            end
        end
    end,
})

local playerHealthLabels = {}
renx.PVP:AddToggle("ShowPlayerHealth", {
    Title = "Hiển thị máu",
    Description = "Hiển thị máu người chơi",
    Default = false,
    Callback = function(value)
        ShowPlayerHealthEnabled = value
        if not value then
            for _, label in pairs(playerHealthLabels) do
                if label then
                    label:Destroy()
                end
            end
            playerHealthLabels = {}
        end
    end,
})

RunService.RenderStepped:Connect(function()
    if ShowPlayerHealthEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local humanoid = player.Character:FindFirstChild("Humanoid")
                local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                
                if humanoid and rootPart then
                    local distance = (HumanoidRootPart.Position - rootPart.Position).Magnitude
                    if distance <= 100 and humanoid.Health > 0 then
                        if not playerHealthLabels[player] then
                            local billboard = Instance.new("BillboardGui")
                            billboard.Size = UDim2.new(0, 100, 0, 40)
                            billboard.AlwaysOnTop = true
                            billboard.MaxDistance = 150
                            
                            local label = Instance.new("TextLabel", billboard)
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 0.3
                            label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                            label.TextColor3 = Color3.fromRGB(255, 0, 0)
                            label.Font = Enum.Font.GothamBold
                            label.TextSize = 16
                            label.Name = "HealthLabel"
                            
                            playerHealthLabels[player] = billboard
                            billboard.Parent = player.Character
                        end
                        
                        local billboard = playerHealthLabels[player]
                        billboard.Adornee = rootPart
                        billboard.HealthLabel.Text = math.floor(humanoid.Health)
                    elseif playerHealthLabels[player] then
                        playerHealthLabels[player]:Destroy()
                        playerHealthLabels[player] = nil
                    end
                end
            end
        end
    end
end)

renx.PVP:AddToggle("WeaponFX", {
    Title = "Hiệu Ứng Vũ Khí",
    Description = "Hiệu ứng lửa và ánh sáng cho vũ khí",
    Default = false,
    Callback = function(value)
        WeaponFXEnabled = value
        if not value then
            for _, tool in pairs(Character:GetChildren()) do
                if tool:IsA("Tool") then
                    for _, effect in pairs(tool:GetDescendants()) do
                        if effect:IsA("Fire") or effect:IsA("ParticleEmitter") or effect:IsA("Trail") then
                            effect:Destroy()
                        end
                    end
                end
            end
        end
    end,
})

renx.PVP:AddColorpicker("WeaponFXColor", {
    Title = "Màu Hiệu Ứng",
    Default = Color3.fromRGB(255, 150, 50),
    Callback = function(color)
        WeaponFXColor = color
    end,
})

renx.PVP:AddButton({
    Title = "Nhặt Ghế",
    Description = "Nhặt tất cả ghế trong khu vực",
    Callback = function()
        local chairFolder = Workspace:FindFirstChild("Ghe")
        if chairFolder then
            local count = 0
            for _, chair in pairs(chairFolder:GetChildren()) do
                if chair:IsA("Model") then
                    local hitbox = chair:FindFirstChild("hitbox")
                    if hitbox then
                        local clickDetector = hitbox:FindFirstChildOfClass("ClickDetector")
                        if clickDetector then
                            fireclickdetector(clickDetector)
                            count = count + 1
                        end
                    end
                end
            end
            Fluent:Notify({
                Title = "✅ Thành công",
                Content = "Đã nhặt " .. count .. " ghế",
                Duration = 3,
            })
        end
    end,
})

renx.PVP:AddToggle("AutoPickChair", {
    Title = "Auto Nhặt Ghế (0.5s)",
    Default = false,
    Callback = function(value)
        AutoPickChair = value
        if value then
            task.spawn(function()
                while AutoPickChair do
                    local chairFolder = Workspace:FindFirstChild("Ghe")
                    if chairFolder then
                        for _, chair in pairs(chairFolder:GetChildren()) do
                            if chair:IsA("Model") then
                                local hitbox = chair:FindFirstChild("hitbox")
                                if hitbox then
                                    local clickDetector = hitbox:FindFirstChildOfClass("ClickDetector")
                                    if clickDetector then
                                        fireclickdetector(clickDetector)
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end,
})

-- ========== BOSS FEATURES ==========
local AutoFarmBossEnabled = false
local ShowBossHPEnabled = false
local AutoPickupEnabled = false
local BossCameraEnabled = false
local BossRotationRadius = 13.2
local BossRotationSpeed = 0.3

local function FindNearestBoss()
    local bossFolder = Workspace:FindFirstChild("GiangHo2")
    if not bossFolder then return nil end
    
    local npcFolder = bossFolder:FindFirstChild("NPCs")
    if not npcFolder then return nil end
    
    local closestBoss = nil
    local closestDistance = math.huge
    
    for _, npc in pairs(npcFolder:GetChildren()) do
        if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") then
            local humanoid = npc:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local distance = (HumanoidRootPart.Position - npc.HumanoidRootPart.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestBoss = npc
                end
            end
        end
    end
    
    return closestBoss
end

renx.Boss:AddToggle("AutoFarmBoss", {
    Title = "Auto Farm Boss",
    Default = false,
    Callback = function(value)
        AutoFarmBossEnabled = value
        if value then
            task.spawn(function()
                while AutoFarmBossEnabled do
                    local boss = FindNearestBoss()
                    if boss then
                        HumanoidRootPart.CFrame = CFrame.new(boss.HumanoidRootPart.Position + Vector3.new(0, 5, 0))
                        task.wait(0.3)
                        
                        local tool = Character:FindFirstChildOfClass("Tool")
                        if tool then
                            tool:Activate()
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end,
})

renx.Boss:AddToggle("ShowBossHP", {
    Title = "Hiển thị máu Boss",
    Default = false,
    Callback = function(value)
        ShowBossHPEnabled = value
    end,
})

renx.Boss:AddToggle("AutoPickup", {
    Title = "Tự nhặt vật phẩm",
    Default = false,
    Callback = function(value)
        AutoPickupEnabled = value
    end,
})

local bossHPGUI = Instance.new("ScreenGui", CoreGui)
bossHPGUI.Name = "BossHPGUI"
bossHPGUI.Enabled = false

local bossHPLabel = Instance.new("TextLabel", bossHPGUI)
bossHPLabel.Size = UDim2.new(0, 400, 0, 30)
bossHPLabel.Position = UDim2.new(0.5, -200, 0.05, 0)
bossHPLabel.BackgroundTransparency = 0.3
bossHPLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bossHPLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
bossHPLabel.Font = Enum.Font.GothamBold
bossHPLabel.TextSize = 18
bossHPLabel.TextXAlignment = Enum.TextXAlignment.Center

Instance.new("UICorner", bossHPLabel)

task.spawn(function()
    while true do
        if ShowBossHPEnabled then
            local boss = FindNearestBoss()
            if boss then
                local humanoid = boss:FindFirstChild("Humanoid")
                if humanoid then
                    bossHPGUI.Enabled = true
                    bossHPLabel.Text = boss.Name .. ": " .. math.floor(humanoid.Health) .. " / " .. math.floor(humanoid.MaxHealth)
                end
            else
                bossHPGUI.Enabled = false
            end
        else
            bossHPGUI.Enabled = false
        end
        task.wait(0.5)
    end
end)

renx.Boss:AddSlider("BossRadius", {
    Title = "Bán kính xoay",
    Default = 13.2,
    Min = 8,
    Max = 35,
    Rounding = 1,
    Callback = function(value)
        BossRotationRadius = value
    end,
})

renx.Boss:AddSlider("BossSpeed", {
    Title = "Tốc độ xoay",
    Default = 0.3,
    Min = 0.01,
    Max = 100,
    Rounding = 1,
    Callback = function(value)
        BossRotationSpeed = value
    end,
})

renx.Boss:AddToggle("BossCamera", {
    Title = "Camera Trên Cao",
    Default = false,
    Callback = function(value)
        BossCameraEnabled = value
        if value then
            local originalCameraType = CurrentCamera.CameraType
            local originalCFrame = CurrentCamera.CFrame
            
            CurrentCamera.CameraType = Enum.CameraType.Scriptable
            
            RunService.RenderStepped:Connect(function()
                if BossCameraEnabled then
                    local boss = FindNearestBoss()
                    if boss and boss:FindFirstChild("HumanoidRootPart") then
                        CurrentCamera.CFrame = CFrame.new(boss.HumanoidRootPart.Position + Vector3.new(0, 70, 0), boss.HumanoidRootPart.Position)
                    end
                end
            end)
        else
            CurrentCamera.CameraType = Enum.CameraType.Custom
        end
    end,
})

-- ========== MONEY FEATURES ==========
local AutoFarmNPCEnabled = false
local FPSBoostEnabled = false

renx.Money:AddToggle("AutoFarmNPC", {
    Title = "Auto Farm NPC",
    Description = "Tự động farm NPC kiếm tiền",
    Default = false,
    Callback = function(value)
        AutoFarmNPCEnabled = value
        if value then
            task.spawn(function()
                while AutoFarmNPCEnabled do
                    local npcFolder = Workspace:FindFirstChild("CityNPCs")
                    if npcFolder and npcFolder:FindFirstChild("NPCs") then
                        local closestNPC = nil
                        local closestDistance = math.huge
                        
                        for _, npc in pairs(npcFolder.NPCs:GetChildren()) do
                            if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") then
                                local humanoid = npc:FindFirstChild("Humanoid")
                                if humanoid and humanoid.Health > 0 then
                                    local distance = (HumanoidRootPart.Position - npc.HumanoidRootPart.Position).Magnitude
                                    if distance < closestDistance then
                                        closestDistance = distance
                                        closestNPC = npc
                                    end
                                end
                            end
                        end
                        
                        if closestNPC then
                            HumanoidRootPart.CFrame = CFrame.new(closestNPC.HumanoidRootPart.Position + Vector3.new(0, 3, 0))
                            task.wait(0.3)
                            
                            local tool = Character:FindFirstChildOfClass("Tool")
                            if tool then
                                tool:Activate()
                            end
                            
                            if AutoPickupEnabled then
                                local dropFolder = npcFolder:FindFirstChild("Drop")
                                if dropFolder then
                                    for _, drop in pairs(dropFolder:GetChildren()) do
                                        if drop:IsA("BasePart") and drop:FindFirstChildOfClass("ProximityPrompt") then
                                            fireproximityprompt(drop:FindFirstChildOfClass("ProximityPrompt"))
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(2)
                end
            end)
        end
    end,
})

renx.Money:AddInput("MoneyInput", {
    Title = "Nhập số tiền",
    Default = "",
    Placeholder = "VD: 999999",
    Callback = function(value)
        local stats = LocalPlayer:FindFirstChild("leaderstats")
        if stats and stats:FindFirstChild("VND") then
            local amount = tonumber(value)
            if amount then
                stats.VND.Value = amount
                Fluent:Notify({
                    Title = "✅ Thành công",
                    Content = "Đã set tiền: " .. value,
                    Duration = 3,
                })
            else
                Fluent:Notify({
                    Title = "❌ Lỗi",
                    Content = "Vui lòng nhập số hợp lệ!",
                    Duration = 3,
                })
            end
        end
    end,
})

renx.Money:AddButton({
    Title = "Reset Tiền",
    Description = "Reset về số tiền ban đầu",
    Callback = function()
        local stats = LocalPlayer:FindFirstChild("leaderstats")
        if stats and stats:FindFirstChild("VND") then
            stats.VND.Value = 0
            Fluent:Notify({
                Title = "✅ Thành công",
                Content = "Đã reset tiền về 0",
                Duration = 3,
            })
        end
    end,
})

local originalFPS = settings().Rendering.QualityLevel
local originalShadows = Lighting.GlobalShadows

renx.Money:AddToggle("FPSBoost", {
    Title = "FPS Boost",
    Default = false,
    Callback = function(value)
        FPSBoostEnabled = value
        if value then
            settings().Rendering.QualityLevel = 1
            Lighting.GlobalShadows = false
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                    obj.Enabled = false
                elseif obj:IsA("Decal") then
                    obj.Transparency = 1
                end
            end
        else
            settings().Rendering.QualityLevel = originalFPS
            Lighting.GlobalShadows = originalShadows
        end
    end,
})

-- ========== FIXLAG FEATURES ==========
local NoFogEnabled = false
local originalFogStart = Lighting.FogStart
local originalFogEnd = Lighting.FogEnd

renx.Fixlag:AddButton({
    Title = "Fix Lag 10%",
    Callback = function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Fluent:Notify({
            Title = "✅ Thành công",
            Content = "Đã fix lag 10%",
            Duration = 3,
        })
    end,
})

renx.Fixlag:AddButton({
    Title = "Fix Lag 50%",
    Callback = function()
        settings().Rendering.QualityLevel = 1
        Lighting.GlobalShadows = false
        
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.Material = Enum.Material.SmoothPlastic
            end
        end
        
        Fluent:Notify({
            Title = "✅ Thành công",
            Content = "Đã fix lag 50%",
            Duration = 3,
        })
    end,
})

renx.Fixlag:AddButton({
    Title = "Fix Lag 100%",
    Callback = function()
        settings().Rendering.QualityLevel = 1
        Lighting.GlobalShadows = false
        
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.Material = Enum.Material.SmoothPlastic
                obj.Color = Color3.new(1, 1, 1)
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj:Destroy()
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                obj.Enabled = false
            end
        end
        
        Fluent:Notify({
            Title = "✅ Thành công",
            Content = "Đã fix lag 100%",
            Duration = 3,
        })
    end,
})

renx.Fixlag:AddToggle("NoFog", {
    Title = "Xóa Sương Mù",
    Default = false,
    Callback = function(value)
        NoFogEnabled = value
        if value then
            Lighting.FogStart = 9e9
            Lighting.FogEnd = 1e10
        else
            Lighting.FogStart = originalFogStart
            Lighting.FogEnd = originalFogEnd
        end
    end,
})

-- ========== TELEPORT FEATURES ==========
local TeleportLocations = {
    {Name = "Sảnh Chính", Position = Vector3.new(674.5293, 20.3271, -381.9542)},
    {Name = "Bán Phóng Lợn", Position = Vector3.new(792.9041, 20.3271, -290.885)},
    {Name = "Gara Ô Tô", Position = Vector3.new(814.2191, 20.3271, 133.1891)},
    {Name = "Chùa", Position = Vector3.new(1464.2713, 86.7332, -290.7584)},
    {Name = "Farm Gỗ", Position = Vector3.new(1650.7684, 18.7658, -324.5135)},
    {Name = "Gara Xe Máy", Position = Vector3.new(1095.4713, 20.209, -671.6462)},
    {Name = "Chỗ Mua Xe", Position = Vector3.new(771.1827, 18.7002, -480.8843)},
    {Name = "Đồn Công An", Position = Vector3.new(583.4995, 18.7001, -695.2412)},
    {Name = "Trụ Sở Công An", Position = Vector3.new(759.4039, 18.7001, -840.0175)},
    {Name = "Công Viên", Position = Vector3.new(-59.2103, 29.6434, -815.5474)},
    {Name = "Tháp Trầm Hương", Position = Vector3.new(69.9936, 19.4572, -127.9629)},
    {Name = "Khu Boss", Position = Vector3.new(-2578, 278, -1519)},
    {Name = "Đà Lạt", Position = Vector3.new(-17052, 457, -1404)},
}

for _, location in ipairs(TeleportLocations) do
    renx.Teleport:AddButton({
        Title = location.Name,
        Description = string.format("X: %.1f, Y: %.1f, Z: %.1f", location.Position.X, location.Position.Y, location.Position.Z),
        Callback = function()
            if HumanoidRootPart then
                HumanoidRootPart.CFrame = CFrame.new(location.Position)
                Fluent:Notify({
                    Title = "✅ Teleport",
                    Content = "Đã dịch chuyển đến " .. location.Name,
                    Duration = 3,
                })
            end
        end,
    })
end

-- ========== PLAYER2 FEATURES ==========
local SelectedPlayerName = nil
local PlayerESPEnabled = false
local TeleportToPlayerEnabled = false

local playerList = {}
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        table.insert(playerList, player.Name)
    end
end

local playerDropdown = renx.Player2:AddDropdown("PlayerList", {
    Title = "Chọn người chơi",
    Values = playerList,
    Multi = false,
    Callback = function(value)
        SelectedPlayerName = value
    end,
})

Players.PlayerAdded:Connect(function(player)
    table.insert(playerList, player.Name)
    playerDropdown:SetValues(playerList)
end)

Players.PlayerRemoving:Connect(function(player)
    for i, name in ipairs(playerList) do
        if name == player.Name then
            table.remove(playerList, i)
            break
        end
    end
    playerDropdown:SetValues(playerList)
end)

renx.Player2:AddButton({
    Title = "Teleport đến",
    Description = "Dịch chuyển đến người chơi",
    Callback = function()
        if not SelectedPlayerName then
            Fluent:Notify({
                Title = "❌ Lỗi",
                Content = "Chưa chọn người chơi!",
                Duration = 3,
            })
            return
        end
        
        local targetPlayer = Players:FindFirstChild(SelectedPlayerName)
        if targetPlayer and targetPlayer.Character then
            local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                HumanoidRootPart.CFrame = targetRoot.CFrame
                Fluent:Notify({
                    Title = "✅ Thành công",
                    Content = "Đã teleport đến " .. SelectedPlayerName,
                    Duration = 3,
                })
            end
        end
    end,
})

renx.Player2:AddToggle("PlayerESP", {
    Title = "ESP Người chơi",
    Description = "Hiển thị box xung quanh người chơi",
    Default = false,
    Callback = function(value)
        PlayerESPEnabled = value
        if not value then
            for _, highlight in pairs(CoreGui:GetChildren()) do
                if highlight.Name == "PlayerESP" then
                    highlight:Destroy()
                end
            end
        end
    end,
})

local espHighlights = {}
RunService.RenderStepped:Connect(function()
    if PlayerESPEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                if not espHighlights[player] then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "PlayerESP"
                    highlight.FillTransparency = 0.8
                    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineTransparency = 0
                    highlight.Parent = CoreGui
                    espHighlights[player] = highlight
                end
                espHighlights[player].Adornee = player.Character
            elseif espHighlights[player] then
                espHighlights[player]:Destroy()
                espHighlights[player] = nil
            end
        end
    end
end)

-- ========== ROLES FEATURES ==========
local CustomRoleText = ""
local RoleColorValue = Color3.fromRGB(255, 255, 255)
local RainbowRoleEnabled = false
local RoleGradientEnabled = false
local GradientColor1 = Color3.fromRGB(255, 0, 0)
local GradientColor2 = Color3.fromRGB(0, 0, 255)

renx.Roles:AddInput("CustomRole", {
    Title = "Role tùy chỉnh",
    Default = "",
    Placeholder = "Nhập role...",
    Callback = function(value)
        CustomRoleText = value
        if Character and Character:FindFirstChild("NameTag") then
            local nameTag = Character.NameTag.Main
            if nameTag:FindFirstChild("Rank") then
                nameTag.Rank.Text = value
            end
        end
    end,
})

renx.Roles:AddColorpicker("RoleColor", {
    Title = "Màu Role",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(color)
        RoleColorValue = color
        if Character and Character:FindFirstChild("NameTag") then
            local nameTag = Character.NameTag.Main
            if nameTag:FindFirstChild("Rank") then
                nameTag.Rank.TextColor3 = color
            end
        end
    end,
})

renx.Roles:AddToggle("RainbowRole", {
    Title = "Rainbow Role",
    Description = "Màu sắc thay đổi liên tục",
    Default = false,
    Callback = function(value)
        RainbowRoleEnabled = value
        if value then
            task.spawn(function()
                local hue = 0
                while RainbowRoleEnabled do
                    hue = (hue + 0.01) % 1
                    local rainbowColor = Color3.fromHSV(hue, 1, 1)
                    
                    if Character and Character:FindFirstChild("NameTag") then
                        local nameTag = Character.NameTag.Main
                        if nameTag:FindFirstChild("Rank") then
                            nameTag.Rank.TextColor3 = rainbowColor
                        end
                    end
                    
                    task.wait(0.05)
                end
            end)
        end
    end,
})

renx.Roles:AddToggle("RoleGradient", {
    Title = "Gradient Role",
    Description = "Màu chuyển sắc",
    Default = false,
    Callback = function(value)
        RoleGradientEnabled = value
        if value then
            task.spawn(function()
                local time = 0
                while RoleGradientEnabled do
                    time = time + 0.01
                    local t = (math.sin(time) + 1) / 2
                    
                    local r = GradientColor1.R + (GradientColor2.R - GradientColor1.R) * t
                    local g = GradientColor1.G + (GradientColor2.G - GradientColor1.G) * t
                    local b = GradientColor1.B + (GradientColor2.B - GradientColor1.B) * t
                    
                    local gradientColor = Color3.new(r, g, b)
                    
                    if Character and Character:FindFirstChild("NameTag") then
                        local nameTag = Character.NameTag.Main
                        if nameTag:FindFirstChild("Rank") then
                            nameTag.Rank.TextColor3 = gradientColor
                        end
                    end
                    
                    task.wait(0.05)
                end
            end)
        end
    end,
})

renx.Roles:AddColorpicker("GradientColor1", {
    Title = "Màu Gradient 1",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        GradientColor1 = color
    end,
})

renx.Roles:AddColorpicker("GradientColor2", {
    Title = "Màu Gradient 2",
    Default = Color3.fromRGB(0, 0, 255),
    Callback = function(color)
        GradientColor2 = color
    end,
})

-- ========== TRANG PHỤC FEATURES ==========
local AssetIDs = {
    {Name = "Chân Cụt Trái", ID = "139607718"},
    {Name = "Chân Cụt Phải", ID = "139607673"},
    {Name = "Sừng Korblox", ID = "17592708698"},
    {Name = "Vương Miệng Korblox", ID = "73810783541103"},
    {Name = "Đầu Lâu Korblox", ID = "136803300"},
    {Name = "Thân Mini 1", ID = "86276167122427"},
    {Name = "Chân Trái Mini 1", ID = "120785401936070"},
    {Name = "Chân Phải Mini 1", ID = "103061743974631"},
    {Name = "Tay Phải Mini 1", ID = "91595991056038"},
    {Name = "Tay Trái Mini 1", ID = "83057025799838"},
    {Name = "Thân Mini 2", ID = "112722466960512"},
    {Name = "Tay Trái Mini 2", ID = "82598238110471"},
    {Name = "Tay Phải Mini 2", ID = "76079756909323"},
    {Name = "Chân Trái Mini 2", ID = "103380121023771"},
    {Name = "Chân Phải Mini 2", ID = "107431241133468"},
    {Name = "Thân Mini 3", ID = "86122752579187"},
    {Name = "Tay Trái Mini 3", ID = "91583420445531"},
    {Name = "Tay Phải Mini 3", ID = "85720657972091"},
    {Name = "Chân Trái Mini 3", ID = "118745550941304"},
    {Name = "Chân Phải Mini 3", ID = "124168624661431"},
    {Name = "Thân Người Thon", ID = "92757812011061"},
    {Name = "Tay Trái Người Thon", ID = "115905570886697"},
    {Name = "Tay Phải Người Thon", ID = "99519402284266"},
    {Name = "Chân Trái Người Thon", ID = "124343282827669"},
    {Name = "Chân Phải Người Thon", ID = "84418052877367"},
}

renx.TP:AddParagraph({
    Title = "📦 Asset IDs",
    Content = "Nhấn vào tên để copy ID trang phục",
})

for _, asset in ipairs(AssetIDs) do
    renx.TP:AddButton({
        Title = asset.Name,
        Description = "ID: " .. asset.ID,
        Callback = function()
            setclipboard(asset.ID)
            Fluent:Notify({
                Title = "✅ Đã copy",
                Content = "Đã copy ID: " .. asset.ID,
                Duration = 3,
            })
        end,
    })
end

-- ========== EMOTES SYSTEM LOAD ==========
EmoteSystem()

-- ========== TOGGLE UI BUTTON ==========
local ToggleGUI = Instance.new("ScreenGui")
ToggleGUI.Name = "RENX_ToggleGUI"
ToggleGUI.Parent = CoreGui
ToggleGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ToggleGUI
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleButton.Position = UDim2.new(0.12, 0, 0.095, 0)
ToggleButton.Size = UDim2.new(0, 51, 0, 51)
ToggleButton.Image = "rbxassetid://126512304687614"
ToggleButton.Visible = true
ToggleButton.Draggable = true

local Corner = Instance.new("UICorner", ToggleButton)
local Stroke = Instance.new("UIStroke", ToggleButton)
Stroke.Thickness = 3
Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local strokeHue = 0
RunService.Heartbeat:Connect(function(dt)
    strokeHue = (strokeHue + dt * 0.25) % 1
    Stroke.Color = Color3.fromHSV(strokeHue, 1, 1)
end)

ToggleButton.MouseButton1Click:Connect(function()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.J, false, game)
    task.wait(0.05)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.J, false, game)
end)

-- ========== SAVE MANAGER ==========
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/newbie0z-lol/Interface-Manager/refs/heads/main/interface.txt"))()

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
InterfaceManager:BuildInterfaceSection(renx.Settings)
SaveManager:BuildConfigSection(renx.Settings)
SaveManager:LoadAutoloadConfig()

-- ========== FINAL NOTIFICATION ==========
task.wait(1)
Fluent:Notify({
    Title = "✅ RENX HUB",
    Content = "Đã tải thành công! Nhấn J để ẩn/hiện",
    SubContent = "Discord: https://discord.gg/NAyGX2Q7d6",
    Duration = 5,
})

print("RENX HUB đã được kích hoạt thành công!")