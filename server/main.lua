RegisterServerEvent('scrp-idlogs:register')
AddEventHandler('scrp-idlogs:register', function()
	local _source = source
	
	local steam64 = GetPlayerIdentifiers(_source)[1]
	local rp_name = getRoleplayName(_source)
	local steam_name = GetPlayerName(_source)
	local rockstar = nil
	local ipv4 = nil
	
	for _, foundID in ipairs(GetPlayerIdentifiers(_source)) do
		if string.match(foundID, "license:") then
			rockstar = string.sub(foundID, 9)
		elseif string.match(foundID, "ip:") then
			ipv4 = string.sub(foundID, 4)
		end
	end
	
	MySQL.Async.fetchAll('SELECT * FROM account_info WHERE steam64_hex=@steam64_hex', {['@steam64_hex'] = steam64}, function(result)
		if result[1] == nil then
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
			MySQL.Sync.execute("UPDATE account_info SET rp_name=@rp_name, steam_name=@steam_name, ipv4=@ipv4 WHERE steam64_hex=@steam64_hex",
			{
				['@steam64_hex'] = steam64,
				['@rp_name'] = rp_name,
				['@steam_name'] = steam_name,
				['@ipv4'] = ipv4
			})
		end
	end)
end)

RegisterServerEvent('scrp-idlogs:updateTime')
AddEventHandler('scrp-idlogs:updateTime', function(minutesOnline)
	local _source = source
	local steam64 = GetPlayerIdentifiers(_source)[1]
	
	MySQL.Async.fetchAll('SELECT * FROM account_info WHERE steam64_hex=@steam64_hex', {['@steam64_hex'] = steam64}, function(result)
		
		-- is the player found?
		if result[1] ~= nil then
			local playedTime = tonumber(result[1].online_time) + tonumber(minutesOnline)
			MySQL.Sync.execute("UPDATE account_info SET online_time=@online_time WHERE steam64_hex=@steam64_hex",
			{
				['@steam64_hex'] = steam64,
				['@online_time'] = playedTime,
			})
		end
	end)
end)

-- get rp name from esx_identity
function getRoleplayName(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM characters WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]
		return identity['firstname'] .. ' ' .. identity['lastname']
	else
		return 'Unknown'
	end
end