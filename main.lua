--// Anti-AFK
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    local vu = game:GetService("VirtualUser")
    vu:CaptureController()
    vu:ClickButton2(Vector2.new())
end)

--// UI Lib
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Marco8642/science/main/ui%20libs2"))()
local window = library:CreateWindow({ text = "Ultimate Auto Farm Hub" })

--// ENV Settings
local env = getfenv()
env.drivertype = "Rural Bus Driver"

--// Dropdowns
window:AddDropdown({"Select Bus Driver Type", "Rural Bus Driver", "City Bus Driver"}, function(state)
    if state ~= "Select Bus Driver Type" then env.drivertype = state end
end)

--// Toggles for Auto Farm
-- Bus
window:AddToggle("Auto Farm [Bus]", function(state)
    env.busFarm = state
    task.spawn(function()
        while env.busFarm do
            pcall(function()
                local player = game.Players.LocalPlayer
                local char = player.Character
                local gui = player.PlayerGui
                local vehicle = workspace.Vehicles:FindFirstChild(player.Name)

                if vehicle and char and not char.Humanoid.SeatPart and gui:FindFirstChild("Part") then
                    vehicle.DriveSeat:Sit(char.Humanoid)
                end

                if vehicle and not gui:FindFirstChild("Part") then
                    vehicle:PivotTo(CFrame.new(-1683, 15, -1286))
                    task.wait(1)
                    char.Humanoid.Sit = false
                    task.wait(2)

                    if player:DistanceFromCharacter(Vector3.new(-1683, 5, -1286)) < 50 then
                        char.Humanoid:MoveTo(Vector3.new(-1708, 5, -1281))
                        char.Humanoid.MoveToFinished:Wait()
                        char.Humanoid:MoveTo(Vector3.new(-1730, 5, -1280))
                        char.Humanoid.MoveToFinished:Wait()

                        local vim = game:GetService("VirtualInputManager")
                        repeat
                            task.wait()
                            vim:SendKeyEvent(true, "E", false, game)
                            vim:SendKeyEvent(false, "E", false, game)
                        until #gui.ShiftSystem:GetChildren() > 0

                        for _, btn in pairs(gui.ShiftSystem:GetDescendants()) do
                            if btn:IsA("ImageButton") and btn.Name == env.drivertype then
                                firesignal(btn.MouseButton1Click)
                                break
                            end
                        end

                        task.wait(2)
                        for _, btn in pairs(gui.ShiftSystem:GetDescendants()) do
                            if btn:IsA("ImageButton") and btn.ImageColor3 == Color3.fromRGB(142, 68, 173) then
                                firesignal(btn.MouseButton1Click)
                            end
                        end
                    end
                end
            end)
            task.wait(1)
        end
    end)
end)

-- Truck
window:AddToggle("Auto Farm [Truck]", function(state)
    env.truckFarm = state
    task.spawn(function()
        while env.truckFarm do
            pcall(function()
                local player = game.Players.LocalPlayer
                local char = player.Character
                local gui = player.PlayerGui
                local vehicle = workspace.Vehicles:FindFirstChild(player.Name)

                if vehicle and vehicle.Body:FindFirstChild("Trailer") and not char.Humanoid.SeatPart then
                    vehicle.DriveSeat:Sit(char.Humanoid)
                end

                if gui:FindFirstChild("DeliverySystem") and gui.DeliverySystem.Enabled then
                    local bestOption, maxXP = nil, 0
                    for _, el in pairs(gui.DeliverySystem:GetDescendants()) do
                        if el:IsA("TextLabel") and el.Text:find("XP") then
                            local val = tonumber(el.Text:split(" ")[1])
                            if val and val > maxXP then
                                maxXP = val
                                bestOption = el.Parent
                            end
                        end
                    end
                    if bestOption then firesignal(bestOption.MouseButton1Click) end
                end
            end)
            task.wait(1)
        end
    end)
end)

--// Utilities
window:AddButton("Teleport to Job Center", function()
    game.Players.LocalPlayer.Character:PivotTo(CFrame.new(-1700, 5, -1280))
end)

window:AddSlider("WalkSpeed", { min = 16, max = 150, default = 16 }, function(val)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
end)

window:AddSlider("JumpPower", { min = 50, max = 250, default = 50 }, function(val)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = val
end)

window:AddToggle("Fly (Q)", function(state)
    local UIS = game:GetService("UserInputService")
    local player = game.Players.LocalPlayer
    local char = player.Character
    local HRP = char:WaitForChild("HumanoidRootPart")
    local flying = false
    local bodyGyro, bodyVel

    if state then
        flying = true
        bodyGyro = Instance.new("BodyGyro", HRP)
        bodyVel = Instance.new("BodyVelocity", HRP)
        bodyGyro.P = 9e4
        bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyVel.Velocity = Vector3.zero
        bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)

        UIS.InputBegan:Connect(function(i)
            if i.KeyCode == Enum.KeyCode.Q then
                flying = not flying
                bodyGyro:Destroy()
                bodyVel:Destroy()
            end
        end)

        while flying do
            bodyGyro.CFrame = workspace.CurrentCamera.CFrame
            bodyVel.Velocity = workspace.CurrentCamera.CFrame.LookVector * 75
            task.wait()
        end
    end
end)

--// FPS Boost
window:AddButton("FPS Boost", function()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("BasePart") and v:IsDescendantOf(workspace) then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
        elseif v:IsA("Decal") then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)
        end
    end
    settings().Rendering.QualityLevel = 1
end)

--// Anti Speed Detection
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if tostring(self):lower():find("kick") and method == "FireServer" then
        return
    end
    return old(self, ...)
end)

--// Optional ESP (Player)
window:AddToggle("Player ESP", function(state)
    if state then
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer then
                local bb = Instance.new("BillboardGui", plr.Character:WaitForChild("Head"))
                bb.Adornee = plr.Character.Head
                bb.Size = UDim2.new(0, 100, 0, 40)
                bb.StudsOffset = Vector3.new(0, 2, 0)
                bb.AlwaysOnTop = true
                local name = Instance.new("TextLabel", bb)
                name.Text = plr.Name
                name.Size = UDim2.new(1, 0, 1, 0)
                name.BackgroundTransparency = 1
                name.TextColor3 = Color3.new(1, 0, 0)
                name.TextScaled = true
            end
        end
    end
end)
