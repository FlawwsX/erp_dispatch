RegisterCommand('911', function(source, args, rawCommand)
    local msg = rawCommand:sub(5)
    if string.len(msg) > 0 then
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
        local gender = GetPedGender()
        local currentPos = GetEntityCoords(PlayerPedId())
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

-----Test Commands Remove after the script is in 1.0----------
RegisterCommand("13A", function ()
    TriggerEvent("ems:tenThirteenB")
end)

RegisterCommand("bankrobbery", function ()
    TriggerEvent("dispatch:fleeca:bankrobbery")
end)
