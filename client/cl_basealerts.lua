function CarCrash()
    local locationInfo = GetStreetAndZone()
    local gender = GetPedGender()
    local currentPos = GetEntityCoords(PlayerPedId())
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
    local gender = GetPedGender()
    local currentPos = GetEntityCoords(PlayerPedId())
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