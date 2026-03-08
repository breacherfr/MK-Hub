-- [[ MK CHEAT ELITE V17 - INFINITE MULTI-HUB ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- STATES & CONFIG
local States = { aimbot = false, esp = false, tracers = false, fly = false, noclip = false, spin = false }
local Config = { flySpeed = 50, spinSpeed = 50 }
local FlyBV, FlyBG

-- ==========================================
-- 1. MODERN ANIMATED UI (V17)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "MK_Elite_V17"; ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 550, 0, 400); Main.Position = UDim2.new(0.5, -275, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 24); Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
local Stroke = Instance.new("UIStroke", Main); Stroke.Color = Color3.fromRGB(255, 50, 50); Stroke.Thickness = 2

-- Title & Minimize
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 40); TopBar.BackgroundTransparency = 1
local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -50, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0); Title.Text = "MK ELITE V17 | MULTI-HUB"
Title.TextColor3 = Color3.new(1,1,1); Title.Font = Enum.Font.GothamBlack; Title.TextSize = 16; Title.TextXAlignment = "Left"
Title.BackgroundTransparency = 1

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 30, 0, 30); MinBtn.Position = UDim2.new(1, -40, 0, 5)
MinBtn.Text = "-"; MinBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40); MinBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", MinBtn)
local Minimized = false
MinBtn.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    Main:TweenSize(Minimized and UDim2.new(0, 550, 0, 40) or UDim2.new(0, 550, 0, 400), "Out", "Quart", 0.4, true)
end)

-- Sidebar & Pages
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, -40); Sidebar.Position = UDim2.new(0, 0, 0, 40); Sidebar.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
local PageContainer = Instance.new("Frame", Main)
PageContainer.Size = UDim2.new(1, -150, 1, -50); PageContainer.Position = UDim2.new(0, 145, 0, 45); PageContainer.BackgroundTransparency = 1

local Tabs = {}
local function CreateTab(name)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1, 0, 0, 40); btn.Position = UDim2.new(0, 0, 0, #Tabs * 40)
    btn.Text = "  " .. name; btn.TextXAlignment = "Left"; btn.Font = Enum.Font.GothamBold
    btn.BackgroundColor3 = Color3.fromRGB(14, 14, 18); btn.TextColor3 = Color3.new(0.5, 0.5, 0.5); btn.BorderSizePixel = 0
    
    local page = Instance.new("ScrollingFrame", PageContainer)
    page.Size = UDim2.new(1, 0, 1, 0); page.BackgroundTransparency = 1; page.ScrollBarThickness = 2
    page.Visible = (#Tabs == 0); local list = Instance.new("UIListLayout", page); list.Padding = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do t.P.Visible = false; TweenService:Create(t.B, TweenInfo.new(0.2), {TextColor3 = Color3.new(0.5, 0.5, 0.5)}):Play() end
        page.Visible = true; TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 50, 50)}):Play()
    end)
    if #Tabs == 0 then btn.TextColor3 = Color3.fromRGB(255, 50, 50) end
    table.insert(Tabs, {B = btn, P = page}); return page
end

-- UI Element Builders
local function AddToggle(p, name, key)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -10, 0, 38); b.Text = name .. " : OFF"
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 32); b.TextColor3 = Color3.new(0.8, 0.8, 0.8); b.Font = Enum.Font.GothamSemibold; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        States[key] = not States[key]
        b.Text = name .. " : " .. (States[key] and "ON" or "OFF")
        TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = States[key] and Color3.fromRGB(220, 40, 40) or Color3.fromRGB(25, 25, 32)}):Play()
    end)
end
local function AddButton(p, name, cb)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -10, 0, 38); b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 50); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(cb)
end

-- ==========================================
-- 2. UNIVERSAL TAB (INF YIELD LOGIC)
-- ==========================================
local UniTab = CreateTab("UNIVERSAL")
AddToggle(UniTab, "Aimbot", "aimbot")
AddToggle(UniTab, "ESP Boxes & Names", "esp")
AddToggle(UniTab, "Tracer ESP", "tracers")
AddToggle(UniTab, "Inf Yield Noclip", "noclip")
AddToggle(UniTab, "Spinbot", "spin")

-- Infinite Yield Style Fly
AddToggle(UniTab, "Inf Yield Fly", "fly")
RunService.RenderStepped:Connect(function()
    if States.fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        LocalPlayer.Character.Humanoid.PlatformStand = true
        if not FlyBV then
            FlyBV = Instance.new("BodyVelocity", hrp); FlyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            FlyBG = Instance.new("BodyGyro", hrp); FlyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9); FlyBG.CFrame = Camera.CFrame
        end
        local move = Vector3.new()
        if UIS:IsKeyDown(Enum.KeyCode.W) then move += Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move -= Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move -= Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move += Camera.CFrame.RightVector end
        FlyBV.Velocity = move * Config.flySpeed; FlyBG.CFrame = Camera.CFrame
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.PlatformStand = false end
        if FlyBV then FlyBV:Destroy(); FlyBV = nil end
        if FlyBG then FlyBG:Destroy(); FlyBG = nil end
    end
end)

-- ==========================================
-- 3. PRISON LIFE HUB
-- ==========================================
local PLTab = CreateTab("PRISON LIFE")
AddButton(PLTab, "Get Every Gun", function()
    local givers = workspace:FindFirstChild("Prison_ITEMS") and workspace.Prison_ITEMS.giver:GetChildren() or {}
    for _, item in pairs(givers) do
        if item:FindFirstChild("ITEMPICKUP") then
            workspace.Remote.ItemHandler:InvokeServer(item.ITEMPICKUP)
        end
    end
end)
AddButton(PLTab, "TP to Police (Guards)", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.TeamColor.Name == "Bright blue" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            break -- TPs to the first guard found
        end
    end
end)
AddButton(PLTab, "Spawn Car (Must be Yard)", function()
    local carPad = workspace:FindFirstChild("Prison_ITEMS") and workspace.Prison_ITEMS.buttons:FindFirstChild("Car Spawner")
    if carPad then
        LocalPlayer.Character.HumanoidRootPart.CFrame = carPad.CFrame
        task.wait(0.2)
        workspace.Remote.ItemHandler:InvokeServer(carPad.ITEMPICKUP)
    end
end)

-- FLING ALL (Physics Exploit)
AddButton(PLTab, "Fling All (Risky)", function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local bg = Instance.new("BodyAngularVelocity", hrp)
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.AngularVelocity = Vector3.new(0, 90000, 0) -- Extreme spin
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            for i = 1, 10 do -- Force teleport to them 10 times to ensure impact
                hrp.CFrame = p.Character.HumanoidRootPart.CFrame
                task.wait(0.05)
            end
        end
    end
    bg:Destroy()
end)

-- ==========================================
-- 4. MURDER MYSTERY 2 HUB
-- ==========================================
local MM2Tab = CreateTab("MURDER MYSTERY 2")
AddButton(MM2Tab, "Role ESP (Murderer/Sheriff)", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local role = "Innocent"; local color = Color3.new(0, 1, 0)
            -- Check backpack and character for weapons
            local backpack = p:FindFirstChild("Backpack")
            if (backpack and backpack:FindFirstChild("Knife")) or p.Character:FindFirstChild("Knife") then role = "Murderer"; color = Color3.new(1, 0, 0) end
            if (backpack and backpack:FindFirstChild("Gun")) or p.Character:FindFirstChild("Gun") then role = "Sheriff"; color = Color3.new(0, 0, 1) end
            
            -- Draw Role Text
            local root = p.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local b = Instance.new("BillboardGui", root); b.Size = UDim2.new(0, 100, 0, 40); b.AlwaysOnTop = true; b.ExtentsOffset = Vector3.new(0, 4, 0)
                local t = Instance.new("TextLabel", b); t.Size = UDim2.new(1,0,1,0); t.BackgroundTransparency = 1; t.Text = role; t.TextColor3 = color; t.Font = Enum.Font.GothamBlack
            end
        end
    end
end)

-- ==========================================
-- 5. MASTER RENDER ENGINE (ESP, NOCLIP, TRACERS)
-- ==========================================
RunService.Stepped:Connect(function()
    -- True Noclip (Inf Yield style)
    if States.noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
        end
    end
    -- Spinbot
    if States.spin and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(Config.spinSpeed), 0)
    end
end)

RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local char = p.Character
            local root = char.HumanoidRootPart
            
            -- ESP Setup
            local esp = root:FindFirstChild("MK_ESP")
            if not esp then
                esp = Instance.new("BillboardGui", root); esp.Name = "MK_ESP"; esp.AlwaysOnTop = true; esp.Size = UDim2.new(0, 100, 0, 40); esp.ExtentsOffset = Vector3.new(0,3,0)
                local t = Instance.new("TextLabel", esp); t.Size = UDim2.new(1,0,1,0); t.BackgroundTransparency = 1; t.TextColor3 = Color3.new(1,1,1); t.Text = p.Name; t.Font = Enum.Font.GothamBold; t.TextStrokeTransparency = 0
                local box = Instance.new("SelectionBox", char); box.Name = "MK_Box"; box.Adornee = char; box.Color3 = Color3.new(1,0,0); box.LineThickness = 0.05
            end
            esp.Enabled = States.esp; char.MK_Box.Visible = States.esp
            
            -- Tracers Setup
            local tracer = char:FindFirstChild("MK_Tracer")
            if not tracer then
                tracer = Instance.new("Beam", char); tracer.Name = "MK_Tracer"
                tracer.Color = ColorSequence.new(Color3.new(1, 0, 0)); tracer.FaceCamera = true; tracer.Width0 = 0.05; tracer.Width1 = 0.05
                local a0 = Instance.new("Attachment", LocalPlayer.Character:WaitForChild("HumanoidRootPart"))
                local a1 = Instance.new("Attachment", root)
                tracer.Attachment0 = a0; tracer.Attachment1 = a1
            end
            tracer.Enabled = States.tracers
        end
    end
end)

-- Mobile Toggle Icon
local Open = Instance.new("TextButton", ScreenGui); Open.Size = UDim2.new(0, 50, 0, 50); Open.Position = UDim2.new(0, 10, 0, 10); Open.Text = "MK"; Open.BackgroundColor3 = Color3.new(0,0,0); Open.TextColor3 = Color3.new(1,0,0); Instance.new("UICorner", Open).CornerRadius = UDim.new(1,0)
Open.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
