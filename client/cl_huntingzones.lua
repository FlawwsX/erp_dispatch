-- Caches all the HuntingZones so we have an array we can manipulates later
local HuntingZones = {}

-- Global varaible that returns either true or false depending if we are inside the Polyzones
inHuntingZone = false

-- Makes the polyzones and stores the variables inside our HuntingZones array and return true or false if we are inside
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

-- Removes the hunting zones within the arrays
function removeHuntingZones()
    for k, v in pairs(HuntingZones) do
        HuntingZones[k]:destroy()
    end
    HuntingZones = {}
end