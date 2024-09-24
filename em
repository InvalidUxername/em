local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

-- Create the ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MyScreenGui"
screenGui.Parent = playerGui

-- Create the Sound
local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://131485348026250" -- Replace with your audio ID
sound.Parent = player

-- Function to set all parts' transparency to 1, add PointLight, play sound, and change the sky
local function onButtonClick()
	-- Play the sound
	sound:Play()

	wait(2.45)

	-- Create a PointLight
	local pointLight = Instance.new("PointLight")
	pointLight.Color = Color3.fromRGB(255, 0, 0) -- Red color
	pointLight.Brightness = 10 -- Adjust brightness
	pointLight.Range = 50 -- Adjust range
	pointLight.Parent = player.Character:WaitForChild("HumanoidRootPart") -- Attach to the player

	-- Optional: Destroy the PointLight after some time
	wait(0.05)
	pointLight:Destroy()

	-- Wait before starting camera effects
	wait(0.1)

	-- Camera Zoom Out Effect with Tween
	local originalFieldOfView = Camera.FieldOfView
	local targetFieldOfView = originalFieldOfView + 40 -- Increase the zoom level for a faster effect

	-- Create a tween for the zoom out effect
	local zoomOutTween = TweenService:Create(Camera, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { FieldOfView = targetFieldOfView })
	zoomOutTween:Play()
	zoomOutTween.Completed:Wait() -- Wait for the tween to complete

	-- Reset field of view after zooming out
	Camera.FieldOfView = originalFieldOfView

	-- Set all parts' transparency to 1 except for the player's character
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Parent ~= player.Character then
			obj.Transparency = 1
		end
	end

	-- Change the sky
	local newSky = Instance.new("Sky")
	newSky.SkyboxBk = "rbxassetid://159454299"
	newSky.SkyboxDn = "rbxassetid://159454296"
	newSky.SkyboxFt = "rbxassetid://159454293"
	newSky.SkyboxLf = "rbxassetid://159454286"
	newSky.SkyboxRt = "rbxassetid://159454300"
	newSky.SkyboxUp = "rbxassetid://159454288"
	newSky.Parent = Lighting

	-- Highlight all players in red
	for _, otherPlayer in ipairs(Players:GetPlayers()) do
		if otherPlayer ~= player then -- Avoid highlighting the local player
			local highlight = Instance.new("Highlight")
			highlight.Adornee = otherPlayer.Character
			highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Red color
			highlight.FillTransparency = 0.5 -- Adjust transparency as needed
			highlight.Parent = otherPlayer.Character
		end
	end
end

-- Function to create the TextButton for mobile
local function createButton()
	-- Create the TextButton
	local textButton = Instance.new("TextButton")
	textButton.Size = UDim2.new(0, 200, 0, 50) -- Size of the button
	textButton.Position = UDim2.new(0.5, -100, 0.5, -25) -- Center it on the screen
	textButton.Text = "Click Me!"
	textButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	textButton.Parent = screenGui

	-- Connect the button click event
	textButton.MouseButton1Click:Connect(onButtonClick)
end

-- Check if the player is using mobile or PC
if UserInputService.TouchEnabled then
	-- Player is using a mobile device, create the button
	createButton()
else
	-- Player is using a PC, bind the 'F' key to the button click action
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		-- Check if the input is the 'F' key and that the game is not processing it elsewhere
		if input.KeyCode == Enum.KeyCode.F and not gameProcessed then
			-- Simulate the button click when 'F' is pressed
			onButtonClick()
		end
	end)
end
