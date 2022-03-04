PlayerData = {}
PlayerJob = {}

local callID = 0
local currentCallSign = ""
local playerPed, playerCoords = PlayerPedId(), vec3(0, 0, 0)
local currentVehicle, inVehicle, currentlyArmed, currentWeapon = nil, false, false, `WEAPON_UNARMED`
local HuntingZones = {}
local inHuntingZone = false

QBCore = exports["qb-core"]:GetCoreObject()

-- for testing when restarting script
CreateThread(function()
    while QBCore == nil do
        Wait(200)
    end
    PlayerData = QBCore.Functions.GetPlayerData()
    PlayerJob  = QBCore.Functions.GetPlayerData().job
end)

-- core related

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData= QBCore.Functions.GetPlayerData()
    PlayerJob  = QBCore.Functions.GetPlayerData().job
    generateHuntingZones()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
	PlayerData = {}
    currentCallSign = ""
    currentVehicle, inVehicle, currentlyArmed, currentWeapon = nil, false, false, `WEAPON_UNARMED`
    removeHuntingZones()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

--------- Event to set blips-----------------
RegisterNetEvent('dispatch:setBlip', function(type, pos, id)
    if (IsPoliceJob(PlayerJob.name) or PlayerJob.name == 'ambulance') and PlayerJob.onduty then	
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
                Citizen.Wait(240 * 4)
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
                Citizen.Wait(240 * 4)
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