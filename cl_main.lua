-- Globals
QBCore = exports["qb-core"]:GetCoreObject()
PlayerData = {}
PlayerJob = {}

local callID = 0
local currentCallSign = ""
local playerPed, playerCoords = PlayerPedId(), vec3(0, 0, 0)
local currentVehicle, inVehicle, currentlyArmed, currentWeapon = nil, false, false, `WEAPON_UNARMED`

-- Hunting Stuff
local HuntingZones = {}
local inHuntingZone = false

function generateHuntingZones()
    for zone, data in pairs(Config.HuntingZones) do 
        local z = PolyZone:Create(data.area, {
            name = data.name,
            minZ = data.minZ,
            maxZ = data.maxZ,
            debugGrid = data.debugGrid or false,
            gridDivisions = data.gridDivisions or 25,
        })
        z:onPlayerInOut(function(isPointInside, point)
            inHuntingZone = isPointInside
        end)
        HuntingZones[zone] = z
    end
end

function removeHuntingZones()
    for zone, data in pairs(HuntingZones) do 
        HuntingZones[zone]:destroy()
    end
    HuntingZones = {}
end

-- for testing when restarting script
CreateThread(function()
    while QBCore == nil do
        Wait(200)
    end
    PlayerData = QBCore.Functions.GetPlayerData()
    PlayerJob  = QBCore.Functions.GetPlayerData().job
end)

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

function IsPoliceJob(job)
    for k, v in pairs(Config.PoliceJob) do
        if job == v then
            return true
        end
    end
    return false
end


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

function GetPedGender()
    local gender = "Male"
    if QBCore.Functions.GetPlayerData().charinfo.gender == 1 then gender = "Female" end
    return gender
end

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

function getCardinalDirectionFromHeading()
    local heading = GetEntityHeading(playerPed)
    if heading >= 315 or heading < 45 then return "North Bound"
    elseif heading >= 45 and heading < 135 then return "West Bound"
    elseif heading >=135 and heading < 225 then return "South Bound"
    elseif heading >= 225 and heading < 315 then return "East Bound" end
end

function GetStreetAndZone()
    local coords = GetEntityCoords(playerPed)
    local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
    local area = GetLabelText(tostring(GetNameOfZone(coords.x, coords.y, coords.z)))
    local playerStreetsLocation = area
    if not zone then zone = "UNKNOWN" end
    if currentStreetName ~= nil and currentStreetName ~= "" then playerStreetsLocation = currentStreetName .. ", " ..area
    else playerStreetsLocation = area end
    return playerStreetsLocation
end

function GetClosestNPC(sentPos, sentDistance, sentType, sentIgnoredPed)
    if sentType == 'combat' then
        local allPeds = GetGamePool('CPed')
        for i=1, #allPeds do
            local ped = allPeds[i]
            if DoesEntityExist(ped) then
                if ped ~= sentIgnoredPed then
                    local dist = #(GetEntityCoords(ped) - sentPos)
                    if dist < sentDistance then
                        return ped
                    end
                end 
            end
        end
    elseif sentType == 'gunshot' then
        local allPeds = GetGamePool('CPed')
        for i=1, #allPeds do
            local ped = allPeds[i]
            if DoesEntityExist(ped) then
                local dist = #(GetEntityCoords(ped) - sentPos)
                if dist < sentDistance then
                    if (GetPedAlertness(ped) > 0) and not IsPedAimingFromCover(ped) and not IsPedBeingStunned(ped, 0) and not IsPedDeadOrDying(ped, 1) and IsPedHuman(ped) and not IsPedInAnyPlane(ped) and not IsPedInAnyHeli(ped) and not IsPedShooting(ped) and not IsPedAPlayer(ped) then
                        TaskUseMobilePhoneTimed(ped, 5000)
                        return ped
                    end
                end
            end
        end
    elseif sentType == 'armed' then
        local allPeds = GetGamePool('CPed')
        for i=1, #allPeds do
            local ped = allPeds[i]
            if DoesEntityExist(ped) and not IsPedAPlayer(ped) then
                local dist = #(GetEntityCoords(ped) - sentPos)
                if dist < 50.0 and math.random(10) > 4 then
                    if not IsPedAimingFromCover(ped) and not IsPedBeingStunned(ped, 0) and not IsPedDeadOrDying(ped, 1) and IsPedHuman(ped) and not IsPedInAnyPlane(ped) and not IsPedInAnyHeli(ped) and not IsPedShooting(ped) then
                        TaskUseMobilePhoneTimed(ped, 5000)
                        return ped
                    end
                end
            end
        end
    else
        local allPeds = GetGamePool('CPed')
        for i=1, #allPeds do
            local ped = allPeds[i]
            if DoesEntityExist(ped) and not IsPedAPlayer(ped) then
                local dist = #(GetEntityCoords(ped) - sentPos)
                if dist < sentDistance then
                    return ped
                end
            end
        end
    end
end

function GetPedInFront()	
	local plyPed = playerPed
	local plyPos = GetEntityCoords(plyPed, false)
	local plyOffset = GetOffsetFromEntityInWorldCoords(plyPed, 0.0, 1.3, 0.0)
	local rayHandle = StartShapeTestCapsule(plyPos.x, plyPos.y, plyPos.z, plyOffset.x, plyOffset.y, plyOffset.z, 1.0, 12, plyPed, 7)
	local _, _, _, _, ped = GetShapeTestResult(rayHandle)
	return ped
end

function GetVehicleDescription(sentVehicle)
    if not sentVehicle or sentVehicle == nil then
        local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if not DoesEntityExist(currentVehicle) then
            return
        end
    elseif sentVehicle then
        currentVehicle = sentVehicle
    end
  
    plate = GetVehicleNumberPlateText(currentVehicle)
    make = GetDisplayNameFromVehicleModel(GetEntityModel(currentVehicle))
    color1, color2 = GetVehicleColours(currentVehicle)
  
    if color1 == 0 then color1 = 1 end
    if color2 == 0 then color2 = 2 end
    if color1 == -1 then color1 = 158 end
    if color2 == -1 then color2 = 158 end 
  
    if math.random(1, 2) == math.random(1, 2) then
      plate = "Unknown"
    end
  
    local dir = getCardinalDirectionFromHeading()
  
    local vehicleData  = {
      model = make,
      plate = plate,
      firstColor = Config.VehicleColors[color1],
      secondColor = Config.VehicleColors[color2],
      heading = dir
    }
    return vehicleData
end

function canPedBeUsed(ped,isGunshot,isSpeeder)

    if math.random(100) > 15 then
      return false
    end

    if ped == nil then
        return false
    end

    if isSpeeder == nil then
        isSpeeder = false
    end

    if ped == PlayerPedId() then
        return false
    end

    if GetEntityHealth(ped) == 0 then
      return false
    end

    if isSpeeder then
      if not IsPedInAnyVehicle(ped, false) then
          return false
      end
    end

    if `mp_f_deadhooker` == GetEntityModel(ped) then
      return false
    end

    local curcoords = GetEntityCoords(PlayerPedId())
    local startcoords = GetEntityCoords(ped)

    if #(curcoords - startcoords) < 10.0 then
      return false
    end    

    -- here we add areas that peds can not alert the police
    if #(curcoords - vector3( 1088.76, -3187.51, -38.99)) < 15.0 then
      return false
    end  

    if not HasEntityClearLosToEntity(PlayerPedId(), ped, 17) and not isGunshot then
      return false
    end

    if not DoesEntityExist(ped) then
        return false
    end

    if IsPedAPlayer(ped) then
        return false
    end

    if IsPedFatallyInjured(ped) then
        return false
    end
    
    if IsPedArmed(ped, 7) then
        return false
    end

    if IsPedInMeleeCombat(ped) then
        return false
    end

    if IsPedShooting(ped) then
        return false
    end

    if IsPedDucking(ped) then
        return false
    end

    if IsPedBeingJacked(ped) then
        return false
    end

    if IsPedSwimming(ped) then
        return false
    end

    if IsPedJumpingOutOfVehicle(ped) or IsPedBeingJacked(ped) then
        return false
    end

    local pedType = GetPedType(ped)
    if pedType == 6 or pedType == 27 or pedType == 29 or pedType == 28 then
        return false
    end
    return true
end

-- GUNSHOTS

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

-- FIGHT IN PROGRESS

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

function ResetMathRandom()
    math.randomseed(GetCloudTimeAsInt())
end

function randomizeBlipLocation(pOrigin)
    local x = pOrigin.x
    local y = pOrigin.y
    local z = pOrigin.z
    ResetMathRandom()
    local luck = math.random(1, 2)
    ResetMathRandom()
    y = math.random(25) + y
    ResetMathRandom()
    if luck == math.random(1, 2) then
        ResetMathRandom()
        x = math.random(25) + x
    end
    return vec3(x, y, z)
end

RegisterNetEvent('alert:noPedCheck', function(alertType)
    if alertType == "banktruck" then
        AlertBankTruck()
    elseif alertType == "yacht" then
        AlertYacht()
    elseif alertType == "art" then
        AlertArt()
    end
end)

RegisterNetEvent('civilian:alertPolice', function(basedistance,alertType,objPassed,isGunshot,isHunting,sentWeapon)
    if PlayerJob == nil then return end

    local isPolice = IsPoliceJob(PlayerJob.name)
    local object = objPassed

    if not daytime then
      basedistance = basedistance * 8.2
    else
      basedistance = basedistance * 3.45
    end

    if alertType == "personRobbed" --[[and not isPolice]] then
      AlertpersonRobbed()
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
    elseif alertType == "druguse" and not underground and not pd then
        if dst > 12.0 and dst < 18.0 then
            DrugUse()
        end
    elseif alertType == "carcrash" then
        CarCrash()
    elseif alertType == "death" then
        AlertDeath()
        local roadtest2 = IsPointOnRoad(GetEntityCoords(PlayerPedId()), PlayerPedId())
        if roadtest2 then return end
        BringNpcs()
    elseif alertType == "Suspicious" then
        AlertSuspicious()
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
    elseif alertType == "robberyhouse" then
        AlertCheckRobbery2()
    end
end)

function BringNpcs()
    for i = 1, #curWatchingPeds do
      if DoesEntityExist(curWatchingPeds[i]) then
        ClearPedTasks(curWatchingPeds[i])
        SetEntityAsNoLongerNeeded(curWatchingPeds[i])
      end
    end
    curWatchingPeds = {}
    local basedistance = 35.0
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom
    repeat

        local pos = GetEntityCoords(ped)
        local distance = #(playerCoords - pos)
        if canPedBeUsed(ped,false) and distance < basedistance and distance > 3.0 then

          if math.random(75) > 45 and #curWatchingPeds < 5 then

            TriggerEvent("TriggerAIRunning",ped)
            curWatchingPeds[#curWatchingPeds] = ped

          end

        end

        success, ped = FindNextPed(handle)

    until not success

    EndFindPed(handle)
end

  
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

