-- Brandishing Dispatch Alert!!

function ArmedPlayer() -- When aiming weapon.
    local locationInfo = GetStreetAndZone()
    local gender = GetPedGender()
    local currentPos = GetEntityCoords(PlayerPedId())
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

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Dispatch for Fights!

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
            return
        end)
    end
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
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Gunshot Alerts
function AlertGunShot(isHunting, sentWeapon) -- Check for automatic, change priority to 1
    if Config.KnownWeapons[sentWeapon] and not IsPedCurrentWeaponSilenced(PlayerPedId()) then
        local locationInfo = GetStreetAndZone()
        local gender = GetPedGender()
        local currentPos = GetEntityCoords(PlayerPedId())

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
                    Citizen.Wait(math.random(20, 30) * 4)
                    blipAlpha = blipAlpha - 1
                    SetBlipAlpha(gunshotBlip, blipAlpha)
    
                    if blipAlpha == 0 then
                        RemoveBlip(gunshotBlip)
                        return
                    end
                end
                return
            end)
        end 
    end 
end)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Drug Sale
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
            return
        end)
    end
end

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
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- house robbery

RegisterNetEvent('qb-dispatch:client:houserobbery')
AddEventHandler("qb-dispatch:client:houserobbery",function()
    AlertHouseRobbery()
end)

function AlertHouseRobbery()
    local locationInfo = GetStreetAndZone()
    local gender = GetPedGender()
    local currentPos = GetEntityCoords(PlayerPedId())
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
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


function AlertJewelRob()
    local locationInfo = GetStreetAndZone()
    local gender = GetPedGender()
    local currentPos = GetEntityCoords(PlayerPedId())
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
    local gender = GetPedGender()
    local currentPos = GetEntityCoords(PlayerPedId())
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
            return
        end)
    end
end


function AlertFleecaRobbery()
    local locationInfo = GetStreetAndZone()
    local gender = GetPedGender()
    local currentPos = GetEntityCoords(PlayerPedId())
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
  
  RegisterNetEvent('dispatch:fleeca:bankrobbery',function()
    AlertFleecaRobbery()
  end)
  
  RegisterNetEvent('dispatch:paleto:bankrobbery',function()
   AlertPaletoRobbery()
  end)
  

  RegisterNetEvent('dispatch:pacific:bankrobbery',function()
    AlertPacificRobbery()
  end)
  
  function AlertPacificRobbery()
      local locationInfo = GetStreetAndZone()
      local gender = GetPedGender()
      local currentPos = GetEntityCoords(PlayerPedId())
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
      local gender = GetPedGender()
      local currentPos = GetEntityCoords(PlayerPedId())
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
  

  
  ---- Bank Truck ----

  
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
