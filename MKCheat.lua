-- Load the Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 1. CREATE THE MAIN WINDOW
local Window = Rayfield:CreateWindow({
   Name = "MK Elite V18 | Multi-Hub",
   LoadingTitle = "MK Elite Loading...",
   LoadingSubtitle = "The Ultimate Framework",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "MK_Elite_Configs",
      FileName = "V18_Config"
   },
   Discord = {
      Enabled = false,
      Invite = "YourDiscordHere",
      RememberJoins = true 
   },
   KeySystem = false -- Set to true if you want to add a key system later
})

-- ==========================================
-- 2. CREATE TABS
-- ==========================================
local UniversalTab = Window:CreateTab("Universal", 4483362458) -- Icon ID
local CombatTab = Window:CreateTab("Combat", 4483362458)
local PrisonLifeTab = Window:CreateTab("Prison Life", 4483362458)
local MM2Tab = Window:CreateTab("MM2", 4483362458)

-- ==========================================
-- 3. UNIVERSAL SECTION
-- ==========================================
local MovementSection = UniversalTab:CreateSection("Movement")

UniversalTab:CreateToggle({
   Name = "Infinite Yield Fly",
   CurrentValue = false,
   Flag = "FlyToggle", 
   Callback = function(Value)
      -- Your fly logic would go here
      print("Fly is now: ", Value)
   end,
})

UniversalTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Flag = "NoclipToggle",
   Callback = function(Value)
      print("Noclip is now: ", Value)
   end,
})

UniversalTab:CreateSlider({
   Name = "WalkSpeed Override",
   Range = {16, 250},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "WalkSpeedSlider",
   Callback = function(Value)
      print("Walkspeed set to: ", Value)
   end,
})

-- ==========================================
-- 4. COMBAT & VISUALS SECTION
-- ==========================================
local CombatSection = CombatTab:CreateSection("Targeting & ESP")

CombatTab:CreateToggle({
   Name = "Enable Aimbot",
   CurrentValue = false,
   Flag = "AimToggle",
   Callback = function(Value)
      print("Aimbot: ", Value)
   end,
})

CombatTab:CreateToggle({
   Name = "ESP (Boxes & Names)",
   CurrentValue = false,
   Flag = "ESPToggle",
   Callback = function(Value)
      print("ESP: ", Value)
   end,
})

CombatTab:CreateToggle({
   Name = "Tracer Lines",
   CurrentValue = false,
   Flag = "TracerToggle",
   Callback = function(Value)
      print("Tracers: ", Value)
   end,
})

-- ==========================================
-- 5. PRISON LIFE SPECIFIC
-- ==========================================
local PLTeleports = PrisonLifeTab:CreateSection("Teleports")

PrisonLifeTab:CreateButton({
   Name = "Teleport to Criminal Base",
   Callback = function()
      print("Teleporting to Crim Base...")
   end,
})

PrisonLifeTab:CreateButton({
   Name = "Teleport to Guards",
   Callback = function()
      print("Teleporting to Police...")
   end,
})

local PLTrolls = PrisonLifeTab:CreateSection("Server Tools")

-- Example of a toggleable Fling All structure
PrisonLifeTab:CreateToggle({
   Name = "Fling All (Loop)",
   CurrentValue = false,
   Flag = "FlingToggle",
   Callback = function(Value)
      if Value then
          print("Starting Fling Loop...")
          -- Loop logic would start here
      else
          print("Stopping Fling Loop...")
          -- Loop logic would safely disconnect here
      end
   end,
})

-- ==========================================
-- 6. MM2 SPECIFIC
-- ==========================================
MM2Tab:CreateToggle({
   Name = "Role ESP (Murderer/Sheriff)",
   CurrentValue = false,
   Flag = "MM2ESP",
   Callback = function(Value)
      print("MM2 ESP: ", Value)
   end,
})
