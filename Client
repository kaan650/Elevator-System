--NOTE: THIS SYSTEM IS INSPIRED BY DOORS!

local Players: Players = game:GetService("Players")
local TweenService: TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Electric = workspace:WaitForChild("Electric")
local inElectric = false

local PowerUI = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("PowerUI")
local PowerBack = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("PowerBack")
local PowerBeepSound = game:GetService("SoundService"):WaitForChild("PowerBeep")

PowerBack.Button.Activated:Connect(function() -- this is the back button when you press this its cancels the system
	if not inElectric then return end
	inElectric = false
	PowerBack.Button.Visible = false
	TweenService:Create(Electric.PanelDoor, TweenInfo.new(.5), {CFrame = Electric.RealPanelDoor.CFrame}):Play()
	workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
end)

local inNumberUsing = { -- all numbers table and these are off thats why i am did false
	["01"] = false,
	["02"] = false,
	["03"] = false,
	["04"] = false,
	["05"] = false,
	["06"] = false,
	["07"] = false,
	["08"] = false,
	["09"] = false,
	["10"] = false,
}

local SETTINGS = {
	OPEN = {
		COLOR = Color3.fromRGB(223, 148, 105),
		MATERIAL = Enum.Material.Neon
	},
	
	CLOSE = {
		COLOR = Color3.fromRGB(151, 0, 0),
		MATERIAL = Enum.Material.Metal
	},
}

local MAX_ROUND: number = 0
local CURRENT_ROUND: number = 0

local function getMyTrueNumbers(currentAnswers): number -- this gets my true numbers check the real answers and my answers and gives my net
	local correct, wrong = 0, 0
	for i,v in pairs(currentAnswers) do
		if inNumberUsing[i] == v then
			correct += 1
		else
			wrong += 1
		end
	end
	return correct - wrong < 0 and 0 or correct- wrong, correct, wrong
end

local function makeCurrentString(number): string -- it makes string like if number is < 10 and "0X"
	number = tonumber(number)
	return number < 10 and ("0%d"):format(number) or tostring(number)
end

local function shuffle(tbl: {any}) -- it shuffles the tables
	for i = #tbl, 2, -1 do
		local j = math.random(i)
		tbl[i], tbl[j] = tbl[j], tbl[i]
	end
	return tbl
end

local function closeorOpenCurrentButton(currentButton, isOpen: boolean) -- these are button functions when you press this its on or off
	if currentButton.EndButton:GetAttribute("isActive") == isOpen then return end
	if not currentButton.EndButton:GetAttribute("isAvailable") then return end
	
	currentButton.EndButton:SetAttribute("isActive", isOpen)
	currentButton.EndButton:SetAttribute("isAvailable", false)
	inNumberUsing[makeCurrentString(currentButton.Name)] = currentButton.EndButton:GetAttribute("isActive")
	currentButton.Light.Color = SETTINGS[isOpen and "OPEN" or "CLOSE"].COLOR
	currentButton.Light.Material = SETTINGS[isOpen and "OPEN" or "CLOSE"].MATERIAL
	local tween = TweenService:Create(currentButton.EndButton, TweenInfo.new(.1), {Position = currentButton.EndButton.Position + Vector3.new(isOpen and .300 or -.300,0,0)})
	tween:Play()
	tween.Completed:Wait()
	currentButton.EndButton:SetAttribute("isAvailable", true)
end

local function closeorOpenAll(isOpen: boolean) -- this is closes all buttons or opens all buttons
	if not inElectric then return end
	PowerUI.Bar.insideBar.Size = UDim2.new(0, 0, 1, 0)
	for _,v in ipairs(Electric.Numbers:GetChildren()) do
		if not tonumber(v.Name) then continue end
		closeorOpenCurrentButton(v, isOpen)
	end
	if not isOpen then return end
	
	PowerBack.Button.Visible = false
	task.wait(.3)
	inElectric = false
	workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
	TweenService:Create(Electric.PanelDoor, TweenInfo.new(.5), {CFrame = Electric.RealPanelDoor.CFrame}):Play()
end

local oldAction = tick()

local function Action(currentAnswers) -- this is when you touch part from server it FireClient and do this function
	if inElectric then return end
	if tick() - oldAction < 3 then return end
	oldAction = tick()
	
	inElectric = true
	PowerBack.Button.Visible = true
	MAX_ROUND = #currentAnswers
	PowerUI.Tour.Text = ("%d/%d"):format(CURRENT_ROUND, MAX_ROUND)
	
	Electric.PanelDoor.CFrame = Electric.FakePanelDoor.CFrame
	--TweenService:Create(Electric.PanelDoor, TweenInfo.new(.5), {CFrame = Electric.FakePanelDoor.CFrame}):Play()
	local tween = TweenService:Create(workspace.CurrentCamera, TweenInfo.new(.5), {CFrame = Electric.Camera.CFrame})
	workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
	tween:Play()
	tween.Completed:Wait()
	coroutine.resume(coroutine.create(function()
		task.wait(1)
		while true do -- this loop main event is looping the numbers and shuffling the numbers and printing all the numbers at the screen
			if not inElectric then break end
			if CURRENT_ROUND >= MAX_ROUND then closeorOpenAll(true) break end
			PowerUI.Box.Visible = true

			local shuffledKeys = {}
			local currentCorrects = currentAnswers[CURRENT_ROUND+1]

			for i,v in pairs(currentCorrects) do
				table.insert(shuffledKeys, i)
			end
			shuffledKeys = shuffle(shuffledKeys)

			for _,v in ipairs(shuffledKeys) do
				if not inElectric then break end

				PowerBeepSound.PitchShiftSoundEffect.Octave = currentCorrects[v] and 1 or 0.85
				PowerBeepSound:Play()
				PowerUI.Number.Text = v
				PowerUI.Box.insideBox.Visible = currentCorrects[v]
				task.wait(.75)
			end
			task.wait(.3)

			local myTrueNumbers, correct, wrong = getMyTrueNumbers(currentCorrects)
			PowerUI.Number.Text = "..."
			PowerUI.Box.Visible = false
			PowerUI.Bar.insideBar:TweenSize(UDim2.new(myTrueNumbers/10, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, myTrueNumbers/2.5)
			task.wait(myTrueNumbers/10 ~= 0 and myTrueNumbers/2.5 + .3 or 3)
			if myTrueNumbers > 0 and wrong == 0 and correct == 10 then -- if player did correct all the all buttons is get closed
				CURRENT_ROUND += 1
				PowerUI.Tour.Text = ("%d/%d"):format(CURRENT_ROUND, MAX_ROUND)

				if CURRENT_ROUND < MAX_ROUND then
					closeorOpenAll(false)
				end
			end
		end
	end))
end

local function ButtonUp() -- this is when you press moouse click it detects
	if not inElectric then return end
	if not Mouse.Target then return end
	if not Mouse.Target.Parent then return end
	if not tonumber(Mouse.Target.Parent.Name) then return end
	closeorOpenCurrentButton(Mouse.Target.Parent, not Mouse.Target.Parent.EndButton:GetAttribute("isActive"))
end

game:GetService("ReplicatedStorage"):WaitForChild("Action").OnClientEvent:Connect(Action)
Mouse.Button1Up:Connect(ButtonUp)
