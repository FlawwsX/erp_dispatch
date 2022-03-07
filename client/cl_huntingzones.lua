local HuntingZones = {}
inHuntingZone = false

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
    for k, v in pairs(HuntingZones) do
        HuntingZones[k]:destroy()
    end
    HuntingZones = {}
end