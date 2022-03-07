--Fleeca bankrobbery

--[[
    To trigger this alert for fleeca robbery, trigger the following export in any client file.
    exports['qb-dispatch']:AddFleecaAlert()
]]--

local function AlertFleecaRobbery()
    local locationInfo = GetStreetAndZone()
    local gender = GetPedGender()
    local currentPos = GetEntityCoords(PlayerPedId())
    local isInVehicle = IsPedInAnyVehicle(PlayerPedId())
    local dispatchCode = "10-90"

    TriggerServerEvent('dispatch:bankrobbery', currentPos)

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
        dispatchMessage = "Fleeca Robbery",
        job = Config.PoliceJob
    })

    if math.random(10) > 2 and not isInVehicle then
        CreateThread(function()
            Wait(math.random(17500, 25000))
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
                TriggerServerEvent('dispatch:bankrobbery', newPos)
            end
        end)
    end
end

exports('AddFleecaAlert', AlertFleecaRobbery)

----Paleto Bay Bank Robbery Alert

--[[
    To trigger this alert for Paleto Robbery, trigger the following export in any client file.
    exports['qb-dispatch']:AddPaletoAlert()
]]--

local function AlertPaletoRobbery()
    local locationInfo = GetStreetAndZone()
    local gender = GetPedGender()
    local currentPos = GetEntityCoords(PlayerPedId())
    local isInVehicle = IsPedInAnyVehicle(PlayerPedId())
    local dispatchCode = "10-90"

    TriggerServerEvent('dispatch:bankrobbery', currentPos)

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
        dispatchMessage = "Paleto Robbery",
        job = Config.PoliceJob
    })

    if math.random(10) > 2 and not isInVehicle then
        CreateThread(function()
            Wait(math.random(17500, 25000))
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
                TriggerServerEvent('dispatch:bankrobbery', newPos)
            end
        end)
    end
end

exports('AddPaletoAlert', AlertPaletoRobbery)

-- pacific bank robbery alert

--[[
    To trigger this alert for Pacific Robbery, trigger the following export in any client file.
    exports['qb-dispatch']:AddPacificAlert()
]]--

local function AlertPacificRobbery()
    local locationInfo = GetStreetAndZone()
    local gender = GetPedGender()
    local currentPos = GetEntityCoords(PlayerPedId())
    local isInVehicle = IsPedInAnyVehicle(PlayerPedId())
    local dispatchCode = "10-90"

    TriggerServerEvent('dispatch:bankrobbery', currentPos)

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
        dispatchMessage = "Pacific Standard Heist",
        job = Config.PoliceJob
    })

    if math.random(10) > 2 and not isInVehicle then
        CreateThread(function()
            Wait(math.random(17500, 25000))
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
                TriggerServerEvent('dispatch:bankrobbery', newPos)
            end
        end)
    end
end

exports('AddPacificAlert', AlertPacificRobbery)

--[[
    If you want to add more robberies, add below this and give documentation of how to use it. try to follow the naming conventions and comments.
]]--





----------------------------------------------Helper Function for bank robbery (Do not touch this unless you know what you are doing)

RegisterNetEvent('dispatch:bankrobbery', function(targetCoords)
    if IsPoliceJob(PlayerJob.name) and onDuty then	
        local alpha = 250
        local bankrobbery = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

        SetBlipSprite(bankrobbery,  161)
        SetBlipColour(bankrobbery,  46)
        SetBlipScale(bankrobbery, 1.5)
        SetBlipAsShortRange(Blip,  1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('10-90 Bank Robbery In Progress')
        EndTextCommandSetBlipName(bankrobbery)
        TriggerEvent("sounds:PlayOnOne","metaldetected",0.1)

        while alpha ~= 0 do
            Wait(120 * 4)
            alpha = alpha - 1
            SetBlipAlpha(bankrobbery, alpha)

            if alpha == 0 then
                RemoveBlip(bankrobbery)
            return
            end
        end
    end
end)