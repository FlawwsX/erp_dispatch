-- car crash

--[[
    To trigger Car crash alert, use  the following event from any script you want
    TriggerEvent("civilian:alertPolice", 10.0, "carcrash")
]]--

function CarCrash()
    local locationInfo = GetStreetAndZone()
    local gender = GetPedGender()
    local currentPos = GetEntityCoords(PlayerPedId())
    local currentVeh = GetVehiclePedIsIn(PlayerPedId(), false)
    if currentVeh == 0 or GetVehicleNumberPlateText(currentVeh) == nil then currentVeh = GetVehiclePedIsIn(PlayerPedId(), true) end
    local vehicleData = GetVehicleDescription(currentVeh) or {}
    local dispatchCode = "10-50"
    TriggerServerEvent('dispatch:vehiclecrash', currentPos)

    TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = dispatchCode,
        firstStreet = locationInfo,
        gender = gender,
        model = vehicleData.model,
        plate = vehicleData.plate,
        priority = 3,
        firstColor = vehicleData.firstColor,
        secondColor = vehicleData.secondColor,
        heading = vehicleData.heading,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = "Vehicle Crash",
        job = Config.PoliceJob
    })
end

RegisterNetEvent('dispatch:vehiclecrash', function(targetCoords)
    
    if (IsPoliceJob(PlayerJob.name)) and onDuty then	
        local alpha = 250
        local injured = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

        SetBlipSprite(injured,  488)
        SetBlipColour(injured,  1)
        SetBlipScale(injured, 1.5)
        SetBlipAsShortRange(injured,  1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('10-50 Vehicle Crash')
        EndTextCommandSetBlipName(injured)
        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)

        while alpha ~= 0 do
            Wait(120 * 4)
            alpha = alpha - 1
            SetBlipAlpha(injured, alpha)

            if alpha == 0 then
                RemoveBlip(injured)
                return
            end
        end
    end
end)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[[
    To trigger Car crash alert, use  the following event from any script you want
    TriggerEvent("civilian:alertPolice", 10.0, "lockpick")
]]--


--- lockpicking vehicle
function AlertCheckLockpick()
    local locationInfo = GetStreetAndZone()
    local gender = GetPedGender()
    local currentPos = GetEntityCoords(PlayerPedId())
    local currentVeh = GetVehiclePedIsIn(PlayerPedId(), false)
    local vehicleData = GetVehicleDescription(currentVeh) or {}
    local dispatchCode = "10-90"
    TriggerServerEvent('dispatch:vehicletheft', currentPos)
    TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = dispatchCode,
        firstStreet = locationInfo,
        gender = gender,
        model = vehicleData.model,
        plate = vehicleData.plate,
        firstColor = vehicleData.firstColor,
        secondColor = vehicleData.secondColor,
        heading = vehicleData.heading,
        priority = 3,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = "Vehicle Theft",
        job = Config.PoliceJob
    })
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Brandishing Dispatch Alert!!

--[[
This function will alert the police when a player is brandishing a weapon and is already taken care in the script (Check cl_loops.lua and search for ArmedPlayer)
]]--

function ArmedPlayer() -- When aiming weapon.
    local locationInfo = GetStreetAndZone()
    local gender = GetPedGender()
    local currentPos = GetEntityCoords(PlayerPedId())
    local vehicleData = GetVehicleDescription() or {}
    local initialTenCode = "10-44"
    
    Wait(math.random(3000, 5000))
    TriggerServerEvent('dispatch:armedperson', currentPos)
    TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = initialTenCode,
        firstStreet = locationInfo,
        gender = gender,
        model = vehicleData.model,
        plate = vehicleData.plate,
        priority = 3,
        firstColor = vehicleData.firstColor,
        secondColor = vehicleData.secondColor,
        heading = vehicleData.heading,
        origin = {
        x = currentPos.x,
        y = currentPos.y,
        z = currentPos.z
        },
        dispatchMessage = "Brandishing",
        job = Config.PoliceJob
    })
end


RegisterNetEvent('dispatch:armedperson', function(sentCoords)
    if sentCoords then
        if IsPoliceJob(PlayerJob.name) and onDuty then 
            local alpha = 250
            local armedperson = AddBlipForCoord(sentCoords)
            SetBlipScale(armedperson, 1.0)
			SetBlipSprite(armedperson, 313)
			SetBlipColour(armedperson, 1)
			SetBlipAlpha(armedperson, alpha)
			SetBlipAsShortRange(armedperson, true)
			BeginTextCommandSetBlipName("STRING")              -- set the blip's legend caption
			AddTextComponentString('Armed Person')              -- to 'supermarket'
			EndTextCommandSetBlipName(armedperson)
			SetBlipAsShortRange(armedperson,  1)
            --PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
            
            CreateThread(function()
                while alpha ~= 0 and DoesBlipExist(armedperson) do
                    Wait(90 * 4)
                    alpha = alpha - 1
                    SetBlipAlpha(armedperson, alpha)
    
                    if alpha == 0 then
                        RemoveBlip(armedperson)
                        return
                    end
                end
            end)
        end
    end 
end)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Dispatch for Fights!
--[[
This function will alert the police when a player is fighting and is already taken care in the script (Check cl_loops.lua and search for AlertFight)
]]--
function AlertFight()
    local locationInfo = GetStreetAndZone()
    local gender, armed = GetPedGender(), IsPedArmed(PlayerPedId(), 7)
    local currentPos = GetEntityCoords(PlayerPedId())
    local dispatchCode = "10-15"
    if armed then
        --dispatchCode = "something"
    end
    local isInVehicle = IsPedInAnyVehicle(PlayerPedId())
    TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = dispatchCode,
        firstStreet = locationInfo,
        gender = gender,
        priority = 3,
        origin = {
        x = currentPos.x,
        y = currentPos.y,
        z = currentPos.z
        },
        dispatchMessage = "Fight In Progress",
        blipSprite = 458,
        blipColor = 25,
        job = Config.PoliceJob
    })
    TriggerServerEvent('dispatch:combatAlert', currentPos)
    if math.random(10) > 5 and not isInVehicle then
        CreateThread(function()
            Wait(math.random(5000, 10000))
            if IsPedInAnyVehicle(PlayerPedId()) then
                local vehicleData = GetVehicleDescription() or {}
                local newPos = GetEntityCoords(PlayerPedId())
                local locationInfo = GetStreetAndZone()
                TriggerServerEvent('dispatch:svNotify', {
                    dispatchCode = 'CarEvading',
                    relatedCode = dispatchCode,
                    firstStreet = locationInfo,
                    gender = gender,
                    model = vehicleData.model,
                    plate = vehicleData.plate,
                    priority = 3,
                    firstColor = vehicleData.firstColor,
                    secondColor = vehicleData.secondColor,
                    heading = vehicleData.heading,
                    origin = {
                    x = newPos.x,
                    y = newPos.y,
                    z = newPos.z
                    },
                    dispatchMessage = "Car fleeing 10-15",
                    job = Config.PoliceJob
                })
                TriggerServerEvent('dispatch:combatAlert', newPos)
            end
        end)
    end
end

RegisterNetEvent('dispatch:combatAlert', function(sentCoords)
    if sentCoords then
        if IsPoliceJob(PlayerJob.name) and onDuty then
            local alpha = 250
            local combatBlip = AddBlipForCoord(sentCoords)

            SetBlipScale(combatBlip, 1.3)
			SetBlipSprite(combatBlip, 437)
			SetBlipColour(combatBlip, 1)
			SetBlipAlpha(combatBlip, alpha)
			SetBlipAsShortRange(combatBlip, true)
			BeginTextCommandSetBlipName("STRING")              -- set the blip's legend caption
			AddTextComponentString('10-11 Fight In Progress')              -- to 'supermarket'
			EndTextCommandSetBlipName(combatBlip)
			SetBlipAsShortRange(combatBlip,  1)
            PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
            
            CreateThread(function()
                while alpha ~= 0 and DoesBlipExist(combatBlip) do
                    Wait(90 * 4)
                    alpha = alpha - 1
                    SetBlipAlpha(combatBlip, alpha)
    
                    if alpha == 0 then
                        RemoveBlip(combatBlip)
                        return
                    end
                end
            end)
        end
    end 
end)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Gunshot Alerts
--[[
This function will alert the police when a player is shooting and is already taken care in the script (Check cl_loops.lua and search for AlertGunShot)
]]--
function AlertGunShot(isHunting, sentWeapon) -- Check for automatic, change priority to 1
    if Config.KnownWeapons[sentWeapon] and not IsPedCurrentWeaponSilenced(PlayerPedId()) then
        local locationInfo = GetStreetAndZone()
        local gender = GetPedGender()
        local currentPos = GetEntityCoords(PlayerPedId())

        local isInVehicle = IsPedInAnyVehicle(PlayerPedId())

        local vehicleData = GetVehicleDescription(GetVehiclePedIsIn(PlayerPedId(), false)) or {}
        local initialTenCode = "10-60"
        local isAuto = Config.KnownWeapons[sentWeapon]['isAuto']

        TriggerServerEvent('dispatch:gunshotAlert', currentPos, isAuto, IsPoliceJob(PlayerJob.name))

        local job = Config.PoliceJob
        --if isHunting then job = {"sapr"} end
        TriggerServerEvent('dispatch:svNotify', {
            dispatchCode = initialTenCode,
            firstStreet = locationInfo,
            gender = gender,
            model = vehicleData.model,
            plate = vehicleData.plate,
            priority = 2,
            firstColor = vehicleData.firstColor,
            secondColor = vehicleData.secondColor,
            heading = vehicleData.heading,
            automaticGunfire = isAuto,
            origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
            },
            dispatchMessage = vehicleData.model ~= nil and "Shots Fired from Vehicle" or "Shots Fired",
            job = {"ambulance","police"}
        })

        if math.random(1, 10) > 3 and not isInVehicle then
            CreateThread(function()
                Wait(math.random(5000, 10000))
                if IsPedInAnyVehicle(PlayerPedId()) then
                    local vehicleData = GetVehicleDescription() or {}
                    local newPos = GetEntityCoords(PlayerPedId())
                    local locationInfo = GetStreetAndZone()
                    TriggerServerEvent('dispatch:svNotify', {
                        dispatchCode = 'CarEvading',
                        relatedCode = initialTenCode,
                        firstStreet = locationInfo,
                        gender = gender,
                        model = vehicleData.model,
                        plate = vehicleData.plate,
                        priority = 2,
                        firstColor = vehicleData.firstColor,
                        secondColor = vehicleData.secondColor,
                        heading = vehicleData.heading,
                        origin = {
                        x = newPos.x,
                        y = newPos.y,
                        z = newPos.z
                        },
                        dispatchMessage = "Car fleeing 10-60",
                        job = Config.PoliceJob
                    })
                    TriggerServerEvent('dispatch:gunshotAlert', newPos, false, IsPoliceJob(PlayerJob.name))
                end
            end)
        end
    end
end

RegisterNetEvent('dispatch:gunshotAlert', function(sentCoords, isAuto, isCop)
    if sentCoords then
        if IsPoliceJob(PlayerJob.name) then
            local blipAlpha = 200
            local gunshotBlip = AddBlipForRadius(sentCoords, 75.0)
            SetBlipHighDetail(gunshotBlip, true)
            if isCop then
                SetBlipColour(gunshotBlip, 2) -- Green
            elseif isAuto then
                SetBlipColour(gunshotBlip, 3) -- Blue
            else
                SetBlipColour(gunshotBlip, 1) -- Red
            end

            SetBlipAlpha(gunshotBlip, blipAlpha)
            SetBlipAsShortRange(gunshotBlip, true)
            BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('10-60 Shots Fired')
			EndTextCommandSetBlipName(gunshotBlip)
            PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
            
            CreateThread(function()
                while blipAlpha ~= 0 and DoesBlipExist(gunshotBlip) do
                    Wait(math.random(50, 300) * 4) -- Here we have the wait time to determaine the transparancy of the GunShot alert decreasing these numbers will make it go away faster and vise versa
                    blipAlpha = blipAlpha - 1
                    SetBlipAlpha(gunshotBlip, blipAlpha)
    
                    if blipAlpha == 0 then
                        RemoveBlip(gunshotBlip)
                        return
                    end
                end
            end)
        end 
    end 
end)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Drug Sale
--[[
To trigger this dispatch from whichever file you want, just use the following command/eventPrefix

`TriggerEvent('qb-dispatch:client:drugsale')`

]]--
RegisterNetEvent('qb-dispatch:client:drugsale',function()
    DrugSale()
end)

function DrugSale()
    local locationInfo = GetStreetAndZone()
    local gender = GetPedGender()
    local currentPos = GetEntityCoords(PlayerPedId())

    local isInVehicle = IsPedInAnyVehicle(PlayerPedId())
    local initialTenCode = "10-99"

    TriggerServerEvent('dispatch:drugsale', currentPos)

    TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = initialTenCode,
        firstStreet = locationInfo,
        gender = gender,
        priority = 2,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = "Suspicious Hand-off",
        job = Config.PoliceJob
    })

    if math.random(10) > 5 and not isInVehicle then
        CreateThread(function()
            Wait(math.random(7500, 12500))
            if IsPedInAnyVehicle(PlayerPedId()) then
                local vehicleData = GetVehicleDescription() or {}
                local newPos = GetEntityCoords(PlayerPedId())
                local locationInfo = GetStreetAndZone()
                TriggerServerEvent('dispatch:svNotify', {
                    dispatchCode = 'CarEvading',
                    relatedCode = initialTenCode,
                    firstStreet = locationInfo,
                    gender = gender,
                    model = vehicleData.model,
                    plate = vehicleData.plate,
                    priority = 2,
                    firstColor = vehicleData.firstColor,
                    secondColor = vehicleData.secondColor,
                    heading = vehicleData.heading,
                    origin = {
                    x = newPos.x,
                    y = newPos.y,
                    z = newPos.z
                    },
                    dispatchMessage = "Car Fleeing 10-99",
                    job = Config.PoliceJob
                })
                TriggerServerEvent('dispatch:drugsale', newPos)
            end
        end)
    end
end

RegisterNetEvent('dispatch:drugsale', function(sentCoords)
    if IsPoliceJob(PlayerJob.name) and onDuty then	
        local alpha = 250
        local drugsale = AddBlipForCoord(sentCoords)

        SetBlipSprite(drugsale,  487)
        SetBlipColour(drugsale,  4)
        SetBlipScale(drugsale, 1.2)
        SetBlipAsShortRange(Blip,  1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('10-99 In Progress')
        EndTextCommandSetBlipName(drugsale)
        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)

        while alpha ~= 0 do
            Wait(120 * 4)
            alpha = alpha - 1
            SetBlipAlpha(drugsale, alpha)

            if alpha == 0 then
                RemoveBlip(drugsale)
                return
            end
        end
    end
end)