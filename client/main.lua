-- _  _  ___  _     _  _                     _  _ 
-- | || || _ \| |   (_)| |__  _ _  __ _  _ _ | || |
-- | __ ||   /| |__ | ||  _ \| '_|/ _` || '_| \_. |
-- |_||_||_|_\|____||_||____/|_|  \__/_||_|   |__/ 
--      © 2023 • HRScripts Development

if GetResourceState('HRNotify') == 'started' then
    clib.Notify = function(msg, type, time)
        exports.HRNotify:Notify(msg, type, time)
    end
end

clib.GetFPlayer = function(playerId)
    FPlayer.id = playerId
    return FPlayer
end

clib.GetIPlayer = function(playerId)
    if playerId == nil or type(playerId) ~= 'number' or not HRLib.DoesIdExist(playerId) then
        return nil
    elseif HRLib.DoesIdExist(playerId) then
        local p = GetPlayerPed(GetPlayerFromServerId(playerId))
        local coo = GetEntityCoords(p)
        return {
            source = playerId,
            invincible_2 = GetPlayerInvincible_2(playerId),
            max = {
                stamina = GetPlayerMaxStamina(playerId),
                armour = GetPlayerMaxArmour(playerId),
                health = GetEntityMaxHealth(p),
            },
            currStamina = GetPlayerStamina(playerId),
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
            coords = coo,
            heading = GetEntityHeading(p),
            currStealthNoise = GetPlayerCurrentStealthNoise(playerId),
            group = GetPlayerGroup(playerId),
            index = GetPlayerIndex(playerId),
            invincible = GetPlayerInvincible(playerId),
            name = GetPlayerName(playerId),
            ped = p,
            pedIsFollowing = GetPlayerPedIsFollowing(p),
            rgbColor = GetPlayerRgbColour(playerId),
            team = GetPlayerTeam(playerId),
            underWaterTimeRmng = GetPlayerUnderwaterTimeRemaining(playerId),
            entity = {
                entity = GetPlayerTargetEntity(playerId),
                health = GetEntityHealth(p),
                archeTypeName = GetEntityArchetypeName(p),
                attachedTo = GetEntityAttachedTo(p),
                model = GetEntityModel(p),
                mapDataOwner = GetEntityMapdataOwner(p),
                alpha = GetEntityAlpha(p),
                forward = {
                    vector = GetEntityForwardVector(p),
                    x = GetEntityForwardX(p),
                    y = GetEntityForwardY(p),
                },
                heightAboveGround = GetEntityHeightAboveGround(p),
                lodDist = GetEntityLodDist(p),
                matrix = GetEntityMatrix(p),
                pitch = GetEntityPitch(p),
                populationType = GetEntityPopulationType(p),
                quaternion = GetEntityQuaternion(p),
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
                offsetFromEGivenWorldCoords = GetOffsetFromEntityGivenWorldCoords(p, coo),
                offsetFromEInWorldCoords = GetOffsetFromEntityInWorldCoords(p, coo),
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
            streetName = GetStreetNameAtCoord(coo.x, coo.y, coo.z)
        }
    end
end

clib.nilCheck = function(value)
    if value == nil then return end

    for _,v in pairs(value) do
        if string.find(v, ' ') then
            return false
        else
            return true
        end
    end
end