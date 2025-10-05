local resName <const> = GetCurrentResourceName()
if IsDuplicityVersion() then
    ---Function to register a server side command with some additional parameters
    ---@param name string|string[] the name of the command
    ---@param accessFromConsole boolean allow access to the command from the console
    ---@param accessFromInGame boolean allow access to the command from the game
    ---@param cb fun(args: string[]|{}, rawCommand: any, IPlayer: HRLibServerIPlayer|table, FPlayer: HRLibServerFPlayer)
    ---@param suggestions { help: string?, restricted: boolean?, args: { name: string, help: string }[]? }?
    HRLib.RegCommand = function(name, accessFromConsole, accessFromInGame, cb, suggestions)
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
            if type(name) ~= 'string' or type(name) == 'table' and table.type(name) ~= 'array' or not accessFromConsole and not accessFromInGame then
                return warn(('^1%s^3 tried to register a client command ^1without^3 name!^0'):format(resName == 'HRLib' and GetInvokingResource() or resName))
            end

            if HRLib.registeredCmds[name] then
                HRLib.registeredCmds[name] = nil

                TriggerClientEvent('chat:removeSuggestion', -1, '/'..name)
            end

            HRLib.registeredCmds[name] = {accessFromConsole = accessFromConsole, accessFromInGame = accessFromInGame, cb = cb, suggestions = suggestions}

            if type(suggestions) == 'table' and table.type(suggestions) ~= 'empty' then
                if not suggestions.isRestricted then
                    TriggerClientEvent('chat:addSuggestion', -1, '/'..name, suggestions.help or '', (type(suggestions.args) == 'table' and table.type(suggestions.args) == 'array') and suggestions.args or {})
                else
                    local players <const> = GetPlayers()
                    for i=1, #players do
                        if IsPlayerAceAllowed(players[i], name) then
                            TriggerClientEvent('chat:addSuggestion', tonumber(players[i]) --[[@as integer]], '/'..name, suggestions.help or '', (type(suggestions.args) == 'table' and table.type(suggestions.args) == 'array') and suggestions.args or {})
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

                    cb(args, rawCommand, HRLib.GetIPlayer(source) --[[@as HRLibServerIPlayer]], HRLib.GetFPlayer(source) --[[@as HRLibServerFPlayer]])
                elseif accessFromConsole and accessFromInGame then
                    local IPlayer <const>, FPlayer <const> = HRLib.GetIPlayer(source) or {
                        id = source, playerId = source, source = source, Id = source, serverId = source,
                        name = 'TxAdmin Console'
                    }, HRLib.GetFPlayer(source) or {}

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
                end
            end
            local isRestricted <const> = type(suggestions.restricted) == 'boolean' and suggestions.restricted or false
            if type(name) == 'string' and name ~= '' then
                RegisterCommand(name, regCmdFn, isRestricted)
            else
                for i=1, #name do
                    if type(name[i]) == 'string' and name[i] ~= '' and not string.find(name, ' ') then
                        RegisterCommand(name[i], regCmdFn, isRestricted)
                    end
                end
            end
        end
    end

    RegisterNetEvent(('__%s:CommandsSuggestions'):format(resName), function()
        for k,v in pairs(HRLib.registeredCmds) do
            if type(v.suggestions) == 'table' and table.type(v.suggestions) ~= 'empty' then
                if not v.suggestions.restricted then
                    TriggerClientEvent('chat:addSuggestion', source, ('/%s'):format(k), v.suggestions.help or '', (type(v.suggestions.args) == 'table' and table.type(v.suggestions.args) == 'array') and v.suggestions.args or {})
                else
                    if IsPlayerAceAllowed(source, ('command.%s'):format(k)) then
                        TriggerClientEvent('chat:addSuggestion', source, ('/%s'):format(k), v.suggestions.help or '', (type(v.suggestions?.args) == 'table' and table.type(v.suggestions?.args) == 'array') and v.suggestions?.args or {})
                    end
                end
            end
        end
    end)
else
    ---Function to register a client side command with some additional options
    ---@param name string|string[]
    ---@param cb fun(args: string[]|{}, rawCommand: any)
    ---@param suggestions { help: string?, args: { name: string, help: string }[]? }?
    HRLib.RegCommand = function(name, cb, suggestions)
        suggestions = type(suggestions) == 'table' and suggestions or {}

        if type(name) ~= 'string' or name == '' or type(name) == 'table' and table.type(name) ~= 'array' then
            return warn(('^1%s^3 tried to register a client command ^1without^3 name!^0'):format(resName == 'HRLib' and GetInvokingResource() or resName))
        end

        if HRLib.registeredCmds[name] then
            TriggerEvent('chat:removeSuggestion', ('/%s'):format(name))
        end

        HRLib.registeredCmds[name] = { cb = cb, suggestions = type(suggestions) == 'table' and suggestions }

        TriggerEvent('chat:addSuggestion', ('/%s'):format(name), suggestions.help or '', (type(suggestions.args) == 'table' and table.type(suggestions.args) == 'array') and suggestions.args or {})

        local callback = function(_, args, rawCommand)
            cb(args, rawCommand)
        end

        if type(name) == 'string' then
            RegisterCommand(name, callback, false)
        else
            for i=1, #name do
                if type(name[i]) == 'string' and name[i] ~= '' then
                    RegisterCommand(name[i], callback, false)
                end
            end
        end
    end

    AddEventHandler('playerSpawned', function()
        while not IsEntityOnScreen(PlayerPedId()) do
            Wait(100)
        end

        TriggerServerEvent(('__%s:CommandsSuggestions'):format(resName))

        for k,v in pairs(HRLib.registeredCmds) do
            if type(v.suggestions) == 'table' and table.type(v.suggestions) ~= 'empty' then
                TriggerEvent('chat:addSuggestion', ('/%s'):format(k), v.suggestions.help or '', (type(v.suggestions.args) == 'table' and table.type(v.suggestions.args) == 'array') and v.suggestions.args or {})
            end
        end
    end)
end