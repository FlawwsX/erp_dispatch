local playAnim = false


-- Item checks to return whether or not the client has a phone or not
local function HasPhone()
    return QBCore.Functions.HasItem("phone")
end


-- Loads the animdict so we can execute it on the ped
local function loadAnimDict(dict)
    RequestAnimDict(dict)

    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
end


-- Does the actual animation of the animation when calling 911
local function PhoneCallAnim()
    loadAnimDict("cellphone@")
    local ped = PlayerPedId()
    CreateThread(function()
        playAnim = true
        while playAnim do
            if not IsEntityPlayingAnim(ped, "cellphone@", 'cellphone_text_to_call', 3) then
                TaskPlayAnim(ped, "cellphone@", 'cellphone_text_to_call', 3.0, 3.0, -1, 50, 0, false, false, false)
            end
            Wait(500)
        end
    end)
end

-- Regular 911 call that goes straight to the Police
RegisterCommand('911', function(source, args, rawCommand)
    local msg = rawCommand:sub(5)
    if string.len(msg) > 0 then
        if not exports['qb-policejob']:IsHandcuffed() then
            if HasPhone() then
                PhoneCallAnim()
                Wait(math.random(3,8) * 1000)
                playAnim = false
                local plyData = QBCore.Functions.GetPlayerData()
                local locationInfo = GetStreetAndZone()
                local gender = GetPedGender()
                local currentPos = GetEntityCoords(PlayerPedId())
                TriggerServerEvent('dispatch:svNotify', {
                    dispatchCode = "911",
                    firstStreet = locationInfo,
                    gender = gender,
                    priority = 1,
                    origin = { x = currentPos.x, y = currentPos.y, z = currentPos.z },
                    dispatchMessage = "911 Call",
                    name = plyData.charinfo.firstname:sub(1,1):upper()..plyData.charinfo.firstname:sub(2).. " ".. plyData.charinfo.lastname:sub(1,1):upper()..plyData.charinfo.lastname:sub(2),
                    number = plyData.charinfo.phone,
                    job = Config.PoliceAndAmbulance,
                    information = msg
                })
                Wait(1000)
                StopEntityAnim(PlayerPedId(), 'cellphone_text_to_call', "cellphone@", 3)
            else
                QBCore.Functions.Notify("You can't call without a Phone!", "error", 4500)
            end
        else
            QBCore.Functions.Notify("You can't call police while handcuffed!", "error", 4500)
        end
    else
        QBCore.Functions.Notify('Please put a reason after the 911', "success")
    end
end)

-- Anonymous 911 calls that goes straight to the Police
RegisterCommand('911a', function(source, args, rawCommand)
    local msg = rawCommand:sub(5)
    if string.len(msg) > 0 then
        if not exports['qb-policejob']:IsHandcuffed() then
            if HasPhone() then
                PhoneCallAnim()
                Wait(math.random(3,8) * 1000)
                playAnim = false
                local locationInfo = GetStreetAndZone()
                local currentPos = GetEntityCoords(PlayerPedId())
                TriggerServerEvent('dispatch:svNotify', {
                    dispatchCode = "911",
                    firstStreet = locationInfo,
                    gender = "unknown",
                    priority = 1,
                    origin = { x = currentPos.x, y = currentPos.y, z = currentPos.z },
                    dispatchMessage = "Anonymous 911 Call",
                    name = "Anonymous",
                    number = "Hidden Number",
                    job = Config.PoliceAndAmbulance,
                    information = msg
                })
                Wait(1000)
                StopEntityAnim(PlayerPedId(), 'cellphone_text_to_call', "cellphone@", 3)
            else
                QBCore.Functions.Notify("You can't call without a Phone!", "error", 4500)
            end
        else
            QBCore.Functions.Notify("You can't call police while handcuffed!", "error", 4500)
        end
    else
        QBCore.Functions.Notify('Please put a reason after the 911a', "success")
    end
end)

-- Regular 311 call that goes straight to the Ambulance
RegisterCommand('311', function(source, args, rawCommand)
    local msg = rawCommand:sub(5)
    if string.len(msg) > 0 then
        if not exports['qb-policejob']:IsHandcuffed() then
            if HasPhone() then
                PhoneCallAnim()
                Wait(math.random(3,8) * 1000)
                playAnim = false
                local plyData = QBCore.Functions.GetPlayerData()
                local locationInfo = GetStreetAndZone()
                local gender = GetPedGender()
                local currentPos = GetEntityCoords(PlayerPedId())
                TriggerServerEvent('dispatch:svNotify', {
                    dispatchCode = "311",
                    firstStreet = locationInfo,
                    gender = gender,
                    priority = 1,
                    origin = { x = currentPos.x, y = currentPos.y, z = currentPos.z },
                    dispatchMessage = "311 Call",
                    name = plyData.charinfo.firstname:sub(1,1):upper()..plyData.charinfo.firstname:sub(2).. " ".. plyData.charinfo.lastname:sub(1,1):upper()..plyData.charinfo.lastname:sub(2),
                    number = plyData.charinfo.phone,
                    job = Config.PoliceAndAmbulance,
                    information = msg
                })
                Wait(1000)
                StopEntityAnim(PlayerPedId(), 'cellphone_text_to_call', "cellphone@", 3)
            else
                QBCore.Functions.Notify("You can't call without a Phone!", "error", 4500)
            end
        else
            QBCore.Functions.Notify("You can't call police while handcuffed!", "error", 4500)
        end
    else
        QBCore.Functions.Notify('Please put a reason after the 311', "success")
    end
end)

-- Anonymous 311 calls that goes straight to the Ambulance
RegisterCommand('311a', function(source, args, rawCommand)
    local msg = rawCommand:sub(5)
    if string.len(msg) > 0 then
        if not exports['qb-policejob']:IsHandcuffed() then
            if HasPhone() then
                PhoneCallAnim()
                Wait(math.random(3,8) * 1000)
                playAnim = false
                local locationInfo = GetStreetAndZone()
                local currentPos = GetEntityCoords(PlayerPedId())
                TriggerServerEvent('dispatch:svNotify', {
                    dispatchCode = "311",
                    firstStreet = locationInfo,
                    gender = "unknown",
                    priority = 1,
                    origin = { x = currentPos.x, y = currentPos.y, z = currentPos.z },
                    dispatchMessage = "Anonymous 311 Call",
                    name = "Anonymous",
                    number = "Hidden Number",
                    job = Config.PoliceAndAmbulance,
                    information = msg
                })
                Wait(1000)
                StopEntityAnim(PlayerPedId(), 'cellphone_text_to_call', "cellphone@", 3)
            else
                QBCore.Functions.Notify("You can't call without a Phone!", "error", 4500)
            end
        else
            QBCore.Functions.Notify("You can't call police while handcuffed!", "error", 4500)
        end
    else
        QBCore.Functions.Notify('Please put a reason after the 311a', "success")
    end
end)

-----Test Commands Remove after the script is in 1.0----------
RegisterCommand("13A", function ()
    TriggerEvent("qb-dispatch:client:police13A")
end)

RegisterCommand("bankrobbery", function ()
    TriggerEvent("dispatch:fleeca:bankrobbery")
end)
