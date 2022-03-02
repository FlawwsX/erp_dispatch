
function ArmedPlayer() -- When aiming weapon.
    local locationInfo = GetStreetAndZone()
    local gender = GetPedGender(playerPed)
    local currentPos = GetEntityCoords(playerPed)

    local isInVehicle = IsPedInAnyVehicle(PlayerPedId())

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


RegisterNetEvent('dispatch:combatAlert', function(sentCoords)
    if sentCoords then
        if IsPoliceJob(PlayerJob.name) and PlayerJob.onduty then
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
                    Citizen.Wait(90 * 4)
                    alpha = alpha - 1
                    SetBlipAlpha(combatBlip, alpha)
    
                    if alpha == 0 then
                        RemoveBlip(combatBlip)
                        return
                    end
                end
                return
            end)
        end
    end 
end)

RegisterNetEvent('dispatch:armedperson', function(sentCoords)
    if sentCoords then
        
        if IsPoliceJob(PlayerJob.name) and PlayerJob.onduty then 
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
                    Citizen.Wait(90 * 4)
                    alpha = alpha - 1
                    SetBlipAlpha(armedperson, alpha)
    
                    if alpha == 0 then
                        RemoveBlip(armedperson)
                        return
                    end
                end
                return
            end)
        end
    end 
end)

function AlertFight()

    local locationInfo = GetStreetAndZone()
    local gender, armed = GetPedGender(playerPed), IsPedArmed(playerPed, 7)
    local currentPos = GetEntityCoords(playerPed)

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
            return
        end)
    end
end

function AlertGunShot(isHunting, sentWeapon) -- Check for automatic, change priority to 1
    if Config.KnownWeapons[sentWeapon] and not IsPedCurrentWeaponSilenced(PlayerPedId()) then
        local locationInfo = GetStreetAndZone()
        local gender = GetPedGender(playerPed)
        local currentPos = GetEntityCoords(playerPed)

        local isInVehicle = IsPedInAnyVehicle(PlayerPedId())

        local vehicleData = GetVehicleDescription() or {}
        print(json.encode(vehicleData))
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
                return
            end)
        end
    end
end

RegisterNetEvent('drugsalecallpolice',function()
    DrugSale()
end)

RegisterCommand("13A", function ()
    TriggerEvent("ems:tenThirteenB")
end)


RegisterCommand('911', function(source, args, rawCommand)
    local msg = rawCommand:sub(5)
    if string.len(msg) > 0 then
        local plyData = QBCore.Functions.GetPlayerData()
        local locationInfo = GetStreetAndZone()
        local gender = GetPedGender(playerPed)
        local currentPos = GetEntityCoords(playerPed)
        TriggerServerEvent('dispatch:svNotify', {
            dispatchCode = "911",
            firstStreet = locationInfo,
            gender = gender,
            priority = 1,
            origin = { x = currentPos.x, y = currentPos.y, z = currentPos.z },
            dispatchMessage = "911 Call",
            name = plyData.charinfo.firstname.. ",".. plyData.charinfo.lastname,
            number = plyData.charinfo.phone,
            job = Config.PoliceAndAmbulance,
            information = msg
        })
    else
        QBCore.Functions.Notify('Please put a reason after the 911', "success")
    end
end)

RegisterCommand('311', function(source, args, rawCommand)
    local msg = rawCommand:sub(5)
    if string.len(msg) > 0 then
        local plyData = QBCore.Functions.GetPlayerData()
        local locationInfo = GetStreetAndZone()
        local gender = GetPedGender(playerPed)
        local currentPos = GetEntityCoords(playerPed)
        TriggerServerEvent('dispatch:svNotify', {
            dispatchCode = "311",
            firstStreet = locationInfo,
            gender = gender,
            priority = 2,
            origin = { x = currentPos.x, y = currentPos.y, z = currentPos.z },
            dispatchMessage = "311 Call",
            name = plyData.charinfo.firstname.. ",".. plyData.charinfo.lastname,
            number = plyData.charinfo.phone,
            job = Config.PoliceAndAmbulance,
            information = msg
        })
    else
        QBCore.Functions.Notify('Please put a reason after the 311', "success")
    end
end)


function DrugSale()
    local locationInfo = GetStreetAndZone()
    local gender = GetPedGender(playerPed)
    local currentPos = GetEntityCoords(playerPed)

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
            return
        end)
    end
end

function CarCrash()
    local locationInfo = GetStreetAndZone()
    local gender = GetPedGender(playerPed)
    local currentPos = GetEntityCoords(playerPed)
    local isInVehicle = IsPedInAnyVehicle(PlayerPedId())
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

function AlertCheckLockpick(object)

    local locationInfo = GetStreetAndZone()
    local gender = GetPedGender(playerPed)
    local currentPos = GetEntityCoords(playerPed)

    local isInVehicle = IsPedInAnyVehicle(PlayerPedId())
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


function AlertpersonRobbed()
    local locationInfo = GetStreetAndZone()
    local gender = GetPedGender(playerPed)
    local currentPos = GetEntityCoords(playerPed)
    local isInVehicle = IsPedInAnyVehicle(PlayerPedId())
    local currentVeh = GetVehiclePedIsIn(PlayerPedId(), false)
    local dispatchCode = "10-90"

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
        dispatchMessage = "Store Robbery",
        job = Config.PoliceJob
    })

    if math.random(10) > 3 and not isInVehicle then
        CreateThread(function()
            Wait(math.random(20000, 25000))
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
                    
                    priority = 2,
                    firstColor = vehicleData.firstColor,
                    secondColor = vehicleData.secondColor,
                    heading = vehicleData.heading,
                    origin = {
                    x = newPos.x,
                    y = newPos.y,
                    z = newPos.z
                    },
                    dispatchMessage = "Vehicle fleeing 10-90",
                    job = Config.PoliceJob
                })
                TriggerServerEvent('dispatch:houserobbery', newPos)
            end
            return
        end)
    end 
end

RegisterNetEvent('dispatch:houserobbery:force')
AddEventHandler("dispatch:houserobbery:force",function()
    AlertCheckRobbery2()
end)

function AlertCheckRobbery2()
    local locationInfo = GetStreetAndZone()
    local gender = GetPedGender(playerPed)
    local currentPos = GetEntityCoords(playerPed)
    local isInVehicle = IsPedInAnyVehicle(PlayerPedId())
    local currentVeh = GetVehiclePedIsIn(PlayerPedId(), false)
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
            return
        end)
    end
end

function AlertBankTruck()
    local locationInfo = GetStreetAndZone()
    local gender = GetPedGender(playerPed)
    local currentPos = GetEntityCoords(playerPed)
    local isInVehicle = IsPedInAnyVehicle(PlayerPedId())
    local currentVeh = GetVehiclePedIsIn(PlayerPedId(), false)
    local dispatchCode = "10-90"

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
    local currentVeh = GetVehiclePedIsIn(PlayerPedId(), false)
    local dispatchCode = "10-90"

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

function AlertG6()
    local locationInfo = GetStreetAndZone()
    local gender = GetPedGender(playerPed)
    local currentPos = GetEntityCoords(playerPed)
    local isInVehicle = IsPedInAnyVehicle(PlayerPedId())
    local currentVeh = GetVehiclePedIsIn(PlayerPedId(), false)
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

function AlertJewelRob()
    local locationInfo = GetStreetAndZone()
    local gender = GetPedGender(playerPed)
    local currentPos = GetEntityCoords(playerPed)
    local isInVehicle = IsPedInAnyVehicle(PlayerPedId())
    local currentVeh = GetVehiclePedIsIn(PlayerPedId(), false)
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
            return
        end)
    end
end

function AlertJailBreak()
    local locationInfo = GetStreetAndZone()
    local gender = GetPedGender(playerPed)
    local currentPos = GetEntityCoords(playerPed)
    local isInVehicle = IsPedInAnyVehicle(PlayerPedId())
    local dispatchCode = "10-98"

    TriggerServerEvent('dispatch:blip:jailbreak', currentPos)

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
        dispatchMessage = "Jail Break in Progress",
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
                    dispatchCode = 'CarFleeing',
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
                    dispatchMessage = "Evading 10-98",
                    job = Config.PoliceJob
                })

                TriggerServerEvent('dispatch:blip:jailbreak', newPos)
            end
            return
        end)
    end
end

function AlertPaletoRobbery()
    local locationInfo = GetStreetAndZone()
    local gender = GetPedGender(playerPed)
    local currentPos = GetEntityCoords(playerPed)
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
            return
        end)
    end
end

function AlertCarBoost(boosted)
    local locationInfo = GetStreetAndZone()
    local gender = GetPedGender(playerPed)
    local currentPos = GetEntityCoords(playerPed)
    local isInVehicle = IsPedInAnyVehicle(PlayerPedId())
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

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(10000)
            hacked = Entity(currentVeh).state.hacked
            if not hacked and DoesEntityExist(currentVeh) then
                currentPos = GetEntityCoords(currentVeh)
                TriggerServerEvent('dispatch:carboosting', currentPos, currentVeh, false)
            end
        end
    end)
end

function AlertFleecaRobbery()
    local locationInfo = GetStreetAndZone()
    local gender = GetPedGender(playerPed)
    local currentPos = GetEntityCoords(playerPed)
    local isInVehicle = IsPedInAnyVehicle(PlayerPedId())
    local currentVeh = GetVehiclePedIsIn(PlayerPedId(), false)
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
            return
        end)
    end
end

RegisterNetEvent('dispatch:drugjob',function()
    AlertDrugJob()
  end)
  
  RegisterNetEvent('dispatch:bankrobbery',function()
    AlertFleecaRobbery()
  end)
  
  RegisterNetEvent('dispatch:paleto:bankrobbery',function()
   AlertPaletoRobbery()
  end)
  
  RegisterNetEvent('dispatch:carboost',function(boosted)
    AlertCarBoost(boosted)
  end)
  
  RegisterNetEvent('dispatch:bankrobbery:pacific',function()
    AlertPacificRobbery()
  end)
  
  function AlertPacificRobbery()
      local locationInfo = GetStreetAndZone()
      local gender = GetPedGender(playerPed)
      local currentPos = GetEntityCoords(playerPed)
      local isInVehicle = IsPedInAnyVehicle(PlayerPedId())
      local currentVeh = GetVehiclePedIsIn(PlayerPedId(), false)
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
              return
          end)
      end
  end
  
  function AlertPowerplant()
      local locationInfo = GetStreetAndZone()
      local gender = GetPedGender(playerPed)
      local currentPos = GetEntityCoords(playerPed)
      local isInVehicle = IsPedInAnyVehicle(PlayerPedId())
      local currentVeh = GetVehiclePedIsIn(PlayerPedId(), false)
      local dispatchCode = "10-90"
  
      TriggerServerEvent('dispatch:bankrobbery', currentPos)
  
      TriggerServerEvent('dispatch:svNotify', {
          dispatchCode = dispatchCode,
          firstStreet = "Senora Way, Palmer-Taylor Power Station",
          gender = gender,
          priority = 1,
          origin = {
              x = currentPos.x,
              y = currentPos.y,
              z = currentPos.z
          },
          dispatchMessage = "Powerplant Hit",
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
              return
          end)
      end
  end
  
  RegisterNetEvent('dispatch:jailbreak',function()
    AlertJailBreak()
  end)
  
  RegisterNetEvent('client:dispatch:jewelrobbery',function()
    AlertJewelRob()
  end)
  
  RegisterNetEvent('dispatch:storerobbery',function()
    AlertpersonRobbed(vehicle)
  end)
  
  RegisterNetEvent('dispatch:carjacking',function()
    AlertCheckLockpick(object)
  end)
  
  RegisterNetEvent('police:downplayer',function()
      AlertDeath()
  end)
  
  RegisterNetEvent('dispatch:AlertG6',function()
      AlertG6()
  end)
  
  
  local tenThirteenAC = false
  
  RegisterNetEvent('police:tenThirteenA', function()
      if tenThirteenAC then return end;
      
      if IsPoliceJob(PlayerJob.name) then	
         print("?????")
          local pos = GetEntityCoords(PlayerPedId(),  true)
          local plyData = QBCore.Functions.GetPlayerData()
  
          TriggerServerEvent("dispatch:svNotify", {
              dispatchCode = "10-13A",
              firstStreet = GetStreetAndZone(),
              name = plyData.charinfo.firstname..' '..plyData.charinfo.lastname,
              priority = 1,
              isDead = "officer",
              dispatchMessage = "Officer Down",
              origin = {
                  x = pos.x,
                  y = pos.y,
                  z = pos.z
              },
              job = {"police","ambulance"}
          })
          
          TriggerServerEvent('dispatch:policealertA', pos)
          
          CreateThread(function()
              tenThirteenAC = true
              Wait(30000)
              tenThirteenAC = false
          end)
      end
  end)
  
  
  RegisterNetEvent('dispatch:policealertA', function(targetCoords)
      if (PlayerJob.name == 'ambulance' or IsPoliceJob(PlayerJob.name)) and PlayerJob.onduty then
          print("??")	
          local alpha = 250
          local policedown = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)
  
          SetBlipSprite(policedown,  126)
          SetBlipColour(policedown,  1)
          SetBlipScale(policedown, 1.3)
          SetBlipAsShortRange(policedown,  1)
          BeginTextCommandSetBlipName("STRING")
          AddTextComponentString('10-13A Officer Down')
          EndTextCommandSetBlipName(policedown)
          PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
  
          while alpha ~= 0 do
              Citizen.Wait(120 * 4)
              alpha = alpha - 1
              SetBlipAlpha(policedown, alpha)
  
              if alpha == 0 then
                  RemoveBlip(policedown)
                  return
              end
          end
      end
  end)
  
  local tenThirteenBC = false
  
  RegisterNetEvent('police:tenThirteenB', function()
      if tenThirteenBC then return end;
      
      if IsPoliceJob(PlayerJob.name) then
          local pos = GetEntityCoords(PlayerPedId(),  true)
          
          local plyData = QBCore.Functions.GetPlayerData()
          
          TriggerServerEvent("dispatch:svNotify", {
              dispatchCode = "10-13B",
              firstStreet = GetStreetAndZone(),
              name = plyData.charinfo.firstname..' '..plyData.charinfo.lastname,
              number =  plyData['phone_number'],
              priority = 1,
              isDead = "officer",
              dispatchMessage = "Officer Down",
              origin = {
                  x = pos.x,
                  y = pos.y,
                  z = pos.z
              },
              job = {"police", "ambulance"}
          })
  
          CreateThread(function()
              tenThirteenBC = true
              Wait(30000)
              tenThirteenBC = false
          end)
  
          TriggerServerEvent('dispatch:policealertB', pos)
      end
  end)
  
  RegisterNetEvent('dispatch:policealertB', function(targetCoords)
      if (PlayerJob.name == 'ambulance' or IsPoliceJob(PlayerJob.name)) and PlayerJob.onduty then	
          local alpha = 250
          local policedown2 = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)
  
          SetBlipSprite(policedown2,  126)
          SetBlipColour(policedown2,  1)
          SetBlipScale(policedown2, 1.3)
          SetBlipAsShortRange(policedown2,  1)
          BeginTextCommandSetBlipName("STRING")
          AddTextComponentString('10-13B Officer Down')
          EndTextCommandSetBlipName(policedown2)
          PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
  
          while alpha ~= 0 do
              Citizen.Wait(120 * 4)
              alpha = alpha - 1
              SetBlipAlpha(policedown2, alpha)
  
              if alpha == 0 then
                  RemoveBlip(policedown2)
              return
          end
          end
      end
  end)
  
  
  ---- Car Crash ----
  RegisterNetEvent('dispatch:vehiclecrash', function(targetCoords)
      
      if (IsPoliceJob(PlayerJob.name)) and PlayerJob.onduty then	
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
              Citizen.Wait(120 * 4)
              alpha = alpha - 1
              SetBlipAlpha(injured, alpha)
  
          if alpha == 0 then
              RemoveBlip(injured)
          return
        end
      end
    end
  end)
  
  ---- Vehicle Theft ----
  
  RegisterNetEvent('dispatch:vehicletheft', function(targetCoords)
      
      if (IsPoliceJob(PlayerJob.name)) and PlayerJob.onduty then	
          local alpha = 250
          local thiefBlip = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)
  
          SetBlipSprite(thiefBlip,  488)
          SetBlipColour(thiefBlip,  1)
          SetBlipScale(thiefBlip, 1.5)
          SetBlipAsShortRange(thiefBlip,  1)
          BeginTextCommandSetBlipName("STRING")
          AddTextComponentString('10-90 Vehicle Theft')
          EndTextCommandSetBlipName(thiefBlip)
          PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
  
          while alpha ~= 0 do
              Citizen.Wait(120 * 4)
              alpha = alpha - 1
              SetBlipAlpha(thiefBlip, alpha)
  
          if alpha == 0 then
              RemoveBlip(thiefBlip)
          return
        end
      end
    end
  end)
  
  ---- Store Robbery ----
  
  RegisterNetEvent('dispatch:storerobbery', function(targetCoords)
      
      if IsPoliceJob(PlayerJob.name) and PlayerJob.onduty then	
          local alpha = 250
          local store = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)
  
          SetBlipHighDetail(store, true)
          SetBlipSprite(store,  52)
          SetBlipColour(store,  1)
          SetBlipScale(store, 1.3)
          SetBlipAsShortRange(store,  1)
          BeginTextCommandSetBlipName("STRING")
          AddTextComponentString('10-90 Robbery In Progress')
          EndTextCommandSetBlipName(store)
          TriggerEvent("sounds:PlayOnOne","metaldetected",0.1)
  
          while alpha ~= 0 do
              Citizen.Wait(120 * 4)
              alpha = alpha - 1
              SetBlipAlpha(store, alpha)
  
              if alpha == 0 then
                  RemoveBlip(store)
              end
          end
      end
  end)
  
  ---- House Robbery ----
  
  RegisterNetEvent('dispatch:houserobbery', function(targetCoords)
      
      if IsPoliceJob(PlayerJob.name) and PlayerJob.onduty then	
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
              Citizen.Wait(120 * 4)
              alpha = alpha - 1
              SetBlipAlpha(burglary, alpha)
  
          if alpha == 0 then
              RemoveBlip(burglary)
          return
        end
      end
    end
  end)
  
  ---- Bank Truck ----
  
  RegisterNetEvent('dispatch:banktruck', function(targetCoords)
      
      if IsPoliceJob(PlayerJob.name) and PlayerJob.onduty then	
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
              Citizen.Wait(120 * 4)
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
      
      if IsPoliceJob(PlayerJob.name) and PlayerJob.onduty then	
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
              Citizen.Wait(120 * 4)
              alpha = alpha - 1
              SetBlipAlpha(gallery, alpha)
  
          if alpha == 0 then
              RemoveBlip(gallery)
          return
        end
      end
    end
  end)
  
  RegisterNetEvent('dispatch:jewel', function(targetCoords)
      
      if IsPoliceJob(PlayerJob.name) and PlayerJob.onduty then	
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
              Citizen.Wait(120 * 4)
              alpha = alpha - 1
              SetBlipAlpha(truck, alpha)
  
          if alpha == 0 then
              RemoveBlip(truck)
          return
        end
      end
    end
  end)
  
  RegisterNetEvent('dispatch:bankrobbery', function(targetCoords)
      if IsPoliceJob(PlayerJob.name) and PlayerJob.onduty then	
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
              Citizen.Wait(120 * 4)
              alpha = alpha - 1
              SetBlipAlpha(bankrobbery, alpha)
  
          if alpha == 0 then
              RemoveBlip(bankrobbery)
          return
        end
      end
    end
  end)
  
  RegisterNetEvent('dispatch:g6', function(targetCoords)
      if IsPoliceJob(PlayerJob.name) and PlayerJob.onduty then	
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
              Citizen.Wait(120 * 4)
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
      if IsPoliceJob(PlayerJob.name) and PlayerJob.onduty then	
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
              Citizen.Wait(120 * 4)
              alpha = alpha - 10
              SetBlipAlpha(carboosting, alpha)
  
              if alpha < 50 then
                  RemoveBlip(carboosting)
              end
          end
      end
  end)
  
  RegisterNetEvent('dispatch:yachtheist', function(targetCoords)
      
      if IsPoliceJob(PlayerJob.name) and PlayerJob.onduty then	
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
              Citizen.Wait(120 * 4)
              alpha = alpha - 1
              SetBlipAlpha(truck, alpha)
  
          if alpha == 0 then
              RemoveBlip(truck)
          return
        end
      end
    end
  end)
  
  ---- Drug Trade ----
  
  RegisterNetEvent('dispatch:drugsale', function(sentCoords)
      
      if IsPoliceJob(PlayerJob.name) and PlayerJob.onduty then	
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
              Citizen.Wait(120 * 4)
              alpha = alpha - 1
              SetBlipAlpha(drugsale, alpha)
  
          if alpha == 0 then
              RemoveBlip(drugsale)
              return
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
      -- if not PlayerJob.onduty then return end;
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
  
  -- EMS 10-14
  
  RegisterNetEvent('ems:tenThirteenA', function()
      if tenThirteenAC then return end;
      
      if PlayerJob.name == 'ambulance' then	
         
          local pos = GetEntityCoords(PlayerPedId(),  true)
          local plyData = QBCore.Functions.GetPlayerData()
  
  
          local job = {"police", "ambulance"}
  
          TriggerServerEvent("dispatch:svNotify", {
              dispatchCode = "10-14A",
              firstStreet = GetStreetAndZone(),
              name = plyData.charinfo.firstname..' '..plyData.charinfo.lastname,
              priority = 1,
              isDead = "officer",
              dispatchMessage = "Medic Down",
              origin = {
                  x = pos.x,
                  y = pos.y,
                  z = pos.z
              },
              job = job
          })
          
          TriggerServerEvent('dispatch:emsalertA', pos)
          
          CreateThread(function()
              tenThirteenAC = true
              Wait(30000)
              tenThirteenAC = false
          end)
      end
  end)
  
  
  RegisterNetEvent('dispatch:emsalertA', function(targetCoords)
      if (PlayerJob.name == 'ambulance' or IsPoliceJob(PlayerJob.name)) and PlayerJob.onduty then	
          local alpha = 250
          local policedown = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)
  
          SetBlipSprite(policedown,  126)
          SetBlipColour(policedown,  3)
          SetBlipScale(policedown, 1.3)
          SetBlipAsShortRange(policedown,  1)
          BeginTextCommandSetBlipName("STRING")
          AddTextComponentString('10-14A Medic Down')
          EndTextCommandSetBlipName(policedown)
          PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
  
          while alpha ~= 0 do
              Citizen.Wait(120 * 4)
              alpha = alpha - 1
              SetBlipAlpha(policedown, alpha)
  
              if alpha == 0 then
                  RemoveBlip(policedown)
                  return
              end
          end
      end
  end)
  
  RegisterNetEvent('ems:tenThirteenB', function()
      if tenThirteenBC then return end;
      
      if PlayerJob.name == 'ambulance' then	
          local pos = GetEntityCoords(PlayerPedId(),  true)
          
          local plyData = QBCore.Functions.GetPlayerData()
  
          TriggerServerEvent("dispatch:svNotify", {
              dispatchCode = "10-14B",
              firstStreet = GetStreetAndZone(),
              name = plyData.charinfo.firstname..' '..plyData.charinfo.lastname,
              number =  plyData['phone_number'],
              priority = 1,
              isDead = "officer",
              dispatchMessage = "Medic Down",
              origin = {
                  x = pos.x,
                  y = pos.y,
                  z = pos.z
              },
              job = {"police", "ambulance"}
          })
  
          CreateThread(function()
              tenThirteenBC = true
              Wait(30000)
              tenThirteenBC = false
          end)
  
          TriggerServerEvent('dispatch:emsalertB', pos)
      end
  end)
  
  RegisterNetEvent('dispatch:emsalertB', function(targetCoords) 
      if (PlayerJob.name == 'ambulance' or IsPoliceJob(PlayerJob.name)) and PlayerJob.onduty then	
          local alpha = 250
          local policedown2 = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)
  
          SetBlipSprite(policedown2,  126)
          SetBlipColour(policedown2,  3)
          SetBlipScale(policedown2, 1.3)
          SetBlipAsShortRange(policedown2,  1)
          BeginTextCommandSetBlipName("STRING")
          AddTextComponentString('10-13B Medic Down')
          EndTextCommandSetBlipName(policedown2)
          PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
  
          while alpha ~= 0 do
              Citizen.Wait(120 * 4)
              alpha = alpha - 1
              SetBlipAlpha(policedown2, alpha)
  
              if alpha == 0 then
                  RemoveBlip(policedown2)
                  return
              end
          end
      end
  end)
  
  RegisterNetEvent('dispatch:mz:lockdown', function(targetCoords) 
      if (PlayerJob.name == 'ambulance' or IsPoliceJob(PlayerJob.name)) and PlayerJob.onduty then	
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
              Citizen.Wait(200 * 4)
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
      if (PlayerJob.name == 'ambulance' or IsPoliceJob(PlayerJob.name)) and PlayerJob.onduty then	
          QBCore.Functions.Notify("Mount Zonah is no longer on lockdown", "success")
      end
  end)