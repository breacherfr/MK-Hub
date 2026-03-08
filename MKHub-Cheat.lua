-- [[ MK CHEAT ELITE V18 - THE 2026 MEGA-HUB ]]
-- Built with Rayfield UI | 300+ Lines of Optimized Code

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "MK-HUB",
   LoadingTitle = "MK-HUB Loading Systems...",
   LoadingSubtitle = "by Madiok",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "MK_Hub_Configs",
      FileName = "Hub_Config"
   },
   Discord = {
      Enabled = false,
      Invite = "none",
      RememberJoins = true 
   },
   KeySystem = false
})

-- [[ GLOBALS & STATES ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Vars = {
    FlySpeed = 50,
    WalkSpeed = 16,
    JumpPower = 50,
    ESP_Color = Color3.fromRGB(255, 0, 0),
    SpinSpeed = 50,
    Flinging = false,
    Flying = false,
    Noclipping = false,
    Spinning = false,
    ESP_Enabled = false,
    Tracers_Enabled = false
}

-- [[ HELPER FUNCTIONS ]]
local function Notify(title, msg)
    Rayfield:Notify({Title = title, Content = msg, Duration = 3, Image = 4483362458})
end

local function Teleport(cf)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = cf
    end
end

-- ==========================================
-- 1. UNIVERSAL TAB
-- ==========================================
local UniversalTab = Window:CreateTab("Universal", 4483362458)
UniversalTab:CreateSection("Movement")

UniversalTab:CreateToggle({
   Name = "Infinite Yield Fly",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value)
      Vars.Flying = Value
      if not Value then
          if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
              LocalPlayer.Character.Humanoid.PlatformStand = false
          end
      end
   end,
})

UniversalTab:CreateSlider({
   Name = "Fly Speed",
   Range = {10, 300},
   Increment = 1,
   Suffix = "SPS",
   CurrentValue = 50,
   Flag = "FlySpeedSlider",
   Callback = function(Value) Vars.FlySpeed = Value end,
})

UniversalTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Flag = "NoclipToggle",
   Callback = function(Value) Vars.Noclipping = Value end,
})

UniversalTab:CreateSection("Character Stats")
UniversalTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 250},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "WSSlider",
   Callback = function(Value) 
       if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
           LocalPlayer.Character.Humanoid.WalkSpeed = Value
       end
   end,
})

UniversalTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "InfJump",
   Callback = function(Value)
       local connection
       if Value then
           connection = UIS.JumpRequest:Connect(function()
               LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
           end)
       else
           if connection then connection:Disconnect() end
       end
   end,
})

-- ==========================================
-- 2. COMBAT & VISUALS TAB
-- ==========================================
local CombatTab = Window:CreateTab("Visuals & Combat", 4483362458)
CombatTab:CreateSection("ESP Settings")

CombatTab:CreateToggle({
   Name = "Enable ESP (Boxes/Names)",
   CurrentValue = false,
   Flag = "ESPToggle",
   Callback = function(Value) Vars.ESP_Enabled = Value end,
})

CombatTab:CreateToggle({
   Name = "Enable Tracers",
   CurrentValue = false,
   Flag = "TracerToggle",
   Callback = function(Value) Vars.Tracers_Enabled = Value end,
})

CombatTab:CreateColorPicker({
    Name = "ESP Color",
    Color = Color3.fromRGB(255, 0, 0),
    Flag = "ESPColor",
    Callback = function(Value) Vars.ESP_Color = Value end
})

CombatTab:CreateSection("Trolls")
CombatTab:CreateToggle({
   Name = "Spinbot",
   CurrentValue = false,
   Flag = "SpinToggle",
   Callback = function(Value) Vars.Spinning = Value end,
})

CombatTab:CreateSlider({
   Name = "Spin Speed",
   Range = {10, 300},
   Increment = 5,
   CurrentValue = 50,
   Flag = "SpinSlider",
   Callback = function(Value) Vars.SpinSpeed = Value end,
})

-- ==========================================
-- 3. PRISON LIFE TAB
-- ==========================================
local PrisonTab = Window:CreateTab("Prison Life", 4483362458)
PrisonTab:CreateSection("Guns & Gears")

PrisonTab:CreateButton({
   Name = "Get All Guns (Instantly)",
   Callback = function()
       local items = {"M4A1", "Remington 870", "AK-47"}
       for _, v in pairs(items) do
           local giver = workspace:FindFirstChild("Prison_ITEMS") and workspace.Prison_ITEMS.giver:FindFirstChild(v)
           if giver then
               workspace.Remote.ItemHandler:InvokeServer(giver.ITEMPICKUP)
           end
       end
       Notify("Success", "Guns Added to Backpack!")
   end,
})

PrisonTab:CreateSection("Teleports")
PrisonTab:CreateButton({
   Name = "TP to Criminal Base",
   Callback = function() Teleport(CFrame.new(-943, 94, 2063)) end,
})
PrisonTab:CreateButton({
   Name = "TP to Armory",
   Callback = function() Teleport(CFrame.new(389, 14, 94)) end,
})
PrisonTab:CreateButton({
   Name = "TP to Police",
   Callback = function()
       for _, p in pairs(Players:GetPlayers()) do
           if p.TeamColor.Name == "Bright blue" and p.Character then
               Teleport(p.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,3))
               break
           end
       end
   end,
})

PrisonTab:CreateSection("Experimental")
PrisonTab:CreateToggle({
   Name = "Fling All (Toggle)",
   CurrentValue = false,
   Flag = "FlingToggle",
   Callback = function(Value)
       Vars.Flinging = Value
       if Value then
           Notify("WARNING", "Flinging is active. Loop starting...")
           spawn(function()
               while Vars.Flinging do
                   local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                   if hrp then
                       local bav = Instance.new("BodyAngularVelocity", hrp)
                       bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                       bav.AngularVelocity = Vector3.new(0, 99999, 0)
                       
                       for _, target in pairs(Players:GetPlayers()) do
                           if target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and Vars.Flinging then
                               hrp.CFrame = target.Character.HumanoidRootPart.CFrame
                               task.wait(0.1)
                           end
                       end
                       bav:Destroy()
                   end
                   task.wait(0.5)
               end
           end)
       else
           Notify("Fling", "Fling Stopped Safely.")
       end
   end,
})

-- ==========================================
-- 4. MURDER MYSTERY 2 TAB
-- ==========================================
local MM2Tab = Window:CreateTab("MM2", 4483362458)
MM2Tab:CreateButton({
   Name = "Reveal Murderer/Sheriff",
   Callback = function()
       for _, p in pairs(Players:GetPlayers()) do
           if p.Character then
               local role = "Innocent"
               if p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife") then role = "MURDERER"
               elseif p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun") then role = "SHERIFF" end
               
               if role ~= "Innocent" then
                   Notify(role, p.Name .. " is the " .. role .. "!")
                   local h = Instance.new("Highlight", p.Character)
                   h.FillColor = (role == "MURDERER" and Color3.new(1,0,0) or Color3.new(0,0,1))
               end
           end
       end
   end,
})

-- ==========================================
-- 5. MASTER LOOPS (THE ENGINE)
-- ==========================================
local FlyBV, FlyBG

RunService.RenderStepped:Connect(function()
    -- Force FOV & ESP Updates
    Camera.FieldOfView = 90
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local root = p.Character:FindFirstChild("HumanoidRootPart")
            if root then
                -- ESP Logic
                local highlight = p.Character:FindFirstChild("MK_Elite_ESP") or Instance.new("Highlight", p.Character)
                highlight.Name = "MK_Elite_ESP"
                highlight.Enabled = Vars.ESP_Enabled
                highlight.FillColor = Vars.ESP_Color
                highlight.OutlineColor = Color3.new(1,1,1)
                
                -- Tracer Logic
                local tracer = p.Character:FindFirstChild("MK_Tracer")
                if Vars.Tracers_Enabled then
                    if not tracer then
                        tracer = Instance.new("Beam", p.Character)
                        tracer.Name = "MK_Tracer"; tracer.Width0, tracer.Width1 = 0.1, 0.1
                        tracer.Attachment0 = Instance.new("Attachment", LocalPlayer.Character.HumanoidRootPart)
                        tracer.Attachment1 = Instance.new("Attachment", root)
                    end
                    tracer.Color = ColorSequence.new(Vars.ESP_Color)
                elseif tracer then tracer:Destroy() end
            end
        end
    end

    -- Spinbot Engine
    if Vars.Spinning and LocalPlayer.Character then
        LocalPlayer.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(Vars.SpinSpeed), 0)
    end

    -- Fly Engine (Infinite Yield Style)
    if Vars.Flying and LocalPlayer.Character then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        LocalPlayer.Character.Humanoid.PlatformStand = true
        if not FlyBV then
            FlyBV = Instance.new("BodyVelocity", hrp); FlyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            FlyBG = Instance.new("BodyGyro", hrp); FlyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        end
        local move = Vector3.new(0,0,0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then move += Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move -= Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move -= Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move += Camera.CFrame.RightVector end
        FlyBV.Velocity = move * Vars.FlySpeed
        FlyBG.CFrame = Camera.CFrame
    elseif FlyBV then
        FlyBV:Destroy(); FlyBG:Destroy(); FlyBV, FlyBG = nil, nil
        LocalPlayer.Character.Humanoid.PlatformStand = false
    end
end)

-- Noclip Engine
RunService.Stepped:Connect(function()
    if Vars.Noclipping and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

Rayfield:LoadConfiguration()
Notify("MK Elite Loaded", "Welcome, " .. LocalPlayer.Name .. "!")
