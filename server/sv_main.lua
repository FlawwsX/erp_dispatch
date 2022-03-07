QBCore = exports["qb-core"]:GetCoreObject()
calls = {}

local function IsPoliceJob(job)
    for k, v in pairs(Config.PoliceJob) do
        if job == v then
            return true
        end
    end
    return false
end

RegisterServerEvent('dispatch:customAlert', function(data)
    if data == nil then print("Invalid data was passed to customAlert") return end

    local newId = #calls + 1
    data.callID = newId
	calls[newId] = data
    calls[newId]['source'] = source
    calls[newId]['callId'] = newId
    calls[newId]['units'] = {}
    calls[newId]['responses'] = {}
    calls[newId]['time'] = os.time() * 1000

    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            for i=1, #data.job do 
                if Player.PlayerData.job.name == data.job[i] then
                    TriggerClientEvent('dispatch:customAlert', v, data)
                end
            end
        end
    end
end)

function GetDispatchCalls() return calls end
exports('GetDispatchCalls', GetDispatchCalls) -- exports['erp_dispatch']:GetDispatchCalls()

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
    local Player = QBCore.Functions.GetPlayer(player)
    local name = Player.PlayerData.charinfo.firstname.. " " ..Player.PlayerData.charinfo.lastname
    if calls[callid] then
        table.insert(calls[callid]['responses'], {
            name = name,
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
