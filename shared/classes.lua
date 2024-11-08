---@class HRLibConfig
---@field defaultWebHook string
---@field defaultNotificationsPosition string

---@class HRLibClientFunctions
---@field DoesIdExist fun(playerId: integer?): boolean
---@field GetIPlayer fun(playerId: integer): table?
---@field GetFPlayer fun(playerId: integer): table?
---@field RequestModel fun(model: string|integer|string[]|integer[])
---@field RequestAnimDict fun(dict: string|string[])
---@field SpawnVehicle fun(vehModel: string|integer, coords: vector3, heading: number?): integer?
---@field Teleport fun(playerId: integer, coords: vector3)
---@field ClosestPed fun(Id: integer?, returnClosePeds: boolean?): { ped: integer, distance: number }, { ped: integer, distance: number }[]?
---@field ClosestVehicle fun(Id: integer?, returnCloseVehs: boolean?): { vehicle: integer, distance: number }?, { vehicle: integer, distance: number }[]?
---@field ClosestObject fun(Id: integer?, returnCloseObjects: boolean?): { entity: integer, distance: number }?, { entity: integer, distance: number }[]?
---@field ClosestIPlayer fun(Id: integer?, returnCloseIPlayers: boolean?): HRLibCloseIPlayer?, HRLibCloseIPlayer[]?
---@field ClosestFPlayer fun(Id: integer?, returnCloseFPlayers: boolean?): HRLibCloseFPlayer?, HRLibCloseFPlayer[]?
---@field Notify fun(description: string?, type: 'success'|'info'|'error'|'warning'?, duration: number?, pos: 'top-right'|'center-right'|'bottom-right'|'frombelow-right'|'top-left'|'left-center'|'frombelow-left'?, sound: boolean?)
---@field RegCommand fun(name: string, cb: fun(args: string[]|any[]?, rawCommand: any, IPlayer: HRLibClientIPlayer, FPlayer: HRLibClientFPlayer), suggestions: { help: string?, args: table[]? }?)
---@field string { split: fun(text: string, key: string, returnAllAs: 'string'|'number'?, isArray: boolean?): ...|string[]|number[]?, gather: fun(source: string, key: string): string? }
---@field table { focusedArray: fun(array: table[], focus: table, cb: fun(i: integer, curr: table)), focusedHash: fun(hash: table, focus: table|any, cb: fun(key: string, value: any[], arrayInfo: { i: integer, curr: table })), getHashLength: fun(hash: table): integer, removeIndex: fun(tbl: any[], index: integer, saveOldIndexes: boolean): any[]?, find: fun(tbl: any[], value: any|any[], returnIndex: boolean?): boolean }
---@field CreateCallback fun(name: string, isLocal: boolean?, cb: fun(...: ...?): ...|any) isLocal is not available in the export method!! In the export method, the parameters are name and cb
---@field Callback fun(name: string, ...: ...?): any
---@field ServerCallback fun(name: string, ...: ...?): any
---@field require fun(path: string): any Available in import method only!
---@field GetPlayers fun(): integer[]
---@field GetAllPedWeapons fun(): string[]
---@field SetBlipName fun(blip: integer, blipName: string)
---@field Keys table<string, integer>
---@field AllWeapons string[]
---@field AllPickups string[]
---@field OnStart fun(resName: string|'any'?, cb: fun(resource: string)) Available in import method only!
---@field OnStop fun(resName: string|'any'?, cb: fun(resource: string)) Available in import method only!
---@field OnStarting fun(resName: string|'any'?, cb: fun(resource: string)) Available in import method only!
---@field OnResListRefresh fun(resName: string|'any'?, cb: fun(resource: string))
---@field OnPlConnecting fun(cb: fun(playerName: string, setKickReason: string, deferrals: table)) Available in import method only!
---@field OnPlJoining fun(cb: fun()) Available in import method only!
---@field OnPlSpawn fun(cb: fun()) Available in import method only!
---@field OnPlDisc fun(cb: fun()) Available in import method only!
---@field getNUIValue fun(key: string): any Available in import method only!

---@class HRLibServerFunctions
---@field DiscordMsg fun(webHook: string, botName: string, title: string, message: string, type: string?, color: integer, icon: string, author: string)
---@field PlayerIdentifier fun(playerId: integer, identifier: string|'all'|table, removeNames: boolean?, isArray: boolean?): ...|string?
---@field PlayerIdentifierByIndex fun(playerId: integer, identifier: string|'all'|table, removeNames: boolean?, isArray: boolean?): ...|string?
---@field PlayerServerIdByIdentifier fun(identifier: string): integer?
---@field GetIPlayer fun(playerId: integer): HRLibServerIPlayer?
---@field GetFPlayer fun(playerId: integer): HRLibServerFPlayer?
---@field SpawnVehicle fun(vehModel: string|integer, coords: vector4): integer?
---@field Teleport fun(playerId: integer, coords: vector3)
---@field Freeze fun(playerId: integer, toggle: boolean?)
---@field Notify fun(playerId: integer, description: string?, type: 'success'|'info'|'error'|'warning'?, duration: number?, pos: 'top-right'|'center-right'|'bottom-right'|'frombelow-right'|'top-left'|'left-center'|'frombelow-left'?, sound: boolean?)
---@field AllIPlayers fun(): integer[]
---@field AllFPlayers fun(): integer[]
---@field DoesIdExist fun(playerId: integer?): boolean
---@field RegCommand fun(name: string, accessFromConsole: boolean, accessFromInGame: boolean, cb: fun(args: string[]|any[]?, rawCommand: any?, IPlayer: HRLibServerIPlayer, FPlayer: HRLibServerFPlayer), isPlayerAllowed: boolean?, suggestions: { help: string?, restricted: boolean, args: table[]? }?)
---@field string { split: fun(text: string, key: string, returnAllAs: 'string'|'number'?, isArray: boolean?): string[]|number[]|...?, gather: fun(text: string, key: string?): string? }
---@field table { focusedArray: fun(array: table[], focus: table, cb: fun(i: integer, curr: table)), focusedHash: fun(hash: table, focus: table|any, cb: fun(key: string, value: any[], arrayInfo: { i: integer, curr: table })), getHashLength: fun(hash: table): integer, removeIndex: fun(tbl: any[], index: integer, saveOldIndexes: boolean): any[]?, find: fun(tbl: any[], value: any|any[], returnIndex: boolean?): boolean }
---@field CreateCallback fun(name: string, isLocal: boolean?, cb: fun(...: ...?): ...|any) isLocal is not available in the export method!! In the export method, the parameters are name and cb
---@field Callback fun(name: string, ...: ...?): any? 
---@field ClientCallback fun(name: string, playerId: integer?, ...: ...?): any?
---@field StopMyself fun(msgtype: 'warn'|'error', msg: string)
---@field require fun(path: string): any? Available in import method only!
---@field OnStart fun(resName: string|'any'?, cb: fun(resource: string)) Available in import method only!
---@field OnStop fun(resName: string|'any'?, cb: fun(resource: string)) Available in import method only!
---@field OnStarting fun(resName: string|'any'?, cb: fun(resource: string)) Available in import method only!
---@field OnResListRefresh fun(cb: function) Available in import method only!
---@field OnServerStart fun(resName: string|'any'?, cb: fun(resource: string)) Available in import method only!
---@field OnServerStop fun(resName: string|'any'?, cb: fun(resource: string)) Available in import method only!
---@field OnPlConnecting fun(cb: fun(source: integer, playerName: string, setKickReason: string, deferrals: table)) Available in import method only!
---@field OnPlJoining fun(cb: fun(source: integer)) Available in import method only!
---@field OnPlSpawn fun(cb: fun(source: integer)) Available in import method only!
---@field OnPlDisc fun(cb: fun(source: integer)) Available in import method only!

---@class HRLibClientFPlayer
---@field Teleport fun(self: HRLibClientFPlayer, coords: vector3)
---@field SpawnVehicle fun(self: HRLibClientFPlayer, vehModel: string|integer, spawnPedInside: boolean?, saveVehicle: boolean?): integer?
---@field Freeze fun(self: HRLibClientFPlayer, toggle: boolean)

---@class HRLibServerFPlayer
---@field Teleport fun(self: HRLibServerFPlayer, coords: vector3)
---@field SpawnVehicle fun(self: HRLibServerFPlayer, vehModel: string|integer, spawnPlayerInside: boolean?, saveVehicle: boolean?): integer?
---@field Notify fun(self: HRLibServerFPlayer, description: string?, type: 'success'|'info'|'error'|'warning'?, duration: number?, pos: 'top-right'|'center-right'|'bottom-right'|'frombelow-right'|'top-left'|'left-center'|'frombelow-left'?, sound: boolean?)
---@field FocusedEvent fun(self: HRLibServerFPlayer, eventName: string, ...: any)

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
---@field invincible_2 boolean
---@field max { stamina: number, armour: integer, health: integer }
---@field currStamina number
---@field veh { dmgModifier: number, defModifier: number }
---@field weapon { dmgModifier: number, defModifier: number, defModifier_2: number, malee: { dmgModifier: number, defModifier: number } }
---@field coords vector3
---@field heading number
---@field currStealthNoise number
---@field group integer
---@field invincible boolean
---@field name string
---@field ped integer
---@field pedIsFollowing integer
---@field rgbColor integer
---@field team integer
---@field underWaterTimeRmng number
---@field entity { targetEntity: { [1]: boolean, [2]: integer }, health: number, archeTypeName: string, attachedTo: integer, model: integer, mapDataOwner: { [1]: boolean, [2]: integer, [3]: integer }, alpha: integer, forward: { vector: vector3, x: number, y: number }, heightAboveGround: number, lodDist: integer, matrix: vector3[], pitch: number, populationType: integer, quaternion: number[], roll: number, rotationVelocity: vector3, speed: number, submergedLvl: number, type: number, uprightValue: number, velocity: vector3, lastHitMaterial: integer, nearestPl: integer, objectIndex: integer, vehIndex: integer, hasLoadedCollisionAround: boolean, hasBeenDamagedByAnyObject: boolean, hasBeenDamagedByAnyVeh: boolean, hasCollidedWithAnything: boolean, isAttached: boolean, isAttachedToAnyObject: boolean, isAttachedToAnyPed: boolean, isAttachedToAnyVeh: boolean, isDead: boolean, isInAir: boolean, isInWater: boolean, isOccluded: boolean, isOnScreen: boolean, isStatic: boolean, isUpsideDown: boolean, isVisible: boolean, isVisibleToScript: boolean, isWaitingForWorldCollision: boolean, isFreezed: boolean }
---@field streetName string

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
---@field camRotation vector3
---@field endPoint string
---@field fakeWantedLvl integer
---@field guid string
---@field invincible boolean
---@field lastMsg integer
---@field rountingBucket integer
---@field team integer
---@field wanted { centrePos: vector3, lvl: integer }
---@field weapon { dmgModifier: number, defModifier: number, defModifier_2: number, maleeWeaponDmgModifier: number }
---@field coords vector3
---@field heading number
---@field health integer
---@field entity { attachedTo: integer, isFreezed: boolean, model: integer, populationType: integer, rotation: vector3, rotationVelocity: vector3, rountingBucket: integer, script: string, speed: number, type: integer, velocity: vector3, sourceOfDamage: integer, sourceOfDeath: integer, isVisible: boolean, netId: integer }
---@field veh { bodyHealth: number, colours: integer[], custom: { primaryColour: integer[], secondaryColour: integer[] }, dashboardColour: integer, dirtLevel: number, doorLockStatus: number, doorStatus: integer, doorsLockedForPlayer: integer, engineHealth: number, extraColours: integer[], flightNozzlePosition: number, handbrake: boolean, headlightsColour: integer, homingLockonState: integer, interiorColour: integer, lightsState: boolean[], livery: integer, lockOnTarget: { [1]: boolean, [2]: integer }, plate: string, plateIndex: integer, petrolTankHealth: number, radioStationIndex: integer, roofLivery: integer, steeringAngle: number, type: string, tyreSmokeColour: integer[], wheelType: integer, windowTint: integer }
---@field vehicle integer

---@class HRLibCloseIPlayer : HRLibClientIPlayer
---@field distance number

---@class HRLibCloseFPlayer : HRLibClientFPlayer
---@field distance number