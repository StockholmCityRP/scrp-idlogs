ESX = nil

--ESX base
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- send to jail and register in database
RegisterServerEvent('idlogs:register')
AddEventHandler('idlogs:register', function()
	local player = source
	local steam64 = GetPlayerIdentifiers(player)[1]
	local rp_name = getIdentity(player).name
	local steam_name = GetPlayerName(player)
	local rockstar = nil
	local ipv4 = nil
	for _, foundID in ipairs(GetPlayerIdentifiers(player)) do
		if string.match(foundID, "license:") then
			rockstar = string.sub(foundID, 9)
		elseif string.match(foundID, "ip:") then
			ipv4 = string.sub(foundID, 4)
		end
	end
	
	MySQL.Async.fetchAll('SELECT * FROM account_info WHERE steam64_hex=@steam64_hex', {['@steam64_hex'] = steam64}, function(gotInfo)
		if gotInfo[1] == nil then
			MySQL.Async.execute("INSERT INTO account_info (steam64_hex,rp_name, steam_name, rockstar, ipv4) VALUES (@steam64_hex,@rp_name,@steam_name,@rockstar,@ipv4)",
			{
				['@steam64_hex'] = steam64,
				['@rp_name'] = rp_name,
				['@steam_name'] = steam_name,
				['@rockstar'] = rockstar,
				['@ipv4'] = ipv4
			})
		else
			-- keep database updated
			MySQL.Sync.execute("UPDATE account_info SET rp_name=@rp_name, SET steam_name=@steam_name, SET ipv4=@ipv4 WHERE steam64_hex=@steam64_hex",
			{
				['@steam64_hex'] = steam64,
				['@rp_name'] = rp_name,
				['@steam_name'] = steam_name,
				['@ipv4'] = ipv4
			})
		end
	end)
end)

-- get identity from esx_identity
function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			name = identity['firstname'] .. ' ' .. identity['lastname']
		}
	else
		return {
			name = 'Unknown'
		}
	end
end