     game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "mxxyc.lol",
        Text = "mxxyc.lol loaded",
        Icon = "rbxassetid://12104764025",
        Duration = 3.0
    })


-- Add your additional logic or code here
loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixeluted/adoniscries/main/Source.lua",true))()
-- Assuming your existing code is already set up as described
-- Create a ScreenGui to hold our GUI elements
local gui = Instance.new("ScreenGui")
gui.Name = "FixedGUI"
gui.ResetOnSpawn = false  -- Ensures the GUI doesn't reset on player respawn
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
-- Calculate the size of the square frame
local size = 40  -- Adjust this value to change the size of the square
local halfSize = size / 2
-- Create a Frame for the square
local frame = Instance.new("Frame")
frame.Name = "FixedFrame"
frame.Size = UDim2.new(0, 70, 0, 70)  -- Size of the frame
frame.Position = UDim2.new(0, 15, 0, 100)  -- Position at the desired location
frame.AnchorPoint = Vector2.new(0, 0)  -- Set the anchor point to the top left corner
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Black color
frame.Parent = gui
-- Create a white TextLabel inside the frame
local label = Instance.new("TextLabel")
label.Name = "FixedLabel"
label.Size = UDim2.new(1, 0, 1, 0)  -- Fill the entire frame
label.Position = UDim2.new(0, 0, 0, 0)  -- Center the label within the frame
label.Text = ""
label.TextColor3 = Color3.new(1, 1, 1)  -- White color
label.BackgroundTransparency = 1  -- Transparent background
label.Parent = frame
label.Font = Enum.Font.GothamSemibold
label.TextSize = 13
-- Create an ImageLabel for the image
local imageLabel = Instance.new("ImageLabel")
imageLabel.Name = "FixedImage"
imageLabel.Size = UDim2.new(1, 0, 1, 0)  -- Fill the entire frame
imageLabel.Position = UDim2.new(0, 0, 0, 0)  -- Center the image within the frame
imageLabel.Image = "rbxassetid://9811410578"  -- Replace with the asset ID of your image
imageLabel.BackgroundTransparency = 0.0 -- Transparent background
imageLabel.Parent = frame  -- Parent to the frame or gui depending on layering needs
-- Function to send the keybind (optional, can remove if not needed)
local function OnFrameClick()
    local vim = game:GetService("VirtualInputManager")
    vim:SendKeyEvent(true, "RightControl", false, game)
end
-- Connect the click event for the frame (optional, can remove if not needed)
frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        OnFrameClick()
    end
end)
-- Load library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/KJ7285/-back-ups-for-libs/0c9ed5c842e4801f30415606bae445e6b7e8e664/cat"))()
local Window = Library:CreateWindow("mxxyc.lol", Vector2.new(310, 400), Enum.KeyCode.RightControl)
-- Aiming tab
local AimingTab = Window:CreateTab("Aiming")
local SilentAimSection = AimingTab:CreateSector("Silent", "right")
local TargetAimSection = AimingTab:CreateSector("Aim Target", "left")
-- Silent Aim variables
getgenv().HitPart = "HumanoidRootPart"
getgenv().Prediction_SilentAim = 0.1
getgenv().SilentAimEnabled = false  -- Default to disabled
getgenv().SilentAimShowFOV = true  -- Default to showing FOV
-- FOV settings for Silent Aim
getgenv().SilentAimFOVSize = 150
getgenv().SilentAimFOVTransparency = 1
getgenv().SilentAimFOVThickness = 2.0
getgenv().SilentAimFOVColor = Color3.new(0, 0, 255)
-- FOV circle setup for Silent Aim
local SilentAimFOVCircle = Drawing.new("Circle")
SilentAimFOVCircle.Color = getgenv().SilentAimFOVColor
SilentAimFOVCircle.Visible = getgenv().SilentAimShowFOV
SilentAimFOVCircle.Filled = false
SilentAimFOVCircle.Radius = getgenv().SilentAimFOVSize
SilentAimFOVCircle.Transparency = getgenv().SilentAimFOVTransparency
SilentAimFOVCircle.Thickness = getgenv().SilentAimFOVThickness
-- Function to update FOV circle position
local function updateFOVCirclePosition()
    local centerScreenPosition = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
    SilentAimFOVCircle.Position = centerScreenPosition
end
-- Function to get the closest player to the center of the screen for Silent Aim
-- Function to get the closest player to the center of the screen for Silent Aim
local function getClosestPlayerToCenter()
    local centerScreenPosition = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
    local closestPlayer
    local closestDistance = math.huge
    local localPlayer = game.Players.LocalPlayer
    local camera = workspace.CurrentCamera
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local playerRootPart = player.Character.HumanoidRootPart
            local screenPosition, onScreen = camera:WorldToViewportPoint(playerRootPart.Position)
            if onScreen then
                -- Check if the player is KO'd or grabbed
                local KOd = player.Character:FindFirstChild("BodyEffects") and player.Character.BodyEffects["K.O"].Value
                local Grabbed = player.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
                if not KOd and not Grabbed then
                    -- Check if there are obstructions between player and camera
                    local ray = Ray.new(camera.CFrame.Position, playerRootPart.Position - camera.CFrame.Position)
                    local part, position = workspace:FindPartOnRay(ray, localPlayer.Character, false, true)
                    if part and part:IsDescendantOf(player.Character) then
                        local distance = (centerScreenPosition - Vector2.new(screenPosition.X, screenPosition.Y)).Magnitude
                        if distance < closestDistance and distance <= SilentAimFOVCircle.Radius then
                            closestPlayer = player
                            closestDistance = distance
                        end
                    end
                end
            end
        end
    end
    return closestPlayer
end
local SilentAimTarget = nil
-- Update SilentAimTarget on every RenderStepped
game:GetService("RunService").RenderStepped:Connect(function()
    SilentAimTarget = getClosestPlayerToCenter()
end)
-- Update FOV circle position on every render frame
game:GetService("RunService").RenderStepped:Connect(function()
    updateFOVCirclePosition()
end)
-- Hook into RemoteEvent calls to modify mouse position for Silent Aim
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(...)
    local args = {...}
    if getgenv().SilentAimEnabled and SilentAimTarget ~= nil and SilentAimTarget.Character and getnamecallmethod() == "FireServer" and args[2] == "UpdateMousePos" then
    args[3] = SilentAimTarget.Character[getgenv().HitPart].Position + (SilentAimTarget.Character[getgenv().HitPart].Velocity * getgenv().Prediction_SilentAim)
        return old(unpack(args))
    end
    return old(...)
end)
setreadonly(mt, true)
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(...)
    local args = {...}
    if getgenv().SilentAimEnabled and SilentAimTarget ~= nil and SilentAimTarget.Character and getnamecallmethod() == "FireServer" then
        if args[2] == "UpdateMousePos" or args[2] == "MOUSE" or args[2] == "UpdateMousePosI" or args[2] == "MousePosUpdate" then
            args[3] = SilentAimTarget.Character[getgenv().HitPart].Position + (SilentAimTarget.Character[getgenv().HitPart].Velocity * getgenv().Prediction_SilentAim)
            return old(unpack(args))
        end
    end
    return old(...)
end)
setreadonly(mt, true)
-- Toggle for enabling/disabling Silent Aim
local SilentAimToggle = SilentAimSection:AddToggle("Toggle Silent", false, function(enabled)
    getgenv().SilentAimEnabled = enabled
    if enabled then
        -- Show FOV circle when enabled
        SilentAimFOVCircle.Visible = getgenv().SilentAimShowFOV
    else
        -- Hide FOV circle when disabled
        SilentAimFOVCircle.Visible = false
    end
end)
-- FOV size input textbox for Silent Aim

-- FOV visibility toggle for Silent Aim
local FOVToggle = SilentAimSection:AddToggle("Show On FOV", true, function(showFOV)
    getgenv().SilentAimShowFOV = showFOV
    SilentAimFOVCircle.Visible = showFOV and getgenv().SilentAimEnabled
end)
-- Prediction value input textbox for Silent Aim
local PredictionTextbox = SilentAimSection:AddTextbox("Silent Prediction", tostring(getgenv().Prediction_SilentAim), function(newValue)
    getgenv().Prediction_SilentAim = tonumber(newValue) or getgenv().Prediction_SilentAim
end)
-- Target Aim variables
local TargetEnabled = false
local TargetPrediction = 0.1
local Notifications = true
local AimPart = "HumanoidRootPart"
-- Tool setup for Target Aim
local TargetAimTool = Instance.new("Tool")
TargetAimTool.RequiresHandle = false
TargetAimTool.Name = "Aim Tool"
local Camera = game:GetService("Workspace").CurrentCamera
local Mouse = game.Players.LocalPlayer:GetMouse()
local Plr
local Part = Instance.new("Part", game.Workspace)
Part.Anchored = true
Part.CanCollide = false
Part.Color = Color3.fromRGB(0, 0, 0)
Part.Material = Enum.Material.Neon
Part.Size = Vector3.new(1, 1, 1)
Part.Shape = Enum.PartType.Ball
-- Function to find closest player for Target Aim
function FindClosestPlayer()
    local closestPlayer
    local shortestDistance = math.huge
    for i, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and
            v.Character.Humanoid.Health > 0 and v.Character:FindFirstChild("HumanoidRootPart") then
            local pos = Camera:WorldToViewportPoint(v.Character.PrimaryPart.Position)
            local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude
            if magnitude < shortestDistance then
                closestPlayer = v
                shortestDistance = magnitude
            end
        end
    end
    return closestPlayer
end
-- Tool activation logic for Target Aim
TargetAimTool.Activated:Connect(function()
    if TargetEnabled then
        -- Unlock from current target
        TargetEnabled = false
        if Notifications then
            game.StarterGui:SetCore("SendNotification", {
                Title = "mxxyc.lol",
                Text = "Unlocked"
            })
        end
    else
        -- Lock onto nearest player
        Plr = FindClosestPlayer()
        if Plr then
            TargetEnabled = true
            if Notifications then
                game.StarterGui:SetCore("SendNotification", {
                    Title = "mxxyc.lol",
                    Text = "Locking: " .. Plr.Name
                })
            end
        end
    end
end)
-- Stepped logic to aim at the closest player for Target Aim
game:GetService("RunService").Stepped:Connect(function()
    if TargetEnabled then
        if Plr and Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart") then
            Part.Position = Plr.Character.HumanoidRootPart.Position
        end
    else
        Part.CFrame = CFrame.new(0, -9999, 0)
    end
end)
-- Modify __namecall to handle aiming adjustments when Target Aim is enabled
local mt2 = getrawmetatable(game)
local old2 = mt2.__namecall
setreadonly(mt2, false)
mt2.__namecall = newcclosure(function(...)
    local args = {...}
    if TargetEnabled and getnamecallmethod() == "FireServer" and args[2] == "UpdateMousePos" then
        if Plr and Plr.Character and Plr.Character[AimPart] then
            args[3] = Plr.Character[AimPart].Position + (Plr.Character[AimPart].Velocity * TargetPrediction)
        end
        return old2(unpack(args))
    end
    return old2(...)
end)
setreadonly(mt2, true)
local mt2 = getrawmetatable(game)
local old2 = mt2.__namecall
setreadonly(mt2, false)
mt2.__namecall = newcclosure(function(...)
    local args = {...}
    if TargetEnabled and getnamecallmethod() == "FireServer" then
        if args[2] == "UpdateMousePos" or args[2] == "MOUSE" or args[2] == "UpdateMousePosI" or args[2] == "MousePosUpdate" then
            if Plr and Plr.Character and Plr.Character[AimPart] then
                args[3] = Plr.Character[AimPart].Position + (Plr.Character[AimPart].Velocity * TargetPrediction)
            end
            return old2(unpack(args))
        end
    end
    return old2(...)
end)
setreadonly(mt2, true)
-- Toggle for enabling/disabling Target Aim
local TargetAimToggle = TargetAimSection:AddToggle("Toggle Aim", false, function(enabled)
    getgenv().TargetAimEnabled = enabled  -- Update Target Aim enabled status
    if enabled then
        -- Automatically lock onto nearest player when enabled
        Plr = FindClosestPlayer()
        if Plr then
            TargetEnabled = true
            if Notifications then
                game.StarterGui:SetCore("SendNotification", {
                    Title = "mxxyc.lol",
                    Text = "Locking: " .. Plr.Name
                })
            end
            -- Add tool to player's backpack when enabled
            TargetAimTool.Parent = game.Players.LocalPlayer.Backpack
        end
    else
        -- Disable Target Aim
        -- Remove tool from player's backpack when disabled
        TargetAimTool.Parent = nil
        -- Unlock from current target
        TargetEnabled = false
        if Notifications then
            game.StarterGui:SetCore("SendNotification", {
                Title = "mxxyc.lol",
                Text = "Unlocked"
            })
        end
    end
    -- Handle respawn logic to ensure tool persistence
    local function onCharacterAdded(character)
        if getgenv().TargetAimEnabled then
            TargetAimTool.Parent = game.Players.LocalPlayer.Backpack
        end
    end
    game.Players.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
end)
-- Notifications toggle for Target Aim
local NotificationsToggle = TargetAimSection:AddToggle("notif", true, function(enabled)
    Notifications = enabled
end)
-- Dot Toggle
local DotToggle = TargetAimSection:AddToggle("show dot", true, function(enabled)
    getgenv().DotEnabled = enabled
    if enabled then
        Part.Parent = workspace  -- Show the aiming dot
    else
        Part.Parent = nil  -- Hide the aiming dot
    end
end)
-- Add Look At toggle to Target Aim section
local LookAtToggle = TargetAimSection:AddToggle("look at", false, function(enabled)
    getgenv().LookAtEnabled = enabled
    if enabled then
        -- Start function to make character face locked target
        MakeCharacterFaceTarget()
    end
end)
-- Function to make character face the locked target
function MakeCharacterFaceTarget()
    if Plr and Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart") then
        local character = game.Players.LocalPlayer.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local targetPosition = Plr.Character.HumanoidRootPart.Position
            local lookVector = (targetPosition - rootPart.Position).unit
            -- Adjust character orientation to face the target
            character:SetPrimaryPartCFrame(CFrame.new(rootPart.Position, rootPart.Position + Vector3.new(lookVector.X, 0, lookVector.Z)))
        end
    end
end
-- Modify Stepped logic to call MakeCharacterFaceTarget when Look At is enabled
game:GetService("RunService").Stepped:Connect(function()
    if TargetEnabled and getgenv().LookAtEnabled then
        MakeCharacterFaceTarget()
    end
end)
-- Prediction value input textbox for Target Aim
local TargetPredictionTextbox = TargetAimSection:AddTextbox("Aim Prediction", tostring(TargetPrediction), function(newValue)
    TargetPrediction = tonumber(newValue) or TargetPrediction
end)
local CamlockSection = AimingTab:CreateSector("Aim Assist", "right")
-- Camlock variables
getgenv().Prediction_Camlock = 0.1
getgenv().Smoothness = 0.1
getgenv().AimPart = "UpperTorso"
getgenv().ShakeValue = 0
getgenv().AutoPred = false
getgenv().AimlockEnabled = false  -- Variable to control if Aimlock is enabled
getgenv().LockedPlayer = nil  -- Variable to store locked player
-- Tool setup for Camlock
local Tool = Instance.new("Tool")
Tool.RequiresHandle = false
Tool.Name = "Camlock Tool"
-- Toggle for enabling/disabling Camlock
local CamlockToggle = CamlockSection:AddToggle("Toggle Cam", false, function(enabled)
    getgenv().AimlockEnabled = enabled  -- Update Aimlock enabled status
    if enabled then
        Tool.Parent = game.Players.LocalPlayer.Backpack  -- Add tool to backpack when enabled
    else
        Tool.Parent = nil  -- Remove tool when disabled
        getgenv().LockedPlayer = nil  -- Clear locked player when disabled
    end
end)
-- Function to handle character respawn
local function onCharacterAdded(character)
    if getgenv().AimlockEnabled then
        -- Re-add the tool to the backpack if Aimlock is enabled
        Tool.Parent = game.Players.LocalPlayer.Backpack
    end
end
-- Listen for the local player's character added event
game.Players.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
-- Ensure tool is initially placed in the backpack if Aimlock is enabled at script start
if getgenv().AimlockEnabled then
    Tool.Parent = game.Players.LocalPlayer.Backpack
end
-- Ensure tool is removed from backpack when Aimlock is disabled
if not getgenv().AimlockEnabled then
    Tool.Parent = nil
end
-- Toggle for enabling/disabling Smoothness
local SmoothnessToggle = CamlockSection:AddToggle("Toggle Smooth", false, function(enabled)
    getgenv().SmoothnessEnabled = enabled
end)
-- Prediction value input textbox for Camlock
local PredictionTextbox_Camlock = CamlockSection:AddTextbox("Cam Prediction", tostring(getgenv().Prediction_Camlock), function(newValue)
    getgenv().Prediction_Camlock = tonumber(newValue) or getgenv().Prediction_Camlock
end)
-- Smoothness value input textbox for Camlock
local SmoothnessTextbox = CamlockSection:AddTextbox("Smooth Prediction", tostring(getgenv().Smoothness), function(newValue)
    getgenv().Smoothness = tonumber(newValue) or getgenv().Smoothness
end)
-- Function to find closest player for Camlock
local function getClosestPlayer()
    local closestPlayer
    local shortestDistance = math.huge
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            local aimPart = player.Character:FindFirstChild(getgenv().AimPart)
            
            -- Check if the player is KO'd or grabbed
            local KOd = player.Character:FindFirstChild("BodyEffects") and player.Character.BodyEffects["K.O"].Value
            local Grabbed = player.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
            if aimPart and humanoid.Health > 0 and not KOd and not Grabbed then
                local pos = game.Workspace.CurrentCamera:WorldToViewportPoint(aimPart.Position)
                local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(game.Players.LocalPlayer:GetMouse().X, game.Players.LocalPlayer:GetMouse().Y)).magnitude
                if magnitude < shortestDistance then
                    closestPlayer = player
                    shortestDistance = magnitude
                end
            end
        end
    end
    return closestPlayer
end
-- Lock onto closest player function
local function LockTarget()
    local Victim = getClosestPlayer()
    if Victim then
        getgenv().LockedPlayer = Victim
    end
end
-- RenderStepped logic for Camlock
-- RenderStepped logic for Camlock
game:GetService("RunService").RenderStepped:Connect(function()
    if getgenv().AimlockEnabled and getgenv().LockedPlayer then
        local Victim = getgenv().LockedPlayer
        if Victim and Victim.Character then
            local aimPart = Victim.Character:FindFirstChild(getgenv().AimPart)
            if aimPart then
                -- Check if the locked player is KO'd
                local KOd = Victim.Character:FindFirstChild("BodyEffects") and Victim.Character.BodyEffects["K.O"].Value
                if KOd then
                    getgenv().LockedPlayer = nil
                else
                    -- Aim at the player's position
                    local shakeOffset = Vector3.new(
                        math.random(-getgenv().ShakeValue, getgenv().ShakeValue),
                        math.random(-getgenv().ShakeValue, getgenv().ShakeValue),
                        math.random(-getgenv().ShakeValue, getgenv().ShakeValue)
                    ) * 0.1
                    local LookPosition = CFrame.new(game.Workspace.CurrentCamera.CFrame.p, aimPart.Position + (Victim.Character.HumanoidRootPart.Velocity * getgenv().Prediction_Camlock))
 + shakeOffset
                    if getgenv().SmoothnessEnabled then
                        game.Workspace.CurrentCamera.CFrame = game.Workspace.CurrentCamera.CFrame:Lerp(LookPosition, getgenv().Smoothness)
                    else
                        game.Workspace.CurrentCamera.CFrame = LookPosition
                    end
                end
            end
        else
            -- Handle the case where Victim or Victim.Character is nil
            getgenv().LockedPlayer = nil
        end
    end
end)
-- Function to handle notifications
local function Notify(tx)
    game.StarterGui:SetCore("SendNotification", {
        Title = "mxxyc.lol",
        Text = tx,
        Duration = 5
    })
end
-- Activated event for the tool
Tool.Activated:Connect(function()
    if getgenv().AimlockEnabled then
        if getgenv().LockedPlayer then
            -- Untoggle from current locked player
            getgenv().LockedPlayer = nil
        else
            -- Lock onto closest player when tool is activated
            LockTarget()
        end
    else
        Notify("Camlock is not enabled!")
    end
end)
-- Visuals tab
local VisualsTab = Window:CreateTab("Visualize")
local ESPTab = VisualsTab:CreateSector("player", "right")  -- Create ESP sector in Visuals tab
-- Settings for ESP
local settings = {
    defaultcolor = Color3.new(0, 0, 255),  -- White color for both box and outline
    teamcheck = false,
    teamcolor = false,  -- Disable team color override
    showBox = false,
    showName = false
}
-- services
local runService = game:GetService("RunService")
local players = game:GetService("Players")
-- variables
local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera
-- functions
local newVector2, newColor3, newDrawing = Vector2.new, Color3.new, Drawing.new
local tan, rad = math.tan, math.rad
local round = function(...) local a = {}; for i,v in next, table.pack(...) do a[i] = math.round(v); end return unpack(a); end
local wtvp = function(...) local a, b = camera.WorldToViewportPoint(camera, ...) return newVector2(a.X, a.Y), b, a.Z end
local espCache = {}
local function createEsp(player)
    local drawings = {}
    
    drawings.box = newDrawing("Square")
    drawings.box.Thickness = 1  -- Thin lines for the box
    drawings.box.Filled = false
    drawings.box.Color = settings.defaultcolor
    drawings.box.Visible = false  -- Initially hide the box
    drawings.box.ZIndex = 2
    drawings.boxoutline = newDrawing("Square")
    drawings.boxoutline.Thickness = 2  -- Thinner outline
    drawings.boxoutline.Filled = false
    drawings.boxoutline.Color = settings.defaultcolor
    drawings.boxoutline.Visible = false  -- Initially hide the outline
    drawings.boxoutline.ZIndex = 1
    drawings.username = newDrawing("Text")
    drawings.username.Size = 24  -- Increased font size for the username (adjust as needed)
    drawings.username.Color = settings.defaultcolor
    drawings.username.Center = true  -- Center align the text
    drawings.username.Outline = true  -- Add outline to text for readability
    drawings.username.Visible = false  -- Initially hide the username
    drawings.username.ZIndex = 3  -- Above the box and outline
    espCache[player] = drawings
end
local function removeEsp(player)
    local drawings = espCache[player]
    if drawings then
        for _, drawing in pairs(drawings) do
            drawing:Remove()
        end
        espCache[player] = nil
    end
end
local function updateEsp(player, esp)
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if humanoid and rootPart then
            local cframe = rootPart.CFrame
            local position, visible, depth = wtvp(cframe.Position)
            esp.box.Visible = settings.showBox and visible
            esp.boxoutline.Visible = settings.showBox and visible
            esp.username.Visible = settings.showName and visible
            if cframe and visible then
                local scaleFactor = 1 / (depth * tan(rad(camera.FieldOfView / 2)) * 2) * 800  -- Decreased scaleFactor to make boxes slightly smaller
                local width, height = round(2.5 * scaleFactor, 3.5 * scaleFactor)  -- Adjusted values for slightly smaller boxes
                local x, y = round(position.X, position.Y)
                esp.box.Size = newVector2(width, height)
                esp.box.Position = newVector2(round(x - width / 2), round(y - height / 2))
                esp.box.Color = settings.defaultcolor  -- White color for box
                esp.boxoutline.Size = esp.box.Size
                esp.boxoutline.Position = esp.box.Position
                esp.boxoutline.Color = settings.defaultcolor  -- White color for outline
                -- Position the username above the box
                esp.username.Position = newVector2(round(x), round(y - height / 2 - 25))  -- Adjust the offset as needed
                esp.username.Text = player.Name  -- Display player's username
                esp.username.Color = settings.defaultcolor  -- White color for username
            end
        end
    else
        esp.box.Visible = false
        esp.boxoutline.Visible = false
        esp.username.Visible = false
    end
end
-- Create ESP for existing players
for _, player in ipairs(players:GetPlayers()) do
    if player ~= localPlayer then
        createEsp(player)
    end
end
-- Connect events for new players joining or leaving
players.PlayerAdded:Connect(function(player)
    createEsp(player)
end)
players.PlayerRemoving:Connect(function(player)
    removeEsp(player)
end)
-- Update ESP every render step
runService.RenderStepped:Connect(function()
    for player, drawings in pairs(espCache) do
        if settings.teamcheck and player.Team == localPlayer.Team then
            continue
        end
        if drawings and player ~= localPlayer then
            updateEsp(player, drawings)
        end
    end
end)
-- Toggle for enabling/disabling Box in ESP
local ESPBoxToggle = ESPTab:AddToggle("Box", false, function(enabled)
    settings.showBox = enabled
    for player, drawings in pairs(espCache) do
        if drawings then
            drawings.box.Visible = settings.showBox
            drawings.boxoutline.Visible = settings.showBox
        end
    end
end)
-- Toggle for enabling/disabling Name in ESP

-- Create a section named "Textures" in the "Misc" tab

-- Variables to store original materials and colors
local OriginalMaterials = {}
local OriginalColors = {}
-- Function to recursively change material and color of all parts in a model
local function changeParts(model, applyChanges)
    for _, part in ipairs(model:GetChildren()) do
        if part:IsA("BasePart") then
            -- Check if the part is not part of a player's character
            local isPlayerCharacter = false
            for _, player in ipairs(game.Players:GetPlayers()) do
                if part:IsDescendantOf(player.Character) then
                    isPlayerCharacter = true
                    break
                end
            end
            
            if not isPlayerCharacter then
                if applyChanges then
                    -- Store original material and color if applying changes
                    OriginalMaterials[part] = part.Material
                    OriginalColors[part] = part.Color
                    
                    -- Apply new material and color
                    part.Material = Enum.Material.Brick
                    part.Color = Color3.new(1, 1, 1) -- White color
                else
                    -- Revert to original material and color
                    if OriginalMaterials[part] then
                        part.Material = OriginalMaterials[part]
                        part.Color = OriginalColors[part]
                    end
                end
            end
        end
        -- Recursively apply to child models
        changeParts(part, applyChanges)
    end
end
-- Add a toggle button in the "Textures" section to enable/disable the material script
local MaterialScriptToggle = TexturesSection:AddToggle("Bricks with snow", false, function(enabled)
    if enabled then
        -- Enable the material script
        changeParts(game.Workspace, true)
    else
        -- Disable the material script and revert changes
        changeParts(game.Workspace, false)
    end
end)
-- Variables to store original materials and colors
local OriginalMaterials = {}
local OriginalColors = {}
-- Function to recursively change material and preserve color of all parts in a model
local function changePartsToSand(model, applyChanges)
    for _, part in ipairs(model:GetChildren()) do
        if part:IsA("BasePart") then
            -- Check if the part is not part of a player's character
            local isPlayerCharacter = false
            for _, player in ipairs(game.Players:GetPlayers()) do
                if part:IsDescendantOf(player.Character) then
                    isPlayerCharacter = true
                    break
                end
            end
            
            if not isPlayerCharacter then
                if applyChanges then
                    -- Store original material and color if applying changes
                    OriginalMaterials[part] = part.Material
                    OriginalColors[part] = part.Color
                    
                    -- Apply new material (Sand) and preserve original color
                    part.Material = Enum.Material.Sand
                else
                    -- Revert to original material and color
                    if OriginalMaterials[part] then
                        part.Material = OriginalMaterials[part]
                        part.Color = OriginalColors[part]
                    end
                end
            end
        end
        -- Recursively apply to child models
        changePartsToSand(part, applyChanges)
    end
end
-- Add a toggle button in the "Textures" section to enable/disable the sand material script
local SandMaterialToggle = TexturesSection:AddToggle("Sand", false, function(enabled)
    if enabled then
        -- Enable the sand material script
        changePartsToSand(game.Workspace, true)
    else
        -- Disable the sand material script and revert changes
        changePartsToSand(game.Workspace, false)
    end
end)
-- Create a new tab named "misc"
local MiscTab = Window:CreateTab("Misc")
-- Create a section named "cframe" in the "misc" tab
local CFrameSection = MiscTab:CreateSector("CFrame", "left") -- Renamed section for clarity
-- Add variables needed
local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService('RunService')
local MovementEnabled = false
local Multiplier = 0.5
local MovementConnection  -- Variable to hold the connection
-- Add a toggle button in the "cframe" section to enable/disable the CFrame script
local CFScriptToggle = CFrameSection:AddToggle("Enable", false, function(enabled)
    MovementEnabled = enabled
    if MovementEnabled then
        -- Start script when enabled
        MovementConnection = RunService.Stepped:Connect(function()
            if MovementEnabled then
                LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame +
                    LocalPlayer.Character.Humanoid.MoveDirection * Multiplier
            else
                MovementConnection:Disconnect()  -- Disconnect if somehow enabled state changes
            end
        end)
    else
        -- Stop script when disabled
        if MovementConnection then
            MovementConnection:Disconnect()
        end
    end
end)
-- Add a textbox to control the speed multiplier
CFrameSection:AddTextbox("Speed", tostring(Multiplier), function(speed)
    Multiplier = tonumber(speed) or Multiplier
end)
local gunPosSection = MiscTab:CreateSector("Gun Pos", "right")  -- Changed section name to "Gun Pos"
local yValueTextbox = gunPosSection:AddTextbox("Y Value", "0", function(newValue)
    local newY = tonumber(newValue)
    if newY then
        local plr = game.Players.LocalPlayer
        local tool = plr.Character:FindFirstChildOfClass("Tool")
        if tool then
            tool.GripPos = Vector3.new(0, newY, 0)
        end
    else
        warn("Invalid Y value entered!")
    end
end)
-- New button with label "Reset Gun Pos"
local resetGunPosButton = gunPosSection:AddButton("Reset Gun Pos", function()
    local plr = game.Players.LocalPlayer
    local tool = plr.Character:FindFirstChildOfClass("Tool")
    if tool then
        -- Reset GripPos to original value (adjust as needed)
        tool.GripPos = Vector3.new(0, 0, 0)  -- Reset to original position
    else
        warn("Tool not found in character!")
    end
end)
local gui = Instance.new("ScreenGui")
gui.Name = "DraggableGUI"
gui.ResetOnSpawn = false
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
-- Calculate the size of the square frame
local size = 30
local halfSize = size / 2
-- Create a Frame for the square
local frame = Instance.new("Frame")
frame.Name = "DraggableFrame"
frame.Size = UDim2.new(0, size, 0, size)
frame.Position = UDim2.new(0, 10, 0, 95)  -- Positioned a bit lower
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.Parent = gui
-- Create a white TextLabel inside the frame
local label = Instance.new("TextLabel")
label.Name = "RCLabel"
label.Size = UDim2.new(1, 0, 1, 0)
label.Position = UDim2.new(0, 0, 0, 0)
label.Text = "RC"
label.TextColor3 = Color3.new(1, 1, 1)
label.BackgroundTransparency = 1
label.Font = Enum.Font.GothamSemibold
label.TextSize = 13
label.Parent = frame
-- Function to handle touch input for dragging
local function enableDrag(frame)
    local dragging
    local dragInput
    local dragStart
    local startPos
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and dragging then
            dragInput = input
            update(dragInput)
        end
    end)
end
-- Function to send the keybind
local function OnFrameClick()
    local vim = game:GetService("VirtualInputManager")
    vim:SendKeyEvent(true, "ButtonL2", false, game)
end
-- Connect the click event for the frame
frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        OnFrameClick()
    end
end)
-- Enable dragging for the frame
enableDrag(frame)
local OthersSection = MiscTab:CreateSector("Others", "right")
local RCEnabled = false  -- Variable to track if RC GUI is enabled
OthersSection:AddToggle("Right click", RCEnabled, function(enabled)
    RCEnabled = enabled
    gui.Enabled = enabled
end)
OthersSection:AddToggle("Auto stomp", ToggleEnabled, function(enabled)
    ToggleEnabled = enabled
    if enabled then
        while ToggleEnabled do
            wait()
            game.ReplicatedStorage.MainEvent:FireServer("Stomp")
        end
    end
end)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/cat"))()
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
-- Get the player and the player's player GUI
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
-- Create a ScreenGui to hold our GUI elements
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CameraRotationGui"
screenGui.ResetOnSpawn = false  -- Ensures the GUI doesn't reset on player respawn
screenGui.Enabled = false  -- Start hidden
screenGui.Parent = playerGui
-- Calculate the size of the outer frame
local outerSize = 150  -- Adjust this value to change the size of the outer frame (width only)
local outerHeight = 60  -- Adjust this value for the height of the outer frame
local halfOuterSize = outerSize / 2
-- Create an outer Frame for the 360 rotation control
local outerFrame = Instance.new("Frame")
outerFrame.Name = "OuterFrame"
outerFrame.Size = UDim2.new(0, outerSize, 0, outerHeight)  -- Size of the outer frame
outerFrame.Position = UDim2.new(0.5, -halfOuterSize, 0, 0)  -- Centered position of the frame
outerFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Black color
outerFrame.BorderSizePixel = 2
outerFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)  -- White border color
outerFrame.Parent = screenGui
-- Create a Frame for the 360 rotation control
local frame = Instance.new("Frame")
frame.Name = "ControlFrame"
frame.Size = UDim2.new(0, 120, 0, 50)  -- Reduced width of the frame
frame.Position = UDim2.new(0.5, -60, 0, 5)  -- Centered position within the outer frame
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)  -- Background color
frame.BorderSizePixel = 0
frame.Parent = outerFrame
-- Create a TextButton inside the frame
local button = Instance.new("TextButton")
button.Name = "360"
button.Size = UDim2.new(1, 0, 1, 0)
button.Position = UDim2.new(0, 0, 0, 0)
button.Text = "360"
button.Parent = frame
button.TextColor3 = Color3.fromRGB(255, 255, 255)  -- White text color
button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Black background color
-- Configuration settings
local Toggle = false
local RotationSpeed = 10000 -- Degrees per second
local Keybind = Enum.KeyCode.R -- Change this to your desired keybind
-- Variables for rotation logic
local LastRenderTime = 0
local FullCircleRotation = 2 * math.pi
local TotalRotation = 0
local InitialCFrame
-- Function to handle button clicks
local function OnButtonClick()
    Toggle = not Toggle
    if Toggle then
        InitialCFrame = Camera.CFrame
    else
        Camera.CFrame = InitialCFrame
        TotalRotation = 0
    end
    button.Text = Toggle and "360" or "360"
end
button.MouseButton1Click:Connect(OnButtonClick)
-- Function to handle key presses
local function OnKeyPress(Input, GameProcessedEvent)
    if Input.KeyCode == Keybind and not GameProcessedEvent then 
        Toggle = not Toggle
        if Toggle then
            InitialCFrame = Camera.CFrame
        else
            Camera.CFrame = InitialCFrame
            TotalRotation = 0
        end
        button.Text = Toggle and "360" or "360"
    end
end
UserInputService.InputBegan:Connect(OnKeyPress)
-- Function to rotate the camera
local function RotateCamera()
    if Toggle then
        local CurrentTime = tick()
        local TimeDelta = math.min(CurrentTime - LastRenderTime, 0.01)
        LastRenderTime = CurrentTime
        local Rotation = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), math.rad(RotationSpeed * TimeDelta))
        Camera.CFrame = Camera.CFrame * Rotation
        TotalRotation = TotalRotation + math.rad(RotationSpeed * TimeDelta)
        if TotalRotation >= FullCircleRotation then
            Toggle = false
            Camera.CFrame = InitialCFrame
            TotalRotation = 0
            button.Text = "360"
        end
    end
end
RunService.RenderStepped:Connect(RotateCamera)
-- Function to handle dragging for both desktop and mobile
local function enableDrag(frame)
    local dragging
    local dragInput
    local dragStart
    local startPos
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            dragInput = input
            update(dragInput)
        end
    end)
end
-- Enable dragging for the outer frame
enableDrag(outerFrame)
local toggleShow360GUI = OthersSection:AddToggle("360 button", false, function(enabled)
    screenGui.Enabled = enabled
end)
local TeleportSection = MiscTab:CreateSector("Teleports", "left") -- Renamed section for clarity
TeleportSection:AddButton("Uphill Guns", function(enabled)
  game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(481.3045959472656, 48.07050323486328, -620.1513671875)
end)
TeleportSection:AddButton("Downhill Guns", function(enabled)
  game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-578.5796508789062, 8.314779281616211, -736.3884887695312)
end)
TeleportSection:AddButton("Hood fitness", function(enabled)
  game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-76.4957275390625, 22.700284957885742, -630.9816284179688)
end)
TeleportSection:AddButton("Bank", function(enabled)
  game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-432.1439208984375, 38.9649658203125, -284.1016540527344)
end)
TeleportSection:AddButton("Bar", function(enabled)
  game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-264.5504455566406, 48.52669143676758, -446.29254150390625)
end)
TeleportSection:AddButton("Da furniture", function(enabled)
  game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-489.1640319824219, 21.8498477935791, -76.60957336425781)
end)
TeleportSection:AddButton("Da casino", function(enabled)
  game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-863.4664306640625, 21.59995460510254, -152.92788696289062)
end)
TeleportSection:AddButton("School", function(enabled)
  game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-531.3531494140625, 21.74999237060547, 252.47506713867188)
end)
TeleportSection:AddButton("Da Theatre", function(enabled)
  game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1004.9942626953125, 25.10002326965332, -135.17315673828125)
end)
TeleportSection:AddButton("FoodsMart", function(enabled)
  game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-906.5833740234375, 22.005002975463867, -653.2225952148438)
end)
TeleportSection:AddButton("Basketball Court", function(enabled)
  game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-896.5643310546875, 21.999818801879883, -528.7317504882812)
end)
TeleportSection:AddButton("Military", function(enabled)
  game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-50.412960052490234, 25.25499725341797, -868.921142578125)
end)
local ConfigsTab = Window:CreateTab("Configs")
ConfigsTab:CreateConfigSystem("right") --this is the config system