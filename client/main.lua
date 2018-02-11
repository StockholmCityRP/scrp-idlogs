ESX = nil

--ESX base
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('playerSpawned', function(spawn)
	TriggerServerEvent('idlogs:register')
end)