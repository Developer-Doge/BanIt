-- // METADATA
-- Creator: Ty_Scripts
-- Date created: 2/26/2021 16:00 UTC-5
-- More info: https://devforum.roblox.com/t/banit-simple-ban-module-for-anyone/1074218
-- Version: 5.1

-- // VARIABLES

local serverBanTable = {} 

local Players = game:GetService("Players")
local DSS = game:GetService("DataStoreService")
local banStore = DSS:GetDataStore("BanStore"..game.PlaceID.."123456789")

local success, data = pcall(function()
	return banStore:GetAsync("Bans")
end)

if success and not data then
	data = {}
elseif not success then
	warn("DataStore failed. Try turning on Studio Access to API Services.")
end

-- // FUNCTIONS

local function saveData()
	local suc, err = pcall(function()
		return banStore:SetAsync("Bans", data)
	end)
	if not suc and err then
		warn(err)
	elseif suc then
		print("BanIt | Successfully saved")
	end
end

Players.PlayerAdded:Connect(function(plr)
	if table.find(data, plr.UserId) or table.find(serverBanTable, plr.UserId) then
		plr:Kick("Banned from the game!")
	end
end)

-- // MODULE

local BanIt = {}

function BanIt.ServerBan(plrUser, reason)
	local plr = Players:GetUserIdFromNameAsync(plrUser)
	table.insert(serverBanTable, plr)
	if Players:FindFirstChild(plrUser) then
		Players[plrUser]:Kick(reason or "Banned from the server!")
	end
end

function BanIt.Ban(plrUser, reason)
	local plr = Players:GetUserIdFromNameAsync(plrUser)
	table.insert(data, plr)
	saveData()
	if Players:FindFirstChild(plrUser) then
		Players[plrUser]:Kick(reason or "Banned from the game!")
	end
end

function BanIt.Unban(plrUser)
	local plr = Players:GetUserIdFromNameAsync(plrUser)
	if plr then
		local pos = table.find(data, plr)
		print(pos)
		table.remove(data, pos)
		print(data[pos])
		saveData()
	else
		warn("Player not found in database.")
	end
end

function BanIt.ServerUnban(plrUser)
	local plr = Players:GetUserIdFromNameAsync(plrUser)
	if plr then
		local pos = table.find(serverBanTable, plr)
		print(pos)
		table.remove(serverBanTable, pos)
		print(serverBanTable[pos])
		saveData()
	else
		warn("Player not found in database.")
	end
end

return BanIt
