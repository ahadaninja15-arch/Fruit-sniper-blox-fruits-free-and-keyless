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

-- TARGET FRUIT FILTERS
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

-- SETUP CLEAN, MODERN DARK UI FRAMEWORK
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICornerMain = Instance.new("UICorner")
local TopBar = Instance.new("Frame")
local UICornerTop = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local MinimizeButton = Instance.new("TextButton")

local Container = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

local ControlButton = Instance.new("TextButton")
local UICornerBtn1 = Instance.new("UICorner")

local StatusLabel = Instance.new("TextLabel")
local UICornerStatus = Instance.new("UICorner")

local NotificationLabel = Instance.new("TextLabel")
local UICornerNotif = Instance.new("UICorner")

local OpenButton = Instance.new("TextButton")
local UICornerOpen = Instance.new("UICorner")

ScreenGui.Name = "NinjaPremiumSniper"
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
MainFrame.Size = UDim2.new(0, 270, 0, 225)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true 

UICornerMain.CornerRadius = UDim.new(0, 8)
UICornerMain.Parent = MainFrame

TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TopBar.Size = UDim2.new(1, 0, 0, 32)
TopBar.BorderSizePixel = 0

UICornerTop.CornerRadius = UDim.new(0, 8)
UICornerTop.Parent = TopBar

Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "NINJA MYTHIC & RAID SNIPER"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.TextSize = 11
Title.TextXAlignment = Enum.TextXAlignment.Left

MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TopBar
MinimizeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
MinimizeButton.Position = UDim2.new(1, -28, 0, 4)
MinimizeButton.Size = UDim2.new(0, 24, 0, 24)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 14
local UICornerMin = Instance.new("UICorner")
UICornerMin.CornerRadius = UDim.new(0, 4)
UICornerMin.Parent = MinimizeButton

OpenButton.Name = "OpenButton"
OpenButton.Parent = ScreenGui
OpenButton.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
OpenButton.Position = UDim2.new(0.05, 0, 0.05, 0)
OpenButton.Size = UDim2.new(0, 85, 0, 32)
OpenButton.Font = Enum.Font.GothamBold
OpenButton.Text = "OPEN UI"
OpenButton.TextColor3 = Color3.fromRGB(255, 215, 0)
OpenButton.TextSize = 12
OpenButton.Visible = false
OpenButton.Active = true
OpenButton.Draggable = true
UICornerOpen.CornerRadius = UDim.new(0, 6)
UICornerOpen.Parent = OpenButton

Container.Name = "Container"
Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 10, 0, 40)
Container.Size = UDim2.new(1, -20, 1, -48)
Container.CanvasSize = UDim2.new(0, 0, 0, 190)
Container.ScrollBarThickness = 3

UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

ControlButton.Name = "ControlButton"
ControlButton.Parent = Container
ControlButton.BackgroundColor3 = Color3.fromRGB(40, 160, 80)
ControlButton.Size = UDim2.new(1, 0, 0, 32)
ControlButton.Font = Enum.Font.GothamBold
ControlButton.Text = "SCRIPT STATUS: ACTIVE"
ControlButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ControlButton.TextSize = 12
UICornerBtn1.CornerRadius = UDim.new(0, 6)
UICornerBtn1.Parent = ControlButton

StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = Container
StatusLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
StatusLabel.Size = UDim2.new(1, 0, 0, 40)
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.Text = "Status: Initializing..."
StatusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
StatusLabel.TextSize = 11
StatusLabel.TextWrapped = true
UICornerStatus.CornerRadius = UDim.new(0, 6)
UICornerStatus.Parent = StatusLabel

NotificationLabel.Name = "NotificationLabel"
NotificationLabel.Parent = Container
NotificationLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
NotificationLabel.Size = UDim2.new(1, 0, 0, 40)
NotificationLabel.Font = Enum.Font.GothamMedium
NotificationLabel.Text = "Notif: Ready for scanning."
NotificationLabel.TextColor3 = Color3.fromRGB(0, 220, 255)
NotificationLabel.TextSize = 11
NotificationLabel.TextWrapped = true
UICornerNotif.CornerRadius = UDim.new(0, 6)
UICornerNotif.Parent = NotificationLabel

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
        ControlButton.BackgroundColor3 = Color3.fromRGB(40, 160, 80)
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

-- BULLETPROOF SERVER HOPPER (FILTERS PRIVATE, FULL, & VIP SERVERS)
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
    StatusLabel.Text = "Status: Filtering clean servers..."
    sendNotification("Scanning public API...", Color3.fromRGB(255, 165, 0))
    
    local success, err = pcall(function()
        local validServers = {}
        local cursor = ""
        
        for i = 1, 4 do
            local url = "https://games.roproxy.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100" .. (cursor ~= "" and "&cursor=" .. cursor or "")
            local response = game:HttpGet(url)
            local data = HttpService:JSONDecode(response)
            
            if data and data.data then
                for _, s in pairs(data.data) do
                    if type(s) == "table" and s.id and s.playing and s.maxPlayers then
                        -- Strict checks to avoid VIP, restricted, full, or dead servers
                        local isPrivateOrRestricted = s.private or s.showPrivateContent == true
                        if not isPrivateOrRestricted and s.id ~= game.JobId and not serverBlacklist[s.id] then
                            if s.playing >= 3 and s.playing <= (s.maxPlayers - 2) then
                                table.insert(validServers, s.id)
                            end
                        end
                    end
                end
            end
            
            if data.nextPageCursor and data.nextPageCursor ~= "" then
                cursor = data.nextPageCursor
            else
                break
            end
            task.wait(0.05)
        end
        
        if #validServers > 0 then
            local targetId = validServers[math.random(1, #validServers)]
            serverBlacklist[targetId] = os.time()
            saveBlacklist(serverBlacklist)
            
            StatusLabel.Text = "Status: Teleporting to public server..."
            TeleportService:TeleportToPlaceInstance(game.PlaceId, targetId, LocalPlayer)
        else
            -- Safe public queue fallback using standard Roblox service instead of random raw IDs
            StatusLabel.Text = "Status: Fallback queue hop..."
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end
    end)
    
    if not success then
        sendNotification("Hop exception, retrying...", Color3.fromRGB(255, 100, 100))
        task.wait(2)
        isHopping = false
        pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
    end
    
    task.wait(8)
    isHopping = false 
end

TeleportService.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage)
    if player == LocalPlayer then
        isHopping = false
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        StatusLabel.Text = "Status: Hop rejected/restricted, retrying..."
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
