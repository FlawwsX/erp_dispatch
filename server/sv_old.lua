RegisterNetEvent("dispatch:svNotify", function(data)
	local newId = #calls + 1
	calls[newId] = data
    calls[newId]['source'] = source
    calls[newId]['callId'] = newId
    calls[newId]['units'] = {}
    calls[newId]['responses'] = {}
    calls[newId]['time'] = os.time() * 1000
    TriggerClientEvent('dispatch:clNotify', -1, data, newId, source)
    if data['dispatchCode'] == '911' or data['dispatchCode'] == '311' then
        TriggerClientEvent('dispatch:setBlip', -1, data['dispatchCode'], vector3(data['origin']['x'], data['origin']['y'], data['origin']['z']), newId)
    end
end)

RegisterNetEvent('dispatch:gunshotAlert', function(sentCoords, isAuto, isCop)
    TriggerClientEvent('dispatch:gunshotAlert', -1, sentCoords, isAuto, isCop)
end)

RegisterNetEvent('dispatch:combatAlert', function(sentCoords)
    TriggerClientEvent('dispatch:combatAlert', -1, sentCoords)
end)

RegisterNetEvent('dispatch:armedperson', function(sentCoords)
    TriggerClientEvent('dispatch:armedperson', -1, sentCoords)
end)

RegisterNetEvent('dispatch:vehiclecrash', function(sentCoords)
    TriggerClientEvent('dispatch:vehiclecrash', -1, sentCoords)
end)


RegisterNetEvent('dispatch:houserobbery', function(sentCoords)
    TriggerClientEvent('dispatch:houserobbery', -1, sentCoords)
end)

RegisterNetEvent('dispatch:banktruck', function(sentCoords)
    TriggerClientEvent('dispatch:banktruck', -1, sentCoords)
end)

RegisterNetEvent('dispatch:art', function(sentCoords)
    TriggerClientEvent('dispatch:art', -1, sentCoords)
end)

RegisterNetEvent('dispatch:jewel', function(sentCoords)
    TriggerClientEvent('dispatch:jewel', -1, sentCoords)
end)

RegisterNetEvent('dispatch:bankrobbery', function(sentCoords)
    TriggerClientEvent('dispatch:bankrobbery', -1, sentCoords)
end)

RegisterNetEvent('dispatch:g6', function(sentCoords)
    TriggerClientEvent('dispatch:g6', -1, sentCoords)
end)

RegisterNetEvent('dispatch:carboosting', function(sentCoords, vehicle, alert)
    TriggerClientEvent('dispatch:carboosting', -1, sentCoords, vehicle, alert)
end)

RegisterNetEvent('dispatch:yachtheist', function(sentCoords)
    TriggerClientEvent('dispatch:yachtheist', -1, sentCoords)
end)

RegisterNetEvent('dispatch:vehicletheft', function(sentCoords)
    TriggerClientEvent('dispatch:vehicletheft', -1, sentCoords)
end)

RegisterNetEvent('dispatch:blip:jailbreak', function(sentCoords)
    TriggerClientEvent('dispatch:blip:jailbreak', -1, sentCoords)
end)

RegisterNetEvent('dispatch:drugsale', function(sentCoords)
    TriggerClientEvent('dispatch:drugsale', -1, sentCoords)
end)

RegisterNetEvent('dispatch:officerAlert', function(pos, name)
    TriggerClientEvent('dispatch:officerAlert', -1, pos, name, source)
end)

--[[ Officer downs ]]

RegisterNetEvent('dispatch:policealertA', function(sentCoords)
    TriggerClientEvent('dispatch:policealertA', -1, sentCoords)
end)

RegisterNetEvent('dispatch:policealertB', function(sentCoords)
    TriggerClientEvent('dispatch:policealertB', -1, sentCoords)
end)


RegisterNetEvent('dispatch:emsalertA', function(sentCoords)
    TriggerClientEvent('dispatch:emsalertA', -1, sentCoords)
end)

RegisterNetEvent('dispatch:emsalertB', function(sentCoords)
    TriggerClientEvent('dispatch:emsalertB', -1, sentCoords)
end)