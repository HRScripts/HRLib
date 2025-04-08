if IsDuplicityVersion() then
    ---@diagnostic disable: param-type-mismatch

    local pli = GetPlayerIdentifierByType --[[@as fun(playerSrc: integer, identifierType: string): string]]

    ---@param playerId integer An existing player server Id
    ---@return HRLibServerIPlayer?
    HRLib.GetIPlayer = function(playerId)
        if HRLib.DoesIdExist(playerId) then ---@diagnostic disable-line: deprecated
            local p <const> = GetPlayerPed(playerId)
            local veh <const> = GetVehiclePedIsIn(p, false)
            return {
                source = playerId, id = playerId, Id = playerId, ID = playerId, playerId = playerId, player = playerId, serverId = playerId, plId = playerId, serverPlId = playerId, sPlId = playerId,
                state = Player(playerId).state,
                name = GetPlayerName(playerId) or 'undefined',
                identifier = {
                    license = pli(playerId, 'license') or 'undefined',
                    license2 = pli(playerId, 'license2') or 'undefined',
                    steam = pli(playerId, 'steam') or 'undefined',
                    discord = pli(playerId, 'discord') or 'undefined',
                    xbl = pli(playerId, 'xbl') or 'undefined',
                    live = pli(playerId, 'live') or 'undefined',
                    ip = pli(playerId, 'ip') or 'undefined',
                    fivem = pli(playerId, 'fivem') or 'undefined',
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
        end
    end

    ---@return HRLibServerIPlayer[]|{}
    HRLib.AllIPlayers = function()
        local allIPlayers <const> = {}

        local pls <const> = GetPlayers()
        for i=1, #pls do
            allIPlayers[#allIPlayers+1] = HRLib.GetIPlayer(tonumber(pls[i]) --[[@as integer]])
        end

        return allIPlayers
    end
else
    ---@param playerId integer An existing player server Id
    ---@return HRLibClientIPlayer?
    HRLib.GetIPlayer = function(playerId)
        if HRLib.DoesIdExist(playerId) then
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
            }
        end
    end
end