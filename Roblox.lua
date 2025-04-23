-- Anti-AFK
warn("Anti AFK running")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    warn("Anti AFK triggered")
    local vu = game:GetService("VirtualUser")
    vu:CaptureController()
    vu:ClickButton2(Vector2.new())
end)

-- UI Library Load
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Marco8642/science/main/ui%20libs2"))()
local window = library:CreateWindow({ text = "Auto Farm Hub" })

-- Driver type setting
getfenv().drivertype = "Rural Bus Driver"
window:AddDropdown({"Select Bus Driver Type", "Rural Bus Driver", "City Bus Driver"}, function(state)
    if state ~= "Select Bus Driver Type" then
        getfenv().drivertype = state
    end
end)

-- Auto Bus Farm Toggle
window:AddToggle("Auto Farm [Bus]", function(state)
    getfenv().busFarm = state
    spawn(function()
        while getfenv().busFarm do
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
                    wait(1)
                    char.Humanoid.Sit = false
                    wait(2)

                    if player:DistanceFromCharacter(Vector3.new(-1683, 5, -1286)) < 50 then
                        char.Humanoid:MoveTo(Vector3.new(-1708, 5, -1281))
                        char.Humanoid.MoveToFinished:Wait()
                        char.Humanoid:MoveTo(Vector3.new(-1730, 5, -1280))
                        char.Humanoid.MoveToFinished:Wait()

                        local vim = game:GetService("VirtualInputManager")
                        repeat
                            wait()
                            vim:SendKeyEvent(true, "E", false, game)
                            vim:SendKeyEvent(false, "E", false, game)
                        until #gui.ShiftSystem:GetChildren() > 0

                        for _, btn in pairs(gui.ShiftSystem:GetDescendants()) do
                            if btn:IsA("ImageButton") and btn.Name == getfenv().drivertype then
                                firesignal(btn.MouseButton1Click)
                                break
                            end
                        end

                        wait(2)
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

-- Auto Truck Farm Toggle
window:AddToggle("Auto Farm [Truck]", function(state)
    getfenv().truckFarm = state
    spawn(function()
        while getfenv().truckFarm do
            pcall(function()
                local player = game.Players.LocalPlayer
                local char = player.Character
                local gui = player.PlayerGui
                local vehicle = workspace.Vehicles:FindFirstChild(player.Name)

                if vehicle and vehicle.Body:FindFirstChild("Trailer") and not char.Humanoid.SeatPart then
                    vehicle.DriveSeat:Sit(char.Humanoid)
                end

                if gui.DeliverySystem.Enabled and char.Humanoid.SeatPart then
                    local maxXP, bestOption = 0, nil
                    for _, el in pairs(gui.DeliverySystem:GetDescendants()) do
                        if el:IsA("TextLabel") and string.find(el.Text, "XP") then
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

-- Optional: You can add a reset/health check loop if needed
