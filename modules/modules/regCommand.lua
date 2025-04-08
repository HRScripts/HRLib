local resName <const> = GetCurrentResourceName()
if IsDuplicityVersion() then
    ---@param name string|string[] the name of the command
    ---@param accessFromConsole boolean allow access to the command from the console
    ---@param accessFromInGame boolean allow access to the command from the game
    ---@param cb fun(args: string[]|any[], rawCommand: any, IPlayer: HRLibServerIPlayer, FPlayer: HRLibServerFPlayer) return values: args, rawCommand, IPlayer, FPlayer
    ---@param isPlayerAllowed boolean? only ace allowed players can access the command ( command.cmdName )
    ---@param suggestions { help: string?, restricted: boolean?, args: { name: string, help: string }[]? }?
    HRLib.RegCommand = function(name, accessFromConsole, accessFromInGame, cb, isPlayerAllowed, suggestions)
        suggestions = type(suggestions) == 'table' and suggestions or {}
        local commandExists

        local commands <const> = GetRegisteredCommands()
        for i=1, #commands do
            if commands[i].name == name and type(HRLib.registeredCmds[name]) == 'nil' then
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

            if HRLib.registeredCmds[name] then
                HRLib.registeredCmds[name] = nil

                TriggerClientEvent('chat:removeSuggestion', -1, '/'..name)
            end

            HRLib.registeredCmds[name] = {accessFromConsole = accessFromConsole, accessFromInGame = accessFromInGame, cb = cb, isPlayerAllowed = isPlayerAllowed, suggestions = suggestions}

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

            local regCmdFn = function(source, args, rawCommand)
                if accessFromConsole and not accessFromInGame then
                    if source ~= 0 then
                        HRLib.Notify(source, 'You cannot use this command from the game!', 'error', 2500)
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
                        cb(args, rawCommand, HRLib.GetIPlayer(source) --[[@as HRLibServerIPlayer]], HRLib.GetFPlayer(source) --[[@as HRLibServerFPlayer]]) ---@diagnostic disable-line: deprecated
                    end
                elseif accessFromConsole and accessFromInGame then
                    if not isPlayerAllowed then
                        local IPlayer <const>, FPlayer <const> = HRLib.GetIPlayer(source) --[[@as HRLibServerIPlayer]] or {
                            id = source, playerId = source, source = source, Id = source, serverId = source,
                            name = 'TxAdmin Console'
                        }, HRLib.GetFPlayer(source) --[[@as HRLibServerFPlayer]] or {} ---@diagnostic disable-line: deprecated

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
                            cb(args, rawCommand, HRLib.GetIPlayer(source) --[[@as HRLibServerIPlayer]], HRLib.GetFPlayer(source) --[[@as HRLibServerFPlayer]]) ---@diagnostic disable-line: deprecated
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
            end
            local isRestricted <const> = type(suggestions.restricted) == 'boolean' and suggestions.restricted or false

            if type(name) == 'string' then
                RegisterCommand(name, regCmdFn, isRestricted)
            else
                for i=1, #name do
                    RegisterCommand(name[i], regCmdFn, isRestricted)
                end
            end
        end
    end

    RegisterNetEvent(('__%s:CommandsSuggestions'):format(resName), function()
        for k,v in pairs(HRLib.registeredCmds) do
            if type(v.suggestions) == 'table' and table.type(v.suggestions) ~= 'empty' then
                if not v.isPlayerAllowed then
                    TriggerClientEvent('chat:addSuggestion', source, '/'..k, v.suggestions.help or '', v.suggestions.args or {})
                else
                    if IsPlayerAceAllowed(source, k) then
                        TriggerClientEvent('chat:addSuggestion', source, '/'..k, v.suggestions.help or '', v.suggestions.args or {})
                    end
                end
            end
        end
    end)
else
    ---@param name string name of the command
    ---@param cb fun(args: string[]|any[], rawCommand: any, IPlayer: HRLibClientIPlayer, FPlayer: HRLibClientFPlayer) function arguments: args, rawCommand, IPlayer
    ---@param suggestion { help: string?, restricted: boolean?, args: table[]? }?
    HRLib.RegCommand = function(name, cb, suggestion)
        suggestion = type(suggestion) == 'table' and suggestion or {}

        if not name or name == '' then
            warn(('^1%s^3 tried to register a client command ^1without^3 name!^0'):format(GetInvokingResource()))
            return
        end

        if HRLib.registeredCmds[name] then
            TriggerEvent('chat:removeSuggestion', ('/%s'):format(name))
        end

        HRLib.registeredCmds[name] = { cb = cb, suggestions = suggestion }

        TriggerEvent('chat:addSuggestion', ('/%s'):format(name), suggestion.help or '', suggestion.args or {})

        RegisterCommand(name, function(_, args, rawCommand)
            local IPlayer <const> = HRLib.GetIPlayer(GetPlayerServerId(PlayerId())) --[[@as HRLibClientIPlayer? ]]

            if not IPlayer then return end

            cb(
                args,
                rawCommand,
                IPlayer,
                HRLib.GetFPlayer() --[[@as HRLibClientFPlayer]]
            )
        end, false)
    end

    AddEventHandler('playerSpawned', function(resource)
        if resource == resName then
            while not NetworkIsPlayerActive(PlayerId()) or IsScreenFadedOut() do
                Wait(100)
            end

            TriggerServerEvent(('__%s:CommandsSuggestions'):format(resName))

            for k,v in pairs(HRLib.registeredCmds) do
                if type(v.suggestions) == 'table' and table.type(v.suggestions) ~= 'empty' then
                    TriggerEvent('chat:addSuggestion', ('/%s'):format(k), v.suggestions.help or '', v.suggestions.args or {})
                end
            end
        end
    end)
end