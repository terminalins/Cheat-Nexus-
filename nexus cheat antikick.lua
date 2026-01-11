--[[
    NEXUS HUB - Ultra Stealth Edition
    V4.5 - HARDENED & BYPASS OPTIMIZED
    Optimiert gegen Kicks und serverseitige Detektion
]]

local Nexus = {}

-- Dienste laden
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- Schutz vor mehrfacher Ausführung
if _G.NexusLoaded then
    return
end
_G.NexusLoaded = true

-- Verschleierter Container für ESP (Keine festen Namen)
local VisualsContainer = Instance.new("Folder")
VisualsContainer.Name = ""
for i = 1, math.random(10, 20) do
    VisualsContainer.Name = VisualsContainer.Name .. string.char(math.random(97, 122))
end
VisualsContainer.Parent = CoreGui

-- Funktion für weiche Animationen
local function Tween(obj, info, goal)
    local t = TweenService:Create(obj, TweenInfo.new(unpack(info)), goal)
    t:Play()
    return t
end

-- ERWEITERTE SETTINGS FÜR STEALTH
local Settings = {
    WalkSpeed = 16,
    InfJump = false,
    Xray = false,
    SkeletonESP = false,
    Fullbright = false,
    Fly = false,
    FlySpeed = 50,
    WorldDestroyer = false,
    Aimbot = false,
    AutoShoot = false,
    AimbotFOV = 150,
    AimbotSmoothing = 5,
    AimbotWallCheck = true,
    AimbotTeamCheck = true,
    ShowFOV = false,
    Noclip = false,
    WallhackNames = false,
    StealthSpeed = true,
    HumanizedSmoothing = true
}

-- X-RAY FUNKTION (FIXED)
local function SetXray(state)
    task.spawn(function()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj:IsDescendantOf(LocalPlayer.Character) and not obj:IsA("Terrain") then
                if state then
                    if not obj:GetAttribute("OriginalTransparency") then
                        obj:SetAttribute("OriginalTransparency", obj.Transparency)
                    end
                    obj.Transparency = 0.5
                else
                    local original = obj:GetAttribute("OriginalTransparency")
                    if original then
                        obj.Transparency = original
                        obj:SetAttribute("OriginalTransparency", nil)
                    end
                end
            end
            -- Kleiner Delay um Kicks wegen massiver Eigenschafts-Änderungen zu vermeiden
            if _ % 500 == 0 then task.wait() end
        end
    end)
end

function Nexus:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Engine_Storage_" .. math.random(1000, 9999)
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    -- --- FOV KREIS ---
    local FOVCircle = Instance.new("Frame")
    FOVCircle.Name = "Render_Proxy"
    FOVCircle.Parent = ScreenGui
    FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
    FOVCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
    FOVCircle.BackgroundColor3 = Color3.fromRGB(59, 130, 246)
    FOVCircle.BackgroundTransparency = 0.98
    FOVCircle.BorderSizePixel = 0
    FOVCircle.Visible = false
    
    local FOVStroke = Instance.new("UIStroke")
    FOVStroke.Color = Color3.fromRGB(59, 130, 246)
    FOVStroke.Thickness = 1.2
    FOVStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    FOVStroke.Parent = FOVCircle

    local FOVCorner = Instance.new("UICorner")
    FOVCorner.CornerRadius = UDim.new(1, 0)
    FOVCorner.Parent = FOVCircle

    -- --- START-ANIMATION ---
    local IntroFrame = Instance.new("Frame")
    IntroFrame.Name = "Loader"
    IntroFrame.Parent = ScreenGui
    IntroFrame.BackgroundTransparency = 1 
    IntroFrame.BorderSizePixel = 0
    IntroFrame.Size = UDim2.new(1, 0, 1, 0)
    IntroFrame.ZIndex = 100

    local IntroLogo = Instance.new("TextLabel")
    IntroLogo.Parent = IntroFrame
    IntroLogo.AnchorPoint = Vector2.new(0.5, 0.5)
    IntroLogo.Position = UDim2.new(0.5, 0, 0.5, 0)
    IntroLogo.Size = UDim2.new(0, 0, 0, 0)
    IntroLogo.BackgroundTransparency = 1
    IntroLogo.Text = "NEXUS"
    IntroLogo.TextColor3 = Color3.fromRGB(255, 255, 255)
    IntroLogo.Font = Enum.Font.GothamBlack
    IntroLogo.TextSize = 80
    IntroLogo.TextTransparency = 1
    IntroLogo.TextScaled = true

    local LogoGradient = Instance.new("UIGradient")
    LogoGradient.Color = ColorSequence.new(Color3.fromRGB(59, 130, 246), Color3.fromRGB(139, 92, 246))
    LogoGradient.Parent = IntroLogo

    -- Main Frame
    local Main = Instance.new("CanvasGroup")
    Main.Name = "Root_Node"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, -250, 0.5, -175)
    Main.Size = UDim2.new(0, 500, 0, 350)
    Main.ClipsDescendants = true
    Main.GroupTransparency = 1
    Main.Visible = false

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 14)
    UICorner.Parent = Main

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(45, 45, 50)
    UIStroke.Thickness = 1.2
    UIStroke.Parent = Main

    -- Minimieren Button
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Name = "Control_Switch"
    MinimizeBtn.Parent = Main
    MinimizeBtn.AnchorPoint = Vector2.new(1, 0)
    MinimizeBtn.Position = UDim2.new(1, -12, 0, 12)
    MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeBtn.BackgroundTransparency = 0.95
    MinimizeBtn.Text = "—"
    MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.TextSize = 14
    MinimizeBtn.ZIndex = 50
    MinimizeBtn.AutoButtonColor = false

    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 8)
    MinCorner.Parent = MinimizeBtn

    MinimizeBtn.MouseEnter:Connect(function()
        Tween(MinimizeBtn, {0.2}, {BackgroundTransparency = 0.85, TextColor3 = Color3.fromRGB(255, 255, 255)})
    end)
    MinimizeBtn.MouseLeave:Connect(function()
        Tween(MinimizeBtn, {0.2}, {BackgroundTransparency = 0.95, TextColor3 = Color3.fromRGB(200, 200, 200)})
    end)

    local isMinimized = false
    local originalSize = UDim2.new(0, 500, 0, 350)
    local minimizedSize = UDim2.new(0, 500, 0, 50)

    -- Intro Animation
    task.spawn(function()
        task.wait(0.3)
        Tween(IntroLogo, {0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out}, {TextTransparency = 0, Size = UDim2.new(0, 320, 0, 110)})
        task.wait(1.2)
        Tween(IntroLogo, {0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.In}, {TextTransparency = 1, Size = UDim2.new(0, 40, 0, 15)})
        task.wait(0.6)
        IntroFrame:Destroy()
        Main.Visible = true
        Tween(Main, {0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {GroupTransparency = 0})
    end)

    -- Sidebar & Content
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Nav"
    Sidebar.Parent = Main
    Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    Sidebar.BorderSizePixel = 0
    Sidebar.Size = UDim2.new(0, 150, 1, 0)

    local SideCorner = Instance.new("UICorner")
    SideCorner.CornerRadius = UDim.new(0, 14)
    SideCorner.Parent = Sidebar

    local Content = Instance.new("Frame")
    Content.Name = "Body"
    Content.Parent = Main
    Content.Position = UDim2.new(0, 160, 0, 20)
    Content.Size = UDim2.new(1, -180, 1, -40)
    Content.BackgroundTransparency = 1

    -- Minimize Logic
    MinimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            Content.Visible = false
            Tween(Sidebar, {0.3}, {BackgroundTransparency = 1})
            Tween(Main, {0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {Size = minimizedSize})
            task.delay(0.2, function() Sidebar.Visible = false end)
            MinimizeBtn.Text = "▢"
        else
            Sidebar.Visible = true
            Tween(Main, {0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out}, {Size = originalSize})
            Tween(Sidebar, {0.3}, {BackgroundTransparency = 0})
            task.delay(0.4, function() if not isMinimized then Content.Visible = true end end)
            MinimizeBtn.Text = "—"
        end
    end)

    -- Dragging
    local dragging, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Logo
    local LogoContainer = Instance.new("Frame")
    LogoContainer.Parent = Sidebar
    LogoContainer.BackgroundTransparency = 1
    LogoContainer.Size = UDim2.new(1, 0, 0, 60)

    local LogoText = Instance.new("TextLabel")
    LogoText.Parent = LogoContainer
    LogoText.Text = "NEXUS"
    LogoText.TextColor3 = Color3.fromRGB(255, 255, 255)
    LogoText.Font = Enum.Font.GothamBold
    LogoText.TextSize = 18
    LogoText.TextXAlignment = Enum.TextXAlignment.Left
    LogoText.Position = UDim2.new(0, 20, 0.5, -10)
    LogoText.BackgroundTransparency = 1

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Parent = Sidebar
    TabContainer.Position = UDim2.new(0, 0, 0, 70)
    TabContainer.Size = UDim2.new(1, 0, 1, -80)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0

    local TabList = Instance.new("UIListLayout")
    TabList.Parent = TabContainer
    TabList.Padding = UDim.new(0, 6)
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local Tabs = {}
    local FirstPage, FirstTabBtn = nil, nil

    function Tabs:CreateTab(name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = TabContainer
        TabBtn.Size = UDim2.new(0.85, 0, 0, 38)
        TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(140, 140, 145)
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 13
        TabBtn.AutoButtonColor = false

        local TBtnCorner = Instance.new("UICorner")
        TBtnCorner.CornerRadius = UDim.new(0, 8)
        TBtnCorner.Parent = TabBtn

        local Page = Instance.new("ScrollingFrame")
        Page.Parent = Content
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Color3.fromRGB(59, 130, 246)

        local PageList = Instance.new("UIListLayout")
        PageList.Parent = Page
        PageList.Padding = UDim.new(0, 10)

        if not FirstPage then FirstPage = Page FirstTabBtn = TabBtn end

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Content:GetChildren()) do v.Visible = false end
            for _, v in pairs(TabContainer:GetChildren()) do 
                if v:IsA("TextButton") then Tween(v, {0.2}, {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(140, 140, 145)}) end 
            end
            Page.Visible = true
            Tween(TabBtn, {0.2}, {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255, 255, 255)})
        end)

        local Elements = {}
        function Elements:CreateLabel(text)
            local Label = Instance.new("TextLabel")
            Label.Parent = Page
            Label.Size = UDim2.new(1, -10, 0, 25)
            Label.BackgroundTransparency = 1
            Label.Text = text:upper()
            Label.TextColor3 = Color3.fromRGB(90, 90, 100)
            Label.Font = Enum.Font.GothamBold
            Label.TextSize = 10
            Label.TextXAlignment = Enum.TextXAlignment.Left
        end
        function Elements:CreateButton(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Parent = Page
            Btn.Size = UDim2.new(1, -10, 0, 42)
            Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            Btn.Text = "  " .. text
            Btn.TextColor3 = Color3.fromRGB(220, 220, 225)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 13
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            local BCorner = Instance.new("UICorner")
            BCorner.CornerRadius = UDim.new(0, 10)
            BCorner.Parent = Btn
            Btn.MouseButton1Click:Connect(function()
                local originalColor = Btn.BackgroundColor3
                Tween(Btn, {0.1}, {BackgroundColor3 = Color3.fromRGB(59, 130, 246)})
                task.wait(0.1)
                Tween(Btn, {0.1}, {BackgroundColor3 = originalColor})
                callback()
            end)
        end
        function Elements:CreateToggle(text, callback)
            local TglFrame = Instance.new("Frame")
            TglFrame.Parent = Page
            TglFrame.Size = UDim2.new(1, -10, 0, 42)
            TglFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            local TCorner = Instance.new("UICorner")
            TCorner.CornerRadius = UDim.new(0, 10)
            TCorner.Parent = TglFrame
            local TglLabel = Instance.new("TextLabel")
            TglLabel.Parent = TglFrame
            TglLabel.Text = "  " .. text
            TglLabel.Size = UDim2.new(1, 0, 1, 0)
            TglLabel.BackgroundTransparency = 1
            TglLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
            TglLabel.Font = Enum.Font.Gotham
            TglLabel.TextSize = 13
            TglLabel.TextXAlignment = Enum.TextXAlignment.Left
            local Box = Instance.new("TextButton")
            Box.Parent = TglFrame
            Box.Position = UDim2.new(1, -45, 0.5, -11)
            Box.Size = UDim2.new(0, 36, 0, 22)
            Box.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            Box.Text = ""
            local BoxCorner = Instance.new("UICorner")
            BoxCorner.CornerRadius = UDim.new(1, 0)
            BoxCorner.Parent = Box
            local Dot = Instance.new("Frame")
            Dot.Parent = Box
            Dot.Position = UDim2.new(0, 3, 0.5, -8)
            Dot.Size = UDim2.new(0, 16, 0, 16)
            Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            local DotCorner = Instance.new("UICorner")
            DotCorner.CornerRadius = UDim.new(1, 0)
            DotCorner.Parent = Dot
            local enabled = false
            Box.MouseButton1Click:Connect(function()
                enabled = not enabled
                if enabled then Tween(Box, {0.2}, {BackgroundColor3 = Color3.fromRGB(59, 130, 246)}) Tween(Dot, {0.2}, {Position = UDim2.new(1, -19, 0.5, -8)}) else Tween(Box, {0.2}, {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}) Tween(Dot, {0.2}, {Position = UDim2.new(0, 3, 0.5, -8)}) end
                callback(enabled)
            end)
        end
        function Elements:CreateSlider(text, min, max, default, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Parent = Page
            SliderFrame.Size = UDim2.new(1, -10, 0, 52)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            local SCorner = Instance.new("UICorner")
            SCorner.CornerRadius = UDim.new(0, 10)
            SCorner.Parent = SliderFrame
            local SLabel = Instance.new("TextLabel")
            SLabel.Parent = SliderFrame
            SLabel.Text = "  " .. text
            SLabel.Size = UDim2.new(1, 0, 0, 30)
            SLabel.BackgroundTransparency = 1
            SLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
            SLabel.Font = Enum.Font.Gotham
            SLabel.TextSize = 13
            SLabel.TextXAlignment = Enum.TextXAlignment.Left
            local ValLabel = Instance.new("TextLabel")
            ValLabel.Parent = SliderFrame
            ValLabel.Text = tostring(default) .. " "
            ValLabel.Size = UDim2.new(1, -12, 0, 30)
            ValLabel.BackgroundTransparency = 1
            ValLabel.TextColor3 = Color3.fromRGB(59, 130, 246)
            ValLabel.Font = Enum.Font.GothamBold
            ValLabel.TextSize = 13
            ValLabel.TextXAlignment = Enum.TextXAlignment.Right
            local Container = Instance.new("Frame")
            Container.Parent = SliderFrame
            Container.Position = UDim2.new(0, 12, 0, 36)
            Container.Size = UDim2.new(1, -24, 0, 5)
            Container.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            local CCorner = Instance.new("UICorner")
            CCorner.CornerRadius = UDim.new(1, 0)
            CCorner.Parent = Container
            local Fill = Instance.new("Frame")
            Fill.Parent = Container
            Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(59, 130, 246)
            local FCorner = Instance.new("UICorner")
            FCorner.CornerRadius = UDim.new(1, 0)
            FCorner.Parent = Fill
            local sliding = false
            local function move(input)
                local pos = math.clamp((input.Position.X - Container.AbsolutePosition.X) / Container.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max - min) * pos)
                ValLabel.Text = tostring(val) .. " "
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                callback(val)
            end
            Container.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true move(input) end end)
            UserInputService.InputChanged:Connect(function(input) if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then move(input) end end)
            UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end end)
        end
        return Elements
    end

    task.delay(3.0, function() if FirstPage and FirstTabBtn then FirstPage.Visible = true Tween(FirstTabBtn, {0.2}, {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255, 255, 255)}) end end)
    
    RunService.RenderStepped:Connect(function()
        if ScreenGui.Parent then
            FOVCircle.Size = UDim2.new(0, Settings.AimbotFOV * 2, 0, Settings.AimbotFOV * 2)
        end
    end)

    return Tabs, FOVCircle
end

-- VISIBILITY CHECK (RAYCAST BYPASS)
local function IsVisible(targetPart)
    if not Settings.AimbotWallCheck then return true end
    local char = LocalPlayer.Character
    if not char then return false end
    
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin)
    
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {char, VisualsContainer}
    params.FilterType = Enum.RaycastFilterType.Blacklist
    
    local result = workspace:Raycast(origin, direction, params)
    
    if result then
        return result.Instance:IsDescendantOf(targetPart.Parent)
    end
    return true
end

-- CLOSEST PLAYER FINDER
local function GetClosestPlayer()
    local target = nil
    local shortestDist = Settings.AimbotFOV

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            if Settings.AimbotTeamCheck and p.Team ~= nil and p.Team == LocalPlayer.Team then continue end
            
            local pos, onScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
            if onScreen and IsVisible(p.Character.Head) then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    target = p
                end
            end
        end
    end
    return target
end

-- --- NOCLIP ---
RunService.Stepped:Connect(function()
    if Settings.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- --- MAIN LOOP ---
local lastShootTime = 0
RunService.RenderStepped:Connect(function()
    local target = nil
    if Settings.Aimbot or Settings.AutoShoot then
        target = GetClosestPlayer()
    end

    -- HUMANISED AIMBOT LOCK
    if Settings.Aimbot and target and target.Character and target.Character:FindFirstChild("Head") then
        local targetPos = target.Character.Head.Position
        local baseSmoothing = Settings.AimbotSmoothing
        if Settings.HumanizedSmoothing then
            baseSmoothing = baseSmoothing + (math.random(-10, 10) / 10)
        end
        local lerpFactor = math.clamp(1 / math.max(baseSmoothing, 1), 0.01, 1)
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPos), lerpFactor)
    end

    -- STEALTH AUTO-SHOOT
    if Settings.AutoShoot and target then
        local now = tick()
        if now - lastShootTime > (0.1 + (math.random(0, 10) / 100)) then
            lastShootTime = now
            task.spawn(function()
                if typeof(mouse1press) == "function" then
                    mouse1press()
                    task.wait(math.random(20, 50) / 1000)
                    mouse1release()
                else
                    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                end
            end)
        end
    end

    -- ADVANCED STEALTH SPEED
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")

    if char and hum and root and hum.Health > 0 and not Settings.Fly then
        if Settings.WalkSpeed > 16 then
            if Settings.StealthSpeed then
                if hum.MoveDirection.Magnitude > 0 then
                    local jitter = 1 + (math.random(-5, 5) / 1000)
                    root.CFrame = root.CFrame + (hum.MoveDirection * (Settings.WalkSpeed / 100) * jitter)
                end
                hum.WalkSpeed = 16
            else
                hum.WalkSpeed = Settings.WalkSpeed
            end
        else
            hum.WalkSpeed = 16
        end
    end

    if Settings.Fullbright then Lighting.Brightness = 2 Lighting.ClockTime = 14 Lighting.FogEnd = 1e6 Lighting.GlobalShadows = false end
end)

-- Jump Logic
UserInputService.JumpRequest:Connect(function()
    if Settings.InfJump then
        pcall(function()
            local character = LocalPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if humanoid and humanoid.Health > 0 and root then
                root.Velocity = Vector3.new(root.Velocity.X, humanoid.JumpPower, root.Velocity.Z)
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end)

-- Fly Logic
RunService.Heartbeat:Connect(function(dt)
    if Settings.Fly then
        local character = LocalPlayer.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if root and humanoid and humanoid.Health > 0 then
            humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            local moveDir = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0,1,0) end
            root.Velocity = moveDir.Magnitude > 0 and moveDir.Unit * Settings.FlySpeed or Vector3.new(0, 0, 0)
        end
    end
end)

-- World Destroyer
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and Settings.WorldDestroyer then
        local target = Mouse.Target
        if target and target:IsA("BasePart") and not target:IsDescendantOf(LocalPlayer.Character) then
            pcall(function()
                if not target.Anchored then
                    target.Velocity = Vector3.new(math.random(-500,500), -1000, math.random(-500,500))
                end
                target:Destroy()
            end)
        end
    end
end)

-- ESP System (Silent Errors & Team Check)
RunService.Heartbeat:Connect(function()
    if not Settings.SkeletonESP and not Settings.WallhackNames then return end
    
    pcall(function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local c = p.Character
                if c and c:FindFirstChild("HumanoidRootPart") then
                    -- TEAM CHECK FÜR ESP
                    if Settings.AimbotTeamCheck and p.Team == LocalPlayer.Team then
                        local h = VisualsContainer:FindFirstChild(p.UserId.."_E") if h then h:Destroy() end
                        local b = VisualsContainer:FindFirstChild(p.UserId.."_N") if b then b:Destroy() end
                        continue 
                    end

                    if Settings.SkeletonESP then
                        local h = VisualsContainer:FindFirstChild(p.UserId.."_E") or Instance.new("Highlight")
                        h.Name = p.UserId.."_E" h.FillTransparency = 1 h.OutlineColor = Color3.fromRGB(59, 130, 246) h.Parent = VisualsContainer h.Adornee = c
                    end

                    if Settings.WallhackNames then
                        local b = VisualsContainer:FindFirstChild(p.UserId.."_N") or Instance.new("BillboardGui")
                        b.Name = p.UserId.."_N" b.Adornee = c:FindFirstChild("Head") b.Size = UDim2.new(0, 100, 0, 50) b.AlwaysOnTop = true b.Parent = VisualsContainer b.StudsOffset = Vector3.new(0, 3, 0)
                        local l = b:FindFirstChild("L") or Instance.new("TextLabel")
                        l.Name = "L" l.Size = UDim2.new(1, 0, 1, 0) l.BackgroundTransparency = 1 l.Text = p.DisplayName l.TextColor3 = Color3.fromRGB(255, 255, 255) l.Font = Enum.Font.GothamBold l.TextSize = 10 l.Parent = b
                    end
                else
                    -- Cleanup falls Charakter weg ist
                    local h = VisualsContainer:FindFirstChild(p.UserId.."_E") if h then h:Destroy() end
                    local b = VisualsContainer:FindFirstChild(p.UserId.."_N") if b then b:Destroy() end
                end
            end
        end
    end)
end)

-- UI INITIALISIERUNG
local Window, FOVGui = Nexus:CreateWindow("NEXUS STEALTH")
local MainTab = Window:CreateTab("Main")
local CombatTab = Window:CreateTab("Combat")
local VisualsTab = Window:CreateTab("Visuals")
local MiscTab = Window:CreateTab("Misc")

MainTab:CreateLabel("Movement (Safe Settings)")
MainTab:CreateSlider("WalkSpeed", 16, 100, 16, function(val) Settings.WalkSpeed = val end)
MainTab:CreateToggle("Stealth Mode (Anti-Pattern)", function(state) Settings.StealthSpeed = state end)
MainTab:CreateToggle("Infinite Jump", function(state) Settings.InfJump = state end)
MainTab:CreateToggle("Noclip (Safe Mode)", function(state) Settings.Noclip = state end)
MainTab:CreateToggle("Fly Hack", function(state) Settings.Fly = state end)

CombatTab:CreateLabel("Combat (Humanized)")
CombatTab:CreateToggle("Aimbot Aktiviert", function(state) Settings.Aimbot = state end)
CombatTab:CreateToggle("Auto Shoot (Human Click)", function(state) Settings.AutoShoot = state end)
CombatTab:CreateToggle("Team Check (Global)", function(state) Settings.AimbotTeamCheck = state end)
CombatTab:CreateToggle("Humanized Smoothing", function(state) Settings.HumanizedSmoothing = state end)
CombatTab:CreateSlider("Glättung (Smoothing)", 3, 25, 5, function(val) Settings.AimbotSmoothing = val end)
CombatTab:CreateSlider("Aimbot Radius (FOV)", 10, 500, 150, function(val) Settings.AimbotFOV = val end)
CombatTab:CreateToggle("FOV anzeigen", function(state) Settings.ShowFOV = state FOVGui.Visible = state end)

VisualsTab:CreateLabel("Intelligence")
VisualsTab:CreateToggle("Wallhack (Names)", function(state) Settings.WallhackNames = state end)
VisualsTab:CreateToggle("X-Ray (Welt)", function(state) Settings.Xray = state SetXray(state) end)
VisualsTab:CreateToggle("Highlights", function(state) Settings.SkeletonESP = state end)
VisualsTab:CreateToggle("Fullbright", function(state) Settings.Fullbright = state end)

MiscTab:CreateLabel("Experimental")
MiscTab:CreateToggle("World Destroyer (Riskant)", function(state) Settings.WorldDestroyer = state end)

print("Nexus Hub V4.5 (Stealth & Xray Fix) geladen!")