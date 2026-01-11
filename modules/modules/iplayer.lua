if IsDuplicityVersion() then
    ---@diagnostic disable: param-type-mismatch

    local pli = GetPlayerIdentifierByType --[[@as fun(playerSrc: integer, identifierType: string): string]]
    local entityFunctions <const> = {
        isFreezed = IsEntityPositionFrozen,
        model = GetEntityModel,
        populationType = GetEntityPopulationType,
        type = GetEntityType,
        isVisible = IsEntityVisible,
        netId = NetworkGetNetworkIdFromEntity,
        networkId = NetworkGetNetworkIdFromEntity
    }

    ---@param playerId integer An existing player server Id
    ---@return HRLibServerIPlayer? IPlayer
    HRLib.GetIPlayer = function(playerId)
        if HRLib.DoesIdExist(playerId) then
            return setmetatable({
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
                max = {
                    health = GetPlayerMaxHealth(playerId),
                    armour = GetPlayerMaxArmour(playerId),
                },
                tokens = {
                    t1 = GetPlayerToken(playerId, 0) or 'undefined',
                    t2 = GetPlayerToken(playerId, 1) or 'undefined',
                    t3 = GetPlayerToken(playerId, 2) or 'undefined',
                    t4 = GetPlayerToken(playerId, 3) or 'undefined',
                    allString = ('%s\n%s\n%s\n%s'):format(GetPlayerToken(playerId, 0) or 'undefined', GetPlayerToken(playerId, 1) or 'undefined', GetPlayerToken(playerId, 2) or 'undefined', GetPlayerToken(playerId, 3) or 'undefined'),
                    num = GetNumPlayerTokens(playerId),
                },
                entity = setmetatable({}, {
                    __index = function(_, k)
                        return entityFunctions[k](GetPlayerPed(playerId))
                    end
                })
            }, {
                __index = function(_, k)
                    local ped <const> = GetPlayerPed(playerId)
                    if k == 'ping' then
                        return GetPlayerPing(ped)
                    elseif k == 'ped' then
                        return GetPlayerPed(ped)
                    elseif k == 'coords' or k == 'coordinates' then
                        return GetConvar('onesync', 'no') ~= 'on' and GetEntityCoords(ped) or vector3(0, 0, 0)
                    elseif k == 'heading' then
                        return GetEntityHeading(ped)
                    elseif k == 'health' then
                        return GetEntityHealth(ped)
                    elseif k == 'identifiersNum' then
                        return GetNumPlayerIdentifiers(playerId)
                    end
                end
            })
        end
    end

    ---@return HRLibServerIPlayer[]? allIPlayers
    HRLib.AllIPlayers = function()
        local allIPlayers <const> = {}

        local pls <const> = GetPlayers()
        for i=1, #pls do
            allIPlayers[#allIPlayers+1] = HRLib.GetIPlayer(tonumber(pls[i]) --[[@as integer]])
        end

        return #allIPlayers > 0 and allIPlayers or nil
    end
else
    local entityFunctions <const> = {
        archetypeName = GetEntityArchetypeName,
        model = GetEntityModel,
        mapdataOwner = GetEntityMapdataOwner,
        populationType = GetEntityPopulationType,
        type = GetEntityType
    }

    local playerId <const> = GetPlayerServerId(PlayerId())
    local p <const> = GetPlayerFromServerId(playerId)
    HRLib.IPlayer = setmetatable({
        source = playerId, id = playerId, Id = playerId, ID = playerId, playerId = playerId, player = playerId, serverId = playerId, plId = playerId, serverPlId = playerId, sPlId = playerId,
        state = LocalPlayer.state,
        max = setmetatable({}, {
            __index = function(_, k)
                if k == 'health' then
                    return GetEntityMaxHealth(GetPlayerPed(p))
                elseif k == 'stamina' then
                    return GetPlayerMaxStamina(playerId)
                elseif k == 'armour' then
                    return GetPlayerMaxArmour(playerId)
                end
            end
        }),
        name = GetPlayerName(GetPlayerFromServerId(playerId)),
        entity = setmetatable({}, {
            __index = function(_, k)
                return k ~= 'mapdataOwner' and entityFunctions[k](GetPlayerPed(p)) or { entityFunctions[k](GetPlayerPed(p)) }
            end
        })
    }, {
        __index = function(_, k)
            local ped <const> = GetPlayerPed(p)
            if k == 'ped' then
                return ped
            elseif k == 'coords' or k == 'coordinates' then
                return GetEntityCoords(ped)
            elseif k == 'heading' then
                return GetEntityHeading(ped)
            elseif k == 'health' then
                return GetEntityHealth(ped)
            end
        end
    }) --[[@as HRLibClientIPlayer]]
end