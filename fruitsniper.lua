-- Wait for game to fully load
repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

-- Global Toggles
getgenv().FruitSniperEnabled = false
getgenv().AutoHopEnabled = false
getgenv().AntiAFKEnabled = true

-- Create GUI Elements
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local SniperToggle = Instance.new("TextButton")
local HopToggle = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")

-- Configure Screen GUI
ScreenGui.Name = "FruitSniperGUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Menu Frame
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 250, 0, 220)
MainFrame.Active = true
MainFrame.Draggable = true -- Allows you to drag the menu on mobile screen

-- Title Bar
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "NINJA FRUIT SNIPER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

-- Fruit Sniper Toggle Button
SniperToggle.Name = "SniperToggle"
SniperToggle.Parent = MainFrame
SniperToggle.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
SniperToggle.Position = UDim2.new(0.1, 0, 0.25, 0)
SniperToggle.Size = UDim2.new(0.8, 0, 0, 35)
SniperToggle.Font = Enum.Font.SourceSans
SniperToggle.Text = "Fruit Sniper: OFF"
SniperToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
SniperToggle.TextSize = 16

-- Auto Server Hop Toggle Button
HopToggle.Name = "HopToggle"
HopToggle.Parent = MainFrame
HopToggle.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
HopToggle.Position = UDim2.new(0.1, 0, 0.48, 0)
HopToggle.Size = UDim2.new(0.8, 0, 0, 35)
HopToggle.Font = Enum.Font.SourceSans
HopToggle.Text = "Auto Server Hop: OFF"
HopToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
HopToggle.TextSize = 16

-- System Status Tracker Label
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
StatusLabel.Position = UDim2.new(0.1, 0, 0.72, 0)
StatusLabel.Size = UDim2.new(0.8, 0, 0, 40)
StatusLabel.Font = Enum.Font.SourceSansItalic
StatusLabel.Text = "Status: Idle"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 14
StatusLabel.TextWrapped = true

-- Anti-AFK Engine (Always running in background when script launches)
local vu = game:GetService("VirtualUser")
game.Players.LocalPlayer.Idled:Connect(function()
    if getgenv().AntiAFKEnabled then
        vu:CaptureController()
        vu:ClickButton2(Vector2.new(0,0))
    end
end)

-- Server Hopping Logic Function
local function hopServer()
    StatusLabel.Text = "Status: Finding new server..."
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

-- Button Functionality: Toggle Sniper
SniperToggle.MouseButton1Click:Connect(function()
    getgenv().FruitSniperEnabled = not getgenv().FruitSniperEnabled
    if getgenv().FruitSniperEnabled then
        SniperToggle.Text = "Fruit Sniper: ON"
        SniperToggle.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    else
        SniperToggle.Text = "Fruit Sniper: OFF"
        SniperToggle.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        StatusLabel.Text = "Status: Idle"
    end
end)

-- Button Functionality: Toggle Auto Hop
HopToggle.MouseButton1Click:Connect(function()
    getgenv().AutoHopEnabled = not getgenv().AutoHopEnabled
    if getgenv().AutoHopEnabled then
        HopToggle.Text = "Auto Server Hop: ON"
        HopToggle.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    else
        HopToggle.Text = "Auto Server Hop: OFF"
        HopToggle.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    end
end)

-- Main Background Scanning Thread Loop
task.spawn(function()
    while task.wait(1) do
        if getgenv().FruitSniperEnabled then
            local character = game.Players.LocalPlayer.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            
            if root then
                local currentFruit = nil
                -- Scan workspace map objects for things named fruit
                for _, item in pairs(workspace:GetChildren()) do
                    if string.find(string.lower(item.name), "fruit") then
                        currentFruit = item
                        break
                    end
                end
                
                if currentFruit then
                    StatusLabel.Text = "Status: Found " .. currentFruit.name .. "! Teleporting..."
                    root.CFrame = currentFruit:GetModelCFrame()
                    task.wait(0.5)
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", currentFruit.name, currentFruit)
                else
                    if getgenv().AutoHopEnabled then
                        StatusLabel.Text = "Status: No fruits. Triggering hop..."
                        task.wait(2)
                        hopServer()
                    else
                        StatusLabel.Text = "Status: No fruits found on this server."
                    end
                end
            end
        end
    end
end)
