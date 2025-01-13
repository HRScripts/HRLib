local load, LoadResourceFile = load, LoadResourceFile
local hrlib <const>, clib <const>, fplayer <const>, config <const> = setmetatable({
    string = load(LoadResourceFile('HRLib', 'server/modules/string.lua'), '@@HRLib/server/modules/string.lua')(),
    table = load(LoadResourceFile('HRLib', 'server/modules/table.lua'), '@@HRLib/server/modules/table.lua')()
}, {
    __call = function(self)
        local exportableHRLib <const> = {}

        for k,v in pairs(self) do
            if k ~= 'require' or k:sub(1, 2) ~= 'On' or k ~= 'StopMyself' then
                exportableHRLib[k] = v
            end
        end

        return exportableHRLib
    end
}), load(LoadResourceFile('HRLib', 'server/modules/local.lua'), '@@HRLib/server/modules/local.lua')(), load(LoadResourceFile('HRLib', 'server/modules/fplayer.lua'), '@@HRLib/server/modules/fplayer.lua')(), load(LoadResourceFile('HRLib', 'config.lua'), ('@@%s/config.lua'):format('HRLib'))() --[[@as HRLibConfig]]

---@param webHook string URL of Discord WebHook bot
---@param botName string name of the bot
---@param title string title of the notification
---@param message string message of the notification
---@param type string? if type nil then type is rich
---@param color number color of the message
---@param icon string URL of an image
---@param author string author of the message
---@changelog version 1.0.0
---@version 1.0.0
hrlib.DiscordMsg = function(webHook, botName, title, message, type, color, icon, author)
    local Bot <const> = webHook or config.defaultWebHook

    if not Bot then return end

    type = not type and 'rich' or type
    color = not color and 555555 or color
    icon = (not tostring(icon):sub(1, 8) == 'https://' or tostring(icon):sub(1, 8) == 'http://') and '' or icon
    author = not author and '' or author
    title = not title and '' or title

    local msg <const> = message
    PerformHttpRequest(Bot, function()end, 'POST', json.encode({ username = botName or 'Information', embeds = {
        {
            title = title,
            type = type,
            color = color,
            description = msg,
            footer = {
                text = author,
                icon_url = icon
            }
        }
    }}), { ['Content-Type'] = 'application/json' })
end

---@param playerId integer existing player server Id
---@param identifier string|'all'|table identifier type. Identifier types: steam ; license ; licens2 ; fivem ; discord ; xbl ; live ; ip . It's a table when you want to get multiple of identifiers. Example: hrlib.PlayerIdentifier(playerId, { 'steam', 'license', 'discord' }). You can also set the `identifier` param to ` 'all' ` to get every identifier
---@param removeNames boolean? remove the name(s) of the identifier(s)
---@param isArray boolean? return the IDs as array or not
---@changelog version 1.0.0, version 2.0.0
---@version 2.0.0
---@return ...|string?
hrlib.PlayerIdentifier = function(playerId, identifier, removeNames, isArray)
    if clib.DoesIdExist(playerId) or GetPlayerIdentifierByType(tostring(playerId), 'license') ~= nil then
        if type(identifier) == 'table' then
            if #identifier == 0 then return end

            local identifiers <const> = {}

            for i=1, #identifier do
                if string.find('steam license license2 discord xbl ip live fivem', identifier[i], nil, true) then
                    identifiers[i] = clib.PlI(tonumber(playerId), identifier[i])

                    if removeNames then
                        identifiers[i] = hrlib.string.split(identifiers[i], ':', 'string', true)[2]
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
                    local _ <const>, identity <const> = hrlib.string.split(GetPlayerIdentifier(playerId, i), ':') ---@diagnostic disable-line: deprecated, param-type-mismatch

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
            local currIdentity = clib.PlI(tonumber(playerId), identifier)

            if removeNames then
                currIdentity = hrlib.string.split(currIdentity, ':', 'string', true)[2]
            end

            return isArray and { currIdentity } or currIdentity
        end
    end
end

---@param playerId integer existing player server Id
---@param identifier integer|'all'|table identifier index ( 0-7 ). It's a table when you want to get multiple of identifiers. Example: hrlib.PlayerIdentifier(playerId, { 'steam', 'license', 'discord' }); You can also add
---@param removeNames boolean? remove the name(s) of the identifier(s)
---@param isArray boolean? return the IDs as array or not
---@changelog version 1.0.0, version 2.0.0
---@version 2.0.0
---@return ...|string?
hrlib.PlayerIdentifierByIndex = function(playerId, identifier, removeNames, isArray)
    if type(identifier) == 'table' then
        if playerId == nil or identifier == nil or playerId == '' or #identifier > 8 then return end

        local identifiers <const> = {}

        for i=1, #identifier do
            if identifier[i] > 8 or type(identifier[i]) ~= 'number' then return end

            identifiers[i] = GetPlayerIdentifier(tonumber(playerId), identifier[i]) ---@diagnostic disable-line: deprecated, param-type-mismatch

            if removeNames then
                identifiers[i] = hrlib.string.split(identifiers[i], ':', 'string', true)
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
                local _ <const>, identity <const> = hrlib.string.split(GetPlayerIdentifier(playerId, i), ':') ---@diagnostic disable-line: deprecated, param-type-mismatch

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
            local identity <const> = hrlib.string.split(GetPlayerIdentifier(tostring(playerId), identifier --[[@as integer]]), ':', 'string', true)

            if isArray then
                return { identity }
            else
                return identity
            end
        else
            return isArray and { GetPlayerIdentifier(tostring(playerId), identifier --[[@as integer]]) } or GetPlayerIdentifier(tostring(playerId), identifier --[[@as integer]])
        end
    end
end

---@param identifier string
---@return integer?
hrlib.PlayerServerIdByIdentifier = function(identifier)
    if type(identifier) ~= 'string' or not string.find(identifier, ':', nil, true) then return nil end

    local prefix <const>, _ <const> = clib.splitString(identifier, ':')

    if not string.find('steam fivem license license2 ip xbl live discord', prefix, nil, true) then return nil end

    local pls <const> = GetPlayers()
    for i=1, #pls do
        local curr <const> = tonumber(pls[i])
        if clib.PlI(curr, prefix) == identifier then
            return curr
        end
    end
end

---@param playerId integer existing player server Id
---@changelog version 1.0.0
---@version 1.0.0
---@return HRLibServerIPlayer?
hrlib.GetIPlayer = function(playerId)
    return clib.GetIPlayer(tonumber(playerId))
end

---@param playerId integer existing player server Id
---@changelog version 1.0.0
---@version 1.0.0
---@return HRLibServerFPlayer?
hrlib.GetFPlayer = function(playerId)
    if hrlib.DoesIdExist(playerId) then ---@diagnostic disable-line: deprecated
        return fplayer:newObject(playerId)
    end
end

---@param vehModel string|integer existing vehicle model in string format like futo or in hash format
---@param coords vector4 vehicle spawn coordinates
---@changelog version 1.0.0, version 1.1.0, version 1.2.0
---@version 1.2.0 removed the 
---@return integer?
hrlib.SpawnVehicle = function(vehModel, coords)
    if not vehModel or not coords then return nil end

    local model <const> = type(vehModel) == 'string' and joaat(vehModel) or vehModel

    return CreateVehicle(model, coords, true, true) ---@diagnostic disable-line: missing-parameter, param-type-mismatch
end

---@param playerId integer
---@param coords vector3
---@changelog version 1.0.0
---@version 1.0.0
hrlib.Teleport = function(playerId, coords)
    if playerId == nil then return end

    SetEntityCoords(GetPlayerPed(playerId), coords) ---@diagnostic disable-line: missing-parameter, param-type-mismatch
end

---@param playerId integer An existing player server Id
---@param toggle any
---@changelog version 1.0.0
---@version 1.0.0
hrlib.Freeze = function(playerId, toggle)
    TriggerClientEvent('HRLib:freeze', playerId, toggle)
end

---@type fun(playerId: integer, msg: string, type: string, time: number, pos: 'top-right'|'center-right'|'bottom-right'|'frombelow-right'|'top-left'|'left-center'|'frombelow-left'?, sound: boolean?)
hrlib.Notify = clib.Notify

---@return table
---@changelog version 1.0.0
---@version 1.0.0
hrlib.AllIPlayers = function()
    local allIPlayers <const> = {}

    local pls <const> = GetPlayers()
    for i=1, #pls do
        allIPlayers[#allIPlayers+1] = clib.GetIPlayer(tonumber(pls[i]))
    end

    return allIPlayers
end

---@return table
---@changelog version 1.0.0
---@version 1.0.0
hrlib.AllFPlayers = function()
    local allFPlayers <const> = {}

    local pls <const> = GetPlayers()
    for i=1, #pls do
        allFPlayers[#allFPlayers+1] = fplayer:newObject(tonumber(pls[i]))
    end

    return allFPlayers
end

---@param playerId integer player server Id
---@changelog version 1.0.0
---@version 1.0.0
---@return boolean?
hrlib.DoesIdExist = function(playerId)
    return clib.DoesIdExist(playerId)
end

---@param name string the name of the command
---@param accessFromConsole boolean allow access to the command from the console
---@param accessFromInGame boolean allow access to the command from the game
---@param cb fun(args: string[]|any[], rawCommand: any, IPlayer: HRLibServerIPlayer, FPlayer: HRLibServerFPlayer) return values: args, rawCommand, IPlayer, FPlayer
---@param isPlayerAllowed boolean? only ace allowed players can access the command ( command.cmdName )
---@param suggestions { help: string?, restricted: boolean?, args: table[]? }? table format: {help = 'STRING', args = { {name = 'STRING', help = 'STRING'} } }
---@changelog version 1.0.0, version 2.0.0
---@version 2.0.0 optimazed & made more secured
hrlib.RegCommand = function(name, accessFromConsole, accessFromInGame, cb, isPlayerAllowed, suggestions)
    suggestions = type(suggestions) == 'table' and suggestions or {}
    local commandExists

    local commands <const> = GetRegisteredCommands()
    for i=1, #commands do
        if commands[i].name == name and type(clib.RegisteredCmds[name]) == 'nil' then
            commandExists = true
            break
        end
    end

    if not commandExists then
        if type(name) ~= 'string' or not accessFromConsole and not accessFromInGame then
            return
        end

        if not isPlayerAllowed then
            isPlayerAllowed = false
        end

        if clib.RegisteredCmds[name] then
            clib.RegisteredCmds[name] = nil

            TriggerClientEvent('chat:removeSuggestion', -1, '/'..name)
        end

        clib.RegisteredCmds[name] = {accessFromConsole = accessFromConsole, accessFromInGame = accessFromInGame, cb = cb, isPlayerAllowed = isPlayerAllowed, suggestions = suggestions}

        if type(suggestions) == 'table' and table.type(suggestions) ~= 'empty' then
            if not isPlayerAllowed then
                TriggerClientEvent('chat:addSuggestion', -1, '/'..name, suggestions.help or '', suggestions.args or {})
            else
                local players <const> = GetPlayers()
                for i=1, #players do
                    if IsPlayerAceAllowed(players[i], name) then
                        TriggerClientEvent('chat:addSuggestion', tonumber(players[i]) --[[@as integer]], '/'..name, suggestions.help or '', suggestions.args or {})
                    end
                end
            end
        end

        RegisterCommand(name, function(source, args, rawCommand)
            if accessFromConsole and not accessFromInGame then
                if source ~= 0 then
                    clib.Notify(source, 'You cannot use this command from the game!', 'error', 2500)
                    return
                end

                local IPlayer <const>, FPlayer <const> = {
                    id = source, playerId = source, source = source, Id = source, serverId = source,
                    name = 'TxAdmin Console'
                }, {}

                function FPlayer:Notify(text, type)
                    if not text then return end
                    if not type then type = 'info' end

                    if type == 'success' then
                        print(('^2! SUCCESS ! %s^0'):format(text))
                    elseif type == 'error' then
                        print(('^1! ERROR ! %s^0'):format(text))
                    elseif type == 'warning' or type == 'warn' then
                        print(('^3! WARNING ! %s^0'):format(text))
                    elseif type == 'info' then
                        print(('^5! INFO ! %s^0'):format(text))
                    end
                end

                cb(args, rawCommand, IPlayer, FPlayer)
            elseif not accessFromConsole and accessFromInGame then
                if source == 0 then
                    print('^1! ERROR ! You cannot use this command from the console!^0')
                    return
                end

                if not isPlayerAllowed or IsPlayerAceAllowed(source, 'command.'..name) == 1 then
                    cb(args, rawCommand, clib.GetIPlayer(source), hrlib.GetFPlayer(source) --[[@as HRLibServerFPlayer]]) ---@diagnostic disable-line: deprecated
                end
            elseif accessFromConsole and accessFromInGame then
                if not isPlayerAllowed then
                    local IPlayer <const>, FPlayer <const> = clib.GetIPlayer(source) or {
                        id = source, playerId = source, source = source, Id = source, serverId = source,
                        name = 'TxAdmin Console'
                    }, hrlib.GetFPlayer(source) or {} ---@diagnostic disable-line: deprecated

                    if table.type(FPlayer) == 'empty' then
                        function FPlayer:Notify(text, type)
                            if not text then return end
                            if not type then type = 'info' end

                            if type == 'success' then
                                print(('^2! SUCCESS ! %s^0'):format(text))
                            elseif type == 'error' then
                                print(('^1! ERROR ! %s^0'):format(text))
                            elseif type == 'warning' or type == 'warn' then
                                print(('^3! WARNING ! %s^0'):format(text))
                            elseif type == 'info' then
                                print(('^5! INFO ! %s^0'):format(text))
                            end
                        end
                    end

                    cb(args, rawCommand, IPlayer, FPlayer)
                elseif isPlayerAllowed and source ~= 0 then
                    if IsPlayerAceAllowed(source, 'command.'..name) == 1 then
                        cb(args, rawCommand, clib.GetIPlayer(source), hrlib.GetFPlayer(source) --[[@as HRLibServerFPlayer]]) ---@diagnostic disable-line: deprecated
                    end
                elseif isPlayerAllowed and source == 0 then
                    local IPlayer <const>, FPlayer <const> = {
                        id = source, playerId = source, source = source, Id = source, serverId = source,
                        name = 'TxAdmin Console'
                    }, {}

                    function FPlayer:Notify(text, type)
                        if not text then return end
                        if not type then type = 'info' end

                        if type == 'success' then
                            print(('^2! SUCCESS ! %s^0'):format(text))
                        elseif type == 'error' then
                            print(('^1! ERROR ! %s^0'):format(text))
                        elseif type == 'warning' or type == 'warn' then
                            print(('^3! WARNING ! %s^0'):format(text))
                        elseif type == 'info' then
                            print(('^5! INFO ! %s^0'):format(text))
                        end
                    end

                    cb(args, rawCommand, IPlayer, FPlayer)
                end
            end
        end, type(suggestions.restricted) == 'boolean' and suggestions.restricted or false)
    end
end

if GetCurrentResourceName() == 'HRLib' then
    ---@param name string the callback name
    ---@param isLocal boolean? By default it's false
    ---@param cb any the callback value
    hrlib.CreateCallback = function(name, isLocal, cb)
        if type(name) ~= 'string' or type(cb) == 'nil' then return end

        clib.Callbacks[name] = cb
    end

    ---@param name string the callback name
    ---@param ... any
    ---@return any?
    hrlib.Callback = function(name, ...)
        local callback = clib.Callbacks[name]

        if callback == nil then return end

        if type(callback) == 'function' or (type(callback) == 'table' and callback['__cfx_functionReference']) then
            return callback(false, ...)
        else
            return callback
        end
    end

    ---@param name string the callback name
    ---@param playerId integer? An existing player server Id or nil (if nil, the player server Id will be set to -1 or if the player server Id does not exist, it will be set to -1)
    ---@param ... any?
    ---@return ...|any?
    hrlib.ClientCallback = function(name, playerId, ...)
        clib.CallbacksPromises[name] = promise.new()

        local callback

        TriggerClientEvent('__HRLib:SendCallback', clib.DoesIdExist(playerId --[[@as integer]]) and playerId or -1, name, ...)
        Citizen.Await(clib.CallbacksPromises[name])

        callback = clib.ClientCallbacks[name]

        if callback == nil then
            warn(('Resource ^2%s^3 tried to use non-existent client callback!'):format(GetInvokingResource()))

            return
        end

        return table.unpack(callback)
    end
end

---@param values any[]
---@param createRandomValue fun(): any
hrlib.RandomValueWithNoRepetition = function(values, createRandomValue)
    if type(createRandomValue) == 'function' then
        local randomValue = createRandomValue()
        local found

        for i=1, #values do
            if randomValue == values[i] then
                found = true
            end
        end

        if found then
            while found do
                randomValue = createRandomValue()

                for i=1, #values do
                    if randomValue == values[i] then
                        found = true
                    end
                end

                Wait(0)
            end
        end

        return randomValue
    end
end

hrlib.AllWeapons = clib.allWeapons

local modules <const> = { 'bridge', 'import', 'string', 'table' }
for i=1, #modules do
    local curr <const> = modules[i]
    local module <const> = load(LoadResourceFile('HRLib', ('server/modules/%s.lua'):format(curr)), ('@@HRLib/server/modules/%s.lua'):format(curr))()
    if curr == 'bridge' then
        hrlib.bridge = module
    else
        if module then
            for k,v in pairs(module) do
                hrlib[k] = v
            end
        end
    end
end

return hrlib --[[@as HRLibServerFunctions]], clib, fplayer --[[@as HRLibServerFPlayer]]