-- MUSCLE LEGENDS SCRIPT - VERSION AVEC LIBRAIRIE EXTERNE
-- Utilise la bibliothèque GUI de GitHub

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/SlGHOST0/SL-HUB-PUBLIC/refs/heads/main/GUI%20ML.txt", true))()
local window = library:AddWindow("SL HUB PUBLIC | MUSCLE LEGENDS | HAVE A GOOD DAY", {
    main_color = Color3.fromRGB(139, 0, 0),
    min_size = Vector2.new(700, 700),
    can_resize = true,
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Variables globales
local playerWhitelist = {}
local targetPlayerNames = {}
local targetRebirthValue = 0

-- ============================================
-- ONGLET FARMS
-- ============================================
local AutoFarm = window:AddTab("Farms")
AutoFarm:AddLabel("Farming Features")

-- Auto Eat Egg
local autoEatEnabled = false
local function eatProteinEgg()
    local backpack = LocalPlayer:WaitForChild("Backpack")
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local egg = backpack:FindFirstChild("Protein Egg")
    if egg then
        egg.Parent = character
        pcall(function()
            egg:Activate()
        end)
    end
end

task.spawn(function()
    while true do
        if autoEatEnabled then
            eatProteinEgg()
            task.wait(1800)
        else
            task.wait(1)
        end
    end
end)

AutoFarm:AddSwitch("Auto Eat Egg", function(state)
    autoEatEnabled = state
end)

-- Auto Farm
local repToggle = false
AutoFarm:AddSwitch("Auto Farm (Equip Any tool)", function(state)
    repToggle = state
    task.spawn(function()
        while repToggle do
            pcall(function()
                local args = {"rep"}
                LocalPlayer.muscleEvent:FireServer(unpack(args))
            end)
            task.wait(0.2)
        end
    end)
end)

-- Folder pour les outils
local folder1 = AutoFarm:AddFolder("Tools")

-- Weight
local weightOn = false
folder1:AddSwitch("Weight", function(bool)
    weightOn = bool
    task.spawn(function()
        while weightOn do
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
local pushupsOn = false
folder1:AddSwitch("Pushups", function(bool)
    pushupsOn = bool
    task.spawn(function()
        while pushupsOn do
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
local handstandOn = false
folder1:AddSwitch("Handstand", function(bool)
    handstandOn = bool
    task.spawn(function()
        while handstandOn do
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
local situpsOn = false
folder1:AddSwitch("Situps", function(bool)
    situpsOn = bool
    task.spawn(function()
        while situpsOn do
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

-- ============================================
-- ONGLET ROCK
-- ============================================
local Rock = window:AddTab("Rock")

function gettool()
    pcall(function()
        for i, v in pairs(LocalPlayer.Backpack:GetChildren()) do
            if v.Name == "Punch" and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid:EquipTool(v)
            end
        end
        LocalPlayer.muscleEvent:FireServer("punch", "leftHand")
        LocalPlayer.muscleEvent:FireServer("punch", "rightHand")
    end)
end

local function createRockSwitch(name, durabilityNeeded)
    Rock:AddSwitch(name, function(Value)
        getgenv().autoFarm = Value
        task.spawn(function()
            while getgenv().autoFarm do
                pcall(function()
                    if LocalPlayer.Durability.Value >= durabilityNeeded then
                        for i, v in pairs(workspace.machinesFolder:GetDescendants()) do
                            if v.Name == "neededDurability" and v.Value == durabilityNeeded then
                                if LocalPlayer.Character:FindFirstChild("LeftHand") and LocalPlayer.Character:FindFirstChild("RightHand") then
                                    firetouchinterest(v.Parent.Rock, LocalPlayer.Character.RightHand, 0)
                                    firetouchinterest(v.Parent.Rock, LocalPlayer.Character.RightHand, 1)
                                    firetouchinterest(v.Parent.Rock, LocalPlayer.Character.LeftHand, 0)
                                    firetouchinterest(v.Parent.Rock, LocalPlayer.Character.LeftHand, 1)
                                    gettool()
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

createRockSwitch("Tiny Rock", 0)
createRockSwitch("Starter Rock", 100)
createRockSwitch("Legend Beach Rock", 5000)
createRockSwitch("Frozen Rock", 150000)
createRockSwitch("Mythical Rock", 400000)
createRockSwitch("Eternal Rock", 750000)
createRockSwitch("Legend Rock", 1000000)
createRockSwitch("Muscle King Rock", 5000000)
createRockSwitch("Jungle Rock", 10000000)

-- ============================================
-- ONGLET REBIRTHS
-- ============================================
local rebirths = window:AddTab("Rebirths")

rebirths:AddTextBox("Rebirth Target", function(text)
    local newValue = tonumber(text)
    if newValue and newValue > 0 then
        targetRebirthValue = newValue
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Target Updated",
            Text = "New target: " .. tostring(targetRebirthValue) .. " rebirths",
            Duration = 3
        })
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Error",
            Text = "Put a size larger than 0",
            Duration = 3
        })
    end
end)

local infiniteSwitch
local targetSwitch = rebirths:AddSwitch("Auto Rebirth Target", function(bool)
    _G.targetRebirthActive = bool
    if bool then
        if _G.infiniteRebirthActive and infiniteSwitch then
            infiniteSwitch:Set(false)
            _G.infiniteRebirthActive = false
        end
        spawn(function()
            while _G.targetRebirthActive and wait(0.1) do
                pcall(function()
                    local currentRebirths = LocalPlayer.leaderstats.Rebirths.Value
                    if currentRebirths >= targetRebirthValue then
                        targetSwitch:Set(false)
                        _G.targetRebirthActive = false
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = "Goal Reached!",
                            Text = "Reached " .. tostring(targetRebirthValue) .. " rebirths",
                            Duration = 5
                        })
                    else
                        ReplicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                    end
                end)
            end
        end)
    end
end, "automatic rebirth until reaching the goal")

infiniteSwitch = rebirths:AddSwitch("Auto Rebirth (Infinitely)", function(bool)
    _G.infiniteRebirthActive = bool
    if bool then
        if _G.targetRebirthActive and targetSwitch then
            targetSwitch:Set(false)
            _G.targetRebirthActive = false
        end
        spawn(function()
            while _G.infiniteRebirthActive and wait(0.1) do
                pcall(function()
                    ReplicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                end)
            end
        end)
    end
end, "rebirth infinitely")

rebirths:AddSwitch("Auto Size 1", function(bool)
    _G.autoSizeActive = bool
    if bool then
        spawn(function()
            while _G.autoSizeActive and wait() do
                pcall(function()
                    ReplicatedStorage.rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 1)
                end)
            end
        end)
    end
end, "Size 1")

rebirths:AddSwitch("Auto Teleport to Muscle King", function(bool)
    _G.teleportActive = bool
    if bool then
        spawn(function()
            while _G.teleportActive and wait() do
                pcall(function()
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-8646, 17, -5738)
                    end
                end)
            end
        end)
    end
end, "Tp to Mk")

-- Folder Auto Equip Tools
local autoEquipToolsFolder = rebirths:AddFolder("Auto Equip Tools")

autoEquipToolsFolder:AddButton("Gamepass AutoLift", function()
    pcall(function()
        local gamepassFolder = ReplicatedStorage.gamepassIds
        for _, gamepass in pairs(gamepassFolder:GetChildren()) do
            local value = Instance.new("IntValue")
            value.Name = gamepass.Name
            value.Value = gamepass.Value
            value.Parent = LocalPlayer.ownedGamepasses
        end
    end)
end, "Unlock AutoLift Pass")

autoEquipToolsFolder:AddSwitch("Auto Weight", function(Value)
    _G.AutoWeight = Value
    if Value then
        pcall(function()
            local weightTool = LocalPlayer.Backpack:FindFirstChild("Weight")
            if weightTool and LocalPlayer.Character then
                LocalPlayer.Character.Humanoid:EquipTool(weightTool)
            end
        end)
    else
        pcall(function()
            local character = LocalPlayer.Character
            local equipped = character:FindFirstChild("Weight")
            if equipped then
                equipped.Parent = LocalPlayer.Backpack
            end
        end)
    end
    task.spawn(function()
        while _G.AutoWeight do
            pcall(function()
                LocalPlayer.muscleEvent:FireServer("rep")
            end)
            task.wait(0.1)
        end
    end)
end, "Auto Weight")

autoEquipToolsFolder:AddSwitch("Auto Pushups", function(Value)
    _G.AutoPushups = Value
    if Value then
        pcall(function()
            local pushupsTool = LocalPlayer.Backpack:FindFirstChild("Pushups")
            if pushupsTool and LocalPlayer.Character then
                LocalPlayer.Character.Humanoid:EquipTool(pushupsTool)
            end
        end)
    else
        pcall(function()
            local character = LocalPlayer.Character
            local equipped = character:FindFirstChild("Pushups")
            if equipped then
                equipped.Parent = LocalPlayer.Backpack
            end
        end)
    end
    task.spawn(function()
        while _G.AutoPushups do
            pcall(function()
                LocalPlayer.muscleEvent:FireServer("rep")
            end)
            task.wait(0.1)
        end
    end)
end, "Auto Pushups")

autoEquipToolsFolder:AddSwitch("Auto Handstands", function(Value)
    _G.AutoHandstands = Value
    if Value then
        pcall(function()
            local handstandsTool = LocalPlayer.Backpack:FindFirstChild("Handstands")
            if handstandsTool and LocalPlayer.Character then
                LocalPlayer.Character.Humanoid:EquipTool(handstandsTool)
            end
        end)
    else
        pcall(function()
            local character = LocalPlayer.Character
            local equipped = character:FindFirstChild("Handstands")
            if equipped then
                equipped.Parent = LocalPlayer.Backpack
            end
        end)
    end
    task.spawn(function()
        while _G.AutoHandstands do
            pcall(function()
                LocalPlayer.muscleEvent:FireServer("rep")
            end)
            task.wait(0.1)
        end
    end)
end, "Auto Handstands")

autoEquipToolsFolder:AddSwitch("Auto Situps", function(Value)
    _G.AutoSitups = Value
    if Value then
        pcall(function()
            local situpsTool = LocalPlayer.Backpack:FindFirstChild("Situps")
            if situpsTool and LocalPlayer.Character then
                LocalPlayer.Character.Humanoid:EquipTool(situpsTool)
            end
        end)
    else
        pcall(function()
            local character = LocalPlayer.Character
            local equipped = character:FindFirstChild("Situps")
            if equipped then
                equipped.Parent = LocalPlayer.Backpack
            end
        end)
    end
    task.spawn(function()
        while _G.AutoSitups do
            pcall(function()
                LocalPlayer.muscleEvent:FireServer("rep")
            end)
            task.wait(0.1)
        end
    end)
end, "Auto Situps")

autoEquipToolsFolder:AddSwitch("Auto Punch", function(Value)
    _G.fastHitActive = Value
    if Value then
        task.spawn(function()
            while _G.fastHitActive do
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
            while _G.fastHitActive do
                pcall(function()
                    LocalPlayer.muscleEvent:FireServer("punch", "rightHand")
                    LocalPlayer.muscleEvent:FireServer("punch", "leftHand")
                    local character = LocalPlayer.Character
                    if character then
                        local punchTool = character:FindFirstChild("Punch")
                        if punchTool then
                            punchTool:Activate()
                        end
                    end
                end)
                task.wait(0)
            end
        end)
    else
        pcall(function()
            local character = LocalPlayer.Character
            local equipped = character:FindFirstChild("Punch")
            if equipped then
                equipped.Parent = LocalPlayer.Backpack
            end
        end)
    end
end, "Auto Punch")

autoEquipToolsFolder:AddSwitch("Fast Tools", function(Value)
    _G.FastTools = Value
    local defaultSpeeds = {
        {"Punch", "attackTime", Value and 0 or 0.35},
        {"Ground Slam", "attackTime", Value and 0 or 6},
        {"Stomp", "attackTime", Value and 0 or 7},
        {"Handstands", "repTime", Value and 0 or 1},
        {"Pushups", "repTime", Value and 0 or 1},
        {"Weight", "repTime", Value and 0 or 1},
        {"Situps", "repTime", Value and 0 or 1}
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
end, "Speed up all tools")

-- ============================================
-- ONGLET PETS
-- ============================================
local pets = window:AddTab("Pets")

local selectedPet = "Neon Guardian"
local petDropdown = pets:AddDropdown("Select Pet", function(text)
    selectedPet = text
end)

-- Liste des pets
local petList = {
    "Neon Guardian", "Blue Birdie", "Blue Bunny", "Blue Firecaster", "Blue Pheonix",
    "Crimson Falcon", "Cybernetic Showdown Dragon", "Dark Golem", "Dark Legends Manticore",
    "Dark Vampy", "Darkstar Hunter", "Eternal Strike Leviathan", "Frostwave Legends Penguin",
    "Gold Warrior", "Golden Pheonix", "Golden Viking", "Green Butterfly", "Green Firecaster",
    "Infernal Dragon", "Lightning Strike Phantom", "Magic Butterfly", "Muscle Sensei",
    "Orange Hedgehog", "Orange Pegasus", "Phantom Genesis Dragon", "Purple Dragon",
    "Purple Falcon", "Red Dragon", "Red Firecaster", "Red Kitty", "Silver Dog",
    "Ultimate Supernova Pegasus", "Ultra Birdie", "White Pegasus", "White Pheonix",
    "Yellow Butterfly"
}

for _, pet in ipairs(petList) do
    petDropdown:Add(pet)
end

pets:AddSwitch("Auto Open Pet", function(bool)
    _G.AutoHatchPet = bool
    if bool then
        spawn(function()
            while _G.AutoHatchPet and selectedPet ~= "" do
                pcall(function()
                    local petToOpen = ReplicatedStorage.cPetShopFolder:FindFirstChild(selectedPet)
                    if petToOpen then
                        ReplicatedStorage.cPetShopRemote:InvokeServer(petToOpen)
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
end)

local selectedAura = "Blue Aura"
local auraDropdown = pets:AddDropdown("Select Aura", function(text)
    selectedAura = text
end)

-- Liste des auras
local auraList = {
    "Astral Electro", "Azure Tundra", "Blue Aura", "Dark Electro", "Dark Lightning",
    "Dark Storm", "Electro", "Enchanted Mirage", "Entropic Blast", "Eternal Megastrike",
    "Grand Supernova", "Green Aura", "Inferno", "Lightning", "Muscle King",
    "Power Lightning", "Purple Aura", "Purple Nova", "Red Aura", "Supernova",
    "Ultra Inferno", "Ultra Mirage", "Unstable Mirage", "Yellow Aura"
}

for _, aura in ipairs(auraList) do
    auraDropdown:Add(aura)
end

pets:AddSwitch("Auto Open Aura", function(bool)
    _G.AutoHatchAura = bool
    if bool then
        spawn(function()
            while _G.AutoHatchAura and selectedAura ~= "" do
                pcall(function()
                    local auraToOpen = ReplicatedStorage.cPetShopFolder:FindFirstChild(selectedAura)
                    if auraToOpen then
                        ReplicatedStorage.cPetShopRemote:InvokeServer(auraToOpen)
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
end)

-- ============================================
-- ONGLET KILL
-- ============================================
local Killer = window:AddTab("Kill")

Killer:AddSwitch("Auto Good Karma", function(bool)
    _G.autoGoodKarma = bool
    task.spawn(function()
        while _G.autoGoodKarma do
            pcall(function()
                local playerChar = LocalPlayer.Character
                local rightHand = playerChar and playerChar:FindFirstChild("RightHand")
                local leftHand = playerChar and playerChar:FindFirstChild("LeftHand")
                if playerChar and rightHand and leftHand then
                    for _, target in ipairs(Players:GetPlayers()) do
                        if target ~= LocalPlayer then
                            local evilKarma = target:FindFirstChild("evilKarma")
                            local goodKarma = target:FindFirstChild("goodKarma")
                            if evilKarma and goodKarma and evilKarma:IsA("IntValue") and goodKarma:IsA("IntValue") and evilKarma.Value > goodKarma.Value then
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

Killer:AddSwitch("Auto Bad Karma", function(bool)
    _G.autoBadKarma = bool
    task.spawn(function()
        while _G.autoBadKarma do
            pcall(function()
                local playerChar = LocalPlayer.Character
                local rightHand = playerChar and playerChar:FindFirstChild("RightHand")
                local leftHand = playerChar and playerChar:FindFirstChild("LeftHand")
                if playerChar and rightHand and leftHand then
                    for _, target in ipairs(Players:GetPlayers()) do
                        if target ~= LocalPlayer then
                            local evilKarma = target:FindFirstChild("evilKarma")
                            local goodKarma = target:FindFirstChild("goodKarma")
                            if evilKarma and goodKarma and evilKarma:IsA("IntValue") and goodKarma:IsA("IntValue") and goodKarma.Value > evilKarma.Value then
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

local friendWhitelistActive = false
Killer:AddSwitch("Auto Whitelist Friends", function(state)
    friendWhitelistActive = state
    if state then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and LocalPlayer:IsFriendsWith(player.UserId) then
                playerWhitelist[player.Name] = true
            end
        end
        Players.PlayerAdded:Connect(function(player)
            if friendWhitelistActive and player ~= LocalPlayer and LocalPlayer:IsFriendsWith(player.UserId) then
                playerWhitelist[player.Name] = true
            end
        end)
    else
        for name in pairs(playerWhitelist) do
            local friend = Players:FindFirstChild(name)
            if friend and LocalPlayer:IsFriendsWith(friend.UserId) then
                playerWhitelist[name] = nil
            end
        end
    end
end)

Killer:AddTextBox("Whitelist", function(text)
    local target = Players:FindFirstChild(text)
    if target then
        playerWhitelist[target.Name] = true
    end
end)

Killer:AddTextBox("UnWhitelist", function(text)
    local target = Players:FindFirstChild(text)
    if target then
        playerWhitelist[target.Name] = nil
    end
end)

Killer:AddSwitch("Auto Kill", function(bool)
    _G.autoKill = bool
    task.spawn(function()
        while _G.autoKill do
            pcall(function()
                local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local rightHand = character:FindFirstChild("RightHand")
                local leftHand = character:FindFirstChild("LeftHand")
                
                local punch = LocalPlayer.Backpack:FindFirstChild("Punch")
                if punch and not character:FindFirstChild("Punch") then
                    punch.Parent = character
                end
                
                if rightHand and leftHand then
                    for _, target in ipairs(Players:GetPlayers()) do
                        if target ~= LocalPlayer and not playerWhitelist[target.Name] then
                            local targetChar = target.Character
                            local rootPart = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
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

local targetDropdown = Killer:AddDropdown("Select Target", function(name)
    if name and not table.find(targetPlayerNames, name) then
        table.insert(targetPlayerNames, name)
    end
end)

Killer:AddTextBox("Remove Target", function(name)
    for i, v in ipairs(targetPlayerNames) do
        if v == name then
            table.remove(targetPlayerNames, i)
            break
        end
    end
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        targetDropdown:Add(player.Name)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        targetDropdown:Add(player.Name)
    end
end)

Killer:AddSwitch("Start Kill Target", function(state)
    _G.killTarget = state
    task.spawn(function()
        while _G.killTarget do
            pcall(function()
                local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local punch = LocalPlayer.Backpack:FindFirstChild("Punch")
                if punch and not character:FindFirstChild("Punch") then
                    punch.Parent = character
                end
                
                local rightHand = character:WaitForChild("RightHand", 5)
                local leftHand = character:WaitForChild("LeftHand", 5)
                
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

local targetPlayerName = ""
local spyTargetDropdown = Killer:AddDropdown("Select View Target", function(name)
    targetPlayerName = name
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        spyTargetDropdown:Add(player.Name)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        spyTargetDropdown:Add(player.Name)
    end
end)

Killer:AddSwitch("View Player", function(bool)
    _G.spying = bool
    if not _G.spying then
        local cam = workspace.CurrentCamera
        cam.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") or LocalPlayer
        return
    end
    task.spawn(function()
        while _G.spying do
            pcall(function()
                local target = Players:FindFirstChild(targetPlayerName)
                if target and target ~= LocalPlayer then
                    local humanoid = target.Character and target.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        workspace.CurrentCamera.CameraSubject = humanoid
                    end
                end
            end)
            task.wait(0.1)
        end
    end)
end)

Killer:AddButton("Remove Punch Anim", function()
    local blockedAnimations = {
        ["rbxassetid://3638729053"] = true,
        ["rbxassetid://3638767427"] = true,
    }
    
    local function setupAnimationBlocking()
        pcall(function()
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
        end)
    end
    setupAnimationBlocking()
end)

Killer:AddButton("Recover Punch Anim", function()
    if _G.AnimBlockConnection then
        _G.AnimBlockConnection:Disconnect()
        _G.AnimBlockConnection = nil
    end
end)

Killer:AddSwitch("Auto Equip Punch", function(state)
    _G.autoEquipPunch = state
    task.spawn(function()
        while _G.autoEquipPunch do
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

Killer:AddSwitch("Auto Punch [No Animation]", function(state)
    _G.autoPunchNoAnim = state
    task.spawn(function()
        while _G.autoPunchNoAnim do
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

Killer:AddSwitch("Fast Punch", function(state)
    _G.autoPunchActive = state
    if state then
        task.spawn(function()
            while _G.autoPunchActive do
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
            while _G.autoPunchActive do
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

-- ============================================
-- ONGLET SPY STATS
-- ============================================
local LookDura = window:AddTab("Spy Stats")

local SelectPlayerName = ""
local PlayerDrop = LookDura:AddDropdown("Select Player", function(Value)
    SelectPlayerName = Value:match("| (.+)")
end)

local Playerslist = {}
for _, Plr in pairs(Players:GetPlayers()) do
    local displayName = Plr.DisplayName .. " | " .. Plr.Name
    table.insert(Playerslist, displayName)
end

for _, AddPlr in ipairs(Playerslist) do
    PlayerDrop:Add(AddPlr)
end

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

local Update = LookDura:AddLabel("")
local Update1 = LookDura:AddLabel("")
local Update2 = LookDura:AddLabel("")
local Update3 = LookDura:AddLabel("")
local Update4 = LookDura:AddLabel("")
local Update5 = LookDura:AddLabel("")
local Update6 = LookDura:AddLabel("")
local Update9 = LookDura:AddLabel("")
local Update10 = LookDura:AddLabel("")
local Update11 = LookDura:AddLabel("")
local Update12 = LookDura:AddLabel("")
local Update13 = LookDura:AddLabel("")

task.spawn(function()
    while task.wait(0.5) do
        if SelectPlayerName ~= "" then
            pcall(function()
                local player = Players:FindFirstChild(SelectPlayerName)
                if player then
                    if player:FindFirstChild("Gems") then
                        Update1.Text = "Gems: " .. formatNumber(player.Gems.Value)
                    end
                    if player:FindFirstChild("Agility") then
                        Update3.Text = "Agility: " .. formatNumber(player.Agility.Value)
                    end
                    if player:FindFirstChild("Durability") then
                        Update4.Text = "Durability: " .. formatNumber(player.Durability.Value)
                    end
                    if player:FindFirstChild("muscleKingTime") then
                        Update6.Text = "Muscle King Time: " .. formatNumber(player.muscleKingTime.Value)
                    end
                    if player:FindFirstChild("customSize") then
                        Update10.Text = "Custom Size: " .. formatNumber(player.customSize.Value)
                    end
                    if player:FindFirstChild("customSpeed") then
                        Update11.Text = "Custom Speed: " .. formatNumber(player.customSpeed.Value)
                    end
                    if player:FindFirstChild("evilKarma") then
                        Update12.Text = "Evil Karma: " .. formatNumber(player.evilKarma.Value)
                    end
                    if player:FindFirstChild("goodKarma") then
                        Update13.Text = "Good Karma: " .. formatNumber(player.goodKarma.Value)
                    end
                    
                    local leaderstats = player:FindFirstChild("leaderstats")
                    if leaderstats then
                        if leaderstats:FindFirstChild("Strength") then
                            Update.Text = "Strength: " .. formatNumber(leaderstats.Strength.Value)
                        end
                        if leaderstats:FindFirstChild("Rebirths") then
                            Update2.Text = "Rebirth: " .. formatNumber(leaderstats.Rebirths.Value)
                        end
                        if leaderstats:FindFirstChild("Kills") then
                            Update5.Text = "Kills: " .. formatNumber(leaderstats.Kills.Value)
                        end
                    end
                    
                    if player:FindFirstChild("currentMap") then
                        Update9.Text = "Current Map: " .. tostring(player.currentMap.Value)
                    else
                        Update9.Text = "Current Map: No data"
                    end
                end
            end)
        end
    end
end)

-- ============================================
-- ONGLET TELEPORT
-- ============================================
local teleport = window:AddTab("Teleport")

local function createTP(name, position)
    teleport:AddButton(name, function()
        pcall(function()
            local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            humanoidRootPart.CFrame = CFrame.new(position)
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Teleport",
                Text = "Teleported to " .. name,
                Duration = 2
            })
        end)
    end)
end

createTP("Spawn", Vector3.new(2, 8, 115))
createTP("Secret Area", Vector3.new(1947, 2, 6191))
createTP("Tiny Island", Vector3.new(-34, 7, 1903))
createTP("Frozen Island", Vector3.new(-2600.00244, 3.67686558, -403.884369))
createTP("Mythical Island", Vector3.new(2255, 7, 1071))
createTP("Hell Island", Vector3.new(-6768, 7, -1287))
createTP("Legend Island", Vector3.new(4604, 991, -3887))
createTP("Muscle King Island", Vector3.new(-8646, 17, -5738))
createTP("Jungle Island", Vector3.new(-8659, 6, 2384))
createTP("Brawl Lava", Vector3.new(4471, 119, -8836))
createTP("Brawl Desert", Vector3.new(960, 17, -7398))
createTP("Brawl Regular", Vector3.new(-1849, 20, -6335))

-- ============================================
-- ONGLET MISC
-- ============================================
local Misc = window:AddTab("Miscellaneous")

Misc:AddButton("Anti Afk", function()
    local VirtualUser = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

Misc:AddSwitch("Lock Position", function(Value)
    if Value then
        local currentPos = LocalPlayer.Character.HumanoidRootPart.CFrame
        getgenv().posLock = game:GetService("RunService").Heartbeat:Connect(function()
            pcall(function()
                if LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = currentPos
                end
            end)
        end)
    else
        if getgenv().posLock then
            getgenv().posLock:Disconnect()
            getgenv().posLock = nil
        end
    end
end)

Misc:AddSwitch("Anti Knockback", function(Value)
    if Value then
        pcall(function()
            local rootPart = workspace:FindFirstChild(LocalPlayer.Name).HumanoidRootPart
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(100000, 0, 100000)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.P = 1250
            bodyVelocity.Parent = rootPart
        end)
    else
        pcall(function()
            local rootPart = workspace:FindFirstChild(LocalPlayer.Name).HumanoidRootPart
            local existingVelocity = rootPart:FindFirstChild("BodyVelocity")
            if existingVelocity and existingVelocity.MaxForce == Vector3.new(100000, 0, 100000) then
                existingVelocity:Destroy()
            end
        end)
    end
end)

Misc:AddButton("Remove Portals", function()
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
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Portals Removed",
        Text = "Roblox portals have been removed",
        Duration = 3
    })
end)

local timeDropdown = Misc:AddDropdown("Change Time", function(selection)
    local lighting = game:GetService("Lighting")
    if selection == "Night" then
        lighting.ClockTime = 0
    elseif selection == "Day" then
        lighting.ClockTime = 12
    elseif selection == "Midnight" then
        lighting.ClockTime = 6
    end
end)

timeDropdown:Add("Night")
timeDropdown:Add("Day")
timeDropdown:Add("Midnight")

Misc:AddSwitch("Auto Fortune Wheel", function(Value)
    _G.autoFortuneWheelActive = Value
    if Value then
        task.spawn(function()
            while _G.autoFortuneWheelActive do
                pcall(function()
                    local args = {
                        [1] = "openFortuneWheel",
                        [2] = ReplicatedStorage:WaitForChild("fortuneWheelChances"):WaitForChild("Fortune Wheel")
                    }
                    ReplicatedStorage:WaitForChild("rEvents"):WaitForChild("openFortuneWheelRemote"):InvokeServer(unpack(args))
                end)
                task.wait()
            end
        end)
    end
end)

Misc:AddSwitch("God Mode (Brawl)", function(State)
    _G.godModeToggle = State
    if State then
        task.spawn(function()
            while _G.godModeToggle do
                pcall(function()
                    ReplicatedStorage.rEvents.brawlEvent:FireServer("joinBrawl")
                end)
                task.wait()
            end
        end)
    end
end)

Misc:AddSwitch("Full Walk on Water", function(bool)
    if bool then
        _G.waterParts = {}
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
                    pcall(function()
                        local newPart = Instance.new("Part")
                        newPart.Size = Vector3.new(partSize, 1, partSize)
                        newPart.Position = pos
                        newPart.Anchored = true
                        newPart.Transparency = 1
                        newPart.CanCollide = true
                        newPart.Parent = workspace
                        table.insert(_G.waterParts, newPart)
                    end)
                end
            end
        end
    else
        if _G.waterParts then
            for _, part in ipairs(_G.waterParts) do
                pcall(function()
                    if part and part.Parent then
                        part.CanCollide = false
                        part:Destroy()
                    end
                end)
            end
            _G.waterParts = nil
        end
    end
end)

local autoEatBoostsEnabled = false
local boostsList = {
    "ULTRA Shake", "TOUGH Bar", "Protein Shake", "Energy Shake",
    "Protein Bar", "Energy Bar", "Tropical Shake"
}

local function eatAllBoosts()
    for _, boostName in ipairs(boostsList) do
        pcall(function()
            local boost = LocalPlayer.Backpack:FindFirstChild(boostName)
            while boost do
                boost.Parent = LocalPlayer.Character
                boost:Activate()
                task.wait()
                boost = LocalPlayer.Backpack:FindFirstChild(boostName)
            end
        end)
    end
end

task.spawn(function()
    while true do
        if autoEatBoostsEnabled then
            eatAllBoosts()
            task.wait(2)
        else
            task.wait(1)
        end
    end
end)

Misc:AddSwitch("Auto Clear Inventory", function(state)
    autoEatBoostsEnabled = state
end)

-- ============================================
-- ONGLET CREDITS
-- ============================================
local Credits = window:AddTab("Credits")
Credits:AddLabel("SL HUB").TextSize = 30
Credits:AddLabel(" ").TextSize = 30
Credits:AddLabel("Made by SL_GHOST").TextSize = 30
Credits:AddLabel(" ").TextSize = 30
Credits:AddLabel("Join My Discord Server").TextSize = 30
Credits:AddLabel(" ").TextSize = 30
Credits:AddLabel("Made for SL CLAN").TextSize = 30

-- Notification de chargement
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "SL HUB - Muscle Legends",
    Text = "Script loaded successfully with external library!",
    Duration = 5
})

print("SL HUB - Muscle Legends (Library Version) - Loaded!")
