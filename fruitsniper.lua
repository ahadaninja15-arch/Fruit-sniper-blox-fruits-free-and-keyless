-- Force script to wait completely until the core game files and your player are active
if not game:IsLoaded() then game.Loaded:Wait() end
repeat task.wait(1) until game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui")

-- Global Automation Settings
getgenv().FruitSniperEnabled = true
getgenv().AutoHopEnabled = true
getgenv().AntiAFKEnabled = true
getgenv().AutoGachaEnabled = true

-- Setup Error-Proof Screen GUI (Utilizing CoreGui to prevent engine render crashes)
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
Title.Text = "NINJA MYTHIC & GACHA SNIPER"
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
StatusLabel.Text = "Status: Handling Marine team selection protocol..."
StatusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
StatusLabel.TextSize = 12
StatusLabel.TextWrapped = true

-- TARGET FILTERS (Strict Filtering Matches)
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

-- Button Click Functionality
ControlButton.MouseButton1Click:Connect(function()
    getgenv().FruitSniperEnabled = not getgenv().FruitSniperEnabled
    if getgenv().FruitSniperEnabled then
        getgenv().AutoHopEnabled = true
        ControlButton.Text = "SCRIPT STATUS: ACTIVE"
        ControlButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        StatusLabel.Text = "Status: Scanning initialized..."
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
    else
        getgenv().AutoHopEnabled = false
        ControlButton.Text = "SCRIPT STATUS: DEACTIVATED"
        ControlButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        StatusLabel.Text = "Status: System paused by player."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

-- Anti-AFK Engine Module (Bypasses 20-minute disconnects)
local vu = game:GetService("VirtualUser")
game.Players.LocalPlayer.Idled:Connect(function()
    if getgenv().AntiAFKEnabled then
        vu:CaptureController()
        vu:ClickButton2(Vector2.new(0,0))
    end
end)

-- Automated Public Server Changer
local function hopServer()
    if not getgenv().FruitSniperEnabled then return end
    StatusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
    StatusLabel.Text = "Status: Server dry. Changing servers..."
    task.wait(1)
    local Http = game:GetService("HttpService")
    local Teleport = game:GetService("TeleportService")
    local success, result = pcall(function()
        return Http:JSONDecode(game:HttpGet("https://roblox.com" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    if success and result and result.data then
        for _, server in pairs(result.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                Teleport:TeleportToPlaceInstance(game.PlaceId, server.id, game.Players.LocalPlayer)
                break
            end
        end
    end
end

-- Core Target Scanner & Auto-Storer Background Loop
task.spawn(function()
    -- FIXED FORCE MARINE LOOP: Runs inside thread and safely handles trailing space remote layout
    local joined = false
    while not joined do
        pcall(function()
            if game.Players.LocalPlayer.Team == nil then
                game:GetService("ReplicatedStorage").Remotes.CommF:InvokeServer("SetTeam", "Marines ")
                task.wait(1)
            else
                joined = true
            end
        end)
        task.wait(0.5)
    end
    
    StatusLabel.Text = "Status: Successfully joined Marines. Waiting 15s to load map..."
    task.wait(15) 
    
    while task.wait(1) do
        if getgenv().FruitSniperEnabled then
            local character = game.Players.LocalPlayer.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            
            if root then
                -- AUTO GACHA ROLL AND STORE
                if getgenv().AutoGachaEnabled then
                    pcall(function()
                        game:GetService("ReplicatedStorage").Remotes.CommF:InvokeServer("GachaFruit")
                    end)
                end

                -- DISCOVER AND INSPECT MAP FRUITS
                local targetFruit = nil
                for _, item in pairs(workspace:GetChildren()) do
                    if string.find(string.lower(item.name), "fruit") and not item:IsA("Texture") then
                        local localizedName = string.lower(item.name):gsub("fruit", ""):gsub("%s+", "")
                        for target, _ in pairs(TargetFruits) do
                            if string.find(localizedName, target) then
                                targetFruit = item
                                break
                            end
                        end
                    end
                end

                -- INTERCEPT AND STOP LOGIC
                if targetFruit then
                    getgenv().AutoHopEnabled = false -- Freeze Hop Sequence
                    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
                    StatusLabel.Text = "Status: TARGET FOUND (" .. targetFruit.name .. ")! Saving hop..."
                    
                    root.CFrame = targetFruit:GetModelCFrame() -- Instant Collection Teleport
                    task.wait(0.8)
                    
                    StatusLabel.Text = "Status: Storing " .. targetFruit.name .. " to Inventory Chest..."
                    game:GetService("ReplicatedStorage").Remotes.CommF:InvokeServer("StoreFruit", targetFruit.name, targetFruit)
                    task.wait(3)
                    
                    getgenv().AutoHopEnabled = true
                else
                    if getgenv().AutoHopEnabled then
                        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                        StatusLabel.Text = "Status: Target fruits not found here. Preparing hop..."
                        task.wait(2)
                        hopServer()
                    end
                end
            end
        end
    end
end)
