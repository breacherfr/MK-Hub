-- [[ NODEX MASTER HUB | V19 ]]
-- Includes ToS, Rayfield UI, Blade Ball, Prison Life, MM2, and Universal.

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ==========================================
-- 1. NODEX ToS SYSTEM (Local Check)
-- ==========================================
local function checkToSConfirmed()
    local success = pcall(function() return readfile("nodex_confirm_tos.txt") end)
    return success
end

local function createToSFile()
    local success = pcall(function() writefile("nodex_confirm_tos.txt", "confirmed") end)
    return success
end

-- ==========================================
-- 2. THE MAIN HUB (Executes after ToS)
-- ==========================================
local function executeMain()
    -- Load Rayfield UI Library
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

    local Window = Rayfield:CreateWindow({
       Name = "NodeX Master Hub",
       LoadingTitle = "Authenticating NodeX...",
       LoadingSubtitle = "Welcome, " .. LocalPlayer.Name,
       ConfigurationSaving = { Enabled = false },
       KeySystem = false
    })

    -- GLOBAL VARIABLES
    local Vars = {
        FlySpeed = 50, WalkSpeed = 16, Flying = false, Noclipping = false,
        ESP_Enabled = false, ESP_Color = Color3.fromRGB(255, 0, 0), Tracers_Enabled = false,
        BladeBall_Visuals = false
    }

    -- [[ TAB 1: BLADE BALL ]]
    local BladeTab = Window:CreateTab("Blade Ball", 4483362458)
    BladeTab:CreateSection("Combat Assist (Visuals)")
    
    BladeTab:CreateToggle({
       Name = "Highlight Target Ball",
       CurrentValue = false,
       Flag = "BallESP",
       Callback = function(Value) Vars.BladeBall_Visuals = Value end,
    })

    BladeTab:CreateSlider({
       Name = "Ping Prediction Adjustment",
       Range = {0, 150},
       Increment = 1,
       Suffix = "ms",
       CurrentValue = 50,
       Flag = "PingSlider",
       Callback = function(Value) print("Prediction set to: " .. Value .. "ms") end,
    })

    -- [[ TAB 2: UNIVERSAL ]]
    local UniTab = Window:CreateTab("Universal", 4483362458)
    UniTab:CreateSection("Movement")
    
    local FlyBV, FlyBG
    UniTab:CreateToggle({
       Name = "Infinite Yield Fly",
       CurrentValue = false,
       Flag = "FlyToggle",
       Callback = function(Value)
          Vars.Flying = Value
          if not Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
              LocalPlayer.Character.Humanoid.PlatformStand = false
          end
       end,
    })

    UniTab:CreateSlider({
       Name = "Fly Speed",
       Range = {10, 300},
       Increment = 1,
       CurrentValue = 50,
       Flag = "FlySpeed",
       Callback = function(Value) Vars.FlySpeed = Value end,
    })

    UniTab:CreateToggle({
       Name = "Noclip",
       CurrentValue = false,
       Flag = "NoclipToggle",
       Callback = function(Value) Vars.Noclipping = Value end,
    })

    -- [[ TAB 3: VISUALS / ESP ]]
    local VisTab = Window:CreateTab("Visuals", 4483362458)
    VisTab:CreateToggle({
       Name = "Enable Player ESP",
       CurrentValue = false,
       Flag = "ESPToggle",
       Callback = function(Value) Vars.ESP_Enabled = Value end,
    })
    VisTab:CreateToggle({
       Name = "Enable Tracers",
       CurrentValue = false,
       Flag = "TracerToggle",
       Callback = function(Value) Vars.Tracers_Enabled = Value end,
    })
    VisTab:CreateColorPicker({
        Name = "ESP Color",
        Color = Color3.fromRGB(255, 0, 0),
        Flag = "ESPColor",
        Callback = function(Value) Vars.ESP_Color = Value end
    })

    -- [[ TAB 4: PRISON LIFE ]]
    local PLTab = Window:CreateTab("Prison Life", 4483362458)
    PLTab:CreateSection("Teleports & Items")
    
    PLTab:CreateButton({
       Name = "Get All Guns",
       Callback = function()
           local items = {"M4A1", "Remington 870", "AK-47"}
           for _, v in pairs(items) do
               local giver = workspace:FindFirstChild("Prison_ITEMS") and workspace.Prison_ITEMS.giver:FindFirstChild(v)
               if giver then workspace.Remote.ItemHandler:InvokeServer(giver.ITEMPICKUP) end
           end
       end,
    })
    
    local function PL_Teleport(cf)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = cf
        end
    end
    
    PLTab:CreateButton({ Name = "TP: Criminal Base", Callback = function() PL_Teleport(CFrame.new(-943, 94, 2063)) end })
    PLTab:CreateButton({ Name = "TP: Armory", Callback = function() PL_Teleport(CFrame.new(389, 14, 94)) end })
    PLTab:CreateButton({
       Name = "Request Car Spawn (Must be at Pad)",
       Callback = function()
           local pad = workspace:FindFirstChild("Prison_ITEMS") and workspace.Prison_ITEMS.buttons:FindFirstChild("Car Spawner")
           if pad then workspace.Remote.ItemHandler:InvokeServer(pad.ITEMPICKUP) end
       end,
    })

    -- [[ TAB 5: MM2 ]]
    local MM2Tab = Window:CreateTab("MM2", 4483362458)
    MM2Tab:CreateButton({
       Name = "Reveal Roles (Murderer/Sheriff)",
       Callback = function()
           for _, p in pairs(Players:GetPlayers()) do
               if p ~= LocalPlayer and p.Character then
                   if p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife") then
                       Rayfield:Notify({Title = "Role Found", Content = p.Name .. " is the MURDERER!", Duration = 5})
                   elseif p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun") then
                       Rayfield:Notify({Title = "Role Found", Content = p.Name .. " is the SHERIFF!", Duration = 5})
                   end
               end
           end
       end,
    })

    -- ==========================================
    -- MASTER RENDER LOOP (Handles Fly, ESP, Noclip)
    -- ==========================================
    RunService.RenderStepped:Connect(function()
        -- FLY LOGIC
        if Vars.Flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            LocalPlayer.Character.Humanoid.PlatformStand = true
            if not FlyBV then
                FlyBV = Instance.new("BodyVelocity", hrp); FlyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                FlyBG = Instance.new("BodyGyro", hrp); FlyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            end
            local move = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += Camera.CFrame.RightVector end
            FlyBV.Velocity = move * Vars.FlySpeed
            FlyBG.CFrame = Camera.CFrame
        elseif FlyBV then
            FlyBV:Destroy(); FlyBG:Destroy(); FlyBV = nil; FlyBG = nil
            if LocalPlayer.Character then LocalPlayer.Character.Humanoid.PlatformStand = false end
        end

        -- ESP & TRACER LOGIC
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local root = p.Character.HumanoidRootPart
                
                -- Highlight
                local highlight = p.Character:FindFirstChild("NodeX_ESP") or Instance.new("Highlight", p.Character)
                highlight.Name = "NodeX_ESP"
                highlight.Enabled = Vars.ESP_Enabled
                highlight.FillColor = Vars.ESP_Color
                highlight.OutlineColor = Color3.new(1,1,1)
                
                -- Tracer
                local tracer = p.Character:FindFirstChild("NodeX_Tracer")
                if Vars.Tracers_Enabled then
                    if not tracer then
                        tracer = Instance.new("Beam", p.Character); tracer.Name = "NodeX_Tracer"; tracer.Width0, tracer.Width1 = 0.05, 0.05
                        tracer.Attachment0 = Instance.new("Attachment", LocalPlayer.Character:WaitForChild("HumanoidRootPart"))
                        tracer.Attachment1 = Instance.new("Attachment", root)
                    end
                    tracer.Color = ColorSequence.new(Vars.ESP_Color)
                elseif tracer then tracer:Destroy() end
            end
        end

        -- BLADE BALL VISUALS (Example logic for finding the ball)
        if Vars.BladeBall_Visuals then
            local balls = workspace:FindFirstChild("Balls")
            if balls then
                for _, ball in pairs(balls:GetChildren()) do
                    if ball:IsA("BasePart") then
                        local bh = ball:FindFirstChild("NodeX_BallESP") or Instance.new("Highlight", ball)
                        bh.Name = "NodeX_BallESP"; bh.FillColor = Color3.fromRGB(255, 255, 0); bh.Enabled = true
                    end
                end
            end
        end
    end)

    RunService.Stepped:Connect(function()
        if Vars.Noclipping and LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
    
    Rayfield:Notify({Title = "NodeX Master Hub", Content = "Loaded Successfully!", Duration = 4})
end

-- ==========================================
-- 3. ToS UI EXECUTION LOGIC (Your Code)
-- ==========================================
if checkToSConfirmed() then
    executeMain()
else
    local screenGui = Instance.new("ScreenGui"); screenGui.Name = "NodeX_ToS"; screenGui.ResetOnSpawn = false
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local overlay = Instance.new("Frame", screenGui)
    overlay.Size = UDim2.new(1, 0, 1, 0); overlay.BackgroundColor3 = Color3.new(0,0,0); overlay.BackgroundTransparency = 0.5
    
    local popup = Instance.new("Frame", screenGui)
    popup.Size = UDim2.new(0, 380, 0, 240); popup.Position = UDim2.new(0.5, -190, 0.5, -120); popup.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 8)
    
    local titleBar = Instance.new("Frame", popup)
    titleBar.Size = UDim2.new(1, 0, 0, 40); titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 8)
    
    local title = Instance.new("TextLabel", titleBar)
    title.Size = UDim2.new(1, -45, 1, 0); title.Position = UDim2.new(0, 15, 0, 0); title.BackgroundTransparency = 1
    title.Text = "NodeX - Terms of Service"; title.TextColor3 = Color3.new(1,1,1); title.Font = Enum.Font.GothamBold; title.TextXAlignment = Enum.TextXAlignment.Left
    
    local content = Instance.new("Frame", popup)
    content.Size = UDim2.new(1, -30, 1, -70); content.Position = UDim2.new(0, 15, 0, 50); content.BackgroundTransparency = 1
    
    local message = Instance.new("TextLabel", content)
    message.Size = UDim2.new(1, 0, 0, 40); message.BackgroundTransparency = 1; message.Text = "By continuing, you agree to the NodeX Terms of Service."
    message.TextColor3 = Color3.new(0.8, 0.8, 0.8); message.Font = Enum.Font.Gotham; message.TextWrapped = true
    
    local continueBtn = Instance.new("TextButton", content)
    continueBtn.Size = UDim2.new(0, 140, 0, 40); continueBtn.Position = UDim2.new(0.5, -70, 1, -45)
    continueBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255); continueBtn.Text = "Accept & Continue"; continueBtn.TextColor3 = Color3.new(1,1,1); continueBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", continueBtn).CornerRadius = UDim.new(0, 6)
    
    continueBtn.MouseButton1Click:Connect(function()
        if createToSFile() then
            screenGui:Destroy()
            executeMain()
        end
    end)
end
