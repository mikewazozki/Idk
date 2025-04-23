-- Place this in StarterGui as a LocalScript

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local adminList = { "YourUsernameHere" } -- add more usernames if needed

if not table.find(adminList, player.Name) then return end

-- Create ScreenGui
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AdminPanel"
gui.ResetOnSpawn = false

-- Create Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 300)
frame.Position = UDim2.new(0, 20, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

-- UICorner for round corners
local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 8)

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Admin Panel"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamSemibold
title.TextSize = 18

-- Buttons List
local actions = {
	{ name = "Respawn", callback = function()
		player:LoadCharacter()
	end },
	{ name = "Fly", callback = function()
		loadstring(game:HttpGet("https://pastebin.com/raw/VzZdnf7a"))()
	end },
	{ name = "Noclip", callback = function()
		loadstring(game:HttpGet("https://pastebin.com/raw/yYHaN7PN"))()
	end },
	{ name = "Speed x2", callback = function()
		player.Character.Humanoid.WalkSpeed = 32
	end },
	{ name = "Jump Boost", callback = function()
		player.Character.Humanoid.JumpPower = 120
	end },
	{ name = "Kill All", callback = function()
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= player then
				p:Kick("Admin removed you.")
			end
		end
	end }
}

-- Create Buttons
for i, action in ipairs(actions) do
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, 30 + (i * 35))
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.Text = action.name

	local uic = Instance.new("UICorner", btn)
	uic.CornerRadius = UDim.new(0, 6)

	btn.MouseButton1Click:Connect(action.callback)
end
