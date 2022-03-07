# NOT YET WORKING 

## Do not use this branch, this is highly WIP and might be broken
#
## This is a develop branch and still a lot of work needs to be done on this branch! Do not pull it and hope I will support it!

# Current Progress
- Gunshots, gun shots from car, fighting working
- Seperate information for shots fired and shots fired from vehicle
- 911/311 working
- Cleaned up all the erp notify and exports
- All the robberies should be working too (need to trigger them and then provide screenshots)
- added a config for all the police jobs so easier to maintain

# Remaining
- exports/event handlers for mdt need to be worked on (unsure what data is returned through mdt to edit it)
- create config for ambulance


# Helpful info

```lua
TriggerEvent("civilian:alertPolice",distance,type,object,IsGunshot,inHuntingZone,currentWeapon)
```

- distance = distance of the alert blip circle zone
- type - type of alerts (possible types are "gunshot", "personRobbed", 'drugsale', "druguse", "carcrash", "death", "Suspicious", "fight", "gunshot", "gunshotvehicle", "lockpick", "robberyhouse")
- object - object that needs to be passed (can be a nearby ped, nearby vehicle. For eg. if you send lockpick type, you can pass nearby vehicle so that it will tell which vehicle is being lockpicked)
- IsGunshot - self explanatory 
- inHuntingZone - self explanatory (mostly will be false unless you have hunting in your server)
- currentWeapon - Send peds current weapon (just send `GetSelectedPedWeapon(PlayerPedId())`)

Will be adding examples for other robberies here as I verify its working.


# How To Add new Alerts

1. Create a client event that you will have to trigger

```lua
RegisterNetEvent('qb-dispatch:client:testalert',function()
    local locationInfo = GetStreetAndZone() -- return street name and zone
    local gender = GetPedGender() -- returns the gender
    local currentPos = GetEntityCoords(PlayerPedId())
    local isInVehicle = IsPedInAnyVehicle(PlayerPedId())
    local vehicleData = GetVehicleDescription() or {} -- returns vehicle related information if vehicle is involved
    local initialTenCode = "10-44" -- code to display on the dispatch message
    
    --[[
        A server event needs to be triggered which will trigger on all the police clients the alert and send the coordinates along with it.
    ]]--
    TriggerServerEvent('dispatch:server:testalert', currentPos) 
    TriggerServerEvent('dispatch:svNotify', { -- this will take care of the actual dispatch popup
        dispatchCode = initialTenCode,
        firstStreet = locationInfo,
        gender = gender,
        model = vehicleData.model,
        plate = vehicleData.plate,
        priority = 2, -- priority can be 1 or any other number (1 being extremely important which will show in red)
        firstColor = vehicleData.firstColor,
        secondColor = vehicleData.secondColor,
        heading = vehicleData.heading,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = "Brandishing", -- dispatch message that will show
        job = Config.PoliceJob -- job to whom you want to send alerts
    })
end)
```

2. Create a server event

```lua
--[[
    To send the coordinates to all the players to generate blips(this might change in future where the job check will be done on server side and then the client event will be triggered on only the clients that are supposed to get the alerts)
]]--
RegisterNetEvent('dispatch:server:testalert', function(sentCoords)
    TriggerClientEvent('dispatch:client:testalert', -1, sentCoords)
end)
```

3. Create a client event to get the dispatch messages

```lua
RegisterNetEvent('dispatch:client:testalert', function(targetCoords)
      
    if IsPoliceJob(PlayerJob.name) and PlayerJob.onduty then	-- do the job check before setting the blips
        local alpha = 250 --increase this value for longer blips
        local testblip = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

        SetBlipSprite(testblip,  477) -- set the blip sprite
        SetBlipColour(testblip,  47)
        SetBlipScale(testblip, 1.5)
        SetBlipAsShortRange(Blip,  1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('10-?? Test Alert')
        EndTextCommandSetBlipName(testblip)
        -- waits for 480 * alpha for the blip to disappear, if you want longer blips, increase alpha value
        while alpha ~= 0 do
            Citizen.Wait(120 * 4) 
            alpha = alpha - 1
            SetBlipAlpha(testblip, alpha)

            if alpha == 0 then
                RemoveBlip(testblip)
                return
            end
        end
    end
end)

```