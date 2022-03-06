--- Custom alert system
RegisterCommand("dtest", function ()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    TriggerServerEvent("dispatch:customAlert", {
        sprite = 310,
        color = 1,
        scale = 0.7,
        name = "Custom Alert",
        blipTick = 2000,
        alpha = 250,
        coords = coords,
        job = {"police", "ambulance"},
        sound = "Alert",
        soundVolume = 0.2,

        dispatchCode = "test",
        dispatchMessage = "Test Message",
        firstStreet = GetStreetAndZone(),
        name = PlayerData.charinfo.firstname..' '..PlayerData.charinfo.lastname,
        priority = 1,
        gender = GetPedGender(ped),
        origin = {
            x = coords.x,
            y = coords.y,
            z = coords.z,
        }
    })
end)

RegisterNetEvent('dispatch:customAlert', function(data)
    if data.sprite == nil then data.sprite = 1 end
    if data.color == nil then data.color = 1 end
    if data.scale == nil then data.scale = 1 end
    if data.name == nil then data.name = 1 end
    if data.blipTick == nil then data.blipTick = 1000 end
    if data.alpha == nil then data.alpha = 250 end


    local alpha = data.alpha
    local alert = AddBlipForCoord(data.coords)

    SetBlipSprite(alert,  data.sprite)
    SetBlipColour(alert,  data.color)
    SetBlipScale(alert, data.scale)
    SetBlipAsShortRange(alert,  1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(data.name)
    EndTextCommandSetBlipName(alert)

    if data.sound and data.soundVolume then 
        TriggerServerEvent('InteractSound_CL:PlayOnOne', data.sound, data.soundVolume)
    end

    if not disableNotis then
        if data.coords ~= nil then
            SendNUIMessage({
                update = "newCall",
                callID = data.callID,
                data = data,
                timer = 5000,
                isPolice = IsPoliceJob(PlayerJob.name)
            })
        end
    end

    while alpha ~= 0 do
        Wait(data.blipTick)
        alpha = alpha - 1
        SetBlipAlpha(alert, alpha)

        if alpha == 0 then
            RemoveBlip(alert)
            return
        end
    end
end)
----------end of custom alert!--------------------------------------

RegisterNetEvent('dispatch:getCallResponse', function(message)
    SendNUIMessage({
        update = "newCall",
        callID = math.random(1000, 9999),
        data = {
            dispatchCode = 'RSP',
            priority = 1,
            dispatchMessage = "Call Response",
            information = message
        },
        timer = 10000,
        isPolice = true
    })
end)



-- Dispatch Itself

local disableNotis, disableNotifSounds = false, false

RegisterNetEvent('dispatch:manageNotifs', function(sentSetting)
    local wantedSetting = tostring(sentSetting)
    if wantedSetting == "on" then
        disableNotis = false
        disableNotifSounds = false
        QBCore.Functions.Notify("Dispatch enabled", "success")
    elseif wantedSetting == "off" then
        disableNotis = true
        disableNotifSounds = true
        QBCore.Functions.Notify("Dispatch disabled", "success")
    elseif wantedSetting == "mute" then
        disableNotis = false
        disableNotifSounds = true
        QBCore.Functions.Notify("Dispatch muted", "success")
    else
        QBCore.Functions.Notify('Please choose to have dispatch as "on", "off" or "mute".', "success")

    end
end)

--[[
    All the functions triggered in the next event are present in cl_basealerts.lua
]]--
RegisterNetEvent('civilian:alertPolice', function(basedistance,alertType,objPassed,isGunshot,isHunting,sentWeapon)
    if PlayerJob == nil then return end

    local isPolice = IsPoliceJob(PlayerJob.name)
    local object = objPassed

    if not daytime then
      basedistance = basedistance * 8.2
    else
      basedistance = basedistance * 3.45
    end

    if isGunshot == nil then 
        isGunshot = false 
    end

    local plyCoords = GetEntityCoords(PlayerPedId())

    if isGunshot then
        shittypefuckyou = 'gunshot'
    end

    local nearNPC

    if alertType == 'drugsale' then
        nearNPC = GetClosestNPC(plyCoords, basedistance, 'combat', object)
    else
        nearNPC = GetClosestNPC(plyCoords, basedistance, shittypefuckyou)
    end 

    local dst = 0

    if nearNPC then
        dst = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(nearNPC))
    end

    if nearNPC and DoesEntityExist(nearNPC) then -- PED ANIMATION.
        if not isSpeeder and alertType ~= "robberyhouse" then
            Wait(500)
            if GetEntityHealth(nearNPC) == 0 then
            return
            end
            if not DoesEntityExist(nearNPC) then
                return
            end
            if IsPedFatallyInjured(nearNPC) then
                return
            end
            if IsPedInMeleeCombat(nearNPC) then
                return
            end
            if IsPedShooting(nearNPC) then
                return
            end
            local dontcall = {
                [29] = true,
                [28] = true,
                [27] = true
            }
            if not dontcall[GetPedType(nearNPC)] then
                ClearPedTasks(nearNPC)
                TaskPlayAnim(nearNPC, "cellphone@", "cellphone_call_listen_base", 1.0, 1.0, -1, 49, 0, 0, 0, 0)
            end
        end
    end

    local isUnderground = false
    if plyCoords.z <= -25 then isUnderground = true end

    if alertType == "drugsale" and not underground --[[and not isPolice]] then
        if dst > 50.5 and dst < 75.0 then
            DrugSale()
        end
    elseif alertType == "carcrash" then
        CarCrash()
    elseif alertType == "fight" and not underground then
        AlertFight()
    elseif (alertType == "gunshot" or alertType == "gunshotvehicle") then
        AlertGunShot(isHunting, sentWeapon)
    elseif alertType == "lockpick" then
        if dst > 5.0 and dst < 85.0 then
            if math.random(100) >= 25 then
                AlertCheckLockpick(object)
            end
        end
    end
end)


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--makes the AI move towards player

RegisterNetEvent('TriggerAIRunning', function(p)
    local usingped = p
    local nm1 = math.random(6,9) / 100
    local nm2 = math.random(6,9) / 100
    nm1 = nm1 + 0.3
    nm2 = nm2 + 0.3
    if math.random(10) > 5 then
        nm1 = 0.0 - nm1
    end
    if math.random(10) > 5 then
        nm2 = 0.0 - nm2
    end
    local moveto = GetOffsetFromEntityInWorldCoords(PlayerPedId(), nm1, nm2, 0.0)
    TaskGoStraightToCoord(usingped, moveto, 2.5, -1, 0.0, 0.0)
    SetPedKeepTask(usingped, true) 

    local dist = #(moveto - GetEntityCoords(usingped))
    while dist > 3.5 and (imdead == 1 or imcollapsed == 1) do
        TaskGoStraightToCoord(usingped, moveto, 2.5, -1, 0.0, 0.0)
        dist = #(moveto - GetEntityCoords(usingped))
        Citizen.Wait(100)
    end
    ClearPedTasksImmediately(ped)
    TaskLookAtEntity(usingped, PlayerPedId(), 5500.0, 2048, 3)
    TaskTurnPedToFaceEntity(usingped, PlayerPedId(), 5500)
    Citizen.Wait(3000)
    if math.random(3) == 2 then
        TaskStartScenarioInPlace(usingped, Config.TasksIdle[2], 0, 1)
    elseif math.random(1, 2) == 1 then
        TaskStartScenarioInPlace(usingped, Config.TasksIdle[1], 0, 1)
    else
        TaskStartScenarioInPlace(usingped, Config.TasksIdle[2], 0, 1)
        TaskStartScenarioInPlace(usingped, Config.TasksIdle[1], 0, 1)
    end
    SetPedKeepTask(usingped, true) 
    while imdead == 1 or imcollapsed == 1 do
        Citizen.Wait(1)
        if not IsPedFacingPed(usingped, PlayerPedId(), 15.0) then
            ClearPedTasksImmediately(ped)
            TaskLookAtEntity(usingped, PlayerPedId(), 5500.0, 2048, 3)
            TaskTurnPedToFaceEntity(usingped, PlayerPedId(), 5500)
            Citizen.Wait(3000)
        end
    end
    SetEntityAsNoLongerNeeded(usingped)
    ClearPedTasks(usingped)
end)

