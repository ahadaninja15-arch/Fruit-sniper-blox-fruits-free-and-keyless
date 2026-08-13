-- Delta Executor Auto-Launch System
if not game:IsLoaded() then game.Loaded:Wait() end
repeat task.wait(1) until game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui")

-- OVERNIGHT AFK PARAMETERS
getgenv().FruitSniperEnabled = true
getgenv().AutoHopEnabled = true
getgenv().AntiAFKEnabled = true
getgenv().AutoGachaEnabled = true

-- TARGET FILTERS (Strict Filtering)
local TargetFruits = {
    ["buddha"] = true,
    ["portal"] = true,
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

-- Setup Background Visual Engine Layout Grid
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local StatusLabel = Instance.new("TextLabel")

ScreenGui.Name = "NinjaPremiumSniper"
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
MainFrame.Size = UDim2.new(0, 260, 0, 100)
MainFrame.BorderSizePixel = 2

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "NINJA MYTHIC & GACHA SNIPER"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.TextSize = 13

StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
StatusLabel.Position = UDim2.new(0.05, 0, 0.40, 0)
StatusLabel.Size = UDim2.new(0.9, 0, 0, 50)
StatusLabel.Font = Enum.Font.SourceSansItalic
StatusLabel.Text = "Status: Waiting 15s for map assets to load completely..."
StatusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
StatusLabel.TextSize = 12
StatusLabel.TextWrapped = true

-- Anti-AFK Engine Module
local vu = game:GetService("VirtualUser")
game.Players.LocalPlayer.Idled:Connect(function()
    if getgenv().AntiAFKEnabled then
        vu:CaptureController()
        vu:ClickButton2(Vector2.new(0,0))
    end
end)

-- Automated Public Server Changer
local function hopServer()
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

-- Core Core Target Scanner & Auto-Storer Background Loop
task.spawn(function()
    -- CRITICAL FIX: Waits 15 seconds to let the server load fruits before scanning
    task.wait(15)
    
    while task.wait(1) do
        local character = game.Players.LocalPlayer.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        
        if root then
            -- 1. AUTO GACHA ROLL AND STORE (Runs seamlessly every 2 hours)
            if getgenv().AutoGachaEnabled then
                pcall(function()
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GachaFruit")
                end)
            end

            -- 2. DISCOVER AND INSPECT MAP FRUITS
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

            -- 3. INTERCEPT AND STOP LOGIC
            if targetFruit then
                -- STOP HOPPING IMMEDIATELY: Protects your spot on this server
                getgenv().AutoHopEnabled = false
                StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
                StatusLabel.Text = "Status: TARGET FOUND (" .. targetFruit.name .. ")! Saving hop..."
                
                -- Teleport directly onto the fruit model
                root.CFrame = targetFruit:GetModelCFrame()
                task.wait(1)
                
                -- Invoke remote data storage systems
                StatusLabel.Text = "Status: Storing " .. targetFruit.name .. " to Inventory Chest..."
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", targetFruit.name, targetFruit)
                task.wait(3)
                
                -- Safely reactivate automation once inventory chest is updated
                getgenv().AutoHopEnabled = true
            else
                -- If no rare fruits are on this map, safely hop to a new one
                if getgenv().AutoHopEnabled then
                    StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                    StatusLabel.Text = "Status: No rare fruits found on this server. Preparing hop..."
                    task.wait(2)
                    hopServer()
                else
                    StatusLabel.Text = "Status: Auto-hop frozen."
                end
            end
        end
    end
end)
