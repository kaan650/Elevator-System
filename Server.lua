local MAX_ROUND = 2

local function generateRound()
	local newRound = {}
	for i  = 1,10 do
		local isTrue = math.random(1,2)
		newRound[i < 10 and "0"..i or tostring(i)] = isTrue == 1 and true or false
	end
	return newRound
end

local rounds = {}

for i = 1,MAX_ROUND do
	table.insert(rounds, generateRound())
end

script.Parent.Touched:Connect(function(otherPart: BasePart)
	local player = game:GetService("Players"):GetPlayerFromCharacter(otherPart.Parent)
	if player then
		game:GetService("ReplicatedStorage"):WaitForChild("Action"):FireClient(player, rounds)
	end
end)

