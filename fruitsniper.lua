-- Delta Executor Native Script Framework
if not game:IsLoaded() then game.Loaded:Wait() end
repeat task.wait(1) until game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui")

-- OVERNIGHT AFK PARAMETERS
getgenv().FruitSniperEnabled = true
getgenv().AutoHopEnabled = true
getgenv().AntiAFKEnabled = true
getgenv().AutoPirateRaid = true   -- Auto fights Castle/Pirate Raids when active

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
    StatusLabel.Text = "Status: Changing server..."
    task.wait(1)
    
    local Http = game:GetService("HttpService")
    local Teleport = game:GetService("TeleportService")
    local ApiUrl = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    
    local success, result = pcall(function()
        return Http:JSONDecode(game:HttpGet(ApiUrl))
    end)
    
    if success and result and result.data then
        for _, server in pairs(result.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                pcall(function()
                    Teleport:TeleportToPlaceInstance(game.PlaceId, server.id, game.Players.LocalPlayer)
                end)
                task.wait(3)
                break
            end
        end
    end
end

-- Primary Execution Thread
task.spawn(function()
    -- Join Marines Loop
    StatusLabel.Text = "Status: Joining Marine Team..."
    local teamJoined = false
    local attempts = 0
    
    while not teamJoined and attempts < 20 do
        attempts = attempts + 1
        pcall(function()
            if game.Players.LocalPlayer.Team == nil or game.Players.LocalPlayer.Team.Name == "Neutral" then
                game:GetService("ReplicatedStorage").Remotes.CommF:InvokeServer("SetTeam", "Marines")
                game:GetService("ReplicatedStorage").Remotes.CommF:InvokeServer("SetTeam", "Marines ")
            else
                teamJoined = true
            end
        end)
        task.wait(0.5)
    end
    
    StatusLabel.Text = "Status: Joined Marines. Loading assets..."
    task.wait(8) 
    
    while task.wait(0.5) do
        if getgenv().FruitSniperEnabled then
            local character = game.Players.LocalPlayer.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            
            if root then
                -- 1. DETECT & DEFEND PIRATE RAID
                local raidEnemy = nil
                if getgenv().AutoPirateRaid then
                    local enemies = workspace:FindFirstChild("Enemies")
                    if enemies then
                        for _, enemy in pairs(enemies:GetChildren()) do
                            local name = string.lower(enemy.Name)
                            if (string.find(name, "pirate") or string.find(name, "raid") or string.find(name, "tank") or string.find(name, "raider")) then
                                local hum = enemy:FindFirstChild("Humanoid")
                                if hum and hum.Health > 0 then
                                    raidEnemy = enemy
                                    break
                                end
                            end
                        end
                    end
                end

                if raidEnemy and raidEnemy:FindFirstChild("HumanoidRootPart") then
                    getgenv().AutoHopEnabled = false
                    StatusLabel.TextColor3 = Color3.fromRGB(255, 140, 0)
                    StatusLabel.Text = "Status: PIRATE RAID ACTIVE! Defending..."
                    
                    local eRoot = raidEnemy:FindFirstChild("HumanoidRootPart")
                    if eRoot and eRoot.Parent then
                        -- Equip tool if unequipped
                        if not character:FindFirstChildOfClass("Tool") then
                            local backpack = game.Players.LocalPlayer:FindFirstChild("Backpack")
                            if backpack then
                                local tool = backpack:FindFirstChildOfClass("Tool")
                                if tool then
                                    character.Humanoid:EquipTool(tool)
                                end
                            end
                        end
                        
                        -- Hover position
                        root.CFrame = eRoot.CFrame * CFrame.new(0, 4, 0)
                        
                        -- Trigger attack
                        vu:CaptureController()
                        vu:ClickButton1(Vector2.new(0,0))
                    end
                else
                    -- 2. SCAN GROUND FOR TARGET FRUITS
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

                    -- 3. TARGET FOUND HANDLING
                    if targetFruit then
                        getgenv().AutoHopEnabled = false
                        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
                        StatusLabel.Text = "Status: TARGET FOUND (" .. targetFruit.Name .. ")!"
                        
                        if targetFruit:IsA("Model") then
                            root.CFrame = targetFruit:GetPivot()
                        elseif targetFruit:IsA("BasePart") then
                            root.CFrame = targetFruit.CFrame
                        end
                        
                        task.wait(0.8)
                        StatusLabel.Text = "Status: Storing " .. targetFruit.Name .. "..."
                        game:GetService("ReplicatedStorage").Remotes.CommF:InvokeServer("StoreFruit", targetFruit.Name, targetFruit)
                        task.wait(3)
                        getgenv().AutoHopEnabled = true
                    else
                        -- 4. SERVER HOP IF NO RAID OR FRUITS
                        if getgenv().AutoHopEnabled then
                            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                            StatusLabel.Text = "Status: Server clear. Hopping..."
                            task.wait(1.5)
                            hopServer()
                        end
                    end
                end
            end
        end
    end
end)
