PlayerData = {}
PlayerJob = {}
onDuty = false


local callID = 0
local currentCallSign = ""

QBCore = exports["qb-core"]:GetCoreObject()

-- for testing when restarting script
CreateThread(function()
    while QBCore == nil do
        Wait(200)
    end
    PlayerData = QBCore.Functions.GetPlayerData()
    PlayerJob  = QBCore.Functions.GetPlayerData().job
    Wait(50)
    onDuty = PlayerJob.onduty
end)

-- core related

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData= QBCore.Functions.GetPlayerData()
    PlayerJob  = QBCore.Functions.GetPlayerData().job
    generateHuntingZones()
    onDuty = PlayerJob.onduty
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
	PlayerData = {}
    currentCallSign = ""
    removeHuntingZones()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

RegisterNetEvent('QBCore:Client:SetDuty', function(duty)
    onDuty = duty
end)

--------- Event to set blips-----------------
RegisterNetEvent('dispatch:setBlip', function(type, pos, id)
    if (IsPoliceJob(PlayerJob.name) or PlayerJob.name == 'ambulance') and onDuty then	
        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
        PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
            
        if type == '911' then
            local alpha = 250
            local call = AddBlipForCoord(pos)

            SetBlipSprite (call, 480)
            SetBlipDisplay(call, 4)
            SetBlipScale  (call, 1.2)
            SetBlipAsShortRange(call, true)
            SetBlipAlpha(call, alpha)
            SetBlipHighDetail(call, true)
            SetBlipAsShortRange(call, true)

            SetBlipColour (call, 1)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString('['..id..'] 911 Call')
            EndTextCommandSetBlipName(call)
            
        
            while alpha ~= 0 do
                Wait(240 * 4)
                alpha = alpha - 1
                SetBlipAlpha(call, alpha)

                if alpha == 0 then
                    RemoveBlip(call)
                    return
                end
            end
        elseif type == '311' then
            local alpha = 250
            local call = AddBlipForCoord(pos)

            SetBlipSprite (call, 480)
            SetBlipDisplay(call, 4)
            SetBlipScale  (call, 1.2)
            SetBlipAsShortRange(call, true)
            SetBlipAlpha(call, alpha)
            SetBlipHighDetail(call, true)
            SetBlipAsShortRange(call, true)

            SetBlipColour (call, 64)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString('['..id..'] 311 Call')
            EndTextCommandSetBlipName(call)

            while alpha ~= 0 do
                Wait(240 * 4)
                alpha = alpha - 1
                SetBlipAlpha(call, alpha)

                if alpha == 0 then
                    RemoveBlip(call)
                    return
                end
            end
        end
    end
end)

RegisterNetEvent('dispatch:clNotify', function(sNotificationData, sNotificationId, sender)
    if sNotificationData ~= nil then
        if sender == GetPlayerServerId(PlayerId()) and sNotificationData['dispatchCode'] == '911' then
            SendNUIMessage({
                update = "newCall",
                callID = sNotificationId + math.random(1000, 9999),
                data = {
                    dispatchCode = '911',
                    priority = 1,
                    dispatchMessage = "Sent 911 call",
                    information = "Thank you for sending a 911 call in, it has been received and is being processed."
                },
                timer = 5000,
                isPolice = true
            })
        elseif sender == GetPlayerServerId(PlayerId()) and sNotificationData['dispatchCode'] == '311' then
            SendNUIMessage({
                update = "newCall",
                callID = sNotificationId + math.random(1000, 9999),
                data = {
                    dispatchCode = '311',
                    priority = 2,
                    dispatchMessage = "Sent 311 call",
                    information = "Thank you for sending a 311 call in, it has been received and is being processed."
                },
                timer = 5000,
                isPolice = true
            })
        end

        if not onDuty then return end; -- Makes it so there's no alerts if you are NOT on Duty!
        local shouldAlert = false
        for i=1, #sNotificationData['job'] do
            if sNotificationData['job'][i] == PlayerJob.name then
                shouldAlert = true
                break
            end
        end
        if shouldAlert then 
            if not disableNotis then
            if sNotificationData.origin ~= nil then
                if sNotificationData.originStatic == nil or not sNotificationData.originStatic then
                    sNotificationData.origin = randomizeBlipLocation(sNotificationData.origin)
                    else
                    sNotificationData.origin = sNotificationData.origin
                    end
                end
                SendNUIMessage({
                    update = "newCall",
                    callID = sNotificationId,
                    data = sNotificationData,
                    timer = 5000,
                    isPolice = IsPoliceJob(PlayerJob.name)
                })
            end
        end
    end
end)