function AlertBankTruck()
    local locationInfo = GetStreetAndZone()
    local gender = GetPedGender(playerPed)
    local currentPos = GetEntityCoords(playerPed)
    local isInVehicle = IsPedInAnyVehicle(PlayerPedId())
    local dispatchCode = "10-46"

    TriggerServerEvent('dispatch:banktruck', currentPos)

    TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = dispatchCode,
        firstStreet = locationInfo,
        gender = gender,
        
        priority = 1,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = "Bank Truck",
        job = Config.PoliceJob
    })

    if math.random(10) > 2 and not isInVehicle then
        CreateThread(function()
            Wait(math.random(12500, 15000))
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
                    
                    priority = 1,
                    firstColor = vehicleData.firstColor,
                    secondColor = vehicleData.secondColor,
                    heading = vehicleData.heading,
                    origin = {
                        x = newPos.x,
                        y = newPos.y,
                        z = newPos.z
                    },
                    dispatchMessage = "Evading Bank Truck",
                    job = Config.PoliceJob
                })
                TriggerServerEvent('dispatch:banktruck', newPos)
            end
            return
        end)
    end
end

function AlertArt()
    local locationInfo = GetStreetAndZone()
    local gender = GetPedGender(playerPed)
    local currentPos = GetEntityCoords(playerPed)
    local isInVehicle = IsPedInAnyVehicle(PlayerPedId())
    local dispatchCode = "10-97"

    TriggerServerEvent('dispatch:art', currentPos)

    TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = dispatchCode,
        firstStreet = locationInfo,
        gender = gender,
        
        priority = 1,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = "Art Gallery",
        job = Config.PoliceJob
    })

    if math.random(10) > 2 and not isInVehicle then
        CreateThread(function()
            Wait(math.random(12500, 15000))
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
                    
                    priority = 1,
                    firstColor = vehicleData.firstColor,
                    secondColor = vehicleData.secondColor,
                    heading = vehicleData.heading,
                    origin = {
                        x = newPos.x,
                        y = newPos.y,
                        z = newPos.z
                    },
                    dispatchMessage = "Evading Bank Truck",
                    job = Config.PoliceJob
                })
                TriggerServerEvent('dispatch:art', newPos)
            end
            return
        end)
    end
end

function AlertG6() -- whats the difference between this and banktruck?
    local locationInfo = GetStreetAndZone()
    local gender = GetPedGender(playerPed)
    local currentPos = GetEntityCoords(playerPed)
    local dispatchCode = "10-90"

    TriggerServerEvent('dispatch:g6', currentPos)

    TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = dispatchCode,
        firstStreet = locationInfo,
        gender = gender,
        
        priority = 1,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = "Gruppe Sechs Alarm",
        job = Config.PoliceJob
    })
end


function AlertCarBoost(boosted)
    local locationInfo = GetStreetAndZone()
    local gender = GetPedGender(playerPed)
    local currentPos = GetEntityCoords(playerPed)
    local veh = NetworkGetEntityFromNetworkId(boosted)
    local currentVeh = veh
    local dispatchCode = "10-81"

    TriggerServerEvent('dispatch:carboosting', currentPos, currentVeh, true)

    TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = dispatchCode,
        relatedCode = dispatchCode,
        firstStreet = locationInfo,
        gender = gender,
        model = GetDisplayNameFromVehicleModel(GetEntityModel(currentVeh)),
        plate = GetVehicleNumberPlateText(currentVeh),
        
        priority = 1,
        firstColor = GetVehicleModColor_1Name(currentVeh),
        secondColor = GetVehicleModColor_2Name(currentVeh),
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = "Car Boosting",
        job = Config.PoliceJob
    })

    CreateThread(function()
        while true do
            Wait(10000)
            hacked = Entity(currentVeh).state.hacked
            if not hacked and DoesEntityExist(currentVeh) then
                currentPos = GetEntityCoords(currentVeh)
                TriggerServerEvent('dispatch:carboosting', currentPos, currentVeh, false)
            end
        end
    end)
end


RegisterNetEvent('dispatch:carboost',function(boosted)
    AlertCarBoost(boosted)
  end)
  
    
  RegisterNetEvent('dispatch:AlertG6',function()
    AlertG6()
end)

  
RegisterNetEvent('dispatch:banktruck', function(targetCoords)
      
    if IsPoliceJob(PlayerJob.name) and onDuty then	
        local alpha = 250
        local truck = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

        SetBlipSprite(truck,  477)
        SetBlipColour(truck,  47)
        SetBlipScale(truck, 1.5)
        SetBlipAsShortRange(Blip,  1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('10-90 Bank Truck In Progress')
        EndTextCommandSetBlipName(truck)
        TriggerEvent("sounds:PlayOnOne","metaldetected",0.1)

        while alpha ~= 0 do
            Wait(120 * 4)
            alpha = alpha - 1
            SetBlipAlpha(truck, alpha)

        if alpha == 0 then
            RemoveBlip(truck)
        return
      end
    end
  end
end)

RegisterNetEvent('dispatch:art', function(targetCoords)
    
    if IsPoliceJob(PlayerJob.name) and onDuty then	
        local alpha = 250
        local gallery = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

        SetBlipSprite(gallery,  617)
        SetBlipColour(gallery,  47)
        SetBlipScale(gallery, 1.5)
        SetBlipAsShortRange(Blip,  1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('10-90 Art Gallery Heist In Progress')
        EndTextCommandSetBlipName(gallery)
        TriggerEvent("sounds:PlayOnOne","metaldetected",0.1)

        while alpha ~= 0 do
            Wait(120 * 4)
            alpha = alpha - 1
            SetBlipAlpha(gallery, alpha)

        if alpha == 0 then
            RemoveBlip(gallery)
        return
      end
    end
  end
end)

RegisterNetEvent('dispatch:g6', function(targetCoords)
    if IsPoliceJob(PlayerJob.name) and onDuty then	
        local alpha = 250
        local g6 = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

        SetBlipSprite(g6, 478)
        SetBlipColour(g6, 49)
        SetBlipScale(g6, 1.5)
        SetBlipAsShortRange(g6,  1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('10-90 Gruppe Sechs Robbery In Progress')
        EndTextCommandSetBlipName(g6)
        TriggerEvent("sounds:PlayOnOne","metaldetected",0.1)

        while alpha ~= 0 do
            Wait(120 * 4)
            alpha = alpha - 1
            SetBlipAlpha(g6, alpha)

        if alpha == 0 then
            RemoveBlip(g6)
        return
      end
    end
  end
end)

  
RegisterNetEvent('dispatch:carboosting', function(targetCoords, vehicle, alert)
    if IsPoliceJob(PlayerJob.name) and onDuty then	
        local alpha = 250
        local carboosting = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)
        local hacked = false
        if alert then
            TriggerEvent("sounds:PlayOnOne","metaldetected",0.1)
        end
        SetBlipSprite(carboosting,  225)
        SetBlipColour(carboosting,  49)
        SetBlipScale(carboosting, 1.0)
        SetBlipAsShortRange(Blip,  1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('10-81 Car Boosting')
        EndTextCommandSetBlipName(carboosting)


        while alpha ~= 0 do
            Wait(120 * 4)
            alpha = alpha - 10
            SetBlipAlpha(carboosting, alpha)

            if alpha < 50 then
                RemoveBlip(carboosting)
            end
        end
    end
end)

  
RegisterNetEvent('dispatch:mz:lockdown', function(targetCoords) 
    if (PlayerJob.name == 'ambulance' or IsPoliceJob(PlayerJob.name)) and onDuty then	
        local alpha = 250
        local policedown2 = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

        SetBlipSprite(policedown2,  186)
        SetBlipColour(policedown2,  1)
        SetBlipScale(policedown2, 1.0)
        SetBlipAsShortRange(policedown2,  1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Hospital Lockdown')
        EndTextCommandSetBlipName(policedown2)
        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)

        while alpha ~= 0 do
            Wait(200 * 4)
            alpha = alpha - 1
            SetBlipAlpha(policedown2, alpha)

            if alpha == 0 then
                RemoveBlip(policedown2)
                return
            end
        end
    end
end)

RegisterNetEvent('dispatch:mz:lockdownoff', function(targetCoords) 
    if (PlayerJob.name == 'ambulance' or IsPoliceJob(PlayerJob.name)) and onDuty then	
        QBCore.Functions.Notify("Mount Zonah is no longer on lockdown", "success")
    end
end)

RegisterNetEvent('dispatch:yachtheist', function(targetCoords)
    if IsPoliceJob(PlayerJob.name) and onDuty then	
        local alpha = 250
        local truck = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)
        SetBlipSprite(truck,  455)
        SetBlipColour(truck,  3)
        SetBlipScale(truck, 1.5)
        SetBlipAsShortRange(Blip,  1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('10-90 Yacht Heist In Progress')
        EndTextCommandSetBlipName(truck)
        TriggerEvent("sounds:PlayOnOne","metaldetected",0.1)
        while alpha ~= 0 do
            Wait(120 * 4)
            alpha = alpha - 1
            SetBlipAlpha(truck, alpha)
            if alpha == 0 then
                RemoveBlip(truck)
                return
            end
        end
    end
end)