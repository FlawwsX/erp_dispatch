Config = {}

Config.PoliceJob = { "police", "bcso"}

Config.PoliceAndAmbulance = { "police", "ambulance", "bcso"}

Config.WhitelistedWeapons = {
    [`WEAPON_STUNGUN`] = true,
    [`WEAPON_SNOWBALL`] = true,
}

Config.KnownWeapons = {
    --[[ Pistols ]]--
    [`weapon_pistol`] = {['weaponName'] = 'Pistol', ['isAuto'] = false},
    [`weapon_pistol_mk2`] = {['weaponName'] = 'Pistol Mk II', ['isAuto'] = false},
    [`weapon_combatpistol`] = {['weaponName'] = 'Combat Pistol', ['isAuto'] = false},
    [`weapon_appistol`] = {['weaponName'] = 'AP Pistol', ['isAuto'] = false},
    [`weapon_stungun`] = {['weaponName'] = 'Stun Gun (?)', ['isAuto'] = false},
    [`weapon_pistol50`] = {['weaponName'] = 'Pistol .50', ['isAuto'] = false},
    [`weapon_snspistol`] = {['weaponName'] = 'SNS Pistol', ['isAuto'] = false},
    [`weapon_snspistol_mk2`] = {['weaponName'] = 'SNS Pistol Mk II', ['isAuto'] = false},
    [`weapon_heavypistol`] = {['weaponName'] = 'Heavy Pistol', ['isAuto'] = false},
    [`weapon_vintagepistol`] = {['weaponName'] = 'Vintage Pistol', ['isAuto'] = false},
    [`weapon_flaregun`] = {['weaponName'] = 'Flare Gun', ['isAuto'] = false},
    [`weapon_marksmanpistol`] = {['weaponName'] = 'Marksman Pistol', ['isAuto'] = false},
    [`weapon_revolver`] = {['weaponName'] = 'Heavy Revolver', ['isAuto'] = false},
    [`weapon_revolver_mk2`] = {['weaponName'] = 'Heavy Revolver Mk II', ['isAuto'] = false},
    [`weapon_doubleaction`] = {['weaponName'] = 'Double Action Revolver', ['isAuto'] = false},
    [`weapon_raypistol`] = {['weaponName'] = 'Up-n-Atomizer', ['isAuto'] = false},
    [`weapon_ceramicpistol`] = {['weaponName'] = 'Ceramic Pistol', ['isAuto'] = false},
    [`weapon_navyrevolver`] = {['weaponName'] = 'Navy Revolver', ['isAuto'] = false},
    --[[ Submachine Guns ]]--
    [`weapon_microsmg`] = {['weaponName'] = 'Micro SMG', ['isAuto'] = true},
    [`weapon_smg`] = {['weaponName'] = 'SMG', ['isAuto'] = true},
    [`weapon_smg_mk2`] = {['weaponName'] = 'SMG Mk II', ['isAuto'] = true},
    [`weapon_assaultsmg`] = {['weaponName'] = 'Assault SMG', ['isAuto'] = true},
    [`weapon_combatpdw`] = {['weaponName'] = 'Combat PDW', ['isAuto'] = true},
    [`weapon_machinepistol`] = {['weaponName'] = 'Machine Pistol', ['isAuto'] = true},
    [`weapon_minismg`] = {['weaponName'] = 'Mini SMG', ['isAuto'] = true},
    [`weapon_raycarbine`] = {['weaponName'] = 'Unholy Hellbringer', ['isAuto'] = true},
    --[[ Shotguns ]]--
    [`weapon_pumpshotgun`] = {['weaponName'] = 'Pump Shotgun', ['isAuto'] = false},
    [`weapon_pumpshotgun_mk2`] = {['weaponName'] = 'Pump Shotgun Mk II', ['isAuto'] = false},
    [`weapon_sawnoffshotgun`] = {['weaponName'] = 'Sawed-Off Shotgun', ['isAuto'] = false},
    [`weapon_assaultshotgun`] = {['weaponName'] = 'Assault Shotgun', ['isAuto'] = true},
    [`weapon_bullpupshotgun`] = {['weaponName'] = 'Bullpup Shotgun', ['isAuto'] = true},
    [`weapon_musket`] = {['weaponName'] = 'Musket', ['isAuto'] = false},
    [`weapon_heavyshotgun`] = {['weaponName'] = 'Heavy Shotgun', ['isAuto'] = true},
    [`weapon_dbshotgun`] = {['weaponName'] = 'Double Barrel Shotgun', ['isAuto'] = false},
    [`weapon_autoshotgun`] = {['weaponName'] = 'Sweeper Shotgun', ['isAuto'] = true},
    --[[ Assault Rifle ]]--
    [`weapon_assaultrifle`] = {['weaponName'] = 'Assault Rifle', ['isAuto'] = true},
    [`weapon_assaultrifle_mk2`] = {['weaponName'] = 'Assault Rifle Mk II', ['isAuto'] = true},
    [`weapon_carbinerifle`] = {['weaponName'] = 'Carbine Rifle', ['isAuto'] = true},
    [`weapon_carbinerifle_mk2`] = {['weaponName'] = 'Carbine Rifle Mk II', ['isAuto'] =true},
    [`weapon_advancedrifle`] = {['weaponName'] = 'Advanced Rifle', ['isAuto'] =true},
    [`weapon_specialcarbine`] = {['weaponName'] = 'Special Carbine', ['isAuto'] =true},
    [`weapon_specialcarbine_mk2`] = {['weaponName'] = 'Special Carbine Mk II', ['isAuto'] =true},
    [`weapon_bullpuprifle`] = {['weaponName'] = 'Bullpup Rifle', ['isAuto'] =true},
    [`weapon_bullpuprifle_mk2`] = {['weaponName'] = 'Bullpup Rifle Mk II', ['isAuto'] =true},
    [`weapon_compactrifle`] = {['weaponName'] = 'Compact Rifle', ['isAuto'] =true},
    --[[ LMG ]]--
    [`weapon_mg`] = {['weaponName'] = 'MG', ['isAuto'] =true},
    [`weapon_combatmg`] = {['weaponName'] = 'Combat MG', ['isAuto'] =true},
    [`weapon_combatmg_mk2`] = {['weaponName'] = 'Combat MG Mk II', ['isAuto'] =true},
    [`weapon_gusenberg`] = {['weaponName'] = 'Gusenberg Sweeper', ['isAuto'] =true},
    --[[ Snooper Rifle ]]--
    [`weapon_sniperrifle`] = {['weaponName'] = 'Sniper Rifle', ['isAuto'] =false},
    [`weapon_heavysniper`] = {['weaponName'] = 'Heavy Rifle', ['isAuto'] =false},
    [`weapon_heavysniper_mk2`] = {['weaponName'] = 'Heavy Sniper Mk II', ['isAuto'] =false},
    [`weapon_marksmanrifle`] = {['weaponName'] = 'Marksman Rifle', ['isAuto'] =true},
    [`weapon_marksmanrifle_mk2`] = {['weaponName'] = 'Marksman Rifle Mk II', ['isAuto'] =true},

}

Config.NulledAreas = { 
    [1] = vector3(102.09, -1938.74, 20.79),
    [2] = vector3(-221.78, -1667.06, 34.45),
    [3] = vector3(-23.24, -1462.26, 30.8),
    [4] = vector3(-9.77, -1842.7, 26.15),
    [5] = vector3(16.54, -1548.8, 30.75),
    [6] = vector3(-120.32, -1522.75, 34.89),
}

Config.HuntingZones = {
    {
        name="huntingZone",
        minZ=-50.0,
        maxZ=750.0,
        debugGrid=false,
        gridDivisions=25,
        area = {
            vector2(-1416.86, 2730.74),
            vector2(-2415.01, 3701.34),
            vector2(-973.52, 6225.8),
            vector2(356.86, 4802.33),
            vector2(-292.75, 3766.8),
            vector2(62.85, 3368.78),
        },
    },
}

Config.TasksIdle = {
    [1] = "CODE_HUMAN_MEDIC_KNEEL",
    [2] = "WORLD_HUMAN_STAND_MOBILE",
}

Config.VehicleColors = {
        --[0] = "Metallic Black",
        [1] = "Metallic Graphite Black",
        [2] = "Metallic Black Steel",
        [3] = "Metallic Dark Silver",
        [4] = "Metallic Silver",
        [5] = "Metallic Blue Silver",
        [6] = "Metallic Steel Gray",
        [7] = "Metallic Shadow Silver",
        [8] = "Metallic Stone Silver",
        [9] = "Metallic Midnight Silver",
        [10] = "Metallic Gun Metal",
        [11] = "Metallic Anthracite Grey",
        [12] = "Matte Black",
        [13] = "Matte Gray",
        [14] = "Matte Light Grey",
        [15] = "Util Black",
        [16] = "Util Black Poly",
        [17] = "Util Dark Silver",
        [18] = "Util Silver",
        [19] = "Util Gun Metal",
        [20] = "Util Shadow Silver",
        [21] = "Worn Black",
        [22] = "Worn Graphite",
        [23] = "Worn Silver Grey",
        [24] = "Worn Silver",
        [25] = "Worn Blue Silver",
        [26] = "Worn Shadow Silver",
        [27] = "Metallic Red",
        [28] = "Metallic Torino Red",
        [29] = "Metallic Formula Red",
        [30] = "Metallic Blaze Red",
        [31] = "Metallic Graceful Red",
        [32] = "Metallic Garnet Red",
        [33] = "Metallic Desert Red",
        [34] = "Metallic Cabernet Red",
        [35] = "Metallic Candy Red",
        [36] = "Metallic Sunrise Orange",
        [37] = "Metallic Classic Gold",
        [38] = "Metallic Orange",
        [39] = "Matte Red",
        [40] = "Matte Dark Red",
        [41] = "Matte Orange",
        [42] = "Matte Yellow",
        [43] = "Util Red",
        [44] = "Util Bright Red",
        [45] = "Util Garnet Red",
        [46] = "Worn Red",
        [47] = "Worn Golden Red",
        [48] = "Worn Dark Red",
        [49] = "Metallic Dark Green",
        [50] = "Metallic Racing Green",
        [51] = "Metallic Sea Green",
        [52] = "Metallic Olive Green",
        [53] = "Metallic Green",
        [54] = "Metallic Gasoline Blue Green",
        [55] = "Matte Lime Green",
        [56] = "Util Dark Green",
        [57] = "Util Green",
        [58] = "Worn Dark Green",
        [59] = "Worn Green",
        [60] = "Worn Sea Wash",
        [61] = "Metallic Midnight Blue",
        [62] = "Metallic Dark Blue",
        [63] = "Metallic Saxony Blue",
        [64] = "Metallic Blue",
        [65] = "Metallic Mariner Blue",
        [66] = "Metallic Harbor Blue",
        [67] = "Metallic Diamond Blue",
        [68] = "Metallic Surf Blue",
        [69] = "Metallic Nautical Blue",
        [70] = "Metallic Bright Blue",
        [71] = "Metallic Purple Blue",
        [72] = "Metallic Spinnaker Blue",
        [73] = "Metallic Ultra Blue",
        [74] = "Metallic Bright Blue",
        [75] = "Util Dark Blue",
        [76] = "Util Midnight Blue",
        [77] = "Util Blue",
        [78] = "Util Sea Foam Blue",
        [79] = "Uil Lightning blue",
        [80] = "Util Maui Blue Poly",
        [81] = "Util Bright Blue",
        [82] = "Matte Dark Blue",
        [83] = "Matte Blue",
        [84] = "Matte Midnight Blue",
        [85] = "Worn Dark blue",
        [86] = "Worn Blue",
        [87] = "Worn Light blue",
        [88] = "Metallic Taxi Yellow",
        [89] = "Metallic Race Yellow",
        [90] = "Metallic Bronze",
        [91] = "Metallic Yellow Bird",
        [92] = "Metallic Lime",
        [93] = "Metallic Champagne",
        [94] = "Metallic Pueblo Beige",
        [95] = "Metallic Dark Ivory",
        [96] = "Metallic Choco Brown",
        [97] = "Metallic Golden Brown",
        [98] = "Metallic Light Brown",
        [99] = "Metallic Straw Beige",
        [100] = "Metallic Moss Brown",
        [101] = "Metallic Biston Brown",
        [102] = "Metallic Beechwood",
        [103] = "Metallic Dark Beechwood",
        [104] = "Metallic Choco Orange",
        [105] = "Metallic Beach Sand",
        [106] = "Metallic Sun Bleeched Sand",
        [107] = "Metallic Cream",
        [108] = "Util Brown",
        [109] = "Util Medium Brown",
        [110] = "Util Light Brown",
        [111] = "Metallic White",
        [112] = "Metallic Frost White",
        [113] = "Worn Honey Beige",
        [114] = "Worn Brown",
        [115] = "Worn Dark Brown",
        [116] = "Worn straw beige",
        [117] = "Brushed Steel",
        [118] = "Brushed Black steel",
        [119] = "Brushed Aluminium",
        [120] = "Chrome",
        [121] = "Worn Off White",
        [122] = "Util Off White",
        [123] = "Worn Orange",
        [124] = "Worn Light Orange",
        [125] = "Metallic Securicor Green",
        [126] = "Worn Taxi Yellow",
        [127] = "police car blue",
        [128] = "Matte Green",
        [129] = "Matte Brown",
        [130] = "Worn Orange",
        [131] = "Matte White",
        [132] = "Worn White",
        [133] = "Worn Olive Army Green",
        [134] = "Pure White",
        [135] = "Hot Pink",
        [136] = "Salmon pink",
        [137] = "Metallic Vermillion Pink",
        [138] = "Orange",
        [139] = "Green",
        [140] = "Blue",
        [141] = "Mettalic Black Blue",
        [142] = "Metallic Black Purple",
        [143] = "Metallic Black Red",
        [144] = "Hunter Green",
        [145] = "Metallic Purple",
        [146] = "Metallic V Dark Blue",
        [147] = "MODSHOP BLACK1",
        [148] = "Matte Purple",
        [149] = "Matte Dark Purple",
        [150] = "Metallic Lava Red",
        [151] = "Matte Forest Green",
        [152] = "Matte Olive Drab",
        [153] = "Matte Desert Brown",
        [154] = "Matte Desert Tan",
        [155] = "Matte Foilage Green",
        [156] = "DEFAULT ALLOY COLOR",
        [157] = "Epsilon Blue",
        [158] = "Unknown",
}