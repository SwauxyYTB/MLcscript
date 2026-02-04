-- MUSCLE LEGENDS SCRIPT - VERSION COMPLÈTE
-- Toutes les fonctionnalités incluses

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- États globaux
_G.scriptStates = _G.scriptStates or {}
local playerWhitelist = {}
local targetPlayerNames = {}

-- Création de l'interface principale
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MuscleLegendsHub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(139, 0, 0)
MainFrame.Position = UDim2.new(0.25, 0, 0.15, 0)
MainFrame.Size = UDim2.new(0, 600, 0, 450)
MainFrame.Active = true
MainFrame.Draggable = true

-- Titre
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
TitleLabel.BorderSizePixel = 0
TitleLabel.Size = UDim2.new(1, 0, 0, 35)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "SL HUB - MUSCLE LEGENDS"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18

-- Bouton fermer
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "Close"
CloseButton.Parent = TitleLabel
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -30, 0, 2.5)
CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Container pour les onglets
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Parent = MainFrame
TabContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TabContainer.BorderSizePixel = 0
TabContainer.Position = UDim2.new(0, 0, 0, 35)
TabContainer.Size = UDim2.new(0, 120, 1, -35)

local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ContentContainer.BorderSizePixel = 0
ContentContainer.Position = UDim2.new(0, 120, 0, 35)
ContentContainer.Size = UDim2.new(1, -120, 1, -35)

-- Système d'onglets
local currentTab = nil
local tabs = {}

local function createTab(name)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name
    TabButton.Parent = TabContainer
    TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    TabButton.BorderSizePixel = 0
    TabButton.Position = UDim2.new(0, 5, 0, 5 + (#tabs * 35))
    TabButton.Size = UDim2.new(1, -10, 0, 30)
    TabButton.Font = Enum.Font.SourceSans
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.TextSize = 14
    
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name .. "Content"
    TabContent.Parent = ContentContainer
    TabContent.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabContent.BorderSizePixel = 0
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.ScrollBarThickness = 4
    TabContent.Visible = false
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = TabContent
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)
    
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContent.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
    end)
    
    TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(tabs) do
            tab.content.Visible = false
            tab.button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end
        TabContent.Visible = true
        TabButton.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
        currentTab = TabContent
    end)
    
    table.insert(tabs, {button = TabButton, content = TabContent})
    return TabContent
end

-- Fonction pour créer un toggle
local function createToggle(parent, name, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name
    ToggleFrame.Parent = parent
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Size = UDim2.new(1, -10, 0, 35)
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Parent = ToggleFrame
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
    ToggleLabel.Size = UDim2.new(0.7, -10, 1, 0)
    ToggleLabel.Font = Enum.Font.SourceSans
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    ToggleLabel.TextSize = 14
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Parent = ToggleFrame
    ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Position = UDim2.new(0.7, 0, 0.15, 0)
    ToggleButton.Size = UDim2.new(0.25, -10, 0.7, 0)
    ToggleButton.Font = Enum.Font.SourceSansBold
    ToggleButton.Text = "OFF"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 12
    
    local isEnabled = false
    ToggleButton.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        if isEnabled then
            ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            ToggleButton.Text = "ON"
        else
            ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
            ToggleButton.Text = "OFF"
        end
        callback(isEnabled)
    end)
    
    return ToggleButton
end

-- Fonction pour créer un bouton
local function createButton(parent, name, callback)
    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Parent = parent
    Button.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
    Button.BorderSizePixel = 0
    Button.Size = UDim2.new(1, -10, 0, 35)
    Button.Font = Enum.Font.SourceSansBold
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.MouseButton1Click:Connect(callback)
    return Button
end

-- Fonction pour créer un label
local function createLabel(parent, text)
    local Label = Instance.new("TextLabel")
    Label.Parent = parent
    Label.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Label.BorderSizePixel = 0
    Label.Size = UDim2.new(1, -10, 0, 30)
    Label.Font = Enum.Font.SourceSansBold
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 14
    return Label
end

-- Fonction pour créer une textbox
local function createTextBox(parent, placeholder, callback)
    local TextBox = Instance.new("TextBox")
    TextBox.Parent = parent
    TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TextBox.BorderSizePixel = 1
    TextBox.BorderColor3 = Color3.fromRGB(139, 0, 0)
    TextBox.Size = UDim2.new(1, -10, 0, 35)
    TextBox.Font = Enum.Font.SourceSans
    TextBox.PlaceholderText = placeholder
    TextBox.Text = ""
    TextBox.TextColor3 = Color3.fromRGB(220, 220, 220)
    TextBox.TextSize = 14
    TextBox.FocusLost:Connect(function(enterPressed)
        if enterPressed and TextBox.Text ~= "" then
            callback(TextBox.Text)
            TextBox.Text = ""
        end
    end)
    return TextBox
end

-- ONGLET FARMS
local FarmTab = createTab("Farms")
createLabel(FarmTab, "=== Farming Features ===")

-- Auto Eat Egg
createToggle(FarmTab, "Auto Eat Egg", function(state)
    _G.scriptStates.autoEatEgg = state
    task.spawn(function()
        while _G.scriptStates.autoEatEgg do
            pcall(function()
                local egg = LocalPlayer.Backpack:FindFirstChild("Protein Egg")
                if egg and LocalPlayer.Character then
                    egg.Parent = LocalPlayer.Character
                    egg:Activate()
                end
            end)
            task.wait(1800)
        end
    end)
end)

-- Auto Farm
createToggle(FarmTab, "Auto Farm (Equip Any Tool)", function(state)
    _G.scriptStates.autoFarm = state
    task.spawn(function()
        while _G.scriptStates.autoFarm do
            pcall(function()
                LocalPlayer.muscleEvent:FireServer("rep")
            end)
            task.wait(0.2)
        end
    end)
end)

createLabel(FarmTab, "=== Auto Equip Tools ===")

-- Weight
createToggle(FarmTab, "Weight", function(state)
    task.spawn(function()
        while state do
            pcall(function()
                local tool = LocalPlayer.Backpack:FindFirstChild("Weight")
                if tool and LocalPlayer.Character then
                    tool.Parent = LocalPlayer.Character
                end
            end)
            task.wait(0.1)
        end
    end)
end)

-- Pushups
createToggle(FarmTab, "Pushups", function(state)
    task.spawn(function()
        while state do
            pcall(function()
                local tool = LocalPlayer.Backpack:FindFirstChild("Pushups")
                if tool and LocalPlayer.Character then
                    tool.Parent = LocalPlayer.Character
                end
            end)
            task.wait(0.1)
        end
    end)
end)

-- Handstand
createToggle(FarmTab, "Handstand", function(state)
    task.spawn(function()
        while state do
            pcall(function()
                local tool = LocalPlayer.Backpack:FindFirstChild("Handstand")
                if tool and LocalPlayer.Character then
                    tool.Parent = LocalPlayer.Character
                end
            end)
            task.wait(0.1)
        end
    end)
end)

-- Situps
createToggle(FarmTab, "Situps", function(state)
    task.spawn(function()
        while state do
            pcall(function()
                local tool = LocalPlayer.Backpack:FindFirstChild("Situps")
                if tool and LocalPlayer.Character then
                    tool.Parent = LocalPlayer.Character
                end
            end)
            task.wait(0.1)
        end
    end)
end)

-- ONGLET ROCK
local RockTab = createTab("Rock")
createLabel(RockTab, "=== Rock Farming ===")

local function createRockToggle(name, rockName, durabilityNeeded)
    createToggle(RockTab, name, function(state)
        _G.scriptStates["rock_" .. name] = state
        task.spawn(function()
            while _G.scriptStates["rock_" .. name] do
                pcall(function()
                    if LocalPlayer.Durability.Value >= durabilityNeeded then
                        for _, v in pairs(workspace.machinesFolder:GetDescendants()) do
                            if v.Name == "neededDurability" and v.Value == durabilityNeeded then
                                if LocalPlayer.Character:FindFirstChild("LeftHand") and LocalPlayer.Character:FindFirstChild("RightHand") then
                                    firetouchinterest(v.Parent.Rock, LocalPlayer.Character.RightHand, 0)
                                    firetouchinterest(v.Parent.Rock, LocalPlayer.Character.RightHand, 1)
                                    firetouchinterest(v.Parent.Rock, LocalPlayer.Character.LeftHand, 0)
                                    firetouchinterest(v.Parent.Rock, LocalPlayer.Character.LeftHand, 1)
                                    
                                    -- Equiper Punch
                                    local punch = LocalPlayer.Backpack:FindFirstChild("Punch")
                                    if punch and LocalPlayer.Character:FindFirstChild("Humanoid") then
                                        LocalPlayer.Character.Humanoid:EquipTool(punch)
                                    end
                                    LocalPlayer.muscleEvent:FireServer("punch", "leftHand")
                                    LocalPlayer.muscleEvent:FireServer("punch", "rightHand")
                                end
                            end
                        end
                    end
                end)
                task.wait()
            end
        end)
    end)
end

createRockToggle("Tiny Rock", "Tiny Island Rock", 0)
createRockToggle("Starter Rock", "Starter Island Rock", 100)
createRockToggle("Legend Beach Rock", "Legend Beach Rock", 5000)
createRockToggle("Frozen Rock", "Frost Gym Rock", 150000)
createRockToggle("Mythical Rock", "Mythical Gym Rock", 400000)
createRockToggle("Eternal Rock", "Eternal Gym Rock", 750000)
createRockToggle("Legend Rock", "Legend Gym Rock", 1000000)
createRockToggle("Muscle King Rock", "Muscle King Gym Rock", 5000000)
createRockToggle("Jungle Rock", "Ancient Jungle Rock", 10000000)

-- ONGLET REBIRTHS
local RebirthTab = createTab("Rebirths")

local targetRebirthValue = 0
createTextBox(RebirthTab, "Enter Rebirth Target", function(text)
    local newValue = tonumber(text)
    if newValue and newValue > 0 then
        targetRebirthValue = newValue
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Target Updated",
            Text = "New target: " .. tostring(targetRebirthValue) .. " rebirths",
            Duration = 3
        })
    end
end)

createToggle(RebirthTab, "Auto Rebirth Target", function(state)
    _G.scriptStates.targetRebirth = state
    task.spawn(function()
        while _G.scriptStates.targetRebirth do
            pcall(function()
                local currentRebirths = LocalPlayer.leaderstats.Rebirths.Value
                if currentRebirths >= targetRebirthValue and targetRebirthValue > 0 then
                    _G.scriptStates.targetRebirth = false
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "Goal Reached!",
                        Text = "Reached " .. tostring(targetRebirthValue) .. " rebirths",
                        Duration = 5
                    })
                else
                    ReplicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                end
            end)
            task.wait(0.1)
        end
    end)
end)

createToggle(RebirthTab, "Auto Rebirth (Infinite)", function(state)
    _G.scriptStates.infiniteRebirth = state
    task.spawn(function()
        while _G.scriptStates.infiniteRebirth do
            pcall(function()
                ReplicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
            end)
            task.wait(0.1)
        end
    end)
end)

createToggle(RebirthTab, "Auto Size 1", function(state)
    _G.scriptStates.autoSize = state
    task.spawn(function()
        while _G.scriptStates.autoSize do
            pcall(function()
                ReplicatedStorage.rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 1)
            end)
            task.wait()
        end
    end)
end)

createToggle(RebirthTab, "Auto TP to Muscle King", function(state)
    _G.scriptStates.autoTPMK = state
    task.spawn(function()
        while _G.scriptStates.autoTPMK do
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-8646, 17, -5738)
                end
            end)
            task.wait()
        end
    end)
end)

createLabel(RebirthTab, "=== Auto Equip & Train ===")

createButton(RebirthTab, "Unlock AutoLift Gamepass", function()
    pcall(function()
        local gamepassFolder = ReplicatedStorage.gamepassIds
        for _, gamepass in pairs(gamepassFolder:GetChildren()) do
            local value = Instance.new("IntValue")
            value.Name = gamepass.Name
            value.Value = gamepass.Value
            value.Parent = LocalPlayer.ownedGamepasses
        end
    end)
end)

createToggle(RebirthTab, "Auto Weight (Train)", function(state)
    _G.scriptStates.autoWeight = state
    if state then
        pcall(function()
            local tool = LocalPlayer.Backpack:FindFirstChild("Weight")
            if tool and LocalPlayer.Character then
                LocalPlayer.Character.Humanoid:EquipTool(tool)
            end
        end)
    end
    task.spawn(function()
        while _G.scriptStates.autoWeight do
            pcall(function()
                LocalPlayer.muscleEvent:FireServer("rep")
            end)
            task.wait(0.1)
        end
    end)
end)

createToggle(RebirthTab, "Auto Pushups (Train)", function(state)
    _G.scriptStates.autoPushups = state
    if state then
        pcall(function()
            local tool = LocalPlayer.Backpack:FindFirstChild("Pushups")
            if tool and LocalPlayer.Character then
                LocalPlayer.Character.Humanoid:EquipTool(tool)
            end
        end)
    end
    task.spawn(function()
        while _G.scriptStates.autoPushups do
            pcall(function()
                LocalPlayer.muscleEvent:FireServer("rep")
            end)
            task.wait(0.1)
        end
    end)
end)

createToggle(RebirthTab, "Auto Handstands (Train)", function(state)
    _G.scriptStates.autoHandstands = state
    if state then
        pcall(function()
            local tool = LocalPlayer.Backpack:FindFirstChild("Handstands")
            if tool and LocalPlayer.Character then
                LocalPlayer.Character.Humanoid:EquipTool(tool)
            end
        end)
    end
    task.spawn(function()
        while _G.scriptStates.autoHandstands do
            pcall(function()
                LocalPlayer.muscleEvent:FireServer("rep")
            end)
            task.wait(0.1)
        end
    end)
end)

createToggle(RebirthTab, "Auto Situps (Train)", function(state)
    _G.scriptStates.autoSitups = state
    if state then
        pcall(function()
            local tool = LocalPlayer.Backpack:FindFirstChild("Situps")
            if tool and LocalPlayer.Character then
                LocalPlayer.Character.Humanoid:EquipTool(tool)
            end
        end)
    end
    task.spawn(function()
        while _G.scriptStates.autoSitups do
            pcall(function()
                LocalPlayer.muscleEvent:FireServer("rep")
            end)
            task.wait(0.1)
        end
    end)
end)

createToggle(RebirthTab, "Fast Tools", function(state)
    local defaultSpeeds = {
        {"Punch", "attackTime", state and 0 or 0.35},
        {"Ground Slam", "attackTime", state and 0 or 6},
        {"Stomp", "attackTime", state and 0 or 7},
        {"Handstands", "repTime", state and 0 or 1},
        {"Pushups", "repTime", state and 0 or 1},
        {"Weight", "repTime", state and 0 or 1},
        {"Situps", "repTime", state and 0 or 1}
    }
    
    for _, toolInfo in ipairs(defaultSpeeds) do
        pcall(function()
            local tool = LocalPlayer.Backpack:FindFirstChild(toolInfo[1])
            if tool and tool:FindFirstChild(toolInfo[2]) then
                tool[toolInfo[2]].Value = toolInfo[3]
            end
            if LocalPlayer.Character then
                local equippedTool = LocalPlayer.Character:FindFirstChild(toolInfo[1])
                if equippedTool and equippedTool:FindFirstChild(toolInfo[2]) then
                    equippedTool[toolInfo[2]].Value = toolInfo[3]
                end
            end
        end)
    end
end)

-- ONGLET PETS
local PetTab = createTab("Pets")
createLabel(PetTab, "=== Auto Open Pets ===")

local selectedPet = "Neon Guardian"
createTextBox(PetTab, "Pet Name (e.g., Neon Guardian)", function(text)
    selectedPet = text
end)

createToggle(PetTab, "Auto Open Pet", function(state)
    _G.scriptStates.autoOpenPet = state
    task.spawn(function()
        while _G.scriptStates.autoOpenPet do
            pcall(function()
                local pet = ReplicatedStorage.cPetShopFolder:FindFirstChild(selectedPet)
                if pet then
                    ReplicatedStorage.cPetShopRemote:InvokeServer(pet)
                end
            end)
            task.wait(0.1)
        end
    end)
end)

createLabel(PetTab, "=== Auto Open Auras ===")

local selectedAura = "Blue Aura"
createTextBox(PetTab, "Aura Name (e.g., Blue Aura)", function(text)
    selectedAura = text
end)

createToggle(PetTab, "Auto Open Aura", function(state)
    _G.scriptStates.autoOpenAura = state
    task.spawn(function()
        while _G.scriptStates.autoOpenAura do
            pcall(function()
                local aura = ReplicatedStorage.cPetShopFolder:FindFirstChild(selectedAura)
                if aura then
                    ReplicatedStorage.cPetShopRemote:InvokeServer(aura)
                end
            end)
            task.wait(0.1)
        end
    end)
end)

-- ONGLET KILL
local KillTab = createTab("Kill")
createLabel(KillTab, "=== Karma Features ===")

createToggle(KillTab, "Auto Good Karma", function(state)
    _G.scriptStates.autoGoodKarma = state
    task.spawn(function()
        while _G.scriptStates.autoGoodKarma do
            pcall(function()
                local character = LocalPlayer.Character
                local rightHand = character and character:FindFirstChild("RightHand")
                local leftHand = character and character:FindFirstChild("LeftHand")
                if rightHand and leftHand then
                    for _, target in ipairs(Players:GetPlayers()) do
                        if target ~= LocalPlayer then
                            local evilKarma = target:FindFirstChild("evilKarma")
                            local goodKarma = target:FindFirstChild("goodKarma")
                            if evilKarma and goodKarma and evilKarma.Value > goodKarma.Value then
                                local rootPart = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                                if rootPart then
                                    firetouchinterest(rightHand, rootPart, 1)
                                    firetouchinterest(leftHand, rootPart, 1)
                                    firetouchinterest(rightHand, rootPart, 0)
                                    firetouchinterest(leftHand, rootPart, 0)
                                end
                            end
                        end
                    end
                end
            end)
            task.wait(0.01)
        end
    end)
end)

createToggle(KillTab, "Auto Bad Karma", function(state)
    _G.scriptStates.autoBadKarma = state
    task.spawn(function()
        while _G.scriptStates.autoBadKarma do
            pcall(function()
                local character = LocalPlayer.Character
                local rightHand = character and character:FindFirstChild("RightHand")
                local leftHand = character and character:FindFirstChild("LeftHand")
                if rightHand and leftHand then
                    for _, target in ipairs(Players:GetPlayers()) do
                        if target ~= LocalPlayer then
                            local evilKarma = target:FindFirstChild("evilKarma")
                            local goodKarma = target:FindFirstChild("goodKarma")
                            if evilKarma and goodKarma and goodKarma.Value > evilKarma.Value then
                                local rootPart = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                                if rootPart then
                                    firetouchinterest(rightHand, rootPart, 1)
                                    firetouchinterest(leftHand, rootPart, 1)
                                    firetouchinterest(rightHand, rootPart, 0)
                                    firetouchinterest(leftHand, rootPart, 0)
                                end
                            end
                        end
                    end
                end
            end)
            task.wait(0.01)
        end
    end)
end)

createLabel(KillTab, "=== Whitelist ===")

createToggle(KillTab, "Auto Whitelist Friends", function(state)
    if state then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and LocalPlayer:IsFriendsWith(player.UserId) then
                playerWhitelist[player.Name] = true
            end
        end
    else
        for name in pairs(playerWhitelist) do
            local friend = Players:FindFirstChild(name)
            if friend and LocalPlayer:IsFriendsWith(friend.UserId) then
                playerWhitelist[name] = nil
            end
        end
    end
end)

createTextBox(KillTab, "Whitelist Player Name", function(text)
    local target = Players:FindFirstChild(text)
    if target then
        playerWhitelist[target.Name] = true
    end
end)

createTextBox(KillTab, "UnWhitelist Player Name", function(text)
    local target = Players:FindFirstChild(text)
    if target then
        playerWhitelist[target.Name] = nil
    end
end)

createLabel(KillTab, "=== Kill Features ===")

createToggle(KillTab, "Auto Kill All", function(state)
    _G.scriptStates.autoKill = state
    task.spawn(function()
        while _G.scriptStates.autoKill do
            pcall(function()
                local character = LocalPlayer.Character
                local rightHand = character and character:FindFirstChild("RightHand")
                local leftHand = character and character:FindFirstChild("LeftHand")
                
                local punch = LocalPlayer.Backpack:FindFirstChild("Punch")
                if punch and character then
                    punch.Parent = character
                end
                
                if rightHand and leftHand then
                    for _, target in ipairs(Players:GetPlayers()) do
                        if target ~= LocalPlayer and not playerWhitelist[target.Name] then
                            local rootPart = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                            if rootPart then
                                firetouchinterest(rightHand, rootPart, 1)
                                firetouchinterest(leftHand, rootPart, 1)
                                firetouchinterest(rightHand, rootPart, 0)
                                firetouchinterest(leftHand, rootPart, 0)
                            end
                        end
                    end
                end
            end)
            task.wait(0.05)
        end
    end)
end)

createTextBox(KillTab, "Add Kill Target", function(text)
    if text and not table.find(targetPlayerNames, text) then
        table.insert(targetPlayerNames, text)
    end
end)

createTextBox(KillTab, "Remove Kill Target", function(text)
    for i, v in ipairs(targetPlayerNames) do
        if v == text then
            table.remove(targetPlayerNames, i)
            break
        end
    end
end)

createToggle(KillTab, "Start Kill Targets", function(state)
    _G.scriptStates.killTargets = state
    task.spawn(function()
        while _G.scriptStates.killTargets do
            pcall(function()
                local character = LocalPlayer.Character
                local punch = LocalPlayer.Backpack:FindFirstChild("Punch")
                if punch and character then
                    punch.Parent = character
                end
                
                local rightHand = character and character:FindFirstChild("RightHand")
                local leftHand = character and character:FindFirstChild("LeftHand")
                
                if rightHand and leftHand then
                    for _, name in ipairs(targetPlayerNames) do
                        local target = Players:FindFirstChild(name)
                        if target and target ~= LocalPlayer then
                            local rootPart = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                            if rootPart then
                                firetouchinterest(rightHand, rootPart, 1)
                                firetouchinterest(leftHand, rootPart, 1)
                                firetouchinterest(rightHand, rootPart, 0)
                                firetouchinterest(leftHand, rootPart, 0)
                            end
                        end
                    end
                end
            end)
            task.wait(0.05)
        end
    end)
end)

createLabel(KillTab, "=== Punch Features ===")

createToggle(KillTab, "Auto Equip Punch", function(state)
    task.spawn(function()
        while state do
            pcall(function()
                local punch = LocalPlayer.Backpack:FindFirstChild("Punch")
                if punch and LocalPlayer.Character then
                    punch.Parent = LocalPlayer.Character
                end
            end)
            task.wait(0.1)
        end
    end)
end)

createToggle(KillTab, "Auto Punch (No Animation)", function(state)
    _G.scriptStates.autoPunchNoAnim = state
    task.spawn(function()
        while _G.scriptStates.autoPunchNoAnim do
            pcall(function()
                local punch = LocalPlayer.Backpack:FindFirstChild("Punch") or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Punch"))
                if punch then
                    if punch.Parent ~= LocalPlayer.Character then
                        punch.Parent = LocalPlayer.Character
                    end
                    LocalPlayer.muscleEvent:FireServer("punch", "rightHand")
                    LocalPlayer.muscleEvent:FireServer("punch", "leftHand")
                end
            end)
            task.wait(0.01)
        end
    end)
end)

createToggle(KillTab, "Auto Punch", function(state)
    _G.scriptStates.autoPunch = state
    if state then
        task.spawn(function()
            while _G.scriptStates.autoPunch do
                pcall(function()
                    local punch = LocalPlayer.Backpack:FindFirstChild("Punch")
                    if punch and LocalPlayer.Character then
                        punch.Parent = LocalPlayer.Character
                        if punch:FindFirstChild("attackTime") then
                            punch.attackTime.Value = 0
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
        task.spawn(function()
            while _G.scriptStates.autoPunch do
                pcall(function()
                    local punch = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Punch")
                    if punch then
                        punch:Activate()
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
end)

createToggle(KillTab, "Fast Punch", function(state)
    _G.scriptStates.fastPunch = state
    if state then
        task.spawn(function()
            while _G.scriptStates.fastPunch do
                pcall(function()
                    local punch = LocalPlayer.Backpack:FindFirstChild("Punch")
                    if punch and LocalPlayer.Character then
                        punch.Parent = LocalPlayer.Character
                        if punch:FindFirstChild("attackTime") then
                            punch.attackTime.Value = 0
                        end
                    end
                end)
                task.wait()
            end
        end)
        task.spawn(function()
            while _G.scriptStates.fastPunch do
                pcall(function()
                    local punch = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Punch")
                    if punch then
                        punch:Activate()
                    end
                end)
                task.wait()
            end
        end)
    end
end)

createButton(KillTab, "Remove Punch Animation", function()
    local blockedAnimations = {
        ["rbxassetid://3638729053"] = true,
        ["rbxassetid://3638767427"] = true,
    }
    
    local function setupAnimationBlocking()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("Humanoid") then return end
        
        local humanoid = char:FindFirstChild("Humanoid")
        
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            if track.Animation then
                local animId = track.Animation.AnimationId
                local animName = track.Name:lower()
                
                if blockedAnimations[animId] or animName:match("punch") or animName:match("attack") or animName:match("right") then
                    track:Stop()
                end
            end
        end
        
        if not _G.AnimBlockConnection then
            _G.AnimBlockConnection = humanoid.AnimationPlayed:Connect(function(track)
                if track.Animation then
                    local animId = track.Animation.AnimationId
                    local animName = track.Name:lower()
                    
                    if blockedAnimations[animId] or animName:match("punch") or animName:match("attack") or animName:match("right") then
                        track:Stop()
                    end
                end
            end)
        end
    end
    
    setupAnimationBlocking()
end)

createButton(KillTab, "Recover Punch Animation", function()
    if _G.AnimBlockConnection then
        _G.AnimBlockConnection:Disconnect()
        _G.AnimBlockConnection = nil
    end
end)

-- ONGLET SPY STATS
local SpyTab = createTab("Spy Stats")

local selectedPlayerName = ""
createTextBox(SpyTab, "Enter Player Name to Spy", function(text)
    selectedPlayerName = text
end)

local statLabels = {}
for i = 1, 13 do
    statLabels[i] = createLabel(SpyTab, "---")
end

task.spawn(function()
    while true do
        if selectedPlayerName ~= "" then
            pcall(function()
                local player = Players:FindFirstChild(selectedPlayerName)
                if player then
                    local function formatNumber(num)
                        if num >= 1000000000 then
                            return string.format("%.2fB", num / 1000000000)
                        elseif num >= 1000000 then
                            return string.format("%.2fM", num / 1000000)
                        elseif num >= 1000 then
                            return string.format("%.2fK", num / 1000)
                        else
                            return tostring(num)
                        end
                    end
                    
                    if player:FindFirstChild("Gems") then
                        statLabels[1].Text = "Gems: " .. formatNumber(player.Gems.Value)
                    end
                    if player.leaderstats and player.leaderstats:FindFirstChild("Strength") then
                        statLabels[2].Text = "Strength: " .. formatNumber(player.leaderstats.Strength.Value)
                    end
                    if player:FindFirstChild("Agility") then
                        statLabels[3].Text = "Agility: " .. formatNumber(player.Agility.Value)
                    end
                    if player:FindFirstChild("Durability") then
                        statLabels[4].Text = "Durability: " .. formatNumber(player.Durability.Value)
                    end
                    if player.leaderstats and player.leaderstats:FindFirstChild("Rebirths") then
                        statLabels[5].Text = "Rebirths: " .. formatNumber(player.leaderstats.Rebirths.Value)
                    end
                    if player.leaderstats and player.leaderstats:FindFirstChild("Kills") then
                        statLabels[6].Text = "Kills: " .. formatNumber(player.leaderstats.Kills.Value)
                    end
                    if player:FindFirstChild("muscleKingTime") then
                        statLabels[7].Text = "MK Time: " .. formatNumber(player.muscleKingTime.Value)
                    end
                    if player:FindFirstChild("currentMap") then
                        statLabels[8].Text = "Map: " .. tostring(player.currentMap.Value)
                    end
                    if player:FindFirstChild("customSize") then
                        statLabels[9].Text = "Size: " .. formatNumber(player.customSize.Value)
                    end
                    if player:FindFirstChild("customSpeed") then
                        statLabels[10].Text = "Speed: " .. formatNumber(player.customSpeed.Value)
                    end
                    if player:FindFirstChild("evilKarma") then
                        statLabels[11].Text = "Evil Karma: " .. formatNumber(player.evilKarma.Value)
                    end
                    if player:FindFirstChild("goodKarma") then
                        statLabels[12].Text = "Good Karma: " .. formatNumber(player.goodKarma.Value)
                    end
                end
            end)
        end
        task.wait(0.5)
    end
end)

-- ONGLET TELEPORT
local TeleportTab = createTab("Teleport")
createLabel(TeleportTab, "=== Islands ===")

local function createTeleportButton(name, position)
    createButton(TeleportTab, name, function()
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(position)
            end
        end)
    end)
end

createTeleportButton("Spawn", Vector3.new(2, 8, 115))
createTeleportButton("Secret Area", Vector3.new(1947, 2, 6191))
createTeleportButton("Tiny Island", Vector3.new(-34, 7, 1903))
createTeleportButton("Frozen Island", Vector3.new(-2600, 3.67, -403.88))
createTeleportButton("Mythical Island", Vector3.new(2255, 7, 1071))
createTeleportButton("Hell Island", Vector3.new(-6768, 7, -1287))
createTeleportButton("Legend Island", Vector3.new(4604, 991, -3887))
createTeleportButton("Muscle King Island", Vector3.new(-8646, 17, -5738))
createTeleportButton("Jungle Island", Vector3.new(-8659, 6, 2384))

createLabel(TeleportTab, "=== Brawls ===")
createTeleportButton("Brawl Lava", Vector3.new(4471, 119, -8836))
createTeleportButton("Brawl Desert", Vector3.new(960, 17, -7398))
createTeleportButton("Brawl Regular", Vector3.new(-1849, 20, -6335))

-- ONGLET MISC
local MiscTab = createTab("Misc")
createLabel(MiscTab, "=== Utility ===")

createButton(MiscTab, "Anti AFK", function()
    local VirtualUser = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Anti AFK",
        Text = "Anti AFK enabled!",
        Duration = 3
    })
end)

createToggle(MiscTab, "Lock Position", function(state)
    if state then
        local currentPos = LocalPlayer.Character.HumanoidRootPart.CFrame
        _G.posLock = RunService.Heartbeat:Connect(function()
            if LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = currentPos
            end
        end)
    else
        if _G.posLock then
            _G.posLock:Disconnect()
            _G.posLock = nil
        end
    end
end)

createToggle(MiscTab, "Anti Knockback", function(state)
    if state then
        pcall(function()
            local rootPart = LocalPlayer.Character.HumanoidRootPart
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(100000, 0, 100000)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.P = 1250
            bodyVelocity.Parent = rootPart
        end)
    else
        pcall(function()
            local rootPart = LocalPlayer.Character.HumanoidRootPart
            local existingVelocity = rootPart:FindFirstChild("BodyVelocity")
            if existingVelocity then
                existingVelocity:Destroy()
            end
        end)
    end
end)

createButton(MiscTab, "Remove Portals", function()
    for _, portal in pairs(game:GetDescendants()) do
        if portal.Name == "RobloxForwardPortals" then
            portal:Destroy()
        end
    end
    
    if _G.AdRemovalConnection then
        _G.AdRemovalConnection:Disconnect()
    end
    
    _G.AdRemovalConnection = game.DescendantAdded:Connect(function(descendant)
        if descendant.Name == "RobloxForwardPortals" then
            descendant:Destroy()
        end
    end)
end)

createButton(MiscTab, "Change Time: Night", function()
    game:GetService("Lighting").ClockTime = 0
end)

createButton(MiscTab, "Change Time: Day", function()
    game:GetService("Lighting").ClockTime = 12
end)

createButton(MiscTab, "Change Time: Midnight", function()
    game:GetService("Lighting").ClockTime = 6
end)

createToggle(MiscTab, "Auto Fortune Wheel", function(state)
    _G.scriptStates.autoFortuneWheel = state
    task.spawn(function()
        while _G.scriptStates.autoFortuneWheel do
            pcall(function()
                local args = {
                    [1] = "openFortuneWheel",
                    [2] = ReplicatedStorage.fortuneWheelChances:WaitForChild("Fortune Wheel")
                }
                ReplicatedStorage.rEvents.openFortuneWheelRemote:InvokeServer(unpack(args))
            end)
            task.wait()
        end
    end)
end)

createToggle(MiscTab, "God Mode (Brawl)", function(state)
    _G.scriptStates.godMode = state
    task.spawn(function()
        while _G.scriptStates.godMode do
            pcall(function()
                ReplicatedStorage.rEvents.brawlEvent:FireServer("joinBrawl")
            end)
            task.wait()
        end
    end)
end)

createToggle(MiscTab, "Walk on Water", function(state)
    local parts = {}
    if state then
        local partSize = 2048
        local numberOfParts = 25
        local startPosition = Vector3.new(-2, -9.5, -2)
        
        for x = 0, numberOfParts - 1 do
            for z = 0, numberOfParts - 1 do
                local positions = {
                    startPosition + Vector3.new(x * partSize, 0, z * partSize),
                    startPosition + Vector3.new(-x * partSize, 0, z * partSize),
                    startPosition + Vector3.new(-x * partSize, 0, -z * partSize),
                    startPosition + Vector3.new(x * partSize, 0, -z * partSize)
                }
                
                for _, pos in ipairs(positions) do
                    local newPart = Instance.new("Part")
                    newPart.Size = Vector3.new(partSize, 1, partSize)
                    newPart.Position = pos
                    newPart.Anchored = true
                    newPart.Transparency = 1
                    newPart.CanCollide = true
                    newPart.Parent = workspace
                    table.insert(parts, newPart)
                end
            end
        end
        
        _G.waterParts = parts
    else
        if _G.waterParts then
            for _, part in ipairs(_G.waterParts) do
                if part and part.Parent then
                    part:Destroy()
                end
            end
            _G.waterParts = nil
        end
    end
end)

createToggle(MiscTab, "Auto Clear Inventory", function(state)
    _G.scriptStates.autoClearInv = state
    task.spawn(function()
        while _G.scriptStates.autoClearInv do
            pcall(function()
                local boosts = {"ULTRA Shake", "TOUGH Bar", "Protein Shake", "Energy Shake", "Protein Bar", "Energy Bar", "Tropical Shake"}
                for _, boostName in ipairs(boosts) do
                    local boost = LocalPlayer.Backpack:FindFirstChild(boostName)
                    while boost do
                        boost.Parent = LocalPlayer.Character
                        boost:Activate()
                        task.wait()
                        boost = LocalPlayer.Backpack:FindFirstChild(boostName)
                    end
                end
            end)
            task.wait(2)
        end
    end)
end)

-- ONGLET CREDITS
local CreditsTab = createTab("Credits")
createLabel(CreditsTab, "=== SL HUB ===")
createLabel(CreditsTab, "Made by SL_GHOST")
createLabel(CreditsTab, "Version: Complete")
createLabel(CreditsTab, "Made for SL CLAN")
createLabel(CreditsTab, "")
createLabel(CreditsTab, "All Features Included")
createLabel(CreditsTab, "No External Dependencies")

-- Ouvrir le premier onglet par défaut
if #tabs > 0 then
    tabs[1].button.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
    tabs[1].content.Visible = true
end

-- Notification de chargement
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "SL HUB - Muscle Legends",
    Text = "Script loaded successfully! All features included.",
    Duration = 5
})

print("SL HUB - Muscle Legends - Fully Loaded!")
