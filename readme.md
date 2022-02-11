# NOT YET WORKING 


## This is a develop branch and still a lot of work needs to be done on this branch! Do not pull it and hope I will support it!

# Current Progress
- Gunshots, gun shots from car, fighting working
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
- inHuntingZone - self explanatory
- currentWeapon - Send peds current weapon (just send `GetSelectedPedWeapon(PlayerPedId)`)