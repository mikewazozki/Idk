--// Admin Panel
local adminTab = library:CreateWindow({ text = "Admin Panel" })
local env = getfenv()

-- Announce
adminTab:AddTextbox("Announcement", "Enter announcement...", function(text)
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        game.StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[ANNOUNCEMENT]: "..text;
            Color = Color3.fromRGB(255, 255, 0);
            Font = Enum.Font.SourceSansBold;
            FontSize = Enum.FontSize.Size24;
        })
    end
end)

-- Bring
adminTab:AddTextbox("Bring Player", "Enter player name...", function(name)
    local target = game.Players:FindFirstChild(name)
    if target and target.Character and game.Players.LocalPlayer.Character then
        target.Character:PivotTo(game.Players.LocalPlayer.Character:GetPivot() + Vector3.new(3, 0, 0))
    end
end)

-- Freeze
adminTab:AddTextbox("Freeze Player", "Enter player name...", function(name)
    local target = game.Players:FindFirstChild(name)
    if target and target.Character then
        local hum = target.Character:FindFirstChildWhichIsA("Humanoid")
        if hum then
            hum.WalkSpeed = 0
            hum.JumpPower = 0
        end
    end
end)

-- Kick (Local visual only unless you're server-sided)
adminTab:AddTextbox("Kick Player", "Enter player name...", function(name)
    local target = game.Players:FindFirstChild(name)
    if target then
        target:Kick("Kicked by Admin Panel")
    end
end)
