-- house robbery
--[[
    To trigger this alert for House robbery, trigger the following export in any client file.
    exports['qb-dispatch']:HouseRobberyAlert()
]]--

local function AlertHouseRobbery()
    local locationInfo = GetStreetAndZone()
    local gender = GetPedGender()
    local currentPos = GetEntityCoords(PlayerPedId())
    local isInVehicle = IsPedInAnyVehicle(PlayerPedId())
    local dispatchCode = "10-33"

    TriggerServerEvent('dispatch:houserobbery', currentPos)

    TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = dispatchCode,
        firstStreet = locationInfo,
        gender = gender,
        
        priority = 2,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = "Breaking and entering",
        job = Config.PoliceJob
    })

    if math.random(10) > 3 and not isInVehicle then
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
                    dispatchMessage = "Car fleeing 10-90",
                    job = Config.PoliceJob
                })
                TriggerServerEvent('dispatch:houserobbery', newPos)
            end
        end)
    end
end

exports('HouseRobberyAlert', AlertHouseRobbery)

RegisterNetEvent('dispatch:houserobbery', function(targetCoords)
    if IsPoliceJob(PlayerJob.name) and onDuty then	
        local alpha = 250
        local burglary = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)
        SetBlipHighDetail(burglary, true)
        SetBlipSprite(burglary,  411)
        SetBlipColour(burglary,  1)
        SetBlipScale(burglary, 1.3)
        SetBlipAsShortRange(burglary,  1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('10-90 Burglary')
        EndTextCommandSetBlipName(burglary)
        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)

        while alpha ~= 0 do
            Wait(120 * 4)
            alpha = alpha - 1
            SetBlipAlpha(burglary, alpha)
            if alpha == 0 then
                RemoveBlip(burglary)
                return
            end
        end
    end
end)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Jewellery robbery

--[[
    To trigger this alert for Jewellery robbery, trigger the following export in any client file.
    exports['qb-dispatch']:JewlRobAlert()
]]--

local function AlertJewelRob()
    local locationInfo = GetStreetAndZone()
    local gender = GetPedGender()
    local currentPos = GetEntityCoords(PlayerPedId())
    local isInVehicle = IsPedInAnyVehicle(PlayerPedId())
    local dispatchCode = "10-90"

    TriggerServerEvent('dispatch:jewel', currentPos)

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
        dispatchMessage = "Vangelico Robbery",
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
                    dispatchMessage = "Evading 10-90",
                    job = Config.PoliceJob
                })
                TriggerServerEvent('dispatch:jewel', newPos)
            end
        end)
    end
end

exports('JewlRobAlert', AlertJewelRob)

RegisterNetEvent('dispatch:jewel', function(targetCoords)
    if IsPoliceJob(PlayerJob.name) and onDuty then	
        local alpha = 250
        local truck = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

        SetBlipSprite(truck,  434)
        SetBlipColour(truck,  66)
        SetBlipScale(truck, 1.5)
        SetBlipAsShortRange(Blip,  1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('10-90 Vangelico Robbery In Progress')
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

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[[
    TODO
    Create an alert for store robbery
]]--