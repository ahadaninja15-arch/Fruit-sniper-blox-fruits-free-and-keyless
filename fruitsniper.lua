-- Delta Executor Native Script Framework
if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(10) -- Extended 10-second wait for full game asset loading
repeat task.wait(1) until game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui")

-- OVERNIGHT AFK PARAMETERS
getgenv().FruitSniperEnabled = true
getgenv().AutoHopEnabled = true
getgenv().AntiAFKEnabled = true
getgenv().AutoPirateRaid = true   -- Auto fights Castle/Pirate Raids

-- TARGET FILTERS (Strict Matching Keys)
local TargetFruits = {
    ["buddha"] = true,
    ["portal"] = true,
    ["lightning"] = true,
    ["pain"] = true,
    -- Mythicals
    ["kitsune"] = true,
    ["dragon"] = true,
    ["leopard"] = true,
    ["dough"] = true,
    ["t-rex"] = true,
    ["mammoth"] = true,
    ["spirit"] = true,
    ["control"] = true,
    ["venom"] = true,
    ["shadow"] = true,
    ["gravity"] = true
}

-- Setup Draggable UI Framework
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ControlButton = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")

ScreenGui.Name = "NinjaPremiumSniper"
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
MainFrame.Size = UDim2.new(0, 260, 0, 140)
MainFrame.BorderSizePixel = 2
MainFrame.Active = true
MainFrame.Draggable = true 

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "NINJA MYTHIC & RAID SNIPER"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.TextSize = 13

ControlButton.Name = "ControlButton"
ControlButton.Parent = MainFrame
ControlButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
ControlButton.Position = UDim2.new(0.05, 0, 0.28, 0)
ControlButton.Size = UDim2.new(0.9, 0, 0, 30)
ControlButton.Font = Enum.Font.SourceSansBold
ControlButton.Text = "SCRIPT STATUS: ACTIVE"
ControlButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ControlButton.TextSize = 14

StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
StatusLabel.Position = UDim2.new(0.05, 0, 0.55, 0)
StatusLabel.Size = UDim2.new(0.9, 0, 0, 50)
StatusLabel.Font = Enum.Font.SourceSansItalic
StatusLabel.Text = "Status: Initializing systems..."
StatusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
StatusLabel.TextSize = 12
StatusLabel.TextWrapped = true

-- Toggle System State
ControlButton.MouseButton1Click:Connect(function()
    getgenv().FruitSniperEnabled = not getgenv().FruitSniperEnabled
    if getgenv().FruitSniperEnabled then
        getgenv().AutoHopEnabled = true
        ControlButton.Text = "SCRIPT STATUS: ACTIVE"
        ControlButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        StatusLabel.Text = "Status: Active..."
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
    else
        getgenv().AutoHopEnabled = false
        ControlButton.Text = "SCRIPT STATUS: DEACTIVATED"
        ControlButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        StatusLabel.Text = "Status: Paused."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

-- Anti-AFK Engine
local vu = game:GetService("VirtualUser")
game.Players.LocalPlayer.Idled:Connect(function()
    if getgenv().AntiAFKEnabled then
        vu:CaptureController()
        vu:ClickButton2(Vector2.new(0,0))
    end
end)

-- Server Hop Routine
local function hopServer()
    if not getgenv().FruitSniperEnabled or not getgenv().AutoHopEnabled then return end
    StatusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
    StatusLabel.Text = "Status: Searching non-full server..."
    task.wait(0.5)
    
    local Http = game:GetService("HttpService")
    local Teleport = game:GetService("TeleportService")
    local ApiUrl = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    
    local success, result = pcall(function()
        return Http:JSONDecode(game:HttpGet(ApiUrl))
    end)
    
    if success and result and result.data then
        for _, server in pairs(result.data) do
            if server.playing <= 10 and server.id ~= game.JobId then
                pcall(function()
                    Teleport:TeleportToPlaceInstance(game.PlaceId, server.id, game.Players.LocalPlayer)
                end)
                task.wait(3)
                break
            end
        end
    end
end

-- Fail-Safe Marine Joiner
local function forceJoinMarines()
    local lp = game.Players.LocalPlayer
    if lp.Team and (lp.Team.Name == "Marines" or lp.Team.Name == "Marine") then 
        return true 
    end

    -- 1. Direct CommF Remote Invoke
    pcall(function()
        local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
        local commF = remotes and remotes:FindFirstChild("CommF")
        if commF then
            commF:InvokeServer("SetTeam", "Marines")
        end
    end)

    task.wait(0.5)
    if lp.Team and (lp.Team.Name == "Marines" or lp.Team.Name == "Marine") then 
        return true 
    end

    -- 2. UI Click Connections Override
    pcall(function()
        for _, v in pairs(lp.PlayerGui:GetDescendants()) do
            if v:IsA("TextButton") or v:IsA("ImageButton") then
                local nameLower = string.lower(v.Name)
                local parentNameLower = v.Parent and string.lower(v.Parent.Name) or ""
                if nameLower == "marines" or parentNameLower == "marines" or (v:IsA("TextButton") and string.find(string.lower(v.Text), "marine")) then
                    for _, conn in pairs(getconnections(v.Activated)) do conn:Fire() end
                    for _, conn in pairs(getconnections(v.MouseButton1Click)) do conn:Fire() end
                    for _, conn in pairs(getconnections(v.MouseButton1Down)) do conn:Fire() end
                end
            end
        end
    end)

    task.wait(0.5)
    return (lp.Team and (lp.Team.Name == "Marines" or lp.Team.Name == "Marine"))
end

-- Primary Execution Thread
task.spawn(function()
    StatusLabel.Text = "Status: Joining Marine Team..."
    local attempts = 0
    
    while attempts < 10 do
        attempts = attempts + 1
        if forceJoinMarines() then
            break
        end
        task.wait(0.8)
    end
    
    StatusLabel.Text = "Status: Joined Marines. Scanning workspace..."
    task.wait(1.5)
    
    while task.wait(0.15) do
        if getgenv().FruitSniperEnabled then
            local character = game.Players.LocalPlayer.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChild("Humanoid")
            
            if root and humanoid and humanoid.Health > 0 then
                -- 1. DETECT & DEFEND PIRATE RAID
                local raidEnemies = {}
                if getgenv().AutoPirateRaid then
                    local enemies = workspace:FindFirstChild("Enemies")
                    if enemies then
                        for _, enemy in pairs(enemies:GetChildren()) do
                            local name = string.lower(enemy.Name)
                            if (string.find(name, "pirate") or string.find(name, "raid") or string.find(name, "tank") or string.find(name, "raider")) then
                                local hum = enemy:FindFirstChild("Humanoid")
                                if hum and hum.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                                    table.insert(raidEnemies, enemy)
                                end
                            end
                        end
                    end
                end

                if #raidEnemies > 0 then
                    getgenv().AutoHopEnabled = false
                    StatusLabel.TextColor3 = Color3.fromRGB(255, 140, 0)
                    StatusLabel.Text = "Status: RAID ACTIVE! Hovering over " .. #raidEnemies .. " NPCs..."
                    
                    -- Auto Equip Weapon
                    if not character:FindFirstChildOfClass("Tool") then
                        local backpack = game.Players.LocalPlayer:FindFirstChild("Backpack")
                        if backpack then
                            local tool = backpack:FindFirstChildOfClass("Tool")
                            if tool then
                                humanoid:EquipTool(tool)
                            end
                        end
                    end

                    -- Safe Flying BodyVelocity
                    local bv = root:FindFirstChild("RaidHoverBV")
                    if not bv then
                        bv = Instance.new("BodyVelocity")
                        bv.Name = "RaidHoverBV"
                        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                        bv.Velocity = Vector3.new(0, 0, 0)
                        bv.Parent = root
                    end

                    -- Hover Position Above Enemies
                    local baseTarget = raidEnemies[1]:FindFirstChild("HumanoidRootPart")
                    if baseTarget then
                        local safeHoverPosition = CFrame.new(baseTarget.Position.X, baseTarget.Position.Y + 15, baseTarget.Position.Z)
                        root.CFrame = safeHoverPosition
                        
                        -- Mob Stacking directly under player
                        local mobStackCFrame = safeHoverPosition * CFrame.new(0, -10, 0)
                        for _, enemy in pairs(raidEnemies) do
                            pcall(function()
                                local eRoot = enemy:FindFirstChild("HumanoidRootPart")
                                local eHum = enemy:FindFirstChild("Humanoid")
                                if eRoot and eHum and eHum.Health > 0 then
                                    eHum.CanCollide = false
                                    eRoot.CanCollide = false
                                    eRoot.CFrame = mobStackCFrame
                                end
                            end)
                        end
                    end
                    
                    -- Attack Input Trigger
                    vu:CaptureController()
                    vu:ClickButton1(Vector2.new(0,0))
                else
                    -- Cleanup BodyVelocity when raid ends
                    local bv = root:FindFirstChild("RaidHoverBV")
                    if bv then bv:Destroy() end

                    -- 2. INSTANT FRUIT SCAN
                    local targetFruit = nil
                    for _, item in pairs(workspace:GetChildren()) do
                        local nameLower = string.lower(item.Name)
                        if string.find(nameLower, "fruit") and not item:IsA("Texture") then
                            local cleanName = nameLower:gsub("fruit", ""):gsub("%s+", "")
                            for target, _ in pairs(TargetFruits) do
                                if string.find(cleanName, target) then
                                    targetFruit = item
                                    break
                                end
                            end
                        end
                    end

                    -- 3. FRUIT PICKUP & STORE ROUTINE
                    if targetFruit then
                        getgenv().AutoHopEnabled = false
                        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
                        StatusLabel.Text = "Status: TARGET FOUND (" .. targetFruit.Name .. ")!"
                        
                        -- Teleport to fruit
                        if targetFruit:IsA("Model") then
                            root.CFrame = targetFruit:GetPivot()
                        elseif targetFruit:IsA("BasePart") then
                            root.CFrame = targetFruit.CFrame
                        end
                        
                        task.wait(0.8)
                        
                        -- Find fruit in character/backpack and equip
                        local holdingFruit = nil
                        for _, tool in pairs(character:GetChildren()) do
                            if tool:IsA("Tool") and string.find(string.lower(tool.Name), "fruit") then
                                holdingFruit = tool
                                break
                            end
                        end
                        
                        if not holdingFruit then
                            local backpack = game.Players.LocalPlayer:FindFirstChild("Backpack")
                            if backpack then
                                for _, tool in pairs(backpack:GetChildren()) do
                                    if tool:IsA("Tool") and string.find(string.lower(tool.Name), "fruit") then
                                        humanoid:EquipTool(tool)
                                        holdingFruit = tool
                                        task.wait(0.4)
                                        break
                                    end
                                end
                            end
                        end

                        StatusLabel.Text = "Status: Storing " .. targetFruit.Name .. "..."
                        
                        -- Invoke Store Remote
                        local fruitNameToStore = holdingFruit and holdingFruit.Name or targetFruit.Name
                        pcall(function()
                            game:GetService("ReplicatedStorage").Remotes.CommF:InvokeServer("StoreFruit", fruitNameToStore, holdingFruit or targetFruit)
                        end)
                        
                        task.wait(2)
                        getgenv().AutoHopEnabled = true
                    else
                        -- 4. SERVER HOP
                        if getgenv().AutoHopEnabled then
                            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                            StatusLabel.Text = "Status: Server clear. Hopping..."
                            task.wait(0.5)
                            hopServer()
                        end
                    end
                end
            end
        end
    end
end)
