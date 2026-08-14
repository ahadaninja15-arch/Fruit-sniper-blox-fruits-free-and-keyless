-- Delta Executor Native Script Framework
if not game:IsLoaded() then game.Loaded:Wait() end
repeat task.wait(0.5) until game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui")

-- OVERNIGHT AFK & TOGGLE PARAMETERS
getgenv().FruitSniperEnabled = true
getgenv().AutoHopEnabled = true
getgenv().AntiAFKEnabled = true
getgenv().AutoPirateRaid = true
getgenv().AutoBusoHaki = true   
getgenv().AutoKenHaki = false   

-- TARGET FILTERS
local TargetFruits = {
    ["buddha"] = true, ["portal"] = true, ["lightning"] = true,
    ["pain"] = true, ["kitsune"] = true, ["dragon"] = true,
    ["leopard"] = true, ["dough"] = true, ["t-rex"] = true,
    ["mammoth"] = true, ["spirit"] = true, ["control"] = true,
    ["venom"] = true, ["shadow"] = true, ["gravity"] = true
}

-- SERVICES DECLARATION
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = game.Players.LocalPlayer

-- SETUP DRAGGABLE UI FRAMEWORK
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
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

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
    if color then NotificationLabel.TextColor3 = color end
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

-- ANTI-AFK SYSTEM
LocalPlayer.Idled:Connect(function()
    if getgenv().AntiAFKEnabled then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0,0))
    end
end)

-- AUTOMATED DUAL HAKI SYSTEM MODULE
local function activateHaki()
    if not getgenv().FruitSniperEnabled then return end
    
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end

    if getgenv().AutoBusoHaki then
        local hasBusoActive = character:FindFirstChild("HasBuso") or character:FindFirstChild("Buso")
        if not hasBusoActive then
            pcall(function()
                local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                local commF = remotes and (remotes:FindFirstChild("CommF_") or remotes:FindFirstChild("CommF"))
                if commF then commF:InvokeServer("Buso") end
            end)
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.J, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.J, false, game)
            end)
        end
    end

    if getgenv().AutoKenHaki then
        local hasKenActive = character:FindFirstChild("HasKen") or character:FindFirstChild("Ken")
        if not hasKenActive then
            pcall(function()
                local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                local commF = remotes and (remotes:FindFirstChild("CommF_") or remotes:FindFirstChild("CommF"))
                if commF then commF:InvokeServer("Ken") end
            end)
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            end)
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    newCharacter:WaitForChild("HumanoidRootPart", 10)
    task.wait(1.5)
    activateHaki()
end)

task.spawn(function()
    while task.wait(3) do
        activateHaki()
    end
end)

-- ADVANCED SERVER HOPPER (RESTRICTED & GHOST SERVER BYPASS)
local isHopping = false 

local function getBlacklist()
    if isfile and readfile and isfile("NinjaServerBlacklist.json") then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile("NinjaServerBlacklist.json"))
        end)
        if success and type(data) == "table" then return data end
    end
    return {}
end

local function saveBlacklist(tbl)
    if writefile then
        pcall(function()
            writefile("NinjaServerBlacklist.json", HttpService:JSONEncode(tbl))
        end)
    end
end

local serverBlacklist = getBlacklist()
serverBlacklist[game.JobId] = os.time() 

for id, timeAdded in pairs(serverBlacklist) do
    if os.time() - timeAdded > 1800 then
        serverBlacklist[id] = nil
    end
end
saveBlacklist(serverBlacklist)

local function hopServer()
    if not getgenv().FruitSniperEnabled or not getgenv().AutoHopEnabled or isHopping then return end
    isHopping = true 
    
    StatusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
    StatusLabel.Text = "Status: Bypassing restricted servers..."
    sendNotification("Scanning for healthy servers...", Color3.fromRGB(255, 165, 0))
    
    local success, err = pcall(function()
        local validServers = {}
        local cursors = {"", "&cursor=1", "&cursor=2"} 
        local randomCursor = cursors[math.random(1, #cursors)]
        
        local url = "https://games.roproxy.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100" .. randomCursor
        local response = game:HttpGet(url)
        local data = HttpService:JSONDecode(response)
        
        if data and data.data then
            for _, s in pairs(data.data) do
                if type(s) == "table" and s.id and s.playing and s.maxPlayers then
                    -- STRICT FILTER: Valid ping, not blacklisted, not current, 6 to 10 players
                    if s.ping and not serverBlacklist[s.id] and s.id ~= game.JobId then
                        if s.playing >= 6 and s.playing <= (s.maxPlayers - 2) then
                            table.insert(validServers, s.id)
                        end
                    end
                end
            end
        end
        
        if #validServers > 0 then
            local targetId = validServers[math.random(1, #validServers)]
            serverBlacklist[targetId] = os.time()
            saveBlacklist(serverBlacklist)
            
            StatusLabel.Text = "Status: Teleporting safely..."
            TeleportService:TeleportToPlaceInstance(game.PlaceId, targetId, LocalPlayer)
        else
            sendNotification("Proxy empty, trying deep search...", Color3.fromRGB(255, 165, 0))
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end
    end)
    
    if not success then
        sendNotification("Proxy timeout, standard queue...", Color3.fromRGB(255, 100, 100))
        pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
    end
    
    task.wait(10)
    isHopping = false 
end

TeleportService.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage)
    if player == LocalPlayer then
        isHopping = false
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        StatusLabel.Text = "Status: Hop rejected, grabbing new ID..."
        task.wait(1)
        hopServer()
    end
end)

-- PRIMARY EXECUTION THREAD
task.spawn(function()
    while true do
        if LocalPlayer.Team and (LocalPlayer.Team.Name == "Marines" or LocalPlayer.Team.Name == "Marine") then
            StatusLabel.Text = "Status: Marines verified! Scans active."
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
            sendNotification("Successfully joined Marines team!", Color3.fromRGB(0, 255, 120))
            break
        end

        StatusLabel.Text = "Status: Joining Marines..."
        
        pcall(function()
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            if remotes then
                local commF = remotes:FindFirstChild("CommF_") or remotes:FindFirstChild("CommF")
                if commF then commF:InvokeServer("SetTeam", "Marines") end
            end
        end)

        pcall(function()
            local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
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
    
    while task.wait(0.2) do
        if getgenv().FruitSniperEnabled then
            local character = LocalPlayer.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChild("Humanoid")
            
            if root and humanoid and humanoid.Health > 0 then
                
                local officialRaidTriggered = false
                if getgenv().AutoPirateRaid then
                    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
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
                    
                    activateHaki()

                    if not character:FindFirstChildOfClass("Tool") then
                        local backpack = LocalPlayer:FindFirstChild("Backpack")
                        if backpack then
                            local tool = backpack:FindFirstChildOfClass("Tool")
                            if tool then humanoid:EquipTool(tool) end
                        end
                    end

                    root.CFrame = CFrame.new(-5053, 325, -3155)
                    
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton1(Vector2.new(0,0))
                else
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
                            local backpack = LocalPlayer:FindFirstChild("Backpack")
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
                            local commF = ReplicatedStorage.Remotes:FindFirstChild("CommF_") or ReplicatedStorage.Remotes:FindFirstChild("CommF")
                            if commF then
                                commF:InvokeServer("StoreFruit", fruitNameToStore, holdingFruit or targetFruit)
                            end
                        end)
                        
                        task.wait(2)
                        getgenv().AutoHopEnabled = true
                    else
                        if getgenv().AutoHopEnabled and not isHopping then
                            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                            StatusLabel.Text = "Status: Server clear. Hopping..."
                            hopServer()
                        end
                    end
                end
            end
        end
    end
end)
