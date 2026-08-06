--[[
    Script: Auto Teleport + VIP Spoof
    Descripción: Script con auto teleport en 2 mundos, spoof VIP, auto rebirth, auto codes y más.
    Funciona en: Synapse X, ScriptWare, KRNL, Fluxus, Hydrogen, Delta, Oxygen U, Electron, y más.
--]]

-- Eliminar GUI anterior si existe
local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local existingGui = playerGui:FindFirstChild("PotentUI")
if existingGui then
    existingGui:Destroy()
end

-- Configuración para compatibilidad
local isKRNL = pcall(function() return getexecutorname and getexecutorname() == "KRNL" end)
local isSynapse = pcall(function() return syn and syn.crypt end)
local isScriptWare = pcall(function() return scriptware and scriptware.http end)
local isFluxus = pcall(function() return fluxus and fluxus.import end)
local isDelta = pcall(function() return getexecutorname and getexecutorname() == "Delta" end)

-- Services con compatibilidad
local playersService = game:GetService("Players")
local tweenService = game:GetService("TweenService")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local textChatService = game:GetService("TextChatService")

local localPlayer = playersService.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PotentUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "Main"
mainFrame.Size = UDim2.new(0, 500, 0, 450)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(180, 100, 255)
mainStroke.Thickness = 1.5
mainStroke.Transparency = 0.3
mainStroke.Parent = mainFrame

local mainStrokeGradient = Instance.new("UIGradient")
mainStrokeGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 90, 255)),
	ColorSequenceKeypoint.new(0.33, Color3.fromRGB(90, 140, 255)),
	ColorSequenceKeypoint.new(0.66, Color3.fromRGB(255, 100, 180)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 90, 255)),
})
mainStrokeGradient.Parent = mainStroke

-- Animación del gradiente (compatible con todos los ejecutores)
local gradientCoroutine = coroutine.create(function()
	while mainStroke.Parent do
		mainStrokeGradient.Rotation = (mainStrokeGradient.Rotation + 1) % 360
		task.wait()
	end
end)
coroutine.resume(gradientCoroutine)

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(28, 20, 42)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topGradient = Instance.new("UIGradient")
topGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(140, 60, 220)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(90, 70, 230)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 140, 230)),
})
topGradient.Rotation = 0
topGradient.Parent = topBar

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 8)
topCorner.Parent = topBar

local topFix = Instance.new("Frame")
topFix.Size = UDim2.new(1, 0, 0, 10)
topFix.Position = UDim2.new(0, 0, 1, -10)
topFix.BackgroundColor3 = Color3.fromRGB(40, 30, 70)
topFix.BorderSizePixel = 0
topFix.ZIndex = 0
topFix.Parent = topBar

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(0, 280, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Auto Teleport + VIP Spoof"
title.TextColor3 = Color3.fromRGB(240, 240, 245)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

local closeButton = Instance.new("TextButton")
closeButton.Name = "Close"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "Minimize"
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -70, 0, 5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(90, 60, 150)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 18
minimizeButton.Parent = topBar

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 6)
minimizeCorner.Parent = minimizeButton

local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -20, 1, -50)
content.Position = UDim2.new(0, 10, 0, 45)
content.BackgroundTransparency = 1
content.Parent = mainFrame

local buttonHolder = Instance.new("Frame")
buttonHolder.Name = "ButtonHolder"
buttonHolder.Size = UDim2.new(1, 0, 0, 50)
buttonHolder.Position = UDim2.new(0, 0, 0, 0)
buttonHolder.BackgroundTransparency = 1
buttonHolder.Parent = content

local button1 = Instance.new("TextButton")
button1.Name = "Button1"
button1.Size = UDim2.new(0, 220, 0, 36)
button1.Position = UDim2.new(0, 0, 0, 8)
button1.BackgroundColor3 = Color3.fromRGB(60, 40, 120)
button1.Text = "WORLD 1"
button1.TextColor3 = Color3.fromRGB(255, 255, 255)
button1.Font = Enum.Font.GothamMedium
button1.TextSize = 14
button1.Parent = buttonHolder

local button1Corner = Instance.new("UICorner")
button1Corner.CornerRadius = UDim.new(0, 6)
button1Corner.Parent = button1

local button1Stroke = Instance.new("UIStroke")
button1Stroke.Color = Color3.fromRGB(180, 100, 255)
button1Stroke.Thickness = 1
button1Stroke.Transparency = 0.5
button1Stroke.Parent = button1

local button2 = Instance.new("TextButton")
button2.Name = "Button2"
button2.Size = UDim2.new(0, 220, 0, 36)
button2.Position = UDim2.new(1, -220, 0, 8)
button2.BackgroundColor3 = Color3.fromRGB(60, 40, 120)
button2.Text = "WORLD 2"
button2.TextColor3 = Color3.fromRGB(255, 255, 255)
button2.Font = Enum.Font.GothamMedium
button2.TextSize = 14
button2.Parent = buttonHolder

local button2Corner = Instance.new("UICorner")
button2Corner.CornerRadius = UDim.new(0, 6)
button2Corner.Parent = button2

local button2Stroke = Instance.new("UIStroke")
button2Stroke.Color = Color3.fromRGB(180, 100, 255)
button2Stroke.Thickness = 1
button2Stroke.Transparency = 0.5
button2Stroke.Parent = button2

local optionsContainer = Instance.new("ScrollingFrame")
optionsContainer.Name = "OptionsContainer"
optionsContainer.Size = UDim2.new(1, 0, 1, -60)
optionsContainer.Position = UDim2.new(0, 0, 0, 55)
optionsContainer.BackgroundTransparency = 1
optionsContainer.BorderSizePixel = 0
optionsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
optionsContainer.ScrollBarThickness = 4
optionsContainer.Parent = content

local originalSize = mainFrame.Size
local minimized = false

local function tween(instance, properties, duration)
	local info = TweenInfo.new(duration or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local t = tweenService:Create(instance, info, properties)
	t:Play()
	return t
end

local currentWorld = 1
local optionConnections = {}
local activeConnections = {}
local optionStates = {}

local function stopAllConnections()
	for name, conn in pairs(activeConnections) do
		if conn then
			pcall(conn.Disconnect, conn)
			activeConnections[name] = nil
		end
	end
end

local function clearOptions()
	for _, conn in ipairs(optionConnections) do
		pcall(conn.Disconnect, conn)
	end
	optionConnections = {}
	for _, child in ipairs(optionsContainer:GetChildren()) do
		child:Destroy()
	end
	optionsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
end

local function createToggle(parent, labelText, yPosition, optionId, callback)
	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(1, 0, 0, 36)
	holder.Position = UDim2.new(0, 0, 0, yPosition)
	holder.BackgroundColor3 = Color3.fromRGB(30, 26, 40)
	holder.BorderSizePixel = 0
	holder.Parent = parent

	local holderCorner = Instance.new("UICorner")
	holderCorner.CornerRadius = UDim.new(0, 6)
	holderCorner.Parent = holder

	local holderStroke = Instance.new("UIStroke")
	holderStroke.Color = Color3.fromRGB(150, 90, 255)
	holderStroke.Thickness = 1
	holderStroke.Transparency = 0.5
	holderStroke.Parent = holder

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -70, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.TextColor3 = Color3.fromRGB(230, 220, 255)
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = holder

	local switchBack = Instance.new("Frame")
	switchBack.Size = UDim2.new(0, 44, 0, 22)
	switchBack.Position = UDim2.new(1, -54, 0.5, -11)
	switchBack.BackgroundColor3 = Color3.fromRGB(50, 50, 58)
	switchBack.BorderSizePixel = 0
	switchBack.Parent = holder

	local switchBackCorner = Instance.new("UICorner")
	switchBackCorner.CornerRadius = UDim.new(1, 0)
	switchBackCorner.Parent = switchBack

	local switchDot = Instance.new("Frame")
	switchDot.Size = UDim2.new(0, 18, 0, 18)
	switchDot.Position = UDim2.new(0, 2, 0.5, -9)
	switchDot.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
	switchDot.BorderSizePixel = 0
	switchDot.Parent = switchBack

	local switchDotCorner = Instance.new("UICorner")
	switchDotCorner.CornerRadius = UDim.new(1, 0)
	switchDotCorner.Parent = switchDot

	local switchGradient = Instance.new("UIGradient")
	switchGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 90, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 140, 255)),
	})
	switchGradient.Enabled = false
	switchGradient.Parent = switchBack

	local switchButton = Instance.new("TextButton")
	switchButton.Size = UDim2.new(1, 0, 1, 0)
	switchButton.BackgroundTransparency = 1
	switchButton.Text = ""
	switchButton.Parent = switchBack

	local toggled = optionStates[optionId] or false
	local conn

	if toggled then
		switchGradient.Enabled = true
		switchDot.Position = UDim2.new(1, -20, 0.5, -9)
		switchDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	end

	conn = switchButton.MouseButton1Click:Connect(function()
		toggled = not toggled
		optionStates[optionId] = toggled

		if toggled then
			switchGradient.Enabled = true
			tween(switchDot, {Position = UDim2.new(1, -20, 0.5, -9), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
		else
			switchGradient.Enabled = false
			switchBack.BackgroundColor3 = Color3.fromRGB(50, 50, 58)
			tween(switchDot, {Position = UDim2.new(0, 2, 0.5, -9), BackgroundColor3 = Color3.fromRGB(200, 200, 200)}, 0.2)
		end

		pcall(callback, toggled)
	end)

	table.insert(optionConnections, conn)
	return holder
end

-- VARIABLES PARA LAS OPCIONES
local contentCreatorTagEnabled = false
local autoRebirthEnabled = false
local spoofVipEnabled = false
local autoCodeUseEnabled = false
local spoofContentCreatorEnabled = false

local rebirthConnection = nil
local codeUseConnection = nil

-- 7. ETIQUETA CONTENT CREATOR
local function setupContentCreatorTag()
	if contentCreatorTagEnabled then
		textChatService.OnIncomingMessage = function(message)
			local source = message.TextSource
			if source then
				local player = playersService:GetPlayerByUserId(source.UserId)
				if player == localPlayer then
					local props = Instance.new("TextChatMessageProperties")
					props.PrefixText = "<font color=\"#E91E63\">[🎬 Content Creator]</font> " .. (message.PrefixText or "")
					return props
				end
			end
			return nil
		end
	else
		textChatService.OnIncomingMessage = nil
	end
end

-- 10. AUTO REBIRTH
local function toggleAutoRebirth(state)
	autoRebirthEnabled = state
	if autoRebirthEnabled then
		if rebirthConnection then rebirthConnection:Disconnect() end
		rebirthConnection = runService.Heartbeat:Connect(function()
			local leaderstats = localPlayer:FindFirstChild("leaderstats")
			if leaderstats then
				local level = leaderstats:FindFirstChild("Level")
				local rebirths = leaderstats:FindFirstChild("Rebirths")
				if level and rebirths then
					local requiredLevel = 0
					local r = rebirths.Value or 0
					requiredLevel = (r * 100) + 100
					if level.Value >= requiredLevel then
						local event = replicatedStorage:FindFirstChild("Events")
						if event then
							local rebirthEvent = event:FindFirstChild("Rebirth")
							if rebirthEvent then
								local request = rebirthEvent:FindFirstChild("Request")
								if request then
									pcall(request.InvokeServer, request)
								end
							end
						end
					end
				end
			end
		end)
	else
		if rebirthConnection then
			rebirthConnection:Disconnect()
			rebirthConnection = nil
		end
	end
end

-- 18. SPOOFEAR VIP
local function toggleSpoofVip(state)
	spoofVipEnabled = state
	localPlayer:SetAttribute("HasVIPAccess", state)
end

-- 24. AUTO CODE USE
local function toggleAutoCodeUse(state)
	autoCodeUseEnabled = state
	if autoCodeUseEnabled then
		if codeUseConnection then codeUseConnection:Disconnect() end
		codeUseConnection = runService.Heartbeat:Connect(function()
			local codesEvent = replicatedStorage:FindFirstChild("Events")
			if codesEvent then
				local codes = codesEvent:FindFirstChild("Codes")
				if codes then
					local redeem = codes:FindFirstChild("Redeem")
					if redeem then
						local codesList = {"FREE", "SPEED", "REBIRTH", "COINS", "GEMS", "VIP", "BOOST", "SUMMER", "WINTER", "EASTER"}
						for _, code in ipairs(codesList) do
							pcall(redeem.InvokeServer, redeem, code)
							task.wait(0.5)
						end
					end
				end
			end
		end)
	else
		if codeUseConnection then
			codeUseConnection:Disconnect()
			codeUseConnection = nil
		end
	end
end

-- 26. SPOOFEAR CONTENT CREATOR
local function toggleSpoofContentCreator(state)
	spoofContentCreatorEnabled = state
	localPlayer:SetAttribute("IsContentCreator", state)
end

-- CARGAR MUNDOS
local autoTeleport1Enabled = false
local TELEPORT_POSITION_1 = Vector3.new(-6510.84, 271.18, -15757.23)
local JUMP_HEIGHT_1 = 5
local JUMP_SPEED_1 = 2.5

local autoTeleport2Enabled = false
local TELEPORT_POSITION_2 = Vector3.new(-32654.75, -1757.70, 50199.82)
local JUMP_HEIGHT_2 = 5
local JUMP_SPEED_2 = 2.5

local teleportConnection1 = nil
local teleportConnection2 = nil

local function autoJumpTick1(character)
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then return end
	local offset = math.sin(tick() * JUMP_SPEED_1) * JUMP_HEIGHT_1
	humanoidRootPart.CFrame = CFrame.new(TELEPORT_POSITION_1 + Vector3.new(0, offset, 0))
end

local function autoJumpTick2(character)
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then return end
	local offset = math.sin(tick() * JUMP_SPEED_2) * JUMP_HEIGHT_2
	humanoidRootPart.CFrame = CFrame.new(TELEPORT_POSITION_2 + Vector3.new(0, offset, 0))
end

local function loadWorld1()
	clearOptions()

	local y = 0

	-- AUTO TELEPORT (World 1)
	createToggle(optionsContainer, "AUTO TELEPORT", y, "teleport_world1", function(state)
		autoTeleport1Enabled = state
		if autoTeleport1Enabled then
			local character = localPlayer.Character
			if character then autoJumpTick1(character) end
			if not teleportConnection1 then
				teleportConnection1 = runService.Heartbeat:Connect(function()
					local currentCharacter = localPlayer.Character
					if currentCharacter and autoTeleport1Enabled then
						autoJumpTick1(currentCharacter)
					end
				end)
			end
		else
			if teleportConnection1 then
				teleportConnection1:Disconnect()
				teleportConnection1 = nil
			end
		end
	end)
	y = y + 42

	-- 7. ETIQUETA CONTENT CREATOR
	createToggle(optionsContainer, "ETIQUETA CONTENT CREATOR", y, "content_creator_tag", function(state)
		contentCreatorTagEnabled = state
		setupContentCreatorTag()
	end)
	y = y + 42

	-- 10. AUTO REBIRTH
	createToggle(optionsContainer, "AUTO REBIRTH", y, "auto_rebirth", function(state)
		toggleAutoRebirth(state)
	end)
	y = y + 42

	-- 18. SPOOFEAR VIP
	createToggle(optionsContainer, "SPOOFEAR VIP", y, "spoof_vip", function(state)
		toggleSpoofVip(state)
	end)
	y = y + 42

	-- 24. AUTO CODE USE
	createToggle(optionsContainer, "AUTO CODE USE", y, "auto_code_use", function(state)
		toggleAutoCodeUse(state)
	end)
	y = y + 42

	-- 26. SPOOFEAR CONTENT CREATOR
	createToggle(optionsContainer, "SPOOFEAR CONTENT CREATOR", y, "spoof_cc", function(state)
		toggleSpoofContentCreator(state)
	end)
	y = y + 42

	optionsContainer.CanvasSize = UDim2.new(0, 0, 0, y)
end

local function loadWorld2()
	clearOptions()

	local y = 0

	-- AUTO TELEPORT (World 2)
	createToggle(optionsContainer, "AUTO TELEPORT", y, "teleport_world2", function(state)
		autoTeleport2Enabled = state
		if autoTeleport2Enabled then
			local character = localPlayer.Character
			if character then autoJumpTick2(character) end
			if not teleportConnection2 then
				teleportConnection2 = runService.Heartbeat:Connect(function()
					local currentCharacter = localPlayer.Character
					if currentCharacter and autoTeleport2Enabled then
						autoJumpTick2(currentCharacter)
					end
				end)
			end
		else
			if teleportConnection2 then
				teleportConnection2:Disconnect()
				teleportConnection2 = nil
			end
		end
	end)
	y = y + 42

	-- 7. ETIQUETA CONTENT CREATOR
	createToggle(optionsContainer, "ETIQUETA CONTENT CREATOR", y, "content_creator_tag_w2", function(state)
		contentCreatorTagEnabled = state
		setupContentCreatorTag()
	end)
	y = y + 42

	-- 10. AUTO REBIRTH
	createToggle(optionsContainer, "AUTO REBIRTH", y, "auto_rebirth_w2", function(state)
		toggleAutoRebirth(state)
	end)
	y = y + 42

	-- 18. SPOOFEAR VIP
	createToggle(optionsContainer, "SPOOFEAR VIP", y, "spoof_vip_w2", function(state)
		toggleSpoofVip(state)
	end)
	y = y + 42

	-- 24. AUTO CODE USE
	createToggle(optionsContainer, "AUTO CODE USE", y, "auto_code_use_w2", function(state)
		toggleAutoCodeUse(state)
	end)
	y = y + 42

	-- 26. SPOOFEAR CONTENT CREATOR
	createToggle(optionsContainer, "SPOOFEAR CONTENT CREATOR", y, "spoof_cc_w2", function(state)
		toggleSpoofContentCreator(state)
	end)
	y = y + 42

	optionsContainer.CanvasSize = UDim2.new(0, 0, 0, y)
end

button1.MouseButton1Click:Connect(function()
	if currentWorld == 1 then return end
	currentWorld = 1
	button1.BackgroundColor3 = Color3.fromRGB(100, 70, 200)
	button2.BackgroundColor3 = Color3.fromRGB(60, 40, 120)
	loadWorld1()
end)

button2.MouseButton1Click:Connect(function()
	if currentWorld == 2 then return end
	currentWorld = 2
	button2.BackgroundColor3 = Color3.fromRGB(100, 70, 200)
	button1.BackgroundColor3 = Color3.fromRGB(60, 40, 120)
	loadWorld2()
end)

button1.BackgroundColor3 = Color3.fromRGB(100, 70, 200)
loadWorld1()

mainFrame.Size = UDim2.new(0, 500, 0, 0)
mainFrame.BackgroundTransparency = 1
tween(mainFrame, {Size = originalSize, BackgroundTransparency = 0}, 0.3)

closeButton.MouseButton1Click:Connect(function()
	if teleportConnection1 then teleportConnection1:Disconnect() end
	if teleportConnection2 then teleportConnection2:Disconnect() end
	if rebirthConnection then rebirthConnection:Disconnect() end
	if codeUseConnection then codeUseConnection:Disconnect() end
	local t = tween(mainFrame, {Size = UDim2.new(0, 500, 0, 0), BackgroundTransparency = 1}, 0.25)
	t.Completed:Wait()
	screenGui:Destroy()
end)

minimizeButton.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		tween(mainFrame, {Size = UDim2.new(0, 500, 0, 40)}, 0.25)
		minimizeButton.Text = "+"
	else
		tween(mainFrame, {Size = originalSize}, 0.25)
		minimizeButton.Text = "-"
	end
end)

local dragging = false
local dragStart, startPos

topBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

userInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)

return {
	ScreenGui = screenGui,
	MainFrame = mainFrame,
	Content = content,
	Tween = tween,
	Button1 = button1,
	Button2 = button2,
}
