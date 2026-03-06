local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local localPlayer = Players.LocalPlayer
local username = localPlayer.Name
local userId = localPlayer.UserId

local Player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local muscleEvent = Player:WaitForChild("muscleEvent")
local antiAFKConnection



local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/f58075956-jpg/Sxo.lua/refs/heads/main/Papa.lua", true))()

local window = library:AddWindow("CRONOS| Main", {
    main_color = Color3.fromRGB(138, 0, 0),
    min_size = Vector2.new(600, 630),
    can_resize = false,
})

local function setupAntiAFK()
    if antiAFKConnection then
        antiAFKConnection:Disconnect()
    end

    antiAFKConnection = Player.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end
setupAntiAFK()

local function removePortals()
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
end
removePortals()

local blockedFrames = {
    "strengthFrame",
    "durabilityFrame",
    "agilityFrame",
    "evilKarmaFrame",
    "goodKarmaFrame",
}

for _, name in ipairs(blockedFrames) do
    local frame = ReplicatedStorage:FindFirstChild(name)
    if frame and frame:IsA("GuiObject") then
        frame.Visible = false
    end
end

ReplicatedStorage.ChildAdded:Connect(function(child)
    if table.find(blockedFrames, child.Name) and child:IsA("GuiObject") then
        child.Visible = false
    end
end)

local MainTab = window:AddTab("Main")
local KillingTab = window:AddTab("Killing")
local SpecsTab = window:AddTab("Specs")
local FarmingTab = window:AddTab("Farming")
local InventoryTab = window:AddTab("Inventory")
local PetsTab = window:AddTab("Pet Shop")
local TeleportTab = window:AddTab("Teleports")
local StatsTab = window:AddTab("Stats")
local FastRebTab = window:AddTab("Fast Rebirth")
local infoTab = window:AddTab("Info")
KillingTab:Show()

infoTab:AddLabel("karma").TextSize = 20
infoTab:AddLabel("ONTOP")
infoTab:AddButton("Copy ", function()
    local link = "xd"
    if setclipboard then
        setclipboard(link)
        game.StarterGui:SetCore("SendNotification", {
            Title = "Link Copied!";
            Text = "ONTOP";
            Duration = 3;
        })
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "Error!";
            Text = "Not Supported.";
            Duration = 3;
        })
    end
end)

infoTab:AddLabel("")
local wLabel = infoTab:AddLabel("VERSION//2.0.0")
wLabel.TextSize = 30
wLabel.Font = Enum.Font.Arcade

MainTab:AddLabel("Settings:").TextSize = 22

local changeSpeedSizeRemote = ReplicatedStorage.rEvents.changeSpeedSizeRemote

local userSize = 2
local sizeActive = false

MainTab:AddTextBox("Size", function(text)
	text = string.gsub(text, "%s+", "")
	local value = tonumber(text)
	if value and value > 0 then
		userSize = value
	end
end)

local setsizeswitch = MainTab:AddSwitch("Set Size", function(bool)
	sizeActive = bool
end)

setsizeswitch:Set(false)

task.spawn(function()
	while true do
		if sizeActive then
			local character = Players.LocalPlayer.Character
			if character then
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					changeSpeedSizeRemote:InvokeServer("changeSize", userSize)
				end
			end
		end
		task.wait(0.15)
	end
end)

local userSpeed = 120
local speedActive = false

MainTab:AddTextBox("Speed", function(text)
	text = string.gsub(text, "%s+", "")
	local value = tonumber(text)
	if value and value > 0 then
		userSpeed = value
	end
end)

local setspeedswitch = MainTab:AddSwitch("Set Speed", function(bool)
	speedActive = bool
end)

setspeedswitch:Set(false)

task.spawn(function()
	while true do
		if speedActive then
			local character = Players.LocalPlayer.Character
			if character then
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					changeSpeedSizeRemote:InvokeServer("changeSpeed", userSpeed)
				end
			end
		end
		task.wait(0.15)
	end
end)

MainTab:AddLabel("Important:").TextSize = 22

local antiKnockbackSwitch = MainTab:AddSwitch("Anti Fling", function(bool)
    if bool then
        local playerName = game.Players.LocalPlayer.Name
        local character = game.Workspace:FindFirstChild(playerName)
        if character then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(100000, 0, 100000)
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.P = 1250
                bodyVelocity.Parent = rootPart
            end
        end
    else
        local playerName = game.Players.LocalPlayer.Name
        local character = game.Workspace:FindFirstChild(playerName)
        if character then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local existingVelocity = rootPart:FindFirstChild("BodyVelocity")
                if existingVelocity and existingVelocity.MaxForce == Vector3.new(100000, 0, 100000) then
                    existingVelocity:Destroy()
                end
            end
        end
    end
end)
antiKnockbackSwitch:Set(true)

local lockRunning = false
local lockThread = nil

local lockSwitch = MainTab:AddSwitch("Lock Position", function(state)
    lockRunning = state
    if lockRunning then
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        local lockPosition = hrp.Position

        lockThread = coroutine.create(function()
            while lockRunning do
                hrp.Velocity = Vector3.new(0, 0, 0)
                hrp.RotVelocity = Vector3.new(0, 0, 0)
                hrp.CFrame = CFrame.new(lockPosition)
                wait(0.05) 
            end
        end)

        coroutine.resume(lockThread)
    end
end)
lockSwitch:Set(false)

local showpetsswitch = MainTab:AddSwitch("Show Pets", function(bool)
    local player = game:GetService("Players").LocalPlayer
    if player:FindFirstChild("hidePets") then
        player.hidePets.Value = bool
    end
end)
showpetsswitch:Set(false)

local showotherpetsswitch = MainTab:AddSwitch("Show Other Pets", function(bool)
    local player = game:GetService("Players").LocalPlayer
    if player:FindFirstChild("showOtherPetsOn") then
        player.showOtherPetsOn.Value = bool
    end
end)
showotherpetsswitch:Set(false)



MainTab:AddLabel("Misc:").TextSize = 22

MainTab:AddSwitch("Infinite Jump", function(bool)
    _G.InfiniteJump = bool
    
    if bool then
        local InfiniteJumpConnection
        InfiniteJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
            if _G.InfiniteJump then
                game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            else
                InfiniteJumpConnection:Disconnect()
            end
        end)
    end
end)


local parts = {}
local partSize = 2048
local totalDistance = 50000
local startPosition = Vector3.new(-2, -9.5, -2)

local function createAllParts()
    local numberOfParts = math.ceil(totalDistance / partSize)
    
    for x = 0, numberOfParts - 1 do
        for z = 0, numberOfParts - 1 do
            local function createPart(pos, name)
                local part = Instance.new("Part")
                part.Size = Vector3.new(partSize, 1, partSize)
                part.Position = pos
                part.Anchored = true
                part.Transparency = 1
                part.CanCollide = true
                part.Name = name
                part.Parent = workspace
                return part
            end
            
            table.insert(parts, createPart(startPosition + Vector3.new(x*partSize,0,z*partSize), "Part_Side_"..x.."_"..z))
            table.insert(parts, createPart(startPosition + Vector3.new(-x*partSize,0,z*partSize), "Part_LeftRight_"..x.."_"..z))
            table.insert(parts, createPart(startPosition + Vector3.new(-x*partSize,0,-z*partSize), "Part_UpLeft_"..x.."_"..z))
            table.insert(parts, createPart(startPosition + Vector3.new(x*partSize,0,-z*partSize), "Part_UpRight_"..x.."_"..z))
        end
    end
end
task.spawn(createAllParts)

local walkonwaterSwicth =MainTab:AddSwitch("Walk on Water", function(bool)
    for _, part in ipairs(parts) do
        if part and part.Parent then
            part.CanCollide = bool
        end
    end
end)
walkonwaterSwicth:Set(true)


local spinwheelSwitch = MainTab:AddSwitch("Spin Fortune Wheel", function(bool)
    _G.AutoSpinWheel = bool
    
    if bool then
        spawn(function()
            while _G.AutoSpinWheel and wait(1) do
                game:GetService("ReplicatedStorage").rEvents.openFortuneWheelRemote:InvokeServer("openFortuneWheel", game:GetService("ReplicatedStorage").fortuneWheelChances["Fortune Wheel"])
            end
        end)
    end
end)

local timeDropdown = MainTab:AddDropdown("Change Time", function(selection)
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

SpecsTab:AddLabel("Player Stats:").TextSize = 24

local playerToInspect = nil

local emojiMap = {
    ["Time"] = utf8.char(0x1F55B),
    ["Stats"] = utf8.char(0x1F4CA),
    ["Strength"] = utf8.char(0x1F4AA),
    ["Rebirths"] = utf8.char(0x1F504),
    ["Durability"] = utf8.char(0x1F6E1),
    ["Kills"] = utf8.char(0x1F480),
    ["Agility"] = utf8.char(0x1F3C3),
    ["Evil Karma"] = utf8.char(0x1F608),
    ["Good Karma"] = utf8.char(0x1F607),
    ["Brawls"] = utf8.char(0x1F94A)
}

local statDefinitions = {
    { name = "Strength", statName = "Strength" },
    { name = "Rebirths", statName = "Rebirths" },
    { name = "Durability", statName = "Durability" },
    { name = "Agility", statName = "Agility" },
    { name = "Kills", statName = "Kills" },
    { name = "Evil Karma", statName = "evilKarma" },
    { name = "Good Karma", statName = "goodKarma" },
    { name = "Brawls", statName = "Brawls" }
}

local function getCurrentPlayers()
    local playersList = {}
    for _, p in ipairs(Players:GetPlayers()) do
        table.insert(playersList, p)
    end
    return playersList
end

local specdropdown = SpecsTab:AddDropdown("Choose Player", function(text) 
    for _, player in ipairs(getCurrentPlayers()) do
        local optionText = player.DisplayName .. " | " .. player.Name
        if text == optionText then
            playerToInspect = player
            updateStatLabels(playerToInspect)
            break
        end
    end
end)

for _, player in ipairs(getCurrentPlayers()) do
    specdropdown:Add(player.DisplayName .. " | " .. player.Name)
end

Players.PlayerAdded:Connect(function(player)
    specdropdown:Add(player.DisplayName .. " | " .. player.Name)
end)

Players.PlayerRemoving:Connect(function(player)
    specdropdown:Clear()
    for _, p in ipairs(getCurrentPlayers()) do
        specdropdown:Add(p.DisplayName .. " | " .. p.Name)
    end
end)

local playerNameLabel = SpecsTab:AddLabel("Name: N/A")
playerNameLabel.TextSize = 20

local playerUsernameLabel = SpecsTab:AddLabel("Username: N/A")
playerUsernameLabel.TextSize = 20

local statLabels = {}
for _, info in ipairs(statDefinitions) do
    statLabels[info.name] = SpecsTab:AddLabel(emojiMap[info.name] .. " " .. info.name .. ": 0 (0)")
    statLabels[info.name].TextSize = 20
end

local function formatNumber(n)
    if n >= 1e15 then
        return string.format("%.1fqa", n/1e15)
    elseif n >= 1e12 then
        return string.format("%.1ft", n/1e12)
    elseif n >= 1e9 then
        return string.format("%.1fb", n/1e9)
    elseif n >= 1e6 then
        return string.format("%.1fm", n/1e6)
    elseif n >= 1e3 then
        return string.format("%.1fk", n/1e3)
    else
        return tostring(n)
    end
end

local function formatWithCommas(n)
    local formatted = tostring(math.floor(n))
    while true do
        formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end


local function updateStatLabels(targetPlayer)
    if not targetPlayer then return end

    playerNameLabel.Text = "Name: " .. targetPlayer.DisplayName
    playerUsernameLabel.Text = "Username: " .. targetPlayer.Name

    local leaderstats = targetPlayer:FindFirstChild("leaderstats")
    if not leaderstats then return end

    for _, info in ipairs(statDefinitions) do
        local statObject

        if leaderstats:FindFirstChild(info.statName) then
            statObject = leaderstats:FindFirstChild(info.statName)
        elseif targetPlayer:FindFirstChild(info.statName) then
            statObject = targetPlayer:FindFirstChild(info.statName)
        end

        if statObject then
            local value = statObject.Value
            local emoji = emojiMap[info.name] or ""
            statLabels[info.name].Text = string.format(
                "%s %s: %s (%s)",
                emoji,
                info.name,
                formatNumber(value),
                formatWithCommas(value)
            )
        else
            statLabels[info.name].Text = emojiMap[info.name] .. " " .. info.name .. ": 0 (0)"
        end
    end
end

task.spawn(function()
    while true do
        if playerToInspect then
            updateStatLabels(playerToInspect)
        end
        task.wait(0.2)
    end
end)

SpecsTab:AddLabel("â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”")

SpecsTab:AddLabel("Advanced Stats:").TextSize = 24

local enemyHealthLabel = SpecsTab:AddLabel("Enemy Health: N/A")
enemyHealthLabel.TextSize = 20
enemyHealthLabel.TextColor3 = Color3.fromRGB(0, 140, 255)

local playerDamageLabel = SpecsTab:AddLabel("Your Damage: N/A")
playerDamageLabel.TextSize = 20
playerDamageLabel.TextColor3 = Color3.fromRGB(255, 0, 0)

local hitsToKillLabel = SpecsTab:AddLabel("Hits to Kill: N/A")
hitsToKillLabel.TextSize = 20
hitsToKillLabel.TextColor3 = Color3.fromRGB(255, 0, 0)



local function calculateEnemyHealth(targetPlayer)
    if not targetPlayer then return 0 end

    local baseDura = 0
    local durabilityStat = targetPlayer:FindFirstChild("Durability") 
        or (targetPlayer:FindFirstChild("leaderstats") and targetPlayer.leaderstats:FindFirstChild("Durability"))
    if durabilityStat then
        baseDura = durabilityStat.Value
    end

    local totalMultiplier = 1

    local ultFolder = targetPlayer:FindFirstChild("ultimatesFolder")
    if ultFolder then
        local infernalHealth = ultFolder:FindFirstChild("Infernal Health")
        if infernalHealth then
            local upgrades = infernalHealth.Value or 0
            totalMultiplier = totalMultiplier + 0.15 * upgrades
        end
    end

    local equippedPetsFolder = targetPlayer:FindFirstChild("equippedPets")
    if equippedPetsFolder then
        local petBonus = 0
        for _, petValue in ipairs(equippedPetsFolder:GetChildren()) do
            if petValue:IsA("ObjectValue") and petValue.Value then
                local petNameLower = string.lower(petValue.Value.Name)
                if petNameLower:match("mighty") and petNameLower:match("monster") then
                    petBonus = petBonus + 0.5
                end
            end
        end
        totalMultiplier = totalMultiplier + petBonus
    end

    local totalHealth = baseDura * totalMultiplier
    return totalHealth
end

local function calculateLocalPlayerDamage()
    local strengthStat = nil
    local leaderstats = Player:FindFirstChild("leaderstats")
    if leaderstats then
        strengthStat = leaderstats:FindFirstChild("Strength")
    end
    if not strengthStat then return 0 end

    local baseDamage = strengthStat.Value * 0.0667
    local totalMultiplier = 1

    local ultFolder = Player:FindFirstChild("ultimatesFolder")
    if ultFolder then
        local demonDamage = ultFolder:FindFirstChild("Demon Damage")
        if demonDamage then
            local upgrades = demonDamage.Value or 0
            totalMultiplier = totalMultiplier + 0.1 * upgrades
        end
    end

    local equippedPetsFolder = Player:FindFirstChild("equippedPets")
    if equippedPetsFolder then
        local petBonus = 0
        for _, petValue in ipairs(equippedPetsFolder:GetChildren()) do
            if petValue:IsA("ObjectValue") and petValue.Value then
                local petNameLower = string.lower(petValue.Value.Name)
                if petNameLower:match("wild") and petNameLower:match("wizard") then
                    petBonus = petBonus + 0.5
                end
            end
        end
        totalMultiplier = totalMultiplier + petBonus
    end

    baseDamage = baseDamage * totalMultiplier
    return baseDamage
end



local function calculateHitsToKill(health, damage)
    if damage <= 0 then return "âˆž" end
    local hits = math.ceil(health / damage)
    if hits > 100 then
        return "âˆž"
    elseif hits < 1 then
        return 1
    else
        return hits
    end
end

local function updateAdvancedStats(targetPlayer)
    if not targetPlayer then
        enemyHealthLabel.Text = "Enemy Health: N/A"
        playerDamageLabel.Text = "Your Damage: N/A"
        hitsToKillLabel.Text = "Hits to Kill: N/A"
        return
    end
    local enemyHealth = calculateEnemyHealth(targetPlayer)
    local playerDamage = calculateLocalPlayerDamage()
    local hitsToKill = calculateHitsToKill(enemyHealth, playerDamage)
    enemyHealthLabel.Text = string.format("Enemy Health: %s (%s)", formatNumber(enemyHealth), formatWithCommas(enemyHealth))
    playerDamageLabel.Text = string.format("Your Damage: %s (%s)", formatNumber(playerDamage), formatWithCommas(playerDamage))
    hitsToKillLabel.Text = string.format("Hits to Kill: %s", tostring(hitsToKill))
end

task.spawn(function()
    while true do
        if playerToInspect then
            updateAdvancedStats(playerToInspect)
        else
            updateAdvancedStats(nil)
        end
        task.wait(0.1)
    end
end)

local function checkCharacter()
    if not game.Players.LocalPlayer.Character then
        repeat task.wait() until game.Players.LocalPlayer.Character
    end
    return game.Players.LocalPlayer.Character
end

local function gettool()
    for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v.Name == "Punch" and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
        end
    end
    game.Players.LocalPlayer.muscleEvent:FireServer("punch", "leftHand")
    game.Players.LocalPlayer.muscleEvent:FireServer("punch", "rightHand")
end

local function isPlayerAlive(player)
    return player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and
           player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0
end

local function killPlayer(target)
    if not isPlayerAlive(target) then return end
    local character = checkCharacter()
    if character and character:FindFirstChild("LeftHand") then
        pcall(function()
            firetouchinterest(target.Character.HumanoidRootPart, character.LeftHand, 0)
            firetouchinterest(target.Character.HumanoidRootPart, character.LeftHand, 1)
            gettool()
        end)
    end
end

KillingTab:AddLabel("Misc:").TextSize = 22


local dropdown = KillingTab:AddDropdown("Select Pet", function(text)
    local petsFolder = game.Players.LocalPlayer.petsFolder
    for _, folder in pairs(petsFolder:GetChildren()) do
        if folder:IsA("Folder") then
            for _, pet in pairs(folder:GetChildren()) do
                game:GetService("ReplicatedStorage").rEvents.equipPetEvent:FireServer("unequipPet", pet)
            end
        end
    end
    task.wait(0.2)

    local petName = text
    local petsToEquip = {}

    for _, pet in pairs(game.Players.LocalPlayer.petsFolder.Unique:GetChildren()) do
        if pet.Name == petName then
            table.insert(petsToEquip, pet)
        end
    end

    for i = 1, math.min(8, #petsToEquip) do
        game:GetService("ReplicatedStorage").rEvents.equipPetEvent:FireServer("equipPet", petsToEquip[i])
        task.wait(0.1)
    end
end)
dropdown:Add("Wild Wizard")
dropdown:Add("Mighty Monster")

local switch = KillingTab:AddSwitch("Remove Attack Animations", function(bool)
    if bool then
        local blockedAnimations = {
            ["rbxassetid://3638729053"] = true,
            ["rbxassetid://3638767427"] = true,
        }

        local function setupAnimationBlocking()
            local char = game.Players.LocalPlayer.Character
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

        local function processTool(tool)
            if tool and (tool.Name == "Punch" or tool.Name:match("Attack") or tool.Name:match("Right")) then
                if not tool:GetAttribute("ActivatedOverride") then
                    tool:SetAttribute("ActivatedOverride", true)

                    _G.ToolConnections = _G.ToolConnections or {}
                    _G.ToolConnections[tool] = tool.Activated:Connect(function()
                        task.wait(0.05)
                        local char = game.Players.LocalPlayer.Character
                        if char and char:FindFirstChild("Humanoid") then
                            for _, track in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
                                if track.Animation then
                                    local animId = track.Animation.AnimationId
                                    local animName = track.Name:lower()

                                    if blockedAnimations[animId] or animName:match("punch") or animName:match("attack") or animName:match("right") then
                                        track:Stop()
                                    end
                                end
                            end
                        end
                    end)
                end
            end
        end

        local function overrideToolActivation()
            for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                processTool(tool)
            end

            local char = game.Players.LocalPlayer.Character
            if char then
                for _, tool in pairs(char:GetChildren()) do
                    if tool:IsA("Tool") then
                        processTool(tool)
                    end
                end
            end

            _G.BackpackAddedConnection = game.Players.LocalPlayer.Backpack.ChildAdded:Connect(function(child)
                if child:IsA("Tool") then
                    task.wait(0.1)
                    processTool(child)
                end
            end)

            if char then
                _G.CharacterToolAddedConnection = char.ChildAdded:Connect(function(child)
                    if child:IsA("Tool") then
                        task.wait(0.1)
                        processTool(child)
                    end
                end)
            end
        end

        _G.AnimMonitorConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if tick() % 0.5 < 0.01 then
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    for _, track in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
                        if track.Animation then
                            local animId = track.Animation.AnimationId
                            local animName = track.Name:lower()

                            if blockedAnimations[animId] or animName:match("punch") or animName:match("attack") or animName:match("right") then
                                track:Stop()
                            end
                        end
                    end
                end
            end
        end)

        _G.CharacterAddedConnection = game.Players.LocalPlayer.CharacterAdded:Connect(function(newChar)
            task.wait(1)
            setupAnimationBlocking()
            overrideToolActivation()

            if _G.CharacterToolAddedConnection then
                _G.CharacterToolAddedConnection:Disconnect()
            end

            _G.CharacterToolAddedConnection = newChar.ChildAdded:Connect(function(child)
                if child:IsA("Tool") then
                    task.wait(0.1)
                    processTool(child)
                end
            end)
        end)

        setupAnimationBlocking()
        overrideToolActivation()
    else
        if _G.AnimBlockConnection then
            _G.AnimBlockConnection:Disconnect()
            _G.AnimBlockConnection = nil
        end

        if _G.AnimMonitorConnection then
            _G.AnimMonitorConnection:Disconnect()
            _G.AnimMonitorConnection = nil
        end

        if _G.CharacterAddedConnection then
            _G.CharacterAddedConnection:Disconnect()
            _G.CharacterAddedConnection = nil
        end

        if _G.BackpackAddedConnection then
            _G.BackpackAddedConnection:Disconnect()
            _G.BackpackAddedConnection = nil
        end

        if _G.CharacterToolAddedConnection then
            _G.CharacterToolAddedConnection:Disconnect()
            _G.CharacterToolAddedConnection = nil
        end

        if _G.ToolConnections then
            for tool, connection in pairs(_G.ToolConnections) do
                if connection then
                    connection:Disconnect()
                end
                if tool and tool:GetAttribute("ActivatedOverride") then
                    tool:SetAttribute("ActivatedOverride", nil)
                end
            end
            _G.ToolConnections = nil
        end
    end
end)

switch:Set(false)


local player = game:GetService("Players").LocalPlayer

local comboActive = false
local eggLoop, characterAddedConn

local function ensureEggEquipped()
    if not comboActive or not player.Character then return end
    
    local eggsInHand = 0
    for _, item in ipairs(player.Character:GetChildren()) do
        if item.Name == "Protein Egg" then
            eggsInHand += 1
            if eggsInHand > 1 then
                item.Parent = player.Backpack
            end
        end
    end
    
    if eggsInHand == 0 then
        local egg = player.Backpack:FindFirstChild("Protein Egg")
        if egg then
            egg.Parent = player.Character
        end
    end
end

local comboSwitch = KillingTab:AddSwitch("NaN (Egg+NaN+Punch Combo)", function(bool)
    comboActive = bool
    
    if bool then
        changeSpeedSizeRemote:InvokeServer("changeSize", 0/0)
        
        eggLoop = task.spawn(function()
            while comboActive do
                ensureEggEquipped()
                task.wait(0.2)
            end
        end)
        
        characterAddedConn = player.CharacterAdded:Connect(function(newChar)
            task.wait(0.5)
            ensureEggEquipped()
        end)
        
        ensureEggEquipped()
        
    else
        if eggLoop then task.cancel(eggLoop) end
        if characterAddedConn then characterAddedConn:Disconnect() end
    end
end)

comboSwitch:Set(false)

KillingTab:AddButton("Disable Eggs",function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/244ihssp/IlIIS/refs/heads/main/1"))()
end)

KillingTab:AddLabel("Auto Kill:").TextSize = 22

_G.whitelistedPlayers = _G.whitelistedPlayers or {}
_G.blacklistedPlayers = _G.blacklistedPlayers or {}

local function isWhitelisted(player)
    for _, name in ipairs(_G.whitelistedPlayers) do
        if name:lower() == player.Name:lower() then
            return true
        end
    end
    return false
end

local function isBlacklisted(player)
    for _, name in ipairs(_G.blacklistedPlayers) do
        if name:lower() == player.Name:lower() then
            return true
        end
    end
    return false
end

local function getPlayerDisplayText(player)
    return player.DisplayName .. " | " .. player.Name
end

local whitelistDropdown = KillingTab:AddDropdown("Add to Whitelist", function(selectedText)
    local playerName = selectedText:match("| (.+)$")
    if playerName then
        playerName = playerName:gsub("^%s*(.-)%s*$", "%1") 
        for _, name in ipairs(_G.whitelistedPlayers) do
            if name:lower() == playerName:lower() then return end
        end
        table.insert(_G.whitelistedPlayers, playerName)
    end
end)

local switch = KillingTab:AddSwitch("Kill Everyone", function(bool)
    _G.killAll = bool
    if bool then
        if not _G.killAllConnection then
            _G.killAllConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if _G.killAll then
                    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                        if player ~= game.Players.LocalPlayer and not isWhitelisted(player) then
                            killPlayer(player)
                        end
                    end
                end
            end)
        end
    else
        if _G.killAllConnection then
            _G.killAllConnection:Disconnect()
            _G.killAllConnection = nil
        end
    end
end)
switch:Set(false)

local switch = KillingTab:AddSwitch("Whitelist Friends", function(bool)
    _G.whitelistFriends = bool

    if bool then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player:IsFriendsWith(game.Players.LocalPlayer.UserId) then
                local playerName = player.Name
                local alreadyWhitelisted = false
                for _, name in ipairs(_G.whitelistedPlayers) do
                    if name:lower() == playerName:lower() then
                        alreadyWhitelisted = true
                        break
                    end
                end
                if not alreadyWhitelisted then
                    table.insert(_G.whitelistedPlayers, playerName)
                end
            end
        end

        game.Players.PlayerAdded:Connect(function(player)
            if _G.whitelistFriends and player:IsFriendsWith(game.Players.LocalPlayer.UserId) then
                local playerName = player.Name
                local alreadyWhitelisted = false
                for _, name in ipairs(_G.whitelistedPlayers) do
                    if name:lower() == playerName:lower() then
                        alreadyWhitelisted = true
                        break
                    end
                end
                if not alreadyWhitelisted then
                    table.insert(_G.whitelistedPlayers, playerName)
                end
            end
        end)
    end
end)

switch:Set(false)

KillingTab:AddLabel("")

local blacklistDropdown = KillingTab:AddDropdown("Add to Killlist", function(selectedText)
    local playerName = selectedText:match("| (.+)$")
    if playerName then
        playerName = playerName:gsub("^%s*(.-)%s*$", "%1") 
        for _, name in ipairs(_G.blacklistedPlayers) do
            if name:lower() == playerName:lower() then return end
        end
        table.insert(_G.blacklistedPlayers, playerName)
    end
end)

for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
    if player ~= game.Players.LocalPlayer then
        local displayText = getPlayerDisplayText(player)
        whitelistDropdown:Add(displayText)
        blacklistDropdown:Add(displayText)
    end
end

game:GetService("Players").PlayerAdded:Connect(function(player)
    if player ~= game.Players.LocalPlayer then
        local displayText = getPlayerDisplayText(player)
        whitelistDropdown:Add(displayText)
        blacklistDropdown:Add(displayText)
    end
end)


local blacklistKillSwitch = KillingTab:AddSwitch("Kill List", function(bool)
    _G.killBlacklistedOnly = bool
    if bool then
        if not _G.blacklistKillConnection then
            _G.blacklistKillConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if _G.killBlacklistedOnly then
                    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                        if player ~= game.Players.LocalPlayer and isBlacklisted(player) then
                            killPlayer(player)
                        end
                    end
                end
            end)
        end
    else
        if _G.blacklistKillConnection then
            _G.blacklistKillConnection:Disconnect()
            _G.blacklistKillConnection = nil
        end
    end
end)

local selectedPlayerToSpectate = nil
local spectating = false
local currentTargetConnection = nil
local camera = workspace.CurrentCamera

local function updateSpectateTarget(player)
    if currentTargetConnection then
        currentTargetConnection:Disconnect()
    end
    
    if player and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            camera.CameraSubject = humanoid
            currentTargetConnection = player.CharacterAdded:Connect(function(newChar)
                task.wait(0.2)
                local newHumanoid = newChar:FindFirstChildOfClass("Humanoid")
                if newHumanoid then
                    camera.CameraSubject = newHumanoid
                end
            end)
        end
    end
end

local function updatePlayerList()
    return game.Players:GetPlayers()
end

local specdropdown = KillingTab:AddDropdown("Choose Player", function(text)
    for _, player in ipairs(updatePlayerList()) do
        local optionText = player.DisplayName .. " | " .. player.Name
        if text == optionText then
            selectedPlayerToSpectate = player
            if spectating then
                updateSpectateTarget(player)
            end
            break
        end
    end
end)

local spectateSwitch = KillingTab:AddSwitch("Spectate", function(bool)
    spectating = bool
    if spectating and selectedPlayerToSpectate then
        updateSpectateTarget(selectedPlayerToSpectate)
    else
        if currentTargetConnection then
            currentTargetConnection:Disconnect()
            currentTargetConnection = nil
        end
        local localPlayer = game.Players.LocalPlayer
        if localPlayer.Character then
            local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                camera.CameraSubject = humanoid
            end
        end
    end
end)

for _, player in ipairs(updatePlayerList()) do
    specdropdown:Add(player.DisplayName .. " | " .. player.Name)
end

game.Players.PlayerAdded:Connect(function(player)
    specdropdown:Add(player.DisplayName .. " | " .. player.Name)
end)

game.Players.PlayerRemoving:Connect(function(player)
    if selectedPlayerToSpectate and selectedPlayerToSpectate == player then
        selectedPlayerToSpectate = nil
        if spectating then
            spectateSwitch:Set(false)
        end
    end
end)

KillingTab:AddLabel("Kill Aura:").TextSize = 22

local ringPart = nil
local ringColor = Color3.fromRGB(50, 163, 255)
local ringTransparency = 0.6
_G.showDeathRing = false
_G.deathRingRange = 20

local function updateRingSize()
    if not ringPart then return end
    local diameter = (_G.deathRingRange or 20) * 2
    ringPart.Size = Vector3.new(0.2, diameter, diameter)
end

KillingTab:AddTextBox("Range 1-140", function(text)
    local range = tonumber(text)
    if range then
        _G.deathRingRange = math.clamp(range, 1, 140)
        updateRingSize()
    end
end)

local function toggleRingVisual()
    if _G.showDeathRing then
        ringPart = Instance.new("Part")
        ringPart.Shape = Enum.PartType.Cylinder
        ringPart.Material = Enum.Material.Neon
        ringPart.Color = ringColor
        ringPart.Transparency = ringTransparency
        ringPart.Anchored = true
        ringPart.CanCollide = false
        ringPart.CastShadow = false
        updateRingSize()
        ringPart.Parent = workspace
    elseif ringPart then
        ringPart:Destroy()
        ringPart = nil
    end
end

local function updateRingPosition()
    if not ringPart then return end
    local character = checkCharacter()
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        ringPart.CFrame = rootPart.CFrame * CFrame.Angles(0, 0, math.rad(90))
    end
end

local deathRingSwitch = KillingTab:AddSwitch("Death Ring", function(bool)
    _G.deathRingEnabled = bool
    
    if bool then
        if not _G.deathRingConnection then
            _G.deathRingConnection = game:GetService("RunService").Heartbeat:Connect(function()
                updateRingPosition()
                
                local character = checkCharacter()
                local myPosition = character and character:FindFirstChild("HumanoidRootPart") and character.HumanoidRootPart.Position
                if not myPosition then return end

                for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                    if player ~= game.Players.LocalPlayer and not isWhitelisted(player) and isPlayerAlive(player) then
                        local distance = (myPosition - player.Character.HumanoidRootPart.Position).Magnitude
                        if distance <= (_G.deathRingRange or 20) then
                            killPlayer(player)
                        end
                    end
                end
            end)
        end
    else
        if _G.deathRingConnection then
            _G.deathRingConnection:Disconnect()
            _G.deathRingConnection = nil
        end
    end
end)

local visualRingSwitch = KillingTab:AddSwitch("Show Ring", function(bool)
    _G.showDeathRing = bool
    toggleRingVisual()
end)
deathRingSwitch:Set(false)
visualRingSwitch:Set(false)

local whitelistLabel = KillingTab:AddLabel("Whitelist: None")
whitelistLabel.TextColor3 = Color3.fromRGB(26, 122, 212)
whitelistLabel.TextSize = 17

KillingTab:AddButton("Clear Whitelist", function()
    _G.whitelistedPlayers = {}
end)

local blacklistLabel = KillingTab:AddLabel("Killlist: None")
blacklistLabel.TextColor3 = Color3.fromRGB(191, 58, 25)
blacklistLabel.TextSize = 17

KillingTab:AddButton("Clear Blacklist", function()
    _G.blacklistedPlayers = {}
end)

local function updateWhitelistLabel()
    if #_G.whitelistedPlayers == 0 then
        whitelistLabel.Text = "Whitelist: None"
    else
        whitelistLabel.Text = "Whitelist: " .. table.concat(_G.whitelistedPlayers, ", ")
    end
end

local function updateBlacklistLabel()
    if #_G.blacklistedPlayers == 0 then
        blacklistLabel.Text = "Killlist: None"
    else
        blacklistLabel.Text = "Killlist: " .. table.concat(_G.blacklistedPlayers, ", ")
    end
end

task.spawn(function()
    while true do
        updateWhitelistLabel()
        updateBlacklistLabel()
        task.wait(0.2)
    end
end)

FarmingTab:AddLabel("Misc").TextSize = 22

local autoLiftSwitch = FarmingTab:AddSwitch("Auto Lift (Gamepass)", function(bool)
    if bool then
        local gamepassFolder = game:GetService("ReplicatedStorage").gamepassIds
        local player = game:GetService("Players").LocalPlayer
        for _, gamepass in pairs(gamepassFolder:GetChildren()) do
            local value = Instance.new("IntValue")
            value.Name = gamepass.Name
            value.Value = gamepass.Value
            value.Parent = player.ownedGamepasses
        end
    else
        local player = game:GetService("Players").LocalPlayer
        if player and player.ownedGamepasses then
            local gamepassFolder = game:GetService("ReplicatedStorage").gamepassIds
            for _, gamepass in pairs(gamepassFolder:GetChildren()) do
                local ownedPass = player.ownedGamepasses:FindFirstChild(gamepass.Name)
                if ownedPass and ownedPass.Value == gamepass.Value then
                    ownedPass:Destroy()
                end
            end
        end
    end
end)

local rebirthLabel = FarmingTab:AddLabel("Rebirths:")
rebirthLabel.TextSize = 22

local rebirthLabel = FarmingTab:AddLabel("Rebirths: 0")
rebirthLabel.TextSize = 17

local targetLabel = FarmingTab:AddLabel("Target: None")
targetLabel.TextSize = 17

local function formatNumber(num)
    local numStr = tostring(num)
    local formatted = ""
    local counter = 0

    for i = #numStr, 1, -1 do
        counter = counter + 1
        formatted = numStr:sub(i, i) .. formatted
        if counter % 3 == 0 and i > 1 then
            formatted = "," .. formatted
        end
    end
    
    return formatted
end

local rebirths = player.leaderstats:WaitForChild("Rebirths")
local targetRebirths = 0
local isAutoRebirthing = false
local rebirthSwitch

local function autoRebirth()
    isAutoRebirthing = true
    while isAutoRebirthing and rebirths.Value < targetRebirths do
        ReplicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
        task.wait(0.05)
    end
    isAutoRebirthing = false
    if rebirthSwitch then
        rebirthSwitch:Set(false)
    end
end

FarmingTab:AddTextBox("Set Rebirth Target", function(text)
    local val = tonumber(text)
    if val and val >= 0 then
        targetRebirths = val
        print("Target set to:" .. targetRebirths)
    else
        print("Invalid.")
    end
end)

rebirthSwitch = FarmingTab:AddSwitch("Auto Rebirth", function(enabled)
    if enabled then
        if targetRebirths > 0 and rebirths.Value < targetRebirths then
            task.spawn(autoRebirth)
        else
            rebirthSwitch:Set(false)
        end
    else
        isAutoRebirthing = false
    end
end)

task.spawn(function()
    while true do
        rebirthLabel.Text = "Rebirths: " .. formatNumber(rebirths.Value)
        targetLabel.Text = "Target Rebirths: " .. formatNumber(targetRebirths)
        task.wait(0.2)
    end
end)

local sizeActive = false

local oneswitch = FarmingTab:AddSwitch("Auto Size 1", function(bool)
    sizeActive = bool
end)

oneswitch:Set(false)

task.spawn(function()
    while true do
        if sizeActive then
            local character = Players.LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    changeSpeedSizeRemote:InvokeServer("changeSize", 1)
                end
            end
        end
        task.wait(0.05)
    end
end)

local targetPosition = CFrame.new(-8665.4, 17.21, -5792.9)
local teleportActive = false

local autokingswitch = FarmingTab:AddSwitch("Auto King", function(enabled)
    teleportActive = enabled
end)

task.spawn(function()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    while true do
        if teleportActive then
            if (hrp.Position - targetPosition.Position).magnitude > 5 then
                hrp.CFrame = targetPosition
            end
        end
        task.wait(0.05)
    end
end)

FarmingTab:AddLabel("Tools:").TextSize = 22

local SelectedTool = nil
local AutoFarm = false

local toolDropdown = FarmingTab:AddDropdown("Select Tool", function(selection)
    SelectedTool = selection
end)
toolDropdown:Add("Weight")
toolDropdown:Add("Pushups")
toolDropdown:Add("Situps")
toolDropdown:Add("Handstands")
toolDropdown:Add("Fast Punch")
toolDropdown:Add("Stomp")
toolDropdown:Add("Ground Slam")

local autoFarmSwitch = FarmingTab:AddSwitch("Start", function(enabled)
    AutoFarm = enabled

    if enabled then
        task.spawn(function()
            while AutoFarm do
                local player = game:GetService("Players").LocalPlayer

                if SelectedTool == "Weight" then
                    if not player.Character:FindFirstChild("Weight") then
                        local weightTool = player.Backpack:FindFirstChild("Weight")
                        if weightTool then
                            player.Character.Humanoid:EquipTool(weightTool)
                        end
                    end
                    player.muscleEvent:FireServer("rep")

                elseif SelectedTool == "Pushups" then
                    if not player.Character:FindFirstChild("Pushups") then
                        local pushupsTool = player.Backpack:FindFirstChild("Pushups")
                        if pushupsTool then
                            player.Character.Humanoid:EquipTool(pushupsTool)
                        end
                    end
                    player.muscleEvent:FireServer("rep")

                elseif SelectedTool == "Situps" then
                    if not player.Character:FindFirstChild("Situps") then
                        local situpsTool = player.Backpack:FindFirstChild("Situps")
                        if situpsTool then
                            player.Character.Humanoid:EquipTool(situpsTool)
                        end
                    end
                    player.muscleEvent:FireServer("rep")

                elseif SelectedTool == "Handstands" then
                    if not player.Character:FindFirstChild("Handstands") then
                        local handstandsTool = player.Backpack:FindFirstChild("Handstands")
                        if handstandsTool then
                            player.Character.Humanoid:EquipTool(handstandsTool)
                        end
                    end
                    player.muscleEvent:FireServer("rep")

                elseif SelectedTool == "Fast Punch" then
                    local punch = player.Backpack:FindFirstChild("Punch")
                    if punch then
                        punch.Parent = player.Character
                        if punch:FindFirstChild("attackTime") then
                            punch.attackTime.Value = 0
                        end
                    end
                    player.muscleEvent:FireServer("punch", "rightHand")
                    player.muscleEvent:FireServer("punch", "leftHand")

                    if player.Character:FindFirstChild("Punch") then
                        player.Character.Punch:Activate()
                    end

                elseif SelectedTool == "Stomp" then
                    local stomp = player.Backpack:FindFirstChild("Stomp")
                    if stomp then
                        stomp.Parent = player.Character
                        if stomp:FindFirstChild("attackTime") then
                            stomp.attackTime.Value = 0
                        end
                    end
                    player.muscleEvent:FireServer("stomp")

                    if player.Character:FindFirstChild("Stomp") then
                        player.Character.Stomp:Activate()
                    end

                    if tick() % 6 < 0.1 then
                        local virtualUser = game:GetService("VirtualUser")
                        virtualUser:CaptureController()
                        virtualUser:ClickButton1(Vector2.new(500, 500))
                    end

                elseif SelectedTool == "Ground Slam" then
                    local groundSlam = player.Backpack:FindFirstChild("Ground Slam")
                    if groundSlam then
                        groundSlam.Parent = player.Character
                        if groundSlam:FindFirstChild("attackTime") then
                            groundSlam.attackTime.Value = 0
                        end
                    end
                    player.muscleEvent:FireServer("slam")

                    if player.Character:FindFirstChild("Ground Slam") then
                        player.Character["Ground Slam"]:Activate()
                    end

                    if tick() % 6 < 0.1 then
                        local virtualUser = game:GetService("VirtualUser")
                        virtualUser:CaptureController()
                        virtualUser:ClickButton1(Vector2.new(500, 500))
                    end
                end

                task.wait()
            end
        end)
    else
        local player = game:GetService("Players").LocalPlayer
        if SelectedTool and player.Character:FindFirstChild(SelectedTool) then
            player.Character:FindFirstChild(SelectedTool).Parent = player.Backpack
        end
    end
end)

FarmingTab:AddLabel("Rocks:").TextSize = 22

local function gettool()
    for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v.Name == "Punch" and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
        end
    end
    player.muscleEvent:FireServer("punch", "leftHand")
    player.muscleEvent:FireServer("punch", "rightHand")
end

local rockData = {
    ["Tiny Rock"] = 0,
    ["Starter Island"] = 100,
    ["Punching Rock"] = 1000,
    ["Golden Rock"] = 5000,
    ["Frost Rock"] = 150000,
    ["Mythical Rock"] = 400000,
    ["Eternal Rock"] = 750000,
    ["Legend Rock"] = 1000000,
    ["Muscle King Rock"] = 5000000,
    ["Jungle Rock"] = 10000000
}

local selectedRock = nil

local rockDropdown = FarmingTab:AddDropdown("Select Rock", function(selection)
    selectedRock = selection
end)

for rockName in pairs(rockData) do
    rockDropdown:Add(rockName)
end

local autoRockSwitch = FarmingTab:AddSwitch("Auto Rock", function(enabled)
    getgenv().RockFarmRunning = enabled

    if enabled and selectedRock then
        task.spawn(function()
            local requiredDurability = rockData[selectedRock]
            local player = game:GetService("Players").LocalPlayer

            while getgenv().RockFarmRunning do
                task.wait()
                if player.Durability.Value >= requiredDurability then
                    for _, v in pairs(workspace.machinesFolder:GetDescendants()) do
                        if v.Name == "neededDurability" and v.Value == requiredDurability and
                            player.Character:FindFirstChild("LeftHand") and
                            player.Character:FindFirstChild("RightHand") then

                            local rock = v.Parent:FindFirstChild("Rock")
                            if rock then
                                firetouchinterest(rock, player.Character.RightHand, 0)
                                firetouchinterest(rock, player.Character.RightHand, 1)
                                firetouchinterest(rock, player.Character.LeftHand, 0)
                                firetouchinterest(rock, player.Character.LeftHand, 1)
                                gettool()
                            end
                        end
                    end
                end
            end
        end)
    end
end)

FarmingTab:AddLabel("Machines:").TextSize = 22

local selectedLocation = nil
local selectedWorkout = nil
local working = false
local workoutTypeDropdown
local machineDropdown
local repTask = nil

local function pressE()
    local vim = game:GetService("VirtualInputManager")
    vim:SendKeyEvent(true, "E", false, game)
    task.wait(0.1)
    vim:SendKeyEvent(false, "E", false, game)
end

local function autoLift()
    while working and task.wait() do
        game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
    end
end

local function stopAutoLift()
    if repTask then
        repTask:Cancel()  
        repTask = nil
    end
end

local function teleportAndStart(machineName, position)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = position
        task.wait(0.5)
        pressE()
        if working then
            repTask = task.spawn(autoLift)
        end
    end
end

local workoutPositions = {
    ["Bench Press"] = {
        ["Jungle Gym"] = CFrame.new(-8173, 64, 1898),
        ["Muscle King Gym"] = CFrame.new(-8590.06152, 46.0167427, -6043.34717),
        ["Legend Gym"] = CFrame.new(4111.91748, 1020.46674, -3799.97217)
    },
    ["Squat"] = {
        ["Jungle Gym"] = CFrame.new(-8352, 34, 2878),
        ["Muscle King Gym"] = CFrame.new(-8940.12402, 13.1642084, -5699.13477),
        ["Legend Gym"] = CFrame.new(4304.99023, 987.829956, -4124.2334)
    },
    ["Pull Up"] = {
        ["Jungle Gym"] = CFrame.new(-8666, 34, 2070),
        ["Muscle King Gym"] = CFrame.new(-8940.12402, 13.1642084, -5699.13477),
        ["Legend Gym"] = CFrame.new(4304.99023, 987.829956, -4124.2334)
    },
    ["Boulder"] = {
        ["Jungle Gym"] = CFrame.new(-8621, 34, 2684),
        ["Muscle King Gym"] = CFrame.new(-8940.12402, 13.1642084, -5699.13477),
        ["Legend Gym"] = CFrame.new(4304.99023, 987.829956, -4124.2334)
    }
}

local workoutLocations = {
    "Jungle Gym", "Muscle King Gym", "Legend Gym"
}

FarmingTab:AddSwitch("Start", function(enabled)
    working = enabled

    if enabled then
        if selectedLocation and selectedWorkout and workoutPositions[selectedWorkout][selectedLocation] then
            teleportAndStart(selectedWorkout, workoutPositions[selectedWorkout][selectedLocation])
        end
    else
        stopAutoLift()
    end
end)

local locationDropdown = FarmingTab:AddDropdown("Gym", function(location)
    selectedLocation = location

    if machineDropdown then
        machineDropdown:Clear()
    end

    if location == "Jungle Gym" then
        machineDropdown = FarmingTab:AddDropdown("Machine", function(machine)
            selectedWorkout = machine
        end)
        machineDropdown:Add("Bench Press")
        machineDropdown:Add("Squat")
        machineDropdown:Add("Pull Up")
        machineDropdown:Add("Boulder")
    elseif location == "Muscle King Gym" then
        machineDropdown = FarmingTab:AddDropdown("Machine", function(machine)
            selectedWorkout = machine
        end)
        machineDropdown:Add("Bench Press")
        machineDropdown:Add("Squat")
        machineDropdown:Add("Pull Up")
        machineDropdown:Add("Boulder")
    elseif location == "Legend Gym" then
        machineDropdown = FarmingTab:AddDropdown("Machine", function(machine)
            selectedWorkout = machine
        end)
        machineDropdown:Add("Bench Press")
        machineDropdown:Add("Squat")
        machineDropdown:Add("Pull Up")
        machineDropdown:Add("Boulder")
    end
end)

for _, location in ipairs(workoutLocations) do
    locationDropdown:Add(location)
end

InventoryTab:AddLabel("Eater:").TextSize = 22

local function activateProteinEgg()
    local tool = player.Character:FindFirstChild("Protein Egg") or player.Backpack:FindFirstChild("Protein Egg")
    if tool then
        muscleEvent:FireServer("proteinEgg", tool)
    end
end

local running = false

task.spawn(function()
    while true do
        if running then
            activateProteinEgg()
            task.wait(0.25)
        else
            task.wait(1)
        end
    end
end)

local switch = InventoryTab:AddSwitch("Egg Devour", function(state)
    running = state
    if state then
        activateProteinEgg()
    end
end)
switch:Set(false)

local itemList = {
    "Tropical Shake",
    "Energy Shake",
    "Protein Bar",
    "TOUGH Bar",
    "Protein Shake",
    "ULTRA Shake",
    "Energy Bar"
}

local function formatEventName(itemName)
    local parts = {}
    for word in itemName:gmatch("%S+") do
        table.insert(parts, word:lower())
    end
    for i = 2, #parts do
        parts[i] = parts[i]:sub(1,1):upper() .. parts[i]:sub(2)
    end
    return table.concat(parts)
end

local function activateRandomItems(count)
    local shuffledItems = {}
    for _, item in ipairs(itemList) do
        table.insert(shuffledItems, item)
    end
    for i = #shuffledItems, 2, -1 do
        local j = math.random(i)
        shuffledItems[i], shuffledItems[j] = shuffledItems[j], shuffledItems[i]
    end
    for i = 1, math.min(count, #shuffledItems) do
        local tool = player.Character:FindFirstChild(shuffledItems[i]) or player.Backpack:FindFirstChild(shuffledItems[i])
        if tool then
            local eventName = formatEventName(shuffledItems[i]) 
            muscleEvent:FireServer(eventName, tool)
        end
    end
end

local running = false

task.spawn(function()
    while true do
        if running then
            activateRandomItems(4)
            task.wait(0.5)
        else
            task.wait(0.5)
        end
    end
end)

local eatswitch = InventoryTab:AddSwitch("Eat Everything", function(state)
    running = state
    if state then
        activateRandomItems(4)
    end
end)
eatswitch:Set(false)


TeleportTab:AddLabel("Main:").TextSize = 22

TeleportTab:AddButton("Tiny Island",function()
    local char = player.Character or Player.CharacterAdded()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(-37.1, 9.2, 1919)
end)

TeleportTab:AddButton("Main Island",function()
    local char = player.Character or Player.CharacterAdded()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(16.07, 9.08, 133.8)
end)

TeleportTab:AddButton("Beach",function()
    local char = player.Character or Player.CharacterAdded()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(-8, 9, -169.2)
end)

TeleportTab:AddLabel("Gyms:").TextSize = 22

TeleportTab:AddButton("Muscle King Gym",function()
    local char = player.Character or Player.CharacterAdded()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(-8665.4, 17.21, -5792.9)
end)

TeleportTab:AddButton("Jungle Gym",function()
    local char = player.Character or Player.CharacterAdded()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(-8543, 6.8, 2400)
end)

TeleportTab:AddButton("Legends Gym",function()
    local char = player.Character or Player.CharacterAdded()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(4516, 991.5, -3856)
end)

TeleportTab:AddButton("Infernal Gym",function()
    local char = player.Character or Player.CharacterAdded()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(-6759, 7.36, -1284)
end)

TeleportTab:AddButton("Mythical Gym",function()
    local char = player.Character or Player.CharacterAdded()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(2250, 7.37, 1073.2)
end)

TeleportTab:AddButton("Frost Gym",function()
    local char = player.Character or Player.CharacterAdded()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(-2623, 7.36, -409)
end)

PetsTab:AddLabel("Pets:").TextSize = 22

local selectedPet = "Darkstar Hunter "
local petDropdown = PetsTab:AddDropdown("Choose Pet", function(text)
    selectedPet = text
end)

petDropdown:Add("Darkstar Hunter")
petDropdown:Add("Neon Guardian")
petDropdown:Add("Blue Birdie")
petDropdown:Add("Blue Bunny")
petDropdown:Add("Blue Firecaster")
petDropdown:Add("Blue Pheonix")
petDropdown:Add("Crimson Falcon")
petDropdown:Add("Cybernetic Showdown Dragon")
petDropdown:Add("Dark Golem")
petDropdown:Add("Dark Legends Manticore")
petDropdown:Add("Dark Vampy")
petDropdown:Add("Eternal Strike Leviathan")
petDropdown:Add("Frostwave Legends Penguin")
petDropdown:Add("Gold Warrior")
petDropdown:Add("Golden Pheonix")
petDropdown:Add("Golden Viking")
petDropdown:Add("Green Butterfly")
petDropdown:Add("Green Firecaster")
petDropdown:Add("Infernal Dragon")
petDropdown:Add("Lightning Strike Phantom")
petDropdown:Add("Magic Butterfly")
petDropdown:Add("Muscle Sensei")
petDropdown:Add("Orange Hedgehog")
petDropdown:Add("Orange Pegasus")
petDropdown:Add("Phantom Genesis Dragon")
petDropdown:Add("Purple Dragon")
petDropdown:Add("Purple Falcon")
petDropdown:Add("Red Dragon")
petDropdown:Add("Red Firecaster")
petDropdown:Add("Red Kitty")
petDropdown:Add("Silver Dog")
petDropdown:Add("Ultimate Supernova Pegasus")
petDropdown:Add("Ultra Birdie")
petDropdown:Add("White Pegasus")
petDropdown:Add("White Pheonix")
petDropdown:Add("Yellow Butterfly")

PetsTab:AddSwitch("Buy Pet", function(bool)
    _G.AutoHatchPet = bool
    if bool then
        spawn(function()
            while _G.AutoHatchPet and selectedPet ~= "" do
                local petToOpen = ReplicatedStorage.cPetShopFolder:FindFirstChild(selectedPet)
                if petToOpen then
                    ReplicatedStorage.cPetShopRemote:InvokeServer(petToOpen)
                end
                task.wait(0.1)
            end
        end)
    end
end)

PetsTab:AddLabel("Auras:").TextSize = 22

local selectedAura = "Entropic Blast" 
local auraDropdown = PetsTab:AddDropdown("Select Aura", function(text)
    selectedAura = text
end)

auraDropdown:Add("Entropic Blast")
auraDropdown:Add("Muscle King")
auraDropdown:Add("Astral Electro")
auraDropdown:Add("Azure Tundra")
auraDropdown:Add("Blue Aura")
auraDropdown:Add("Dark Electro")
auraDropdown:Add("Dark Lightning")
auraDropdown:Add("Dark Storm")
auraDropdown:Add("Electro")
auraDropdown:Add("Enchanted Mirage")
auraDropdown:Add("Eternal Megastrike")
auraDropdown:Add("Grand Supernova")
auraDropdown:Add("Green Aura")
auraDropdown:Add("Inferno")
auraDropdown:Add("Lightning")
auraDropdown:Add("Power Lightning")
auraDropdown:Add("Purple Aura")
auraDropdown:Add("Purple Nova")
auraDropdown:Add("Red Aura")
auraDropdown:Add("Supernova")
auraDropdown:Add("Ultra Inferno")
auraDropdown:Add("Ultra Mirage")
auraDropdown:Add("Unstable Mirage")
auraDropdown:Add("Yellow Aura")

PetsTab:AddSwitch("Buy Aura", function(bool)
    _G.AutoHatchAura = bool
    
    if bool then
        spawn(function()
            while _G.AutoHatchAura and selectedAura ~= "" do
                local auraToOpen = ReplicatedStorage.cPetShopFolder:FindFirstChild(selectedAura)
                if auraToOpen then
                    ReplicatedStorage.cPetShopRemote:InvokeServer(auraToOpen)
                end
                task.wait(0.1)
            end
        end)
    end
end)

StatsTab:AddLabel(emojiMap["Time"] .. " Time:").TextSize = 22

local stopwatchLabel = StatsTab:AddLabel("0d 0h 0m 0s")
stopwatchLabel.TextSize = 20
StatsTab:AddLabel("")

StatsTab:AddLabel(emojiMap["Stats"] .. " Stats:").TextSize = 22

local startTime = tick()

task.spawn(function()
    while true do
        local currentTime = tick()
        local elapsedTime = currentTime - startTime

        local days = math.floor(elapsedTime / (24 * 3600))
        local hours = math.floor((elapsedTime % (24 * 3600)) / 3600)
        local minutes = math.floor((elapsedTime % 3600) / 60)
        local seconds = math.floor(elapsedTime % 60)

        stopwatchLabel.Text = string.format("%dd %dh %dm %ds", days, hours, minutes, seconds)

        task.wait(0.1)
    end
end)

local leaderstats = player:WaitForChild("leaderstats")
local strengthStat = leaderstats:WaitForChild("Strength")
local rebirthsStat = leaderstats:WaitForChild("Rebirths")
local durabilityStat = player:WaitForChild("Durability")
local killsStat = leaderstats:WaitForChild("Kills")
local agilityStat = player:WaitForChild("Agility")
local evilKarmaStat = player:WaitForChild("evilKarma")
local goodKarmaStat = player:WaitForChild("goodKarma")
local brawlsStat = leaderstats:WaitForChild("Brawls")

local stats = {
    { name = emojiMap["Strength"] .. " Strength", stat = strengthStat },
    { name = emojiMap["Rebirths"] .. " Rebirths", stat = rebirthsStat },
    { name = emojiMap["Durability"] .. " Durability", stat = durabilityStat },
    { name = emojiMap["Kills"] .. " Kills", stat = killsStat },
    { name = emojiMap["Agility"] .. " Agility", stat = agilityStat },
    { name = emojiMap["Evil Karma"] .. " Evil Karma", stat = evilKarmaStat },
    { name = emojiMap["Good Karma"] .. " Good Karma", stat = goodKarmaStat },
    { name = emojiMap["Brawls"] .. " Brawls", stat = brawlsStat }
}

local initialValues = {}
local statLabels = {}

local function formatNumber(n)
    if n >= 1e15 then
        return string.format("%.1fqa", n/1e15)
    elseif n >= 1e12 then
        return string.format("%.1ft", n/1e12)
    elseif n >= 1e9 then
        return string.format("%.1fb", n/1e9)
    elseif n >= 1e6 then
        return string.format("%.1fm", n/1e6)
    elseif n >= 1e3 then
        return string.format("%.1fk", n/1e3)
    else
        return tostring(n)
    end
end

local function formatWithCommas(n)
    local formatted = tostring(n)
    while true do
        formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

for _, info in ipairs(stats) do
    initialValues[info.name] = info.stat.Value
    statLabels[info.name] = StatsTab:AddLabel("")
    statLabels[info.name].TextSize = 20
end

local FastRebTab = window:AddTab("Fast Rebirth")

local function formatNumber(num)
    if num >= 1e15 then return string.format("%.2fQ", num/1e15) end
    if num >= 1e12 then return string.format("%.2fT", num/1e12) end
    if num >= 1e9 then return string.format("%.2fB", num/1e9) end
    if num >= 1e6 then return string.format("%.2fM", num/1e6) end
    if num >= 1e3 then return string.format("%.2fK", num/1e3) end
    return string.format("%.0f", num)
end

local isRunning = false
local startTime = 0
local totalElapsed = 0
local initialRebirths = rebirthsStat.Value
local lastPaceUpdate = 0

local serverLabel = FastRebTab:AddLabel("Time:")
serverLabel.TextSize = 20
local timeLabel = FastRebTab:AddLabel("0d 0h 0m 0s - Inactive")
local paceLabel = FastRebTab:AddLabel("Pace: 0 / Hour | 0 / Day | 0 / Week")
local averagePaceLabel = FastRebTab:AddLabel("Average Pace: 0 / Hour | 0 / Day | 0 / Week")

paceLabel.TextSize = 17
averagePaceLabel.TextSize = 17


timeLabel.TextSize = 17
timeLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
paceLabel.TextSize = 17

local rebirthsStatsLabel = FastRebTab:AddLabel("Rebirths: "..formatNumber(rebirthsStat.Value).." | Gained: 0")
rebirthsStatsLabel.TextSize = 17


local lastRebirthTime = tick()
local lastRebirthValue = rebirthsStat.Value

local function updateRebirthsLabel()
    local gained = rebirthsStat.Value - initialRebirths
    rebirthsStatsLabel.Text = string.format("Rebirths: %s | Gained: %s", 
                                           formatNumber(rebirthsStat.Value), 
                                           formatNumber(gained))
end

local function updateUI(forceUpdate)
end

local lastRebirthTime = tick()
local lastRebirthValue = rebirthsStat.Value

local paceHistoryHour = {}
local paceHistoryDay = {}
local paceHistoryWeek = {}

local maxHistoryLength = 20

local rebirthCount = 0

local function calculatePaceOnRebirth()
    rebirthCount = rebirthCount + 1
    
    -- Erst ab dem 2. Rebirth berechnen
    if rebirthCount < 2 then
        lastRebirthTime = tick()
        lastRebirthValue = rebirthsStat.Value
        return
    end

    local now = tick()
    local gained = rebirthsStat.Value - lastRebirthValue

    if gained > 0 then
        local avgTimePerRebirth = (now - lastRebirthTime) / gained
        local paceHour = 3600 / avgTimePerRebirth
        local paceDay = 86400 / avgTimePerRebirth
        local paceWeek = 604800 / avgTimePerRebirth

        paceLabel.Text = string.format("Pace: %s / Hour | %s / Day | %s / Week",
            formatNumber(paceHour), formatNumber(paceDay), formatNumber(paceWeek))

        table.insert(paceHistoryHour, paceHour)
        table.insert(paceHistoryDay, paceDay)
        table.insert(paceHistoryWeek, paceWeek)

        if #paceHistoryHour > maxHistoryLength then
            table.remove(paceHistoryHour, 1)
            table.remove(paceHistoryDay, 1)
            table.remove(paceHistoryWeek, 1)
        end

        local function average(tbl)
            local sum = 0
            for _, v in ipairs(tbl) do
                sum = sum + v
            end
            return #tbl > 0 and (sum / #tbl) or 0
        end

        local avgHour = average(paceHistoryHour)
        local avgDay = average(paceHistoryDay)
        local avgWeek = average(paceHistoryWeek)

        averagePaceLabel.Text = string.format("Average Pace: %s / Hour | %s / Day | %s / Week",
            formatNumber(avgHour), formatNumber(avgDay), formatNumber(avgWeek))

        lastRebirthTime = now
        lastRebirthValue = rebirthsStat.Value
    end
end




rebirthsStat:GetPropertyChangedSignal("Value"):Connect(function()
    calculatePaceOnRebirth()
    updateRebirthsLabel()
end)

local function managePets(petName)
end

local function doRebirth()
end

local function fastRebirthLoop()
    while isRunning do
        managePets("Swift Samurai")
        doRebirth()
        task.wait(0.5)
    end
end

FastRebTab:AddLabel("")

local RebirthLabel = FastRebTab:AddLabel("Rebirthing:")
RebirthLabel.TextSize = 20

FastRebTab:AddSwitch("Fast Rebirth", function(state)
    isRunning = state
    
    if state then
        startTime = tick()
        task.spawn(fastRebirthLoop)
    else
        totalElapsed = totalElapsed + (tick() - startTime)
        updateUI(true)
    end
end)

rebirthsStat:GetPropertyChangedSignal("Value"):Connect(function()
    if isRunning then
        calculatePace()
    end
    updateRebirthsLabel() 
end)

task.spawn(function()
    while true do
        updateUI(false)
        task.wait(0.1)
    end
end)


local running = false
local thread = nil

local sizeSwitch = FastRebTab:AddSwitch("Set Size 1", function(bool)
    running = bool
    if running then
        thread = coroutine.create(function()
            while running do
                game:GetService("ReplicatedStorage").rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 1)
                wait(0.01)
            end
        end)
        coroutine.resume(thread)
    end
end)

FastRebTab:AddButton("Anti Lag", function()
    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local lighting = game:GetService("Lighting")

    for _, gui in pairs(playerGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            gui:Destroy()
        end
    end

    local function darkenSky()
        for _, v in pairs(lighting:GetChildren()) do
            if v:IsA("Sky") then
                v:Destroy()
            end
        end

        local darkSky = Instance.new("Sky")
        darkSky.Name = "DarkSky"
        darkSky.SkyboxBk = "rbxassetid://0"
        darkSky.SkyboxDn = "rbxassetid://0"
        darkSky.SkyboxFt = "rbxassetid://0"
        darkSky.SkyboxLf = "rbxassetid://0"
        darkSky.SkyboxRt = "rbxassetid://0"
        darkSky.SkyboxUp = "rbxassetid://0"
        darkSky.Parent = lighting

        lighting.Brightness = 0
        lighting.ClockTime = 0
        lighting.TimeOfDay = "00:00:00"
        lighting.OutdoorAmbient = Color3.new(0, 0, 0)
        lighting.Ambient = Color3.new(0, 0, 0)
        lighting.FogColor = Color3.new(0, 0, 0)
        lighting.FogEnd = 100

        task.spawn(function()
            while true do
                wait(5)
                if not lighting:FindFirstChild("DarkSky") then
                    darkSky:Clone().Parent = lighting
                end
                lighting.Brightness = 0
                lighting.ClockTime = 0
                lighting.OutdoorAmbient = Color3.new(0, 0, 0)
                lighting.Ambient = Color3.new(0, 0, 0)
                lighting.FogColor = Color3.new(0, 0, 0)
                lighting.FogEnd = 100
            end
        end)
    end

    local function removeParticleEffects()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") then
                obj:Destroy()
            end
        end
    end

    local function removeLightSources()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                obj:Destroy()
            end
        end
    end

    removeParticleEffects()
    removeLightSources()
    darkenSky()
end)

FastRebTab:AddLabel("")

local miscLabel = FastRebTab:AddLabel("Misc:")
miscLabel.TextSize = 20

local lockRunning = false
local lockThread = nil

local lockSwitch = FastRebTab:AddSwitch("Lock Position", function(state)
    lockRunning = state
    if lockRunning then
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        local lockPosition = hrp.Position

        lockThread = coroutine.create(function()
            while lockRunning do
                hrp.Velocity = Vector3.new(0, 0, 0)
                hrp.RotVelocity = Vector3.new(0, 0, 0)
                hrp.CFrame = CFrame.new(lockPosition)
                wait(0.05) 
            end
        end)

        coroutine.resume(lockThread)
    end
end)

local function activateShake()
    local tool = player.Character:FindFirstChild("Tropical Shake") or player.Backpack:FindFirstChild("Tropical Shake")
    if tool then
        muscleEvent:FireServer("tropicalShake", tool)
    end
end

local running = false

task.spawn(function()
    while true do
        if running then
            activateShake()
            task.wait(450)
        else
            task.wait(1)
        end
    end
end)

local autoshakeSwitch = FastRebTab:AddSwitch("Auto Shake", function(state)
    running = state
    if state then
        activateShake()
    end
end)
autoshakeSwitch:Set(false)

local spinwheelSwitch = FastRebTab:AddSwitch("Spin Fortune Wheel", function(bool)
    _G.AutoSpinWheel = bool
    
    if bool then
        spawn(function()
            while _G.AutoSpinWheel and wait(1) do
                game:GetService("ReplicatedStorage").rEvents.openFortuneWheelRemote:InvokeServer("openFortuneWheel", game:GetService("ReplicatedStorage").fortuneWheelChances["Fortune Wheel"])
            end
        end)
    end
end)

FastRebTab:AddButton("Jungle Lift",function()
    local player = game.Players.LocalPlayer
    local char = player.Character or Player.CharacterAdded:wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(-8642.396484375, 6.7980651855, 2086.1030273)
    task.wait(0.2)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(0.05)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end)






local FarmingTab = window:AddTab("Fast Farm")

local strengthStat = leaderstats:WaitForChild("Strength")
local durabilityStat = player:WaitForChild("Durability")

local function formatNumber(number)
    local isNegative = number < 0
    number = math.abs(number)
    if number >= 1e15 then
        return (isNegative and "-" or "") .. string.format("%.2fQa", number / 1e15)
    elseif number >= 1e12 then
        return (isNegative and "-" or "") .. string.format("%.2fT", number / 1e12)
    elseif number >= 1e9 then
        return (isNegative and "-" or "") .. string.format("%.2fB", number / 1e9)
    elseif number >= 1e6 then
        return (isNegative and "-" or "") .. string.format("%.2fM", number / 1e6)
    elseif number >= 1e3 then
        return (isNegative and "-" or "") .. string.format("%.2fK", number / 1e3)
    else
        return (isNegative and "-" or "") .. string.format("%.2f", number)
    end
end

FarmingTab:AddLabel("Time:").TextSize = 20
local stopwatchLabel = FarmingTab:AddLabel("0d 0h 0m 0s - Fast Rep Inactive")
stopwatchLabel.TextSize = 17
stopwatchLabel.TextColor3 = Color3.fromRGB(255, 50, 50)

local projectedStrengthLabel = FarmingTab:AddLabel("Strength Pace: 0 /Hour | 0 /Day | 0 /Week")
projectedStrengthLabel.TextSize = 17
local projectedDurabilityLabel = FarmingTab:AddLabel("Durability Pace: 0 /Hour | 0 /Day | 0 /Week")
projectedDurabilityLabel.TextSize = 17
local averageStrengthLabel = FarmingTab:AddLabel("Average Strength Pace: 0 /Hour | 0 /Day | 0 /Week")
averageStrengthLabel.TextSize = 17
local averageDurabilityLabel = FarmingTab:AddLabel("Average Durability Pace: 0 /Hour | 0 /Day | 0 /Week")
averageDurabilityLabel.TextSize = 17

FarmingTab:AddLabel("").TextSize = 10
local statsLabel = FarmingTab:AddLabel("Stats:")
statsLabel.TextSize = 20
local strengthLabel = FarmingTab:AddLabel("Strength: 0 | Gained: 0")
strengthLabel.TextSize = 17
local durabilityLabel = FarmingTab:AddLabel("Durability: 0 | Gained: 0")
durabilityLabel.TextSize = 17

local startTime = 0
local pausedElapsedTime = 0
local lastPauseTime = 0

local runFastRep = false
local trackingStarted = false

local strengthHistory = {}
local durabilityHistory = {}
local calculationInterval = 10

local initialStrength = strengthStat.Value
local initialDurability = durabilityStat.Value

task.spawn(function()
    local lastCalcTime = tick()
    while true do
        local currentTime = tick()
        local currentStrength = strengthStat.Value
        local currentDurability = durabilityStat.Value

        strengthLabel.Text = "Strength: " .. formatNumber(currentStrength) .. " | Gained: " .. formatNumber(currentStrength - initialStrength)
        durabilityLabel.Text = "Durability: " .. formatNumber(currentDurability) .. " | Gained: " .. formatNumber(currentDurability - initialDurability)

        if runFastRep then
            if not trackingStarted then
                trackingStarted = true
                startTime = currentTime
                strengthHistory = {}
                durabilityHistory = {}
            end
            local elapsedTime = pausedElapsedTime + (currentTime - startTime)
            local days = math.floor(elapsedTime / (24 * 3600))
            local hours = math.floor((elapsedTime % (24 * 3600)) / 3600)
            local minutes = math.floor((elapsedTime % 3600) / 60)
            local seconds = math.floor(elapsedTime % 60)
            stopwatchLabel.Text = string.format("%dd %dh %dm %ds - Fast Rep Running", days, hours, minutes, seconds)
            stopwatchLabel.TextColor3 = Color3.fromRGB(50, 255, 50)

            table.insert(strengthHistory, {time = currentTime, value = currentStrength})
            table.insert(durabilityHistory, {time = currentTime, value = currentDurability})

            while #strengthHistory > 0 and currentTime - strengthHistory[1].time > calculationInterval do
                table.remove(strengthHistory, 1)
            end
            while #durabilityHistory > 0 and currentTime - durabilityHistory[1].time > calculationInterval do
                table.remove(durabilityHistory, 1)
            end

            if currentTime - lastCalcTime >= calculationInterval then
                lastCalcTime = currentTime

                if #strengthHistory >= 2 then
                    local strengthDelta = strengthHistory[#strengthHistory].value - strengthHistory[1].value
                    local strengthPerSecond = strengthDelta / calculationInterval
                    local strengthPerHour = strengthPerSecond * 3600
                    local strengthPerDay = strengthPerSecond * 86400
                    local strengthPerWeek = strengthPerSecond * 604800
                    projectedStrengthLabel.Text = "Strength Pace: " .. formatNumber(strengthPerHour) .. "/Hour | " .. formatNumber(strengthPerDay) .. "/Day | " .. formatNumber(strengthPerWeek) .. "/Week"
                end

                if #durabilityHistory >= 2 then
                    local durabilityDelta = durabilityHistory[#durabilityHistory].value - durabilityHistory[1].value
                    local durabilityPerSecond = durabilityDelta / calculationInterval
                    local durabilityPerHour = durabilityPerSecond * 3600
                    local durabilityPerDay = durabilityPerSecond * 86400
                    local durabilityPerWeek = durabilityPerSecond * 604800
                    projectedDurabilityLabel.Text = "Durability Pace: " .. formatNumber(durabilityPerHour) .. "/Hour | " .. formatNumber(durabilityPerDay) .. "/Day | " .. formatNumber(durabilityPerWeek) .. "/Week"
                end

                local totalElapsed = pausedElapsedTime + (currentTime - startTime)
                if totalElapsed > 0 then
                    local avgStrengthPerSecond = (currentStrength - initialStrength) / totalElapsed
                    local avgStrengthPerHour = avgStrengthPerSecond * 3600
                    local avgStrengthPerDay = avgStrengthPerSecond * 86400
                    local avgStrengthPerWeek = avgStrengthPerSecond * 604800
                    averageStrengthLabel.Text = "Average Strength Pace: " .. formatNumber(avgStrengthPerHour) .. "/Hour | " .. formatNumber(avgStrengthPerDay) .. "/Day | " .. formatNumber(avgStrengthPerWeek) .. "/Week"

                    local avgDurabilityPerSecond = (currentDurability - initialDurability) / totalElapsed
                    local avgDurabilityPerHour = avgDurabilityPerSecond * 3600
                    local avgDurabilityPerDay = avgDurabilityPerSecond * 86400
                    local avgDurabilityPerWeek = avgDurabilityPerSecond * 604800
                    averageDurabilityLabel.Text = "Average Durability Pace: " .. formatNumber(avgDurabilityPerHour) .. "/Hour | " .. formatNumber(avgDurabilityPerDay) .. "/Day | " .. formatNumber(avgDurabilityPerWeek) .. "/Week"
                end
            end
        else
            if trackingStarted then
                trackingStarted = false
                pausedElapsedTime = pausedElapsedTime + (currentTime - startTime)
                stopwatchLabel.Text = string.format("%dd %dh %dm %ds - Fast Rep Stopped", math.floor(pausedElapsedTime / (24 * 3600)), math.floor((pausedElapsedTime % (24 * 3600)) / 3600), math.floor((pausedElapsedTime % 3600) / 60), math.floor(pausedElapsedTime % 60))
                stopwatchLabel.TextColor3 = Color3.fromRGB(255, 165, 0)

                projectedStrengthLabel.Text = "Strength Pace: 0 /Hour | 0 /Day | 0 /Week"
                projectedDurabilityLabel.Text = "Durability Pace: 0 /Hour | 0 /Day | 0 /Week"
                averageStrengthLabel.Text = "Average Strength Pace: 0 /Hour | 0 /Day | 0 /Week"
                averageDurabilityLabel.Text = "Average Durability Pace: 0 /Hour | 0 /Day | 0 /Week"

                strengthHistory = {}
                durabilityHistory = {}
            end
        end

        task.wait(0.05)
    end
end)

FarmingTab:AddLabel("")
FarmingTab:AddLabel("Fast Farm (Recommended Speed: 20)").TextSize = 20

local repsPerTick = 1

local function getPing()
    local stats = game:GetService("Stats")
    local pingStat = stats:FindFirstChild("PerformanceStats") and stats.PerformanceStats:FindFirstChild("Ping")
    return pingStat and pingStat:GetValue() or 0
end

FarmingTab:AddTextBox("Rep Speed", function(value)
    local num = tonumber(value)
    if num and num > 0 then
        repsPerTick = math.floor(num)
    end
end, {
    placeholder = "1",
})

local function fastRepLoop()
    while runFastRep do
        local startTick = tick()
        while tick() - startTick < 0.75 and runFastRep do
            for i = 1, repsPerTick do
                muscleEvent:FireServer("rep")
            end
            task.wait(0.02)
        end
        while runFastRep and getPing() >= 350 do
            task.wait(1)
        end
    end
end

FarmingTab:AddSwitch("Fast Rep", function(state)
    if state and not runFastRep then
        runFastRep = true
        task.spawn(fastRepLoop)
    elseif not state and runFastRep then
        runFastRep = false
    end
end)




FastRebTab:AddLabel("")

FarmingTab:AddLabel("Misc:").TextSize = 20

local function unequipPets()
    for _, folder in pairs(Player.petsFolder:GetChildren()) do
        if folder:IsA("Folder") then
            for _, pet in pairs(folder:GetChildren()) do
                ReplicatedStorage.rEvents.equipPetEvent:FireServer("unequipPet", pet)
            end
        end
    end
    task.wait(0.1)
end

local function equipPetsByName(name)
    unequipPets()
    task.wait(0.01)
    for _, pet in pairs(Player.petsFolder.Unique:GetChildren()) do
        if pet.Name == name then
            ReplicatedStorage.rEvents.equipPetEvent:FireServer("equipPet", pet)
        end
    end
end

local function activateProteinEgg()
    local tool = Player.Character:FindFirstChild("Protein Egg") or Player.Backpack:FindFirstChild("Protein Egg")
    if tool then
        muscleEvent:FireServer("proteinEgg", tool)
    end
end

local running = false

task.spawn(function()
    while true do
        if running then
            activateProteinEgg()
            task.wait(1800)
        else
            task.wait(1)
        end
    end
end)

local switch = FarmingTab:AddSwitch("Auto Egg", function(state)
    running = state
    if state then
        activateProteinEgg()
    end
end)
switch:Set(false)

local function activateShake()
    local tool = Player.Character:FindFirstChild("Tropical Shake") or Player.Backpack:FindFirstChild("Tropical Shake")
    if tool then
        muscleEvent:FireServer("tropicalShake", tool)
    end
end

local running = false

task.spawn(function()
    while true do
        if running then
            activateShake()
            task.wait(900)
        else
            task.wait(1)
        end
    end
end)

local switch = FarmingTab:AddSwitch("Auto Shake", function(state)
    running = state
    if state then
        activateShake()
    end
end)
switch:Set(false)

local spinwheelSwitch = FarmingTab:AddSwitch("Spin Fortune Wheel", function(bool)
    _G.AutoSpinWheel = bool
    
    if bool then
        spawn(function()
            while _G.AutoSpinWheel and wait(1) do
                game:GetService("ReplicatedStorage").rEvents.openFortuneWheelRemote:InvokeServer("openFortuneWheel", game:GetService("ReplicatedStorage").fortuneWheelChances["Fortune Wheel"])
            end
        end)
    end
end)

FarmingTab:AddButton("Jungle Squat",function()
    local player = game.Players.LocalPlayer
    local char = player.Character or Player.CharacterAdded:wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(-8371.43359375, 6.79806327, 2858.88525390)
    task.wait(0.2)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(0.05)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end)

FarmingTab:AddButton("Anti Lag", function()
    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local lighting = game:GetService("Lighting")

    for _, gui in pairs(playerGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            gui:Destroy()
        end
    end

    local function darkenSky()
        for _, v in pairs(lighting:GetChildren()) do
            if v:IsA("Sky") then
                v:Destroy()
            end
        end

        local darkSky = Instance.new("Sky")
        darkSky.Name = "DarkSky"
        darkSky.SkyboxBk = "rbxassetid://0"
        darkSky.SkyboxDn = "rbxassetid://0"
        darkSky.SkyboxFt = "rbxassetid://0"
        darkSky.SkyboxLf = "rbxassetid://0"
        darkSky.SkyboxRt = "rbxassetid://0"
        darkSky.SkyboxUp = "rbxassetid://0"
        darkSky.Parent = lighting

        lighting.Brightness = 0
        lighting.ClockTime = 0
        lighting.TimeOfDay = "00:00:00"
        lighting.OutdoorAmbient = Color3.new(0, 0, 0)
        lighting.Ambient = Color3.new(0, 0, 0)
        lighting.FogColor = Color3.new(0, 0, 0)
        lighting.FogEnd = 100

        task.spawn(function()
            while true do
                wait(5)
                if not lighting:FindFirstChild("DarkSky") then
                    darkSky:Clone().Parent = lighting
                end
                lighting.Brightness = 0
                lighting.ClockTime = 0
                lighting.OutdoorAmbient = Color3.new(0, 0, 0)
                lighting.Ambient = Color3.new(0, 0, 0)
                lighting.FogColor = Color3.new(0, 0, 0)
                lighting.FogEnd = 100
            end
        end)
    end

    local function removeParticleEffects()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") then
                obj:Destroy()
            end
        end
    end

    local function removeLightSources()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                obj:Destroy()
            end
        end
    end

    removeParticleEffects()
    removeLightSources()
    darkenSky()
end)

FarmingTab:AddButton("Equip Swift Samurai", function()
    unequipPets()
    equipPetsByName("Swift Samurai")
end)

while true do
    for _, info in ipairs(stats) do
        local currentValue = info.stat.Value
        local gained = currentValue - initialValues[info.name]
        
        local displayText = string.format(
            "%s: %s (%s) | Gained: %s (%s)",
            info.name,
            formatNumber(currentValue),
            formatWithCommas(currentValue),
            formatNumber(gained),
            formatWithCommas(gained)
        )
        
        statLabels[info.name].Text = displayText
    end
    wait(0.1)
end
