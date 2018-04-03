local minutesToWait = 10

-- register when ready
Citizen.CreateThread(function()
	Citizen.Wait(1000)
	TriggerServerEvent('scrp-idlogs:register')
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000 * 60 * minutesToWait)
		TriggerServerEvent('scrp-idlogs:updateTime', minutesToWait)
	end
end)
