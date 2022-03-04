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