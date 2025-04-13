---@class HRLibConfig
---@field defaultWebHook string
---@field defaultNotificationsPosition string
---@field defaultProgressBarPosition string
---@field alertDialogueTranslation { agreeButton: string, cancelButton: string }
---@field inputDialogueTranslation { confirmButton: string, cancelButton: string }

---@class HRLibClientFPlayer
---@field Teleport fun(self: HRLibClientFPlayer, coords: vector3)
---@field SpawnVehicle fun(self: HRLibClientFPlayer, vehModel: string|integer, spawnPedInside: boolean?, saveVehicle: boolean?): integer?
---@field Freeze fun(self: HRLibClientFPlayer, toggle: boolean)
---@field SetHealth fun(self: HRLibClientFPlayer, health: integer?)
---@field SetInvincibility fun(self: HRLibClientFPlayer, toggle: boolean?)

---@class HRLibServerFPlayer
---@field Teleport fun(self: HRLibServerFPlayer, coords: vector3)
---@field SpawnVehicle fun(self: HRLibServerFPlayer, vehModel: string|integer, spawnPlayerInside: boolean?, saveVehicle: boolean?): integer?
---@field Notify fun(self: HRLibServerFPlayer, description: string?, type: 'success'|'info'|'error'|'warning'?, duration: number?, pos: 'top-right'|'center-right'|'bottom-right'|'frombelow-right'|'top-left'|'left-center'|'frombelow-left'?, sound: boolean?)
---@field FocusedEvent fun(self: HRLibServerFPlayer, eventName: string, ...: any)
---@field SetHealth fun(self: HRLibServerFPlayer, health: integer?)
---@field SetInvincibility fun(self: HRLibServerFPlayer, toggle: boolean?)

---@class HRLibClientIPlayer
---@field source integer
---@field id integer
---@field Id integer
---@field ID integer
---@field playerId integer
---@field player integer
---@field serverId integer
---@field plId integer
---@field serverPlId integer
---@field sPlId integer
---@field state table?
---@field max { stamina: number, armour: integer, health: integer }
---@field coords vector3
---@field coordinates vector3
---@field heading number
---@field name string
---@field ped integer
---@field entity { archetypeName: string, model: integer, mapdataOwner: { [1]: boolean, [2]: integer, [3]: integer }, populationType: number, type: integer }

---@class HRLibServerIPlayer
---@field source integer
---@field id integer
---@field Id integer
---@field ID integer
---@field playerId integer
---@field player integer
---@field serverId integer
---@field plId integer
---@field serverPlId integer
---@field sPlId integer
---@field state table?
---@field name string
---@field identifier { license: string, license2: string, steam: string, discord: string, xbl: string, live: string, ip: string, fivem: string }
---@field identifiersNum integer
---@field ping integer
---@field max { health: integer, armour: integer }
---@field ped integer
---@field tokens { t1: string, t2: string, t3: string, t4: string, allString: string, num: integer }
---@field coords vector3
---@field heading number
---@field health integer
---@field entity { isFreezed: boolean, model: integer, populationType: integer, type: integer, isVisible: boolean, netId: integer }

---@class HRLibCloseIPlayer : HRLibClientIPlayer
---@field distance number

---@class HRLibCloseFPlayer : HRLibClientFPlayer
---@field distance number

---@class HRLibBlipOptions
---@field sprite integer?
---@field colour integer?
---@field scale number?
---@field alpha number?
---@field asShortRange boolean?
---@field category integer?
---@field displayId integer?
---@field flashBlip boolean?
---@field flashInterval number?

---@class HRLibBlipForCoordOptions
---@field coords vector3

---@class HRLibBlipForEntityOptions
---@field entity integer

---@class HRLibBlipForAreaOptions
---@field coords vector3
---@field width number
---@field height number

---@class HRLibBlipForPickupOptions
---@field pickup integer

---@class HRLibInputDialogueTextOptions
---@field label string
---@field placeholder string?

---@class HRLibVehicleProperties
---@field model number?
---@field plate string?
---@field plateIndex number?
---@field bodyHealth number?
---@field engineHealth number?
---@field tankHealth number?
---@field fuelLevel number?
---@field oilLevel number?
---@field dirtLevel number?
---@field paintType1 number?
---@field paintType2 number?
---@field color1 number|number[]?
---@field color2 number|number[]?
---@field pearlescentColor number?
---@field interiorColor number?
---@field dashboardColor number?
---@field wheelColor number?
---@field wheelWidth number?
---@field wheelSize number?
---@field wheels number?
---@field windowTint number?
---@field xenonColor number?
---@field neonEnabled boolean[]?
---@field neonColor number | number[]?
---@field extras table<number|string,0|1>?
---@field tyreSmokeColor number | number[]?
---@field modSpoilers number?
---@field modFrontBumper number?
---@field modRearBumper number?
---@field modSideSkirt number?
---@field modExhaust number?
---@field modFrame number?
---@field modGrille number?
---@field modHood number?
---@field modFender number?
---@field modRightFender number?
---@field modRoof number?
---@field modEngine number?
---@field modBrakes number?
---@field modTransmission number?
---@field modHorns number?
---@field modSuspension number?
---@field modArmor number?
---@field modNitrous number?
---@field modTurbo boolean?
---@field modSubwoofer boolean?
---@field modSmokeEnabled boolean?
---@field modHydraulics boolean?
---@field modXenon boolean?
---@field modFrontWheels number?
---@field modBackWheels number?
---@field modCustomTiresF boolean?
---@field modCustomTiresR boolean?
---@field modPlateHolder number?
---@field modVanityPlate number?
---@field modTrimA number?
---@field modOrnaments number?
---@field modDashboard number?
---@field modDial number?
---@field modDoorSpeaker number?
---@field modSeats number?
---@field modSteeringWheel number?
---@field modShifterLeavers number?
---@field modAPlate number?
---@field modSpeakers number?
---@field modTrunk number?
---@field modEngineBlock number?
---@field modAirFilter number?
---@field modStruts number?
---@field modArchCover number?
---@field modAerials number?
---@field modTrimB number?
---@field modTank number?
---@field modWindows number?
---@field modDoorR number?
---@field modLivery number?
---@field modRoofLivery number?
---@field modLightbar number?
---@field livery number?
---@field windows number[]?
---@field doors number[]?
---@field tyres table<number|string,1|2>?
---@field bulletProofTyres boolean?
---@field driftTyres boolean?