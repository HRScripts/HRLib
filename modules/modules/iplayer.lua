if IsDuplicityVersion() then
    ---@diagnostic disable: param-type-mismatch

    local pli = GetPlayerIdentifierByType --[[@as fun(playerSrc: integer, identifierType: string): string]]

    ---@param playerId integer An existing player server Id
    ---@return HRLibServerIPlayer? IPlayer
    HRLib.GetIPlayer = function(playerId)
        if HRLib.DoesIdExist(playerId) then
            local p <const> = GetPlayerPed(playerId)
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
                entity = setmetatable({
                    isFreezed = IsEntityPositionFrozen(p),
                    model = GetEntityModel(p),
                    populationType = GetEntityPopulationType(p),
                    type = GetEntityType(p),
                    isVisible = IsEntityVisible(p),
                    netId = NetworkGetNetworkIdFromEntity(p),
                    networkId = NetworkGetNetworkIdFromEntity(p)
                }, {
                    __index = function(self, k)
                        local modules <const> = HRLib.table.getKeys(self, true) --[[@as string[] ]]
                        for i=1, #modules do
                            local curr <const> = modules[i]
                            rawset(self, curr, (curr == 'isFreezed' and IsEntityPositionFrozen or curr == 'model' and GetEntityModel or curr == 'populationType' and GetEntityPopulationType or curr == 'type' and GetEntityType or curr == 'isVisible' and IsEntityVisible or NetworkGetNetworkIdFromEntity)(GetPlayerPed(playerId)))
                        end

                        return rawget(self, k)
                    end
                })
            }, {
                __index = function(self, k)
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

                    return rawget(self, k)
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
    local playerId <const> = GetPlayerServerId(PlayerId())
    local p <const> = GetPlayerFromServerId(playerId)
    HRLib.IPlayer = setmetatable({
        source = playerId, id = playerId, Id = playerId, ID = playerId, playerId = playerId, player = playerId, serverId = playerId, plId = playerId, serverPlId = playerId, sPlId = playerId,
        state = LocalPlayer.state,
        max = setmetatable({
            stamina = GetPlayerMaxStamina(playerId),
            armour = GetPlayerMaxArmour(playerId),
            health = GetEntityMaxHealth(GetPlayerPed(p))
        }, {
            __index = function(self, k)
                if k == 'health' then
                    return GetEntityMaxHealth(GetPlayerPed(p))
                end

                return rawget(self, k)
            end
        }),
        name = GetPlayerName(GetPlayerFromServerId(playerId)),
        entity = setmetatable({
            archetypeName = GetEntityArchetypeName(p),
            model = GetEntityModel(p),
            mapdataOwner = { GetEntityMapdataOwner(p) },
            populationType = GetEntityPopulationType(p),
            type = GetEntityType(p)
        }, {
            __index = function(self, k)
                local modules <const> = HRLib.table.getKeys(self, true)
                if type(modules) == 'table' then
                    for i=1, #modules do
                        local curr <const> = modules[i]
                        rawset(self, curr, curr == 'mapdataOwner' and { GetEntityMapdataOwner(GetPlayerPed(p)) } or (curr == 'archeTypeName' and GetEntityArchetypeName or curr == 'model' and GetEntityModel or curr == 'populationType' and GetEntityPopulationType or GetEntityType)(GetPlayerPed(p)))
                    end
                end

                return rawget(self, k)
            end
        })
    }, {
        __index = function(self, k)
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

            return rawget(self, k)
        end
    }) --[[@as HRLibClientIPlayer]]
end