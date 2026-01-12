--[[
    NEXUS HUB - Ultra Stealth Edition (Transparent UI)
    Version: 4.5.5 - TRANSPARENT DESIGN
    
    LISTE DER FUNKTIONEN:
    - Walkspeed (Slider)
    - Infinite Jump
    - Fly Hack (Slider Speed)
    - Aimbot (Wallcheck, Smoothing, Humanizing)
    - AutoShoot (Fixed & Aggressive)
    - TeamCheck
    - FOV (Radius Slider & Anzeige)
    - Wallhack Names & Player ESP (Blue Highlight)
    - Fullbright & Xray
    - World Destroyer
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
    local old = CoreGui:FindFirstChild("Engine_Storage_Nexus")
    if old then old:Destroy() end
end
_G.NexusLoaded = true

-- Verschleierter Container für ESP
local VisualsContainer = Instance.new("Folder")
VisualsContainer.Name = "Nexus_Internal_Storage"
VisualsContainer.Parent = CoreGui

-- Hilfsfunktion für weiche Animationen
local function Tween(obj, info, goal)
    local t = TweenService:Create(obj, TweenInfo.new(unpack(info)), goal)
    t:Play()
    return t
end

-- SETTINGS
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
    HumanizedSmoothing = true,
    TargetPart = "Head"
}

-- --- FIRE ENGINE (AUTOSHOOT FIX) ---
local function FireWeapon()
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool then
        if typeof(mouse1click) == "function" then
            mouse1click()
        elseif typeof(mouse1press) == "function" then
            mouse1press()
            task.wait(0.02)
            mouse1release()
        else
            tool:Activate()
        end
    end
end

-- --- VISIBILITY CHECK ---
local function IsVisible(targetPart)
    if not Settings.AimbotWallCheck then return true end
    local char = LocalPlayer.Character
    if not char then return false end
    
    local ray = Ray.new(Camera.CFrame.Position, (targetPart.Position - Camera.CFrame.Position).Unit * 1000)
    local hit = workspace:FindPartOnRayWithIgnoreList(ray, {char, VisualsContainer})
    
    if hit then
        return hit:IsDescendantOf(targetPart.Parent)
    end
    return true
end

-- --- TARGET FINDER ---
local function GetClosestPlayer()
    local target, shortestDist = nil, Settings.AimbotFOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(Settings.TargetPart) then
            if Settings.AimbotTeamCheck and p.Team == LocalPlayer.Team then continue end
            
            local part = p.Character[Settings.TargetPart]
            local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
            
            if onScreen and IsVisible(part) then
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

-- X-RAY FUNKTION
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
            if _ % 1000 == 0 then task.wait() end
        end
    end)
end

-- WORLD DESTROYER
Mouse.Button1Down:Connect(function()
    if Settings.WorldDestroyer and Mouse.Target then
        local target = Mouse.Target
        if target:IsA("BasePart") and not target:IsDescendantOf(LocalPlayer.Character) then
            pcall(function() target:Destroy() end)
        end
    end
end)

function Nexus:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Engine_Storage_Nexus"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    -- FOV KREIS
    local FOVCircle = Instance.new("Frame")
    FOVCircle.Name = "Render_Proxy"
    FOVCircle.Parent = ScreenGui
    FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
    FOVCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
    FOVCircle.BackgroundColor3 = Color3.fromRGB(59, 130, 246)
    FOVCircle.BackgroundTransparency = 1
    FOVCircle.BorderSizePixel = 0
    FOVCircle.Visible = false
    local FOVStroke = Instance.new("UIStroke", FOVCircle)
    FOVStroke.Color = Color3.fromRGB(59, 130, 246)
    FOVStroke.Thickness = 1.5
    Instance.new("UICorner", FOVCircle).CornerRadius = UDim.new(1, 0)

    -- INTRO FRAME
    local IntroFrame = Instance.new("Frame", ScreenGui)
    IntroFrame.Name = "Loader"
    IntroFrame.BackgroundTransparency = 1 
    IntroFrame.Size = UDim2.new(1, 0, 1, 0)
    IntroFrame.ZIndex = 100
    local IntroLogo = Instance.new("TextLabel", IntroFrame)
    IntroLogo.AnchorPoint = Vector2.new(0.5, 0.5)
    IntroLogo.Position = UDim2.new(0.5, 0, 0.5, 0)
    IntroLogo.BackgroundTransparency = 1
    IntroLogo.Text = "NEXUS"
    IntroLogo.TextColor3 = Color3.fromRGB(255, 255, 255)
    IntroLogo.Font = Enum.Font.GothamBlack
    IntroLogo.TextSize = 80
    IntroLogo.TextTransparency = 1
    IntroLogo.TextScaled = true
    Instance.new("UIGradient", IntroLogo).Color = ColorSequence.new(Color3.fromRGB(59, 130, 246), Color3.fromRGB(139, 92, 246))

    -- MAIN FRAME (SCHWARZ)
    local Main = Instance.new("CanvasGroup", ScreenGui)
    Main.Name = "Root_Node"
    Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Main.BackgroundTransparency = 0.3
    Main.Position = UDim2.new(0.5, -250, 0.5, -175)
    Main.Size = UDim2.new(0, 500, 0, 350)
    Main.ClipsDescendants = true
    Main.GroupTransparency = 1
    Main.Visible = false
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)
    local UIStroke = Instance.new("UIStroke", Main)
    UIStroke.Color = Color3.fromRGB(59, 130, 246)
    UIStroke.Thickness = 1.5
    UIStroke.Transparency = 0.5

    -- MINIMIZE BUTTON (TRANSPARENT)
    local MinimizeBtn = Instance.new("TextButton", Main)
    MinimizeBtn.Position = UDim2.new(1, -40, 0, 10)
    MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
    MinimizeBtn.BackgroundTransparency = 1
    MinimizeBtn.Text = "—"
    MinimizeBtn.TextColor3 = Color3.fromRGB(59, 130, 246)
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.TextSize = 16
    Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 8)
    local MinStroke = Instance.new("UIStroke", MinimizeBtn)
    MinStroke.Color = Color3.fromRGB(59, 130, 246)
    MinStroke.Thickness = 1.2
    MinStroke.Transparency = 0.6

    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Name = "Nav"
    Sidebar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Sidebar.BackgroundTransparency = 0.4
    Sidebar.Size = UDim2.new(0, 150, 1, 0)
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 14)

    local Content = Instance.new("Frame", Main)
    Content.Name = "Body"
    Content.Position = UDim2.new(0, 160, 0, 20)
    Content.Size = UDim2.new(1, -180, 1, -40)
    Content.BackgroundTransparency = 1

    local isMinimized = false
    MinimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            Tween(Main, {0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {Size = UDim2.new(0, 500, 0, 45)})
            Sidebar.Visible = false Content.Visible = false
            MinimizeBtn.Text = "▢"
        else
            local t = Tween(Main, {0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out}, {Size = UDim2.new(0, 500, 0, 350)})
            t.Completed:Connect(function() if not isMinimized then Sidebar.Visible = true Content.Visible = true end end)
            MinimizeBtn.Text = "—"
        end
    end)

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

    local LogoText = Instance.new("TextLabel", Sidebar)
    LogoText.Size = UDim2.new(1, 0, 0, 60)
    LogoText.Text = "NEXUS"
    LogoText.TextColor3 = Color3.fromRGB(59, 130, 246)
    LogoText.Font = Enum.Font.GothamBold
    LogoText.TextSize = 20
    LogoText.BackgroundTransparency = 1

    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Position = UDim2.new(0, 0, 0, 70)
    TabContainer.Size = UDim2.new(1, 0, 1, -80)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 6)

    local Tabs = {}
    local FirstPage = nil

    function Tabs:CreateTab(name, iconId)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(0.85, 0, 0, 38)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = ""
        TabBtn.AutoButtonColor = false
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)

        local Icon = Instance.new("ImageLabel", TabBtn)
        Icon.Size = UDim2.new(0, 18, 0, 18)
        Icon.Position = UDim2.new(0, 10, 0.5, -9)
        Icon.BackgroundTransparency = 1
        Icon.Image = "rbxassetid://" .. (iconId or "0")
        Icon.ImageColor3 = Color3.fromRGB(100, 100, 120)

        local Label = Instance.new("TextLabel", TabBtn)
        Label.Size = UDim2.new(1, -40, 1, 0)
        Label.Position = UDim2.new(0, 35, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = name
        Label.TextColor3 = Color3.fromRGB(140, 140, 160)
        Label.Font = Enum.Font.GothamSemibold
        Label.TextSize = 13
        Label.TextXAlignment = Enum.TextXAlignment.Left

        local Page = Instance.new("ScrollingFrame", Content)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 0
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)

        if not FirstPage then 
            FirstPage = Page 
            Page.Visible = true 
            Label.TextColor3 = Color3.fromRGB(59, 130, 246) 
            Icon.ImageColor3 = Color3.fromRGB(59, 130, 246)
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Content:GetChildren()) do v.Visible = false end
            for _, v in pairs(TabContainer:GetChildren()) do 
                if v:IsA("TextButton") then 
                    local l = v:FindFirstChildWhichIsA("TextLabel")
                    local i = v:FindFirstChildWhichIsA("ImageLabel")
                    if l then l.TextColor3 = Color3.fromRGB(140, 140, 160) end
                    if i then i.ImageColor3 = Color3.fromRGB(100, 100, 120) end
                end 
            end
            Page.Visible = true
            Label.TextColor3 = Color3.fromRGB(59, 130, 246)
            Icon.ImageColor3 = Color3.fromRGB(59, 130, 246)
        end)

        local Elements = {}
        function Elements:CreateLabel(text)
            local L = Instance.new("TextLabel", Page)
            L.Size = UDim2.new(1, -10, 0, 25)
            L.BackgroundTransparency = 1
            L.Text = text:upper()
            L.TextColor3 = Color3.fromRGB(90, 90, 110)
            L.Font = Enum.Font.GothamBold
            L.TextSize = 10
            L.TextXAlignment = Enum.TextXAlignment.Left
        end
        
        function Elements:CreateButton(text, callback)
            local Btn = Instance.new("TextButton", Page)
            Btn.Size = UDim2.new(1, -10, 0, 42)
            Btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            Btn.BackgroundTransparency = 0.5
            Btn.Text = "  " .. text
            Btn.TextColor3 = Color3.fromRGB(220, 220, 240)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 13
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 10)
            local BtnStroke = Instance.new("UIStroke", Btn)
            BtnStroke.Color = Color3.fromRGB(59, 130, 246)
            BtnStroke.Thickness = 1
            BtnStroke.Transparency = 0.7
            Btn.MouseButton1Click:Connect(callback)
        end
        
        function Elements:CreateToggle(text, callback)
            local TglFrame = Instance.new("Frame", Page)
            TglFrame.Size = UDim2.new(1, -10, 0, 42)
            TglFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            TglFrame.BackgroundTransparency = 0.5
            Instance.new("UICorner", TglFrame).CornerRadius = UDim.new(0, 10)
            local TglStroke = Instance.new("UIStroke", TglFrame)
            TglStroke.Color = Color3.fromRGB(59, 130, 246)
            TglStroke.Thickness = 1
            TglStroke.Transparency = 0.7
            
            local L = Instance.new("TextLabel", TglFrame)
            L.Text = "  " .. text
            L.Size = UDim2.new(1, 0, 1, 0)
            L.TextColor3 = Color3.fromRGB(200, 200, 220)
            L.BackgroundTransparency = 1
            L.Font = Enum.Font.Gotham
            L.TextSize = 13
            L.TextXAlignment = Enum.TextXAlignment.Left
            
            local Box = Instance.new("TextButton", TglFrame)
            Box.Position = UDim2.new(1, -45, 0.5, -11)
            Box.Size = UDim2.new(0, 36, 0, 22)
            Box.BackgroundTransparency = 1
            Box.Text = ""
            Instance.new("UICorner", Box).CornerRadius = UDim.new(1, 0)
            local BoxStroke = Instance.new("UIStroke", Box)
            BoxStroke.Color = Color3.fromRGB(100, 100, 120)
            BoxStroke.Thickness = 1.5
            BoxStroke.Transparency = 0.5
            
            local Dot = Instance.new("Frame", Box)
            Dot.Position = UDim2.new(0, 3, 0.5, -8)
            Dot.Size = UDim2.new(0, 16, 0, 16)
            Dot.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
            Dot.BackgroundTransparency = 0.3
            Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
            
            local state = false
            Box.MouseButton1Click:Connect(function()
                state = not state
                Tween(BoxStroke, {0.2}, {Color = state and Color3.fromRGB(59, 130, 246) or Color3.fromRGB(100, 100, 120)})
                Tween(Dot, {0.2}, {
                    Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
                    BackgroundColor3 = state and Color3.fromRGB(59, 130, 246) or Color3.fromRGB(100, 100, 120)
                })
                callback(state)
            end)
        end
        
        function Elements:CreateSlider(text, min, max, default, callback)
            local SFrame = Instance.new("Frame", Page)
            SFrame.Size = UDim2.new(1, -10, 0, 52)
            SFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            SFrame.BackgroundTransparency = 0.5
            Instance.new("UICorner", SFrame).CornerRadius = UDim.new(0, 10)
            local SFrameStroke = Instance.new("UIStroke", SFrame)
            SFrameStroke.Color = Color3.fromRGB(59, 130, 246)
            SFrameStroke.Thickness = 1
            SFrameStroke.Transparency = 0.7
            
            local L = Instance.new("TextLabel", SFrame)
            L.Text = "  " .. text .. ": " .. default
            L.Size = UDim2.new(1, 0, 0, 30)
            L.TextColor3 = Color3.fromRGB(200, 200, 220)
            L.Font = Enum.Font.Gotham
            L.TextSize = 13
            L.TextXAlignment = Enum.TextXAlignment.Left
            L.BackgroundTransparency = 1
            
            local Bar = Instance.new("Frame", SFrame)
            Bar.Position = UDim2.new(0, 12, 0, 36)
            Bar.Size = UDim2.new(1, -24, 0, 5)
            Bar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            Bar.BackgroundTransparency = 0.3
            Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)
            local BarStroke = Instance.new("UIStroke", Bar)
            BarStroke.Color = Color3.fromRGB(100, 100, 120)
            BarStroke.Thickness = 1
            BarStroke.Transparency = 0.5
            
            local Fill = Instance.new("Frame", Bar)
            Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(59, 130, 246)
            Fill.BackgroundTransparency = 0.3
            Fill.BorderSizePixel = 0
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)
            
            local sliding = false
            local function move(input)
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max - min) * pos)
                L.Text = "  " .. text .. ": " .. val
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                callback(val)
            end
            Bar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true move(input) end end)
            UserInputService.InputChanged:Connect(function(input) if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then move(input) end end)
            UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end end)
        end
        return Elements
    end

    -- DRAGGING
    local dragging, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true dragStart = input.Position startPos = Main.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    return Tabs, FOVCircle
end

-- INITIALISIERUNG
local Window, FOVGui = Nexus:CreateWindow("NEXUS STEALTH")
local MainTab = Window:CreateTab("Main", "10747373117")
local CombatTab = Window:CreateTab("Combat", "10747373176")
local VisualsTab = Window:CreateTab("Visuals", "10747372701")
local MiscTab = Window:CreateTab("Misc", "10747383819")

MainTab:CreateSlider("WalkSpeed", 16, 500, 16, function(v) Settings.WalkSpeed = v end)
MainTab:CreateToggle("Infinite Jump", function(v) Settings.InfJump = v end)
MainTab:CreateToggle("Fly Hack", function(v) Settings.Fly = v end)
MainTab:CreateSlider("Fly Speed", 10, 500, 50, function(v) Settings.FlySpeed = v end)

CombatTab:CreateToggle("Aimbot Aktiv", function(v) Settings.Aimbot = v end)
CombatTab:CreateToggle("Aggressiv AutoShoot", function(v) Settings.AutoShoot = v end)
CombatTab:CreateToggle("Team Check", function(v) Settings.AimbotTeamCheck = v end)
CombatTab:CreateToggle("Humanizing (Smoothing)", function(v) Settings.HumanizedSmoothing = v end)
CombatTab:CreateSlider("Glättung", 1, 20, 5, function(v) Settings.AimbotSmoothing = v end)
CombatTab:CreateSlider("FOV Radius", 10, 800, 150, function(v) Settings.AimbotFOV = v end)
CombatTab:CreateToggle("FOV anzeigen", function(v) Settings.ShowFOV = v FOVGui.Visible = v end)

VisualsTab:CreateToggle("Player Highlight (Blue)", function(v) Settings.SkeletonESP = v end)
VisualsTab:CreateToggle("Wallhack Names", function(v) Settings.WallhackNames = v end)
VisualsTab:CreateToggle("X-Ray (Welt)", function(v) Settings.Xray = v SetXray(v) end)
VisualsTab:CreateToggle("Fullbright", function(v) Settings.Fullbright = v end)

MiscTab:CreateToggle("World Destroyer", function(v) Settings.WorldDestroyer = v end)

-- LOOPS
local lastShoot = 0
RunService.RenderStepped:Connect(function()
    if Settings.ShowFOV then FOVGui.Size = UDim2.new(0, Settings.AimbotFOV * 2, 0, Settings.AimbotFOV * 2) end
    
    local target = (Settings.Aimbot or Settings.AutoShoot) and GetClosestPlayer()

    -- AIMBOT ENGINE
    if Settings.Aimbot and target then
        local tPos = target.Character[Settings.TargetPart].Position
        local lerpVal = Settings.HumanizedSmoothing and (0.7 / math.max(Settings.AimbotSmoothing, 1)) or 1
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, tPos), lerpVal)
    end

    -- AUTOSHOOT ENGINE (FIXED)
    if Settings.AutoShoot and target then
        if tick() - lastShoot > (0.05 + math.random(0, 15)/1000) then
            lastShoot = tick()
            task.spawn(FireWeapon)
        end
    end

    -- ESP & NAMES
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local char = p.Character
            local highlight = char:FindFirstChild("Nexus_Highlight")
            if Settings.SkeletonESP then
                if not highlight then
                    highlight = Instance.new("Highlight", char)
                    highlight.Name = "Nexus_Highlight"
                    highlight.FillColor = Color3.fromRGB(59, 130, 246)
                    highlight.FillTransparency = 0.5
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                end
            elseif highlight then highlight:Destroy() end
            
            local head = char:FindFirstChild("Head")
            if head then
                local tag = head:FindFirstChild("Nexus_Tag")
                if Settings.WallhackNames then
                    if not tag then
                        tag = Instance.new("BillboardGui", head)
                        tag.Name = "Nexus_Tag"
                        tag.AlwaysOnTop = true tag.Size = UDim2.new(0, 100, 0, 50) tag.StudsOffset = Vector3.new(0, 2, 0)
                        local l = Instance.new("TextLabel", tag)
                        l.BackgroundTransparency = 1 l.Size = UDim2.new(1, 0, 1, 0)
                        l.Text = p.DisplayName l.TextColor3 = Color3.fromRGB(255, 255, 255) l.Font = Enum.Font.GothamBold l.TextSize = 12
                    end
                elseif tag then tag:Destroy() end
            end
        end
    end

    -- MOVEMENT SPEED
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char.Humanoid.WalkSpeed = Settings.WalkSpeed
    end
    if Settings.Fullbright then Lighting.Brightness, Lighting.ClockTime = 2, 14 end
end)

-- FLY & JUMP LOGIC
RunService.Heartbeat:Connect(function()
    if Settings.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local r = LocalPlayer.Character.HumanoidRootPart
        local m = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then m = m + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then m = m - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then m = m - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then m = m + Camera.CFrame.RightVector end
        r.Velocity = m.Magnitude > 0 and m.Unit * Settings.FlySpeed or Vector3.new(0, 0, 0)
    end
end)

UserInputService.JumpRequest:Connect(function()
    if Settings.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

print("Nexus Hub V4.5.5 (Transparent Design) Geladen!")
