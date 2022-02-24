local calls = {}

local function IsPoliceJob(job)
    for k, v in pairs(Config.PoliceJob) do
        if job == v then
            return true
        end
    end
    return false
end

function GetDispatchCalls() return calls end
exports('GetDispatchCalls', GetDispatchCalls) -- exports['erp_dispatch']:GetDispatchCalls()

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

-- this is mdt call
AddEventHandler("dispatch:addUnit", function(callid, player, cb)
    if calls[callid] then
        if #calls[callid]['units'] > 0 then
            for i=1, #calls[callid]['units'] do
                if calls[callid]['units'][i]['cid'] == player.cid then
                    cb(#calls[callid]['units'])
                    return
                end
            end
        end

        if IsPoliceJob(player.job.name) then
            table.insert(calls[callid]['units'], { cid = player.cid, fullname = player.fullname, job = 'Police', callsign = player.callsign })
        elseif player.job.name == 'ambulance' then
            table.insert(calls[callid]['units'], { cid = player.cid, fullname = player.fullname, job = 'EMS', callsign = player.callsign })
        end
        cb(#calls[callid]['units'])
    end
end)

-- this is mdt call
AddEventHandler("dispatch:removeUnit", function(callid, player, cb)
    if calls[callid] then
        if #calls[callid]['units'] > 0 then
            for i=1, #calls[callid]['units'] do
                if calls[callid]['units'][i]['cid'] == player.cid then
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
            name = player.fullname,
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
    local Player = QBCore.Functions.GetPlayer(source)
	local job = Player.PlayerData.job
	if IsPoliceJob(job.name) or job.name == 'ambulance' then
		TriggerClientEvent('dispatch:manageNotifs', source, args[1])
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