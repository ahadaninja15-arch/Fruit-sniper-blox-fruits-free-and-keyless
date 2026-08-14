-- Delta Executor Native Script Framework
if not game:IsLoaded() then game.Loaded:Wait() end
repeat task.wait(0.5) until game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui")

-- OVERNIGHT AFK PARAMETERS
getgenv().FruitSniperEnabled = true
getgenv().AutoHopEnabled = true
getgenv().AntiAFKEnabled = true
getgenv().AutoPirateRaid = true   -- Auto fights Castle on the Sea pirate raid events only

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

-- Setup Draggable UI Framework with Minimize / Open Button
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local MinimizeButton = Instance.new("TextButton")
local ControlButton = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")
local OpenButton = Instance.new("TextButton")
local NotificationLabel = Instance.new("TextLabel")

ScreenGui.Name = "NinjaPremiumSniper"
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
MainFrame.Size = UDim2.new(0, 260, 0, 165)
MainFrame.BorderSizePixel = 2
MainFrame.Active = true
MainFrame.Draggable = true 

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Title.Size = UDim2.new(1, -30, 0, 30)
Title.Font = Enum.Font.SourceSansBold
Title.Text = " NINJA MYTHIC & RAID SNIPER"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = MainFrame
MinimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
MinimizeButton.Position = UDim2.new(1, -30, 0, 0)
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 18

OpenButton.Name = "OpenButton"
OpenButton.Parent = ScreenGui
OpenButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
OpenButton.Position = UDim2.new(0.05, 0, 0.05, 0)
OpenButton.Size = UDim2.new(0, 80, 0, 30)
OpenButton.Font = Enum.Font.SourceSansBold
OpenButton.Text = "OPEN UI"
OpenButton.TextColor3 = Color3.fromRGB(255, 215, 0)
OpenButton.TextSize = 12
OpenButton.Visible = false
OpenButton.Active = true
OpenButton.Draggable = true

ControlButton.Name = "ControlButton"
ControlButton.Parent = MainFrame
ControlButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
ControlButton.Position = UDim2.new(0.05, 0, 0.22, 0)
ControlButton.Size = UDim2.new(0.9, 0, 0, 30)
ControlButton.Font = Enum.Font.SourceSansBold
ControlButton.Text = "SCRIPT STATUS: ACTIVE"
ControlButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ControlButton.TextSize = 14

StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
StatusLabel.Position = UDim2.new(0.05, 0, 0.43, 0)
StatusLabel.Size = UDim2.new(0.9, 0, 0, 40)
StatusLabel.Font = Enum.Font.SourceSansItalic
StatusLabel.Text = "Status: Initializing..."
StatusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
StatusLabel.TextSize = 12
StatusLabel.TextWrapped = true

NotificationLabel.Name = "NotificationLabel"
NotificationLabel.Parent = MainFrame
NotificationLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
NotificationLabel.Position = UDim2.new(0.05, 0, 0.70, 0)
NotificationLabel.Size = UDim2.new(0.9, 0, 0, 40)
NotificationLabel.Font = Enum.Font.SourceSansBold
NotificationLabel.Text = "Notif: Ready for scanning."
NotificationLabel.TextColor3 = Color3.fromRGB(0, 220, 255)
NotificationLabel.TextSize = 11
NotificationLabel.TextWrapped = true

-- Notification Function
local function sendNotification(message, color)
    NotificationLabel.Text = "Notif: " .. message
    if color then
        NotificationLabel.TextColor3 = color
    end
    print("[Ninja Sniper Notif]: " .. message)
end

-- Minimize / Open Logic
MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenButton.Visible = true
end)

OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenButton.Visible = false
end)

-- Toggle System State
ControlButton.MouseButton1Click:Connect(function()
    getgenv().FruitSniperEnabled = not getgenv().FruitSniperEnabled
    if getgenv().FruitSniperEnabled then
        getgenv().AutoHopEnabled = true
        ControlButton.Text = "SCRIPT STATUS: ACTIVE"
        ControlButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        StatusLabel.Text = "Status: Active..."
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
        sendNotification("Script activated!", Color3.fromRGB(0, 255, 150))
    else
        getgenv().AutoHopEnabled = false
        ControlButton.Text = "SCRIPT STATUS: DEACTIVATED"
        ControlButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        StatusLabel.Text = "Status: Paused."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        sendNotification("Script paused.", Color3.fromRGB(255, 100, 100))
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

-- DELTA NATIVE REQUEST BRIDGE FOR SERVER LIST FETCHING
local requestFunc = (syn and syn.request) or request or http_request or (fluxus and fluxus.request)

local function hopServer()
    if not getgenv().FruitSniperEnabled or not getgenv().AutoHopEnabled then return end
    StatusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
    StatusLabel.Text = "Status: Fetching public servers..."
    sendNotification("Searching for a better server...", Color3.fromRGB(255, 165, 0))
    task.wait(0.5)
    
    local Http = game:GetService("HttpService")
    local Teleport = game:GetService("TeleportService")
    
    VisitedServers[game.JobId] = true
    
    local ApiUrl = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
    local rawData = nil
    
    pcall(function()
        if requestFunc then
            local response = requestFunc({
                Url = ApiUrl,
                Method = "GET"
            })
            if response and response.Body then
                rawData = response.Body
            end
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
                
                -- Target 3-8 player servers safely
                if currentP >= 3 and currentP <= 8 and serverId ~= game.JobId and not VisitedServers[serverId] then
                    VisitedServers[serverId] = true
                    StatusLabel.Text = "Status: Hopping (" .. currentP .. "/8 players)..."
                    sendNotification("Hopping to server with " .. currentP .. " players!", Color3.fromRGB(0, 255, 200))
                    
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
    
    StatusLabel.Text = "Status: Retrying server list..."
    task.wait(2)
    hopServer()
end

game:GetService("TeleportService").TeleportInitFailed:Connect(function(player, teleportResult, errorMessage)
    if player == game.Players.LocalPlayer then
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        StatusLabel.Text = "Status: Restricted server hit. Retrying..."
        sendNotification("Restricted server block hit, retrying hop...", Color3.fromRGB(255, 80, 80))
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
            sendNotification("Successfully joined Marines team!", Color3.fromRGB(0, 255, 120))
            break
        end

        StatusLabel.Text = "Status: Joining Marines..."
        
        pcall(function()
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            if remotes then
                local commF = remotes:FindFirstChild("CommF_") or remotes:FindFirstChild("CommF")
                if commF then
                    commF:InvokeServer("SetTeam", "Marines")
                end
            end
        end)

        pcall(function()
            local playerGui = lp:FindFirstChild("PlayerGui")
            local mainGui = playerGui and playerGui:FindFirstChild("Main")
            local chooseTeam = mainGui and mainGui:FindFirstChild("ChooseTeam")
            if chooseTeam then
                local container = chooseTeam:FindFirstChild("Container")
                local marineBtn = container and container:FindFirstChild("Marines")
                if marineBtn then
                    local frame = marineBtn:FindFirstChild("Frame") or marineBtn
                    for _, v in pairs(frame:GetDescendants()) do
                        if v:IsA("TextButton") or v:IsA("ImageButton") then
                            if getconnections then
                                for _, conn in pairs(getconnections(v.MouseButton1Click)) do conn:Fire() end
                                for _, conn in pairs(getconnections(v.Activated)) do conn:Fire() end
                            end
                        end
                    end
                end
            end
        end)

        task.wait(2)
    end
    
    task.wait(1)
    
    -- MAIN SNIPER LOOP
    while task.wait(0.15) do
        if getgenv().FruitSniperEnabled then
            local character = lp.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChild("Humanoid")
            
            if root and humanoid and humanoid.Health > 0 then
                -- 1. STRICT CASTLE ON THE SEA PIRATE RAID DETECTOR
                local raidEnemies = {}
                if getgenv().AutoPirateRaid then
                    local enemies = workspace:FindFirstChild("Enemies")
                    if enemies then
                        for _, enemy in pairs(enemies:GetChildren()) do
                            local eRoot = enemy:FindFirstChild("HumanoidRootPart")
                            local hum = enemy:FindFirstChild("Humanoid")
                            
                            if eRoot and hum and hum.Health > 0 then
                                local distToCastle = (eRoot.Position - Vector3.new(-5053, 315, -3155)).Magnitude
                                if distToCastle <= 350 then
                                    local name = string.lower(enemy.Name)
                                    if string.find(name, "pirate") or string.find(name, "island boy") or string.find(name, "captain elephant") or string.find(name, "mythological pirate") then
                                        table.insert(raidEnemies, enemy)
                                    end
                                end
                            end
                        end
                    end
                end

                if #raidEnemies > 0 then
                    getgenv().AutoHopEnabled = false
                    StatusLabel.TextColor3 = Color3.fromRGB(255, 140, 0)
                    StatusLabel.Text = "Status: CASTLE RAID ACTIVE!"
                    sendNotification("Castle Raid active! Fighting " .. #raidEnemies .. " raiders.", Color3.fromRGB(255, 140, 0))
                    
                    if not character:FindFirstChildOfClass("Tool") then
                        local backpack = lp:FindFirstChild("Backpack")
                        if backpack then
                            local tool = backpack:FindFirstChildOfClass("Tool")
                            if tool then humanoid:EquipTool(tool) end
                        end
                    end

                    -- Hover safely above the target (10 studs up) to avoid enemy melee hits
                    local baseTarget = raidEnemies[1]:FindFirstChild("HumanoidRootPart")
                    if baseTarget then
                        root.CFrame = baseTarget.CFrame + Vector3.new(0, 10, 0)
                    end
                    
                    vu:CaptureController()
                    vu:ClickButton1(Vector2.new(0,0))
                else
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
                        StatusLabel.Text = "Status: TARGET FOUND!"
                        sendNotification("Found target fruit: " .. targetFruit.Name .. "!", Color3.fromRGB(0, 255, 120))
                        
                        if targetFruit:IsA("Model") then
                            root.CFrame = targetFruit:GetPivot()
                        elseif targetFruit:IsA("BasePart") then
                            root.CFrame = targetFruit.CFrame
                        end
                        
                        task.wait(0.8)
                        
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

                        StatusLabel.Text = "Status: Storing fruit..."
                        sendNotification("Storing " .. targetFruit.Name .. " in inventory...", Color3.fromRGB(0, 220, 255))
                        
                        local fruitNameToStore = holdingFruit and holdingFruit.Name or targetFruit.Name
                        pcall(function()
                            local ReplicatedStorage = game:GetService("ReplicatedStorage")
                            local commF = ReplicatedStorage.Remotes:FindFirstChild("CommF_") or ReplicatedStorage.Remotes:FindFirstChild("CommF")
                            commF:InvokeServer("StoreFruit", fruitNameToStore, holdingFruit or targetFruit)
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
