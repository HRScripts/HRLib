---@type fun(playerSrc: integer, identifierType: string): string
local pli = GetPlayerIdentifierByType

---@param playerId integer existing player server Id
---@param identifier string|'all'|string[] identifier type. Identifier types: steam ; license ; licens2 ; fivem ; discord ; xbl ; live ; ip . It's a table when you want to get multiple of identifiers. Example: HRLib.PlayerIdentifier(playerId, { 'steam', 'license', 'discord' }). You can also set the `identifier` param to ` 'all' ` to get every identifier
---@param removeNames boolean? remove the name(s) of the identifier(s)
---@param isArray boolean? return the IDs as array or not
---@return ...|string?
HRLib.PlayerIdentifier = function(playerId, identifier, removeNames, isArray)
    if HRLib.DoesIdExist(playerId) or GetPlayerIdentifierByType(tostring(playerId), 'license') ~= nil then
        if type(identifier) == 'table' then
            if #identifier == 0 then return end

            local identifiers <const> = {}

            for i=1, #identifier do
                if string.find('steam license license2 discord xbl ip live fivem', identifier[i], nil, true) then
                    identifiers[i] = pli(tonumber(playerId) --[[@as integer]], identifier[i])

                    if removeNames then
                        identifiers[i] = HRLib.string.split(identifiers[i], ':', 'string', true)[2]
                    end
                end
            end

            if isArray then
                return identifiers
            else
                return table.unpack(identifiers)
            end
        elseif identifier == 'all' then
            local identifiers <const> = {}

            if removeNames then
                for i=0, GetNumPlayerIdentifiers(playerId)-1 do ---@diagnostic disable-line: param-type-mismatch
                    local _ <const>, identity <const> = HRLib.string.split(GetPlayerIdentifier(playerId, i), ':') ---@diagnostic disable-line: param-type-mismatch

                    identifiers[i == 0 and 1 or i+1] = identity
                end
            else
                for i=0, GetNumPlayerIdentifiers(playerId)-1 do ---@diagnostic disable-line: param-type-mismatch
                    identifiers[i == 0 and 1 or i+1] = GetPlayerIdentifier(playerId, i) ---@diagnostic disable-line: param-type-mismatch
                end
            end

            if isArray then
                return identifiers
            else
                return table.unpack(identifiers)
            end
        else
            local currIdentity = pli(tonumber(playerId) --[[@as integer]], identifier)

            if removeNames then
                currIdentity = HRLib.string.split(currIdentity, ':', 'string', true)[2] --[[@as string]]
            end

            return isArray and { currIdentity } or currIdentity
        end
    end
end

---@param playerId integer existing player server Id
---@param identifier integer|'all'|integer[] identifier index ( 0-7 ). It's a table when you want to get multiple of identifiers. Example: HRLib.PlayerIdentifier(playerId, { 'steam', 'license', 'discord' }); You can also add
---@param removeNames boolean? remove the name(s) of the identifier(s)
---@param isArray boolean? return the IDs as array or not
---@return ...|string?
HRLib.PlayerIdentifierByIndex = function(playerId, identifier, removeNames, isArray)
    if type(identifier) == 'table' then
        if playerId == nil or identifier == nil or playerId == '' or #identifier > 8 then return end

        local identifiers <const> = {}

        for i=1, #identifier do
            if identifier[i] > 8 or type(identifier[i]) ~= 'number' then return end

            identifiers[i] = GetPlayerIdentifier(tonumber(playerId), identifier[i]) ---@diagnostic disable-line: param-type-mismatch

            if removeNames then
                identifiers[i] = HRLib.string.split(identifiers[i], ':', 'string', true)
            end
        end

        if isArray then
            return identifiers
        else
            return table.unpack(identifiers)
        end
    elseif identifier == 'all' then
        if playerId == nil or identifier == nil or playerId == '' or identifier == '' then return end

        local identifiers <const>, plIdsCount <const> = {}, GetNumPlayerIdentifiers(tostring(playerId))-1

        if removeNames then
            for i=0, #plIdsCount do
                local _ <const>, identity <const> = HRLib.string.split(GetPlayerIdentifier(playerId, i), ':') ---@diagnostic disable-line: param-type-mismatch

                identifiers[i == 0 and 1 or i+1] = identity
            end
        else
            for i=0, #plIdsCount do
                identifiers[i == 0 and 1 or i+1] = GetPlayerIdentifier(tostring(playerId), i)
            end
        end

        if isArray then
            return identifiers
        else
            return table.unpack(identifiers)
        end
    else
        if playerId == nil or identifier == nil or playerId == '' or tonumber(identifier) > 8 then return end

        if removeNames then
            local identity <const> = HRLib.string.split(GetPlayerIdentifier(tostring(playerId), identifier --[[@as integer]]) or '', ':', 'string', true)?[2]
            if type(identity) == 'string' then
                if isArray then
                    return { identity }
                else
                    return identity
                end
            end
        else
            return isArray and { GetPlayerIdentifier(tostring(playerId), identifier --[[@as integer]]) } or GetPlayerIdentifier(tostring(playerId), identifier --[[@as integer]])
        end
    end
end

---@param identifier string
---@return integer?
HRLib.PlayerServerIdByIdentifier = function(identifier)
    local idType <const> = type(identifier) == 'string' and HRLib.string.split(identifier, ':', nil, true)?[1] --[[@as string]]

    local modules <const> = {'steam', 'fivem', 'license', 'license2', 'ip', 'xbl', 'live', 'discord'}
    if not HRLib.table.find(modules, idType) then return end

    local pls <const> = GetPlayers()
    for i=1, #pls do
        local curr <const> = tonumber(pls[i]) --[[@as integer]]
        if pli(curr, idType) == identifier then
            return curr
        end
    end
end