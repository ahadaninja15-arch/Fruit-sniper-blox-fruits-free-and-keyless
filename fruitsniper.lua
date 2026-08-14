-- Delta Executor Native Script Framework
if not game:IsLoaded() then game.Loaded:Wait() end
repeat task.wait(0.5) until game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui")

-- OVERNIGHT AFK PARAMETERS
getgenv().FruitSniperEnabled = true
getgenv().AutoHopEnabled = true
getgenv().AntiAFKEnabled = true
getgenv().AutoPirateRaid = true

-- TARGET FILTERS (Strict Matching Keys)
local TargetFruits = {
    ["buddha"] = true,
    ["portal"] = true,
    ["lightning"] = true,
    ["pain"] = true,
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

local function sendNotification(message, color)
    NotificationLabel.Text = "Notif: " .. message
    if color then
        NotificationLabel.TextColor3 = color
    end
    print("[Ninja Sniper Notif]: " .. message)
end

MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenButton.Visible = true
end)

OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenButton.Visible = false
end)

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

local vu = game:GetService("VirtualUser")
game.Players.LocalPlayer.Idled:Connect(function()
    if getgenv().AntiAFKEnabled then
        vu:CaptureController()
        vu:ClickButton2(Vector2.new(0,0))
    end
end)

-- **CRITICAL FIX: PROXY ADDED FOR ROBLOX API** 
-- Standard Roblox API endpoints block internal game:HttpGet calls (TrustCheck). 
-- This uses roproxy so Delta can successfully read the player counts without silently failing.
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local function hopServer()
    if not getgenv().FruitSniperEnabled or not getgenv().AutoHopEnabled then return end
    StatusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
    StatusLabel.Text = "Status: Scanning active servers via proxy..."
    sendNotification("Checking player counts...", Color3.fromRGB(255, 165, 0))
    
    local success, err = pcall(function()
        local validServers = {}
        local cursor = ""
        
        repeat
            -- Used roproxy.com to bypass TrustCheck limitations in executors
            local url = "https://games.roproxy.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100" .. (cursor ~= "" and "&cursor=" .. cursor or "")
            local response = game:HttpGet(url)
            local data = HttpService:JSONDecode(response)
            
            if data and data.data then
                for _, s in pairs(data.data) do
                    -- Check if fields exist and verify player count is safely below maximum limit
                    if type(s) == "table" and s.playing and s.maxPlayers and s.id then
                        -- Ignores servers that are full or have 1 slot left (must have at least 2 open slots and not current job ID)
                        if s.playing < (s.maxPlayers - 2) and s.id ~= game.JobId then
                            table.insert(validServers, s.id)
                        end
                    end
                end
            end
            
            cursor = data.nextPageCursor
            task.wait(0.2)
        until #validServers > 0 or not cursor or cursor == ""
        
        if #validServers > 0 then
            local targetId = validServers[math.random(1, #validServers)]
            StatusLabel.Text = "Status: Joining verified open server..."
            TeleportService:TeleportToPlaceInstance(game.PlaceId, targetId, game.Players.LocalPlayer)
        else
            -- If proxy fails entirely, fallback to native queue
            TeleportService:Teleport(game.PlaceId, game.Players.LocalPlayer)
        end
    end)
    
    if not success then
        sendNotification("Proxy timeout, using standard queue...", Color3.fromRGB(255, 100, 100))
        pcall(function()
            TeleportService:Teleport(game.PlaceId, game.Players.LocalPlayer)
        end)
    end
    
    task.wait(6)
end

TeleportService.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage)
    if player == game.Players.LocalPlayer then
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        StatusLabel.Text = "Status: Server rejected, finding another..."
        task.wait(1)
        hopServer()
    end
end)

-- **SAFE HAKI TOGGLER**
local function ensureHakiActive(character)
    pcall(function()
        if not character:FindFirstChild("HasBuso") and not character:FindFirstChild("Buso") then
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            if remotes then
                local commF = remotes:FindFirstChild("CommF_") or remotes:FindFirstChild("CommF")
                if commF then
                    commF:InvokeServer("Buso")
                end
            end
            
            local vim = game:GetService("VirtualInputManager")
            if vim then
                vim:SendKeyEvent(true, Enum.KeyCode.J, false, game)
                task.wait(0.05)
                vim:SendKeyEvent(false, Enum.KeyCode.J, false, game)
            end
        end
    end)
end

-- PRIMARY EXECUTION THREAD
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
    while task.wait(0.2) do
        if getgenv().FruitSniperEnabled then
            local character = lp.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChild("Humanoid")
            
            if root and humanoid and humanoid.Health > 0 then
                
                -- 1. OFFICIAL BANNER RAID NOTIFICATION CHECK
                local officialRaidTriggered = false
                if getgenv().AutoPirateRaid then
                    local playerGui = lp:FindFirstChild("PlayerGui")
                    if playerGui then
                        local possibleUIs = {"Transit", "Notifications", "Main", "Banner"}
                        for _, uiName in pairs(possibleUIs) do
                            local container = playerGui:FindFirstChild(uiName)
                            if container then
                                for _, desc in pairs(container:GetDescendants()) do
                                    if desc:IsA("TextLabel") and desc.Visible then
                                        local msg = string.lower(desc.Text)
                                        if string.find(msg, "pirate raid has started") or string.find(msg, "pirates have arrived at the castle") then
                                            officialRaidTriggered = true
                                            break
                                        end
                                    end
                                end
                            end
                            if officialRaidTriggered then break end
                        end
                    end
                end

                if officialRaidTriggered then
                    getgenv().AutoHopEnabled = false
                    StatusLabel.TextColor3 = Color3.fromRGB(255, 140, 0)
                    StatusLabel.Text = "Status: RAID NOTIFICATION FOUND!"
                    sendNotification("Raid banner detected! Heading to COTS.", Color3.fromRGB(255, 140, 0))
                    
                    ensureHakiActive(character)

                    if not character:FindFirstChildOfClass("Tool") then
                        local backpack = lp:FindFirstChild("Backpack")
                        if backpack then
                            local tool = backpack:FindFirstChildOfClass("Tool")
                            if tool then humanoid:EquipTool(tool) end
                        end
                    end

                    root.CFrame = CFrame.new(-5053, 325, -3155)
                    
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
                            if commF then
                                commF:InvokeServer("StoreFruit", fruitNameToStore, holdingFruit or targetFruit)
                            end
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
