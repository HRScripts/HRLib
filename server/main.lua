-- _  _  ___  _     _  _                     _  _ 
-- | || || _ \| |   (_)| |__  _ _  __ _  _ _ | || |
-- | __ ||   /| |__ | ||  _ \| '_|/ _` || '_| \_. |
-- |_||_||_|_\|____||_||____/|_|  \__/_||_|   |__/ 
--      © 2023 • HRScripts Development

AddEventHandler('onResourceStart', function(resName)
    if GetCurrentResourceName() == resName then
        local status = GetResourceState('HRNotify')
        
        if status ~= 'started' and status ~= 'missing' then
            print('^3!WARNING! You must start ^1HRNotify^3 before HRLib !WARNING!^0')
            ExecuteCommand('stop HRLib')
        elseif status == 'missing' then
            print('^3!WARNING! You must have ^1HRNotify^3 for HRLib and started before HRLib !WARNING!^0')
            ExecuteCommand('stop HRLib')
        end
        
        if GetCurrentResourceName() ~= 'HRLib' then
            repeat error(('^1HRLib is with different name (%s)! Please change this name because script cannot work without currect name!^0'):format(GetCurrentResourceName()), 150000) Wait(3500) until nil ~= nil
        end

        print('HRLibActually works but only for him')
    end
end)

AddEventHandler('onResourceStop', function(resName)
    if resName == GetCurrentResourceName() then
        warn('The restarting/stopping of ^5HRLib^3 is not recommended! You may have error at our other scripts and the commands from the other resources will not be registered!')
    end
end)

clib.PlI = function(player, identifier)
    return GetPlayerIdentifierByType(player, identifier)
end

clib.Notify = function(playerId, msg, type, time)
    TriggerClientEvent('HR:Notify', tonumber(playerId), msg, type, tonumber(time))
end

clib.GetIPlayer = function(playerId)
    if HRLib.DoesIdExist(playerId) then
        local p = GetPlayerPed(playerId)

        return {
            source = playerId,
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
                allString = GetPlayerToken(playerId, 0)..'\n'..GetPlayerToken(playerId, 1)..'\n'..GetPlayerToken(playerId, 2)..'\n'..GetPlayerToken(playerId, 3) or 'undefined\nundefined\nundefined\nundefined',
                num = GetNumPlayerTokens(playerId),
            },
            camRotation = GetPlayerCameraRotation(playerId),
            endPoint = GetPlayerEndpoint(playerId),
            fakeWantedLvl = GetPlayerFakeWantedLevel(playerId),
            guid = GetPlayerGuid(playerId),
            invincible = GetPlayerInvincible(playerId),
            lastMsg = GetPlayerLastMsg(playerId),
            rountingBucket = GetPlayerRoutingBucket(playerId),
            team = GetPlayerTeam(playerId),
            wanted = {
                centrePos = GetPlayerWantedCentrePosition(playerId),
                lvl = GetPlayerWantedLevel(playerId),
            },
            weapon = {
                dmgModifier = GetPlayerWeaponDamageModifier(playerId),
                defModifier = GetPlayerWeaponDefenseModifier(playerId),
                defModifier_2 = GetPlayerWeaponDefenseModifier_2(playerId),
                maleeWeaponDmgModifier = GetPlayerMeleeWeaponDamageModifier(playerId),
            },
            coords = GetEntityCoords(p),
            heading = GetEntityHeading(p),
            health = GetEntityHealth(p),
            entity = {
                attachedTo = GetEntityAttachedTo(p),
                frozen = IsEntityPositionFrozen(p),
                model = GetEntityModel(p),
                populationType = GetEntityPopulationType(p),
                rotation = GetEntityRotation(p),
                rotationVelocity = GetEntityRotationVelocity(p),
                rountingBucket = GetEntityRoutingBucket(p),
                script = GetEntityScript(p),
                speed = GetEntitySpeed(p),
                type = GetEntityType(p),
                velocity = GetEntityVelocity(p),
                sourceOfDamage = GetPedSourceOfDamage(p),
                sourceOfDeath = GetPedSourceOfDeath(p),
                isVisible = IsEntityVisible(p),
                netId = NetworkGetNetworkIdFromEntity(p),
            },
        }
    else return nil end
end

clib.GetFPlayer = function(playerId)
    if HRLib.DoesIdExist(playerId) then
        FPlayer.id = playerId
        return FPlayer
    else return end
end

clib.nilCheck = function(value)
    if value == nil then return false end

    for _,v in pairs(value) do
        if string.find(v, ' ') then
            return false
        else
            return true
        end
    end
end