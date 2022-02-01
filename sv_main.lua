local calls = {}

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function GetDispatchCalls() return calls end
exports('GetDispatchCalls', GetDispatchCalls) -- exports['erp_dispatch']:GetDispatchCalls()

RegisterNetEvent("dispatch:svNotify")
AddEventHandler("dispatch:svNotify", function(data)
	local newId = #calls + 1
	calls[newId] = data
    calls[newId]['source'] = source
    calls[newId]['callId'] = newId
    calls[newId]['units'] = {}
    calls[newId]['responses'] = {}
    calls[newId]['time'] = os.time() * 1000
    TriggerClientEvent('dispatch:clNotify', -1, data, newId, source)
    if data['dispatchCode'] == '911' or data['dispatchCode'] == '311' then
        TriggerClientEvent('erp-dispatch:setBlip', -1, data['dispatchCode'], vector3(data['origin']['x'], data['origin']['y'], data['origin']['z']), newId)
    end
end)

AddEventHandler("dispatch:addUnit", function(callid, player, cb)
    if calls[callid] then

        if #calls[callid]['units'] > 0 then
            for i=1, #calls[callid]['units'] do
                if calls[callid]['units'][i]['cid'] == player.identifier then
                    cb(#calls[callid]['units'])
                    return
                end
            end
        end
	local callsign = exports['mdt']:GetCallsign(player.identifier)
        if player.job.name == 'police' then
            table.insert(calls[callid]['units'], { cid = player.identifier, fullname = player.name, job = 'Police', callsign = callsign[1].callsign	})
        elseif player.job.name == 'ambulance' then
            table.insert(calls[callid]['units'], { cid = player.identifier, fullname = player.name, job = 'EMS', callsign = callsign[1].callsign })
        elseif player.job.name == 'cmmc' then
            table.insert(calls[callid]['units'], { cid = player.identifier, fullname = player.name, job = 'EMS', callsign = callsign[1].callsign })
        end

        cb(#calls[callid]['units'])
    end
end)

AddEventHandler("dispatch:removeUnit", function(callid, player, cb)
    if calls[callid] then
        if #calls[callid]['units'] > 0 then
            for i=1, #calls[callid]['units'] do
                if calls[callid]['units'][i]['cid'] == player.identifier then
                    table.remove(calls[callid]['units'], i)
                end
            end
        end
        cb(#calls[callid]['units'])
    end    
end)

AddEventHandler("dispatch:sendCallResponse", function(player, callid, message, time, cb)
    if calls[callid] then
        table.insert(calls[callid]['responses'], {
            name = player.name,
            message = message,
            time = time
        })
        local player = calls[callid]['source']
        if GetPlayerPing(player) > 0 then
            TriggerClientEvent('dispatch:getCallResponse', player, message)
        end
        cb(true)
    else
        cb(false)
    end    
end)

RegisterCommand('togglealerts', function(source, args, user)
	local source = source
	local job = ESX.GetPlayerFromId(source).job
	if job.name == 'police' or job.name == 'ambulance' or job.name == 'pa' or job.name == 'cmmc' then
		TriggerClientEvent('erp-dispatch:manageNotifs', source, args[1])
	end
end)

RegisterNetEvent('erp-dispatch:gunshotAlert')
AddEventHandler('erp-dispatch:gunshotAlert', function(sentCoords, isAuto, isCop)
    TriggerClientEvent('erp-dispatch:gunshotAlert', -1, sentCoords, isAuto, isCop)
end)

RegisterNetEvent('erp-dispatch:combatAlert')
AddEventHandler('erp-dispatch:combatAlert', function(sentCoords)
    TriggerClientEvent('erp-dispatch:combatAlert', -1, sentCoords)
end)

RegisterNetEvent('erp-dispatch:armedperson')
AddEventHandler('erp-dispatch:armedperson', function(sentCoords)
    TriggerClientEvent('erp-dispatch:armedperson', -1, sentCoords)
end)


RegisterNetEvent('erp-dispatch:vehiclecrash')
AddEventHandler('erp-dispatch:vehiclecrash', function(sentCoords)
    TriggerClientEvent('erp-dispatch:vehiclecrash', -1, sentCoords)
end)

-- erp-dispatch:houserobbery

RegisterNetEvent('erp-dispatch:houserobbery')
AddEventHandler('erp-dispatch:houserobbery', function(sentCoords)
    TriggerClientEvent('erp-dispatch:houserobbery', -1, sentCoords)
end)

-- erp-dispatch:banktruck

RegisterNetEvent('erp-dispatch:banktruck')
AddEventHandler('erp-dispatch:banktruck', function(sentCoords)
    TriggerClientEvent('erp-dispatch:banktruck', -1, sentCoords)
end)

-- erp-dispatch:art

RegisterNetEvent('erp-dispatch:art')
AddEventHandler('erp-dispatch:art', function(sentCoords)
    TriggerClientEvent('erp-dispatch:art', -1, sentCoords)
end)

-- erp-dispatch:jewel

RegisterNetEvent('erp-dispatch:jewel')
AddEventHandler('erp-dispatch:jewel', function(sentCoords)
    TriggerClientEvent('erp-dispatch:jewel', -1, sentCoords)
end)

RegisterNetEvent('erp-dispatch:bankwobbewy')
AddEventHandler('erp-dispatch:bankwobbewy', function(sentCoords)
    TriggerClientEvent('erp-dispatch:bankwobbewy', -1, sentCoords)
end)

RegisterNetEvent('erp-dispatch:g6')
AddEventHandler('erp-dispatch:g6', function(sentCoords)
    TriggerClientEvent('erp-dispatch:g6', -1, sentCoords)
end)


RegisterNetEvent('erp-dispatch:carboosting')
AddEventHandler('erp-dispatch:carboosting', function(sentCoords, vehicle, alert)
    TriggerClientEvent('erp-dispatch:carboosting', -1, sentCoords, vehicle, alert)
end)

RegisterNetEvent('erp-dispatch:yachtheist')
AddEventHandler('erp-dispatch:yachtheist', function(sentCoords)
    TriggerClientEvent('erp-dispatch:yachtheist', -1, sentCoords)
end)

RegisterNetEvent('erp-dispatch:vehicletheft')
AddEventHandler('erp-dispatch:vehicletheft', function(sentCoords)
    TriggerClientEvent('erp-dispatch:vehicletheft', -1, sentCoords)
end)

RegisterNetEvent('erp-dispatch:blip:jailbreak')
AddEventHandler('erp-dispatch:blip:jailbreak', function(sentCoords)
    TriggerClientEvent('erp-dispatch:blip:jailbreak', -1, sentCoords)
end)

RegisterNetEvent('erp-dispatch:drugsale')
AddEventHandler('erp-dispatch:drugsale', function(sentCoords)
    TriggerClientEvent('erp-dispatch:drugsale', -1, sentCoords)
end)

RegisterNetEvent('erp-dispatch:officerAlert')
AddEventHandler('erp-dispatch:officerAlert', function(pos, name)
    TriggerClientEvent('erp-dispatch:officerAlert', -1, pos, name, source)
end)

--[[ Officer downs ]]

RegisterNetEvent('erp-dispatch:policealertA')
AddEventHandler('erp-dispatch:policealertA', function(sentCoords)
    TriggerClientEvent('erp-dispatch:policealertA', -1, sentCoords)
end)

RegisterNetEvent('erp-dispatch:policealertB')
AddEventHandler('erp-dispatch:policealertB', function(sentCoords)
    TriggerClientEvent('erp-dispatch:policealertB', -1, sentCoords)
end)

CreateThread(function()
    while true do
        Wait(3600000) -- 1 hour
        calls = {}
    end
end)

RegisterNetEvent('erp-dispatch:emsalertA')
AddEventHandler('erp-dispatch:emsalertA', function(sentCoords)
    TriggerClientEvent('erp-dispatch:emsalertA', -1, sentCoords)
end)

RegisterNetEvent('erp-dispatch:emsalertB')
AddEventHandler('erp-dispatch:emsalertB', function(sentCoords)
    TriggerClientEvent('erp-dispatch:emsalertB', -1, sentCoords)
end)
