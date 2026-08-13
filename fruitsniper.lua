-- Ensure the game space is loaded before executing
if not game:IsLoaded() then game.Loaded:Wait() end

-- Anti-AFK Kick Bypass Module
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Automated Server Hopper
local function hop()
    local Http = game:GetService("HttpService")
    local Teleport = game:GetService("TeleportService")
    local success, servers = pcall(function()
        return Http:JSONDecode(game:HttpGet("https://roblox.com" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    if success and servers and servers.data then
        for _, s in pairs(servers.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                Teleport:TeleportToPlaceInstance(game.PlaceId, s.id, game.Players.LocalPlayer)
                return
            end
        end
    end
end

-- Core Fruit Sniper & Storage Loop
task.spawn(function()
    while task.wait(2) do
        local root = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local fruit = nil
            for _, obj in pairs(workspace:GetChildren()) do
                if string.find(string.lower(obj.name), "fruit") then
                    fruit = obj
                    break
                end
            end
            if fruit then
                root.CFrame = fruit:GetModelCFrame()
                task.wait(1)
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", fruit.name, fruit)
            else
                hop()
            end
        end
    end
end)
