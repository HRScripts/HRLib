local resName <const> = GetCurrentResourceName()
local clib <const> = {
    RegisteredCmds = {},
    Callbacks = setmetatable({}, {
        __newindex = function(self, k, v)
            rawset(self, k, v)
            TriggerEvent(('__%s:Receive_clibValues'):format(resName), 'Callbacks', k, v)
        end
    }),
    ClientCallbacks = setmetatable({}, {
        __newindex = function(self, k, v)
            rawset(self, k, v)
            TriggerEvent(('__%s:Receive_clibValues'):format(resName), 'ClientCallbacks', k, v)
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
    }
}

---@param playerId integer player server Id
---@changelog version 1.0.0
---@version 1.0.0
---@return boolean?
clib.DoesIdExist = function(playerId)
    if type(tonumber(playerId)) ~= 'number' then return end

    playerId = tonumber(playerId) --[[@as integer]]

    local pls <const> = GetPlayers()
    for i=1, #pls do
        if tonumber(pls[i]) == playerId then
            return true
        end
    end

    return false
end

---@param value table
clib.nilCheck = function(value)
    if value == nil then return false end

    for _,v in pairs(value) do
        if v == '' then
            return false
        else
            return true
        end
    end
end

---@param player integer
---@param identifier string An existing identifier
---@return string
clib.PlI = function(player, identifier)
    return GetPlayerIdentifierByType(player, identifier) ---@diagnostic disable-line: param-type-mismatch
end

clib.Notify = function(playerId, msg, type, time, pos, sound)
    TriggerClientEvent('HRLib:Notify', tonumber(playerId), msg, type, tonumber(time), pos, sound) ---@diagnostic disable-line: param-type-mismatch
end

clib.GetIPlayer = function(playerId)
    if clib.DoesIdExist(playerId) then ---@diagnostic disable-line: deprecated
        local p <const> = GetPlayerPed(playerId)
        local veh <const> = GetVehiclePedIsIn(p, false)

        return {
            source = playerId, id = playerId, Id = playerId, ID = playerId, playerId = playerId, player = playerId, serverId = playerId, plId = playerId, serverPlId = playerId, sPlId = playerId,
            state = Player(playerId).state,
            name = GetPlayerName(playerId) or 'undefined',
            identifier = {
                license = clib.PlI(playerId, 'license') or 'undefined',
                license2 = clib.PlI(playerId, 'license2') or 'undefined',
                steam = clib.PlI(playerId, 'steam') or 'undefined',
                discord = clib.PlI(playerId, 'discord') or 'undefined',
                xbl = clib.PlI(playerId, 'xbl') or 'undefined',
                live = clib.PlI(playerId, 'live') or 'undefined',
                ip = clib.PlI(playerId, 'ip') or 'undefined',
                fivem = clib.PlI(playerId, 'fivem') or 'undefined',
            },
            identifiersNum = GetNumPlayerIdentifiers(playerId),
            ping = GetPlayerPing(playerId),
            max = {
                health = GetPlayerMaxHealth(playerId),
                armour = GetPlayerMaxArmour(playerId),
            },
            ped = p,
            tokens = {
                t1 = GetPlayerToken(playerId, 0) or 'undefined',
                t2 = GetPlayerToken(playerId, 1) or 'undefined',
                t3 = GetPlayerToken(playerId, 2) or 'undefined',
                t4 = GetPlayerToken(playerId, 3) or 'undefined',
                allString = ('%s\n%s\n%s\n%s'):format(GetPlayerToken(playerId, 0) or 'undefined', GetPlayerToken(playerId, 1) or 'undefined', GetPlayerToken(playerId, 2) or 'undefined', GetPlayerToken(playerId, 3) or 'undefined'),
                num = GetNumPlayerTokens(playerId),
            },
            camRotation = GetConvar('onesync', 'no') == 'on' and GetPlayerCameraRotation(playerId) or GetConvar('onesync', 'no') == 'legacy' and GetPlayerCameraRotation(playerId) or vector3(0, 0, 0),
            endPoint = GetPlayerEndpoint(playerId),
            fakeWantedLvl = GetConvar('onesync', 'no') == 'on' and GetPlayerFakeWantedLevel(playerId) or GetConvar('onesync', 'no') == 'legacy' and GetPlayerFakeWantedLevel(playerId) or 0,
            guid = GetPlayerGuid(playerId),
            invincible = GetPlayerInvincible(playerId),
            lastMsg = GetPlayerLastMsg(playerId),
            rountingBucket = GetPlayerRoutingBucket(playerId),
            team = GetPlayerTeam(playerId),
            wanted = {
                centrePos = GetConvar('onesync', 'no') == 'on' and GetPlayerWantedCentrePosition(playerId) or GetConvar('onesync', 'no') == 'legacy' and GetPlayerWantedCentrePosition(playerId) or vector3(0, 0, 0),
                lvl = GetPlayerWantedLevel(playerId),
            },
            weapon = {
                dmgModifier = GetPlayerWeaponDamageModifier(playerId),
                defModifier = GetPlayerWeaponDefenseModifier(playerId),
                defModifier_2 = GetPlayerWeaponDefenseModifier_2(playerId),
                maleeWeaponDmgModifier = GetPlayerMeleeWeaponDamageModifier(playerId),
            },
            coords = GetConvar('onesync', 'no') == 'on' and GetEntityCoords(p) or GetConvar('onesync', 'no') == 'legacy' and GetEntityCoords(p) or vector3(0, 0, 0),
            heading = GetEntityHeading(p),
            health = GetEntityHealth(p),
            entity = {
                attachedTo = GetEntityAttachedTo(p),
                isFreezed = IsEntityPositionFrozen(p),
                model = GetEntityModel(p),
                populationType = GetEntityPopulationType(p),
                rotation = GetEntityRotation(p),
                rotationVelocity = GetEntityRotationVelocity(p),
                rountingBucket = GetEntityRoutingBucket(p),
                script = GetEntityScript(p),
                speed = GetEntitySpeed(p),
                type = GetEntityType(p),
                velocity = GetEntityVelocity(p),
                sourceOfDamage = GetConvar('onesync', 'no') == 'on' and GetPedSourceOfDamage(p) or GetConvar('onesync', 'no') == 'legacy' and GetPedSourceOfDamage(p) or 0,
                sourceOfDeath = GetConvar('onesync', 'no') == 'on' and GetPedSourceOfDeath(p) or GetConvar('onesync', 'no') == 'legacy' and GetPedSourceOfDeath(p) or 0,
                isVisible = IsEntityVisible(p),
                netId = NetworkGetNetworkIdFromEntity(p),
            },
            veh = {
                bodyHealth = GetVehicleBodyHealth(veh),
                colours = { GetVehicleColours(veh) },
                custom = {
                    primaryColour = { GetVehicleCustomPrimaryColour(veh) },
                    secondaryColour = { GetVehicleCustomSecondaryColour(veh) }
                },
                dashboardColour = GetVehicleDashboardColour(veh),
                dirtLevel = GetVehicleDirtLevel(veh),
                doorLockStatus = GetVehicleDoorLockStatus(veh),
                doorStatus = GetVehicleDoorStatus(veh),
                doorsLockedForPlayer = GetVehicleDoorsLockedForPlayer(veh),
                engineHealth = GetVehicleEngineHealth(veh),
                extraColours = { GetVehicleExtraColours(veh) },
                flightNozzlePosition = GetVehicleFlightNozzlePosition(veh),
                handbrake = GetVehicleHandbrake(veh),
                headlightsColour = GetVehicleHeadlightsColour(veh),
                homingLockonState = GetVehicleHomingLockonState(veh),
                interiorColour = GetVehicleInteriorColour(veh),
                lightsState = { GetVehicleLightsState(veh) },
                livery = GetVehicleLivery(veh),
                lockOnTarget = { GetVehicleLockOnTarget(veh) }, ---@diagnostic disable-line: assign-type-mismatch
                plate = GetVehicleNumberPlateText(veh),
                plateIndex = GetVehicleNumberPlateTextIndex(veh),
                petrolTankHealth = GetVehiclePetrolTankHealth(veh),
                radioStationIndex = GetVehicleRadioStationIndex(veh),
                roofLivery = GetVehicleRoofLivery(veh),
                steeringAngle = GetVehicleSteeringAngle(veh),
                type = GetVehicleType(veh),
                tyreSmokeColor = { GetVehicleTyreSmokeColor(veh) },
                wheelType = GetVehicleWheelType(veh),
                windowTint = GetVehicleWindowTint(veh)
            },
            vehicle = veh -- The shorter way for taking the vehicle which the player sits in. The equivalent is veh.pedIsIn
        } --[[@as HRLibServerIPlayer]]
    else
        return nil
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