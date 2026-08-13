-- Delta Executor Native Script Framework
if not game:IsLoaded() then game.Loaded:Wait() end
repeat task.wait(0.5) until game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui")

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

-- Memory table to track and ignore bad / restricted / visited servers
local VisitedServers = {}

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
StatusLabel.Text = "Status: Initializing team joiner..."
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

-- UNIVERSAL EXECUTOR REQUEST FUNCTION
local httpRequest = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)

-- FIXED SAFE SERVER HOPPER (3-8 Players Max Filter + Executor Request Bridge)
local function hopServer()
    if not getgenv().FruitSniperEnabled or not getgenv().AutoHopEnabled then return end
    StatusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
    StatusLabel.Text = "Status: Searching safe public server..."
    task.wait(0.5)
    
    local Http = game:GetService("HttpService")
    local Teleport = game:GetService("TeleportService")
    
    VisitedServers[game.JobId] = true
    
    local ApiUrl = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local rawData = nil
    
    pcall(function()
        if httpRequest then
            local response = httpRequest({Url = ApiUrl, Method = "GET"})
            rawData = response.Body
        else
            rawData = game:HttpGet(ApiUrl)
        end
    end)
    
    if rawData then
        local success, result = pcall(function() return Http:JSONDecode(rawData) end)
        
        if success and result and result.data then
            for _, server in pairs(result.data) do
                local currentP = server.playing or 12
                local serverId = server.id
                
                -- Filter: Only join 3-8 player servers, ignoring visited or restricted targets
                if currentP >= 3 and currentP <= 8 and serverId ~= game.JobId and not VisitedServers[serverId] then
                    VisitedServers[serverId] = true
                    StatusLabel.Text = "Status: Hopping to server (" .. currentP .. "/12 players)..."
                    
                    local tpSuccess = pcall(function()
                        Teleport:TeleportToPlaceInstance(game.PlaceId, serverId, game.Players.LocalPlayer)
                    end)
                    
                    if tpSuccess then
                        task.wait(4)
                        return
                    end
                end
            end
        end
    end
    
    -- Fallback retry if scan failed or no eligible server found
    StatusLabel.Text = "Status: Refreshing server list..."
    task.wait(2)
    hopServer()
end

-- Teleport Error Catching System (Bypasses restricted server popups automatically)
game:GetService("TeleportService").TeleportInitFailed:Connect(function(player, teleportResult, errorMessage)
    if player == game.Players.LocalPlayer then
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        StatusLabel.Text = "Status: Restricted server hit. Retrying..."
        task.wait(1)
        hopServer()
    end
end)

-- Primary Execution Thread
task.spawn(function()
    local lp = game.Players.LocalPlayer
    
    -- DIRECT RELIABLE MARINE JOINER
    while true do
        if lp.Team and (lp.Team.Name == "Marines" or lp.Team.Name == "Marine") then
            StatusLabel.Text = "Status: Marines verified! Scans active."
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
            break
        end

        StatusLabel.Text = "Status: Joining Marines..."
        
        -- Method 1: Remote Invoke
        pcall(function()
            local commF = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") and game:GetService("ReplicatedStorage").Remotes:FindFirstChild("CommF")
            if commF then
                commF:InvokeServer("SetTeam", "Marines")
            end
        end)

        -- Method 2: UI Activation Fallback
        pcall(function()
            local mainGui = lp.PlayerGui:FindFirstChild("Main")
            local chooseTeam = mainGui and mainGui:FindFirstChild("ChooseTeam")
            if chooseTeam and chooseTeam.Visible then
                local marineContainer = chooseTeam:FindFirstChild("Container") and chooseTeam.Container:FindFirstChild("Marines")
                if marineContainer then
                    for _, obj in pairs(marineContainer:GetDescendants()) do
                        if obj:IsA("ImageButton") or obj:IsA("TextButton") then
                            if getconnections then
                                for _, conn in pairs(getconnections(obj.Activated)) do conn:Fire() end
                                for _, conn in pairs(getconnections(obj.MouseButton1Click)) do conn:Fire() end
                            end
                        end
                    end
                end
            end
        end)

        task.wait(1.5)
    end
    
    task.wait(1)
    
    -- MAIN SNIPER LOOP
    while task.wait(0.15) do
        if getgenv().FruitSniperEnabled then
            local character = lp.Character
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
                    StatusLabel.Text = "Status: RAID ACTIVE! Stacking " .. #raidEnemies .. " NPCs..."
                    
                    -- Auto Equip Weapon
                    if not character:FindFirstChildOfClass("Tool") then
                        local backpack = lp:FindFirstChild("Backpack")
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
                                    -- Corrected CanCollide handling on parts only
                                    for _, part in pairs(enemy:GetChildren()) do
                                        if part:IsA("BasePart") then
                                            part.CanCollide = false
                                        end
                                    end
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
                            local backpack = lp:FindFirstChild("Backpack")
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
                        -- 4. SAFE SERVER HOP
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
