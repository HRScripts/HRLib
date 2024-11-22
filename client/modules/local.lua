local resName <const> = GetCurrentResourceName()
local clib <const> = {
    RegisteredCmds = {},
    Callbacks = setmetatable({}, {
        __newindex = function(self, k, v)
            rawset(self, k, v)
            TriggerEvent(('__%s:Receive_clibValues'):format(resName), 'Callbacks', k, v)
        end
    }),
    ServerCallbacks = setmetatable({}, {
        __newindex = function(self, k, v)
            rawset(self, k, v)
            TriggerEvent(('__%s:Receive_clibValues'):format(resName), 'ServerCallbacks', k, v)
        end
    }),
    CallbacksPromises = setmetatable({}, {
        __newindex = function(self, k, v)
            rawset(self, k, v)
            TriggerEvent(('__%s:Receive_clibValues'):format(resName), 'CallbacksPromises', k, v)
        end
    }),
    allWeapons = {
        'weapon_dagger', 'weapon_bat', 'weapon_bottle', 'weapon_crowbar', 'weapon_unarmed', 'weapon_flashlight', 'weapon_golfclub', 'weapon_hammer', 'weapon_hatchet', 'weapon_knuckle', 'weapon_knife', 'weapon_machete', 'weapon_switchblade', 'weapon_nightstick', 'weapon_wrench', 'weapon_battleaxe', 'weapon_poolcue', 'weapon_stone_hatchet', 'weapon_candycane', 'weapon_pistol', 'weapon_pistol_mk2', 'weapon_combatpistol', 'weapon_appistol', 'weapon_stungun', 'weapon_pistol50', 'weapon_snspistol', 'weapon_snspistol_mk2', 'weapon_heavypistol', 'weapon_vintagepistol', 'weapon_flaregun', 'weapon_marksmanpistol', 'weapon_revolver', 'weapon_revolver_mk2', 'weapon_doubleaction', 'weapon_raypistol', 'weapon_ceramicpistol', 'weapon_navyrevolver', 'weapon_gadgetpistol', 'weapon_stungun_mp', 'weapon_pistolxm3', 'weapon_microsmg', 'weapon_smg', 'weapon_smg_mk2', 'weapon_assaultsmg', 'weapon_combatpdw', 'weapon_machinepistol', 'weapon_minismg', 'weapon_raycarbine', 'weapon_tecpistol', 'weapon_pumpshotgun', 'weapon_pumpshotgun_mk2', 'weapon_sawnoffshotgun', 'weapon_assaultshotgun', 'weapon_bullpupshotgun', 'weapon_musket', 'weapon_heavyshotgun', 'weapon_dbshotgun', 'weapon_autoshotgun', 'weapon_combatshotgun', 'weapon_assaultrifle', 'weapon_assaultrifle_mk2', 'weapon_carbinerifle', 'weapon_carbinerifle_mk2', 'weapon_advancedrifle', 'weapon_specialcarbine', 'weapon_specialcarbine_mk2', 'weapon_bullpuprifle', 'weapon_bullpuprifle_mk2', 'weapon_compactrifle', 'weapon_militaryrifle', 'weapon_heavyrifle', 'weapon_tacticalrifle', 'weapon_mg', 'weapon_combatmg', 'weapon_combatmg_mk2', 'weapon_gusenberg', 'weapon_sniperrifle', 'weapon_heavysniper', 'weapon_heavysniper_mk2', 'weapon_marksmanrifle', 'weapon_marksmanrifle_mk2', 'weapon_precisionrifle', 'weapon_rpg', 'weapon_grenadelauncher', 'weapon_grenadelauncher_smoke', 'weapon_minigun', 'weapon_firework', 'weapon_railgun', 'weapon_hominglauncher', 'weapon_compactlauncher', 'weapon_rayminigun', 'weapon_emplauncher', 'weapon_railgunxm3', 'weapon_grenade', 'weapon_bzgas', 'weapon_molotov', 'weapon_stickybomb', 'weapon_proxmine', 'weapon_snowball', 'weapon_pipebomb', 'weapon_ball', 'weapon_smokegrenade', 'weapon_flare', 'weapon_acidpackage', 'weapon_petrolcan', 'gadget_parachute', 'weapon_fireextinguisher', 'weapon_hazardcan', 'weapon_fertilizercan'
    },
    allPickups = {
        'PICKUP_WEAPON_BULLPUPSHOTGUN', 'PICKUP_WEAPON_ASSAULTSMG', 'PICKUP_VEHICLE_WEAPON_ASSAULTSMG', 'PICKUP_WEAPON_PISTOL50', 'PICKUP_VEHICLE_WEAPON_PISTOL50', 'PICKUP_AMMO_BULLET_MP', 'PICKUP_AMMO_MISSILE_MP', 'PICKUP_AMMO_GRENADELAUNCHER_MP', 'PICKUP_WEAPON_ASSAULTRIFLE', 'PICKUP_WEAPON_CARBINERIFLE', 'PICKUP_WEAPON_ADVANCEDRIFLE', 'PICKUP_WEAPON_MG', 'PICKUP_WEAPON_COMBATMG', 'PICKUP_WEAPON_SNIPERRIFLE', 'PICKUP_WEAPON_HEAVYSNIPER', 'PICKUP_WEAPON_MICROSMG', 'PICKUP_WEAPON_SMG', 'PICKUP_ARMOUR_STANDARD', 'PICKUP_WEAPON_RPG', 'PICKUP_WEAPON_MINIGUN', 'PICKUP_HEALTH_STANDARD', 'PICKUP_WEAPON_PUMPSHOTGUN', 'PICKUP_WEAPON_SAWNOFFSHOTGUN', 'PICKUP_WEAPON_ASSAULTSHOTGUN', 'PICKUP_WEAPON_GRENADE', 'PICKUP_WEAPON_MOLOTOV', 'PICKUP_WEAPON_SMOKEGRENADE', 'PICKUP_WEAPON_STICKYBOMB', 'PICKUP_WEAPON_PISTOL', 'PICKUP_WEAPON_COMBATPISTOL', 'PICKUP_WEAPON_APPISTOL', 'PICKUP_WEAPON_GRENADELAUNCHER', 'PICKUP_MONEY_VARIABLE', 'PICKUP_GANG_ATTACK_MONEY', 'PICKUP_WEAPON_STUNGUN', 'PICKUP_WEAPON_PETROLCAN', 'PICKUP_WEAPON_KNIFE', 'PICKUP_WEAPON_NIGHTSTICK', 'PICKUP_WEAPON_HAMMER', 'PICKUP_WEAPON_BAT', 'PICKUP_WEAPON_GolfClub', 'PICKUP_WEAPON_CROWBAR', 'PICKUP_CUSTOM_SCRIPT', 'PICKUP_CAMERA', 'PICKUP_PORTABLE_PACKAGE', 'PICKUP_PORTABLE_CRATE_UNFIXED', 'PICKUP_PORTABLE_PACKAGE_LARGE_RADIUS', 'PICKUP_PORTABLE_CRATE_UNFIXED_INCAR', 'PICKUP_PORTABLE_CRATE_UNFIXED_INAIRVEHICLE_WITH_PASSENGERS', 'PICKUP_PORTABLE_CRATE_UNFIXED_INAIRVEHICLE_WITH_PASSENGERS_UPRIGHT', 'PICKUP_PORTABLE_CRATE_UNFIXED_INCAR_WITH_PASSENGERS', 'PICKUP_PORTABLE_CRATE_FIXED_INCAR_WITH_PASSENGERS', 'PICKUP_PORTABLE_CRATE_FIXED_INCAR_SMALL', 'PICKUP_PORTABLE_CRATE_UNFIXED_INCAR_SMALL', 'PICKUP_PORTABLE_CRATE_UNFIXED_LOW_GLOW', 'PICKUP_MONEY_CASE', 'PICKUP_MONEY_WALLET', 'PICKUP_MONEY_PURSE', 'PICKUP_MONEY_DEP_BAG', 'PICKUP_MONEY_MED_BAG', 'PICKUP_MONEY_PAPER_BAG', 'PICKUP_MONEY_SECURITY_CASE', 'PICKUP_VEHICLE_WEAPON_COMBATPISTOL', 'PICKUP_VEHICLE_WEAPON_APPISTOL', 'PICKUP_VEHICLE_WEAPON_PISTOL', 'PICKUP_VEHICLE_WEAPON_GRENADE', 'PICKUP_VEHICLE_WEAPON_MOLOTOV', 'PICKUP_VEHICLE_WEAPON_SMOKEGRENADE', 'PICKUP_VEHICLE_WEAPON_STICKYBOMB', 'PICKUP_VEHICLE_HEALTH_STANDARD', 'PICKUP_VEHICLE_HEALTH_STANDARD_LOW_GLOW', 'PICKUP_VEHICLE_ARMOUR_STANDARD', 'PICKUP_VEHICLE_WEAPON_MICROSMG', 'PICKUP_VEHICLE_WEAPON_SMG', 'PICKUP_VEHICLE_WEAPON_SAWNOFF', 'PICKUP_VEHICLE_CUSTOM_SCRIPT', 'PICKUP_VEHICLE_CUSTOM_SCRIPT_NO_ROTATE', 'PICKUP_VEHICLE_CUSTOM_SCRIPT_LOW_GLOW', 'PICKUP_VEHICLE_MONEY_VARIABLE', 'PICKUP_SUBMARINE', 'PICKUP_HEALTH_SNACK', 'PICKUP_PARACHUTE', 'PICKUP_AMMO_PISTOL', 'PICKUP_AMMO_SMG', 'PICKUP_AMMO_RIFLE', 'PICKUP_AMMO_MG', 'PICKUP_AMMO_SHOTGUN', 'PICKUP_AMMO_SNIPER', 'PICKUP_AMMO_GRENADELAUNCHER', 'PICKUP_AMMO_RPG', 'PICKUP_AMMO_MINIGUN', 'PICKUP_WEAPON_BOTTLE', 'PICKUP_WEAPON_SNSPISTOL', 'PICKUP_WEAPON_HEAVYPISTOL', 'PICKUP_WEAPON_SPECIALCARBINE', 'PICKUP_WEAPON_BULLPUPRIFLE', 'PICKUP_WEAPON_RAYPISTOL', 'PICKUP_WEAPON_RAYCARBINE', 'PICKUP_WEAPON_RAYMINIGUN', 'PICKUP_WEAPON_BULLPUPRIFLE_MK2', 'PICKUP_WEAPON_DOUBLEACTION', 'PICKUP_WEAPON_MARKSMANRIFLE_MK2', 'PICKUP_WEAPON_PUMPSHOTGUN_MK2', 'PICKUP_WEAPON_REVOLVER_MK2', 'PICKUP_WEAPON_SNSPISTOL_MK2', 'PICKUP_WEAPON_SPECIALCARBINE_MK2', 'PICKUP_WEAPON_PROXMINE', 'PICKUP_WEAPON_HOMINGLAUNCHER', 'PICKUP_AMMO_HOMINGLAUNCHER', 'PICKUP_WEAPON_GUSENBERG', 'PICKUP_WEAPON_DAGGER', 'PICKUP_WEAPON_VINTAGEPISTOL', 'PICKUP_WEAPON_FIREWORK', 'PICKUP_WEAPON_MUSKET', 'PICKUP_AMMO_FIREWORK', 'PICKUP_AMMO_FIREWORK_MP', 'PICKUP_PORTABLE_DLC_VEHICLE_PACKAGE', 'PICKUP_WEAPON_HATCHET', 'PICKUP_WEAPON_RAILGUN', 'PICKUP_WEAPON_HEAVYSHOTGUN', 'PICKUP_WEAPON_MARKSMANRIFLE', 'PICKUP_WEAPON_CERAMICPISTOL', 'PICKUP_WEAPON_HAZARDCAN', 'PICKUP_WEAPON_NAVYREVOLVER', 'PICKUP_WEAPON_COMBATSHOTGUN', 'PICKUP_WEAPON_GADGETPISTOL', 'PICKUP_WEAPON_MILITARYRIFLE', 'PICKUP_WEAPON_FLAREGUN', 'PICKUP_AMMO_FLAREGUN', 'PICKUP_WEAPON_KNUCKLE', 'PICKUP_WEAPON_MARKSMANPISTOL', 'PICKUP_WEAPON_COMBATPDW', 'PICKUP_PORTABLE_CRATE_FIXED_INCAR', 'PICKUP_WEAPON_COMPACTRIFLE', 'PICKUP_WEAPON_DBSHOTGUN', 'PICKUP_WEAPON_MACHETE', 'PICKUP_WEAPON_MACHINEPISTOL', 'PICKUP_WEAPON_FLASHLIGHT', 'PICKUP_WEAPON_REVOLVER', 'PICKUP_WEAPON_SWITCHBLADE', 'PICKUP_WEAPON_AUTOSHOTGUN', 'PICKUP_WEAPON_BATTLEAXE', 'PICKUP_WEAPON_COMPACTLAUNCHER', 'PICKUP_WEAPON_MINISMG', 'PICKUP_WEAPON_PIPEBOMB', 'PICKUP_WEAPON_POOLCUE', 'PICKUP_WEAPON_WRENCH', 'PICKUP_WEAPON_ASSAULTRIFLE_MK2', 'PICKUP_WEAPON_CARBINERIFLE_MK2', 'PICKUP_WEAPON_COMBATMG_MK2', 'PICKUP_WEAPON_HEAVYSNIPER_MK2', 'PICKUP_WEAPON_PISTOL_MK2', 'PICKUP_WEAPON_SMG_MK2', 'PICKUP_WEAPON_STONE_HATCHET', 'PICKUP_WEAPON_METALDETECTOR', 'PICKUP_WEAPON_TACTICALRIFLE', 'PICKUP_WEAPON_PRECISIONRIFLE', 'PICKUP_WEAPON_EMPLAUNCHER', 'PICKUP_AMMO_EMPLAUNCHER', 'PICKUP_WEAPON_HEAVYRIFLE', 'PICKUP_WEAPON_PETROLCAN_SMALL_RADIUS', 'PICKUP_WEAPON_FERTILIZERCAN', 'PICKUP_WEAPON_STUNGUN_MP'
    },
    keys = {
        ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
        ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
        ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
        ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
        ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
        ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
        ['INSERT'] = 121, ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
        ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
        ['NENTER'] = 201, ['N4'] = 108, ['N5'] = 60, ['N6'] = 107, ['N+'] = 96, ['N-'] = 97, ['N7'] = 117, ['N8'] = 61, ['N9'] = 118,
        ['RIGHTCLICK'] = 6, ['LEFTCLICK'] = 2
    }
}

clib.Notify = function(description, type, duration, pos, sound)
    if GetCurrentResourceName() ~= 'HRLib' then
        TriggerEvent('HRLib:Notify', description, type, duration, pos, sound)
    else
        load(LoadResourceFile('HRLib', 'client/modules/notification.lua'), '@@HRLib/client/modules/notification.lua')()(description, type, duration, pos, sound)
    end
end

---@param playerId integer An existing player server Id
---@return HRLibClientIPlayer?
clib.GetIPlayer = function(playerId)
    if playerId == nil or type(playerId) ~= 'number' then
        return nil
    else
        local p <const> = GetPlayerPed(GetPlayerFromServerId(playerId))
        local coo <const> = GetEntityCoords(p)
        return {
            source = playerId, id = playerId, Id = playerId, ID = playerId, playerId = playerId, player = playerId, serverId = playerId, plId = playerId, serverPlId = playerId, sPlId = playerId,
            state = LocalPlayer.state,
            invincible_2 = GetPlayerInvincible_2(playerId),
            max = {
                stamina = GetPlayerMaxStamina(playerId),
                armour = GetPlayerMaxArmour(playerId),
                health = GetEntityMaxHealth(p),
            },
            currStamina = GetPlayerStamina(playerId),
            vehicle = GetVehiclePedIsIn(p), ---@diagnostic disable-line: missing-parameter
            veh = {
                dmgModifier = GetPlayerVehicleDamageModifier(playerId),
                defModifier = GetPlayerVehicleDefenseModifier(playerId),
            },
            weapon = {
                dmgModifier = GetPlayerWeaponDamageModifier(playerId),
                defModifier = GetPlayerWeaponDefenseModifier(playerId),
                defModifier_2 = GetPlayerWeaponDefenseModifier_2(playerId),
                malee = {
                    dmgModifier = GetPlayerMeleeWeaponDamageModifier(playerId),
                    defModifier = GetPlayerMeleeWeaponDefenseModifier(playerId),
                }
            },
            coords = coo, coordinates = coo,
            heading = GetEntityHeading(p),
            currStealthNoise = GetPlayerCurrentStealthNoise(playerId),
            group = GetPlayerGroup(playerId),
            invincible = GetPlayerInvincible(playerId),
            name = GetPlayerName(GetPlayerFromServerId(playerId)),
            ped = p,
            pedIsFollowing = GetPlayerPedIsFollowing(p),
            rgbColor = GetPlayerRgbColour(playerId),
            team = GetPlayerTeam(playerId),
            underWaterTimeRmng = GetPlayerUnderwaterTimeRemaining(playerId),
            entity = {
                targetEntity = { GetPlayerTargetEntity(playerId) },
                health = GetEntityHealth(p),
                archeTypeName = GetEntityArchetypeName(p),
                attachedTo = GetEntityAttachedTo(p),
                model = GetEntityModel(p),
                mapDataOwner = { GetEntityMapdataOwner(p) },
                alpha = GetEntityAlpha(p),
                forward = {
                    vector = GetEntityForwardVector(p),
                    x = GetEntityForwardX(p),
                    y = GetEntityForwardY(p),
                },
                heightAboveGround = GetEntityHeightAboveGround(p),
                lodDist = GetEntityLodDist(p),
                matrix = { GetEntityMatrix(p) },
                pitch = GetEntityPitch(p),
                populationType = GetEntityPopulationType(p),
                quaternion = { GetEntityQuaternion(p) },
                roll = GetEntityRoll(p),
                rotationVelocity = GetEntityRotationVelocity(p),
                speed = GetEntitySpeed(p),
                submergedLvl = GetEntitySubmergedLevel(p), --
                type = GetEntityType(p),
                uprightValue = GetEntityUprightValue(p),
                velocity = GetEntityVelocity(p),
                lastHitMaterial = GetLastMaterialHitByEntity(p),
                nearestPl = GetNearestPlayerToEntity(p),
                objectIndex = GetObjectIndexFromEntityIndex(p),
                vehIndex = GetVehicleIndexFromEntityIndex(p),
                hasLoadedCollisionAround = HasCollisionLoadedAroundEntity(p),
                hasBeenDamagedByAnyObject = HasEntityBeenDamagedByAnyObject(p),
                hasBeenDamagedByAnyVeh = HasEntityBeenDamagedByAnyVehicle(p),
                hasCollidedWithAnything = HasEntityCollidedWithAnything(p),
                isAttached = IsEntityAttached(p),
                isAttachedToAnyObject = IsEntityAttachedToAnyObject(p),
                isAttachedToAnyPed = IsEntityAttachedToAnyPed(p),
                isAttachedToAnyVeh = IsEntityAttachedToAnyVehicle(p),
                isDead = IsEntityDead(p),
                isInAir = IsEntityInAir(p),
                isInWater = IsEntityInWater(p),
                isOccluded = IsEntityOccluded(p),
                isOnScreen = IsEntityOnScreen(p),
                isStatic = IsEntityStatic(p),
                isUpsideDown = IsEntityUpsidedown(p),
                isVisible = IsEntityVisible(p),
                isVisibleToScript = IsEntityVisibleToScript(p),
                isWaitingForWorldCollision = IsEntityWaitingForWorldCollision(p),
                isFreezed = IsEntityPositionFrozen(p),
            },
            streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(coo.x, coo.y, coo.z))
        } --[[@as HRLibClientIPlayer]]
    end
end

---@param source table the table which you wanna check for nil values no matters where they are in the table
clib.nilCheck = function(source)
    if source == nil then return end

    for _,v in pairs(source) do
        if type(v) == 'nil' or (type(v) == 'string' and v == '' or v == ' ') then
            return false
        else
            return true
        end
    end
end

---@param text string the text you want to split
---@param delimiter string
---@param returnAllAs 'string'|'number'?
---@param isArray boolean? true for return every string/number in array
---@return ...|string[]|number[]?
clib.splitString = function(text, delimiter, returnAllAs, isArray)
    if type(text) ~= 'string' or type(delimiter) ~= 'string' then return end

    returnAllAs = not returnAllAs and 'string' or returnAllAs
    local results <const> = {}

    local start = 1
    for _=1, #text do
        local from <const>, to <const> = text:find(delimiter, start, true)

        if not from then
            results[#results+1] = returnAllAs == 'string' and text:sub(start) or (tonumber(text:sub(start)) or text:sub(start))

            break
        end

        results[#results+1] = returnAllAs == 'string' and text:sub(start, from - 1) or (tonumber(text:sub(start, from - 1)) or text:sub(start, from - 1))

        start = to + 1
    end

    if isArray then
        return results
    else
        return table.unpack(results)
    end
end

return clib