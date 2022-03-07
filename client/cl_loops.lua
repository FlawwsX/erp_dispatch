-- loop to update playerped, coords, if in vehicle, etc.
CreateThread(function()
	while true do
		playerPed = PlayerPedId()
        playerCoords = GetEntityCoords(playerPed)
        currentVehicle = GetVehiclePedIsIn(playerPed, false)
        currentWeapon = GetSelectedPedWeapon(playerPed)
        currentlyArmed = IsPedArmed(playerPed, 7) and not Config.WhitelistedWeapons[currentWeapon]
        if currentVehicle ~= 0 then inVehicle = true elseif inVehicle then inVehicle = false end
		Wait(1000)
	end
end)

-- gunshots
CreateThread(function() -- Gun Shots
    local isBusyGunShots, armed, cooldownGS, cooldownSMD = false, false, 0, 0
    while true do
        Wait(0)
        if not isBusyGunShots then
            armed = currentlyArmed
            if armed and Config.KnownWeapons[currentWeapon] then
                if IsPedShooting(playerPed) and ((cooldownGS == 0) or cooldownGS - GetGameTimer() < 0) then
                    isBusyGunShots = true
                    if IsPedCurrentWeaponSilenced(playerPed) then
                        cooldownGS = GetGameTimer() + math.random(25000,30000) -- 20 => 25 Seconds.
                        TriggerEvent("civilian:alertPolice",15.0,"gunshot",0,true,inHuntingZone,currentWeapon)
                    elseif inVehicle then
                        cooldownGS = GetGameTimer() + math.random(20000,25000) -- 20 => 25 Seconds.
                        TriggerEvent("civilian:alertPolice",150.0,"gunshotvehicle",0,true,inHuntingZone,currentWeapon)
                    else
                        cooldownGS = GetGameTimer() + math.random(15000,20000) -- 15 => 20 Seconds.
                        TriggerEvent("civilian:alertPolice",550.0,"gunshot",0,true,inHuntingZone,currentWeapon)
                    end
                    isBusyGunShots = false
                elseif (cooldownSMD == 0 and math.random(10) > 7) or ((cooldownSMD - GetGameTimer() < 0) and math.random(10) > 7) then
                    local shouldAlert = true
                    local myPos = GetEntityCoords(playerPed)
                    for i=1, #Config.NulledAreas do
                        local dist = #(Config.NulledAreas[i] - myPos)
                        if dist <= math.random(75, 100) then
                            shouldAlert = false
                            break 
                        end
                    end
                    if not inVehicle and not shouldAlert then
                        if math.random(10) > 5 then
                            cooldownSMD = GetGameTimer() + math.random(45000,60000) -- 20 => 25 Seconds.
                        elseif not IsPoliceJob(PlayerJob.name) then
                            local closestNPC = GetClosestNPC(playerCoords, 25.0, 'armed')
                            if closestNPC and DoesEntityExist(closestNPC) then
                                cooldownSMD = GetGameTimer() + math.random(60000,90000) -- 20 => 25 Seconds.
                                ArmedPlayer()
                            end
                        end
                    end
                end
            else
                Wait(1000)
            end 
        else
            Wait(250)
        end
    end
end)

-- fights
CreateThread(function() -- Fighting
    local isBusy, cooldown = false, 0
    while true do 
        Wait(0)
        if not inVehicle and not isBusy and (cooldown - GetGameTimer() < 0) then
            local pedinfront = GetPedInFront()
            if pedinfront > 0 then
                if IsPedInMeleeCombat(playerPed) and IsPedInCombat(pedinfront, playerPed) and GetClosestNPC(playerCoords, 25.0, 'combat', pedinfront) then
                    TriggerEvent("civilian:alertPolice", 15.0, "fight", 0)
                    cooldown = GetGameTimer() + math.random(20000,25000) -- 20 => 25 Seconds
                else
                    Wait(1000)
                end
            else
                Wait(1000)
            end
        else 
            Wait(1000)
        end 
    end 
end)