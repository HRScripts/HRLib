local serverSide <const>, resName <const> = IsDuplicityVersion(), GetCurrentResourceName()
local hrlib <const>, clib <const>, _ <const> = load(LoadResourceFile('HRLib', ('%s/modules/functions.lua'):format(serverSide and 'server' or 'client')), ('@@HRLib/%s/modules/functions.lua'):format(serverSide and 'server' or 'client'))()
local loadCallback <const>, sendCallback <const> = ('__%s:LoadHRLibCallback'):format(resName), ('__%s:SendHRLibCallback'):format(resName)
local hrlibExport = exports.HRLib:getLibFunctions()
hrlib.showTextUI = hrlibExport.showTextUI
hrlib.isTextUIOpen = hrlibExport.isTextUIOpen
hrlib.hideTextUI = hrlibExport.hideTextUI
hrlib.progressBar = hrlibExport.progressBar
hrlib.createAlertDialogue = hrlibExport.createAlertDialogue
hrlib.createInputDialogue = hrlibExport.createInputDialogue

---@param name string the callback name
---@param isLocal boolean? By default it's false
---@param cb any the callback value
---@changelog version 1.0.0
---@version 1.0.0
hrlib.CreateCallback = function(name, isLocal, cb)
    if type(name) ~= 'string' or cb == nil then return end

    clib.Callbacks[name] = cb

    if not isLocal then
        TriggerEvent('__HRLib:LoadCallback', name, cb)
    end
end

---@param name string the callback name
---@param ... any
---@changelog version 1.0.0
---@version 1.0.0
---@return any?
hrlib.Callback = function(name, ...)
    local callback = clib.Callbacks[name]

    if callback == nil then
        if resName ~= 'HRLib' then
            clib.CallbacksPromises[name] = promise.new()

            TriggerEvent('__HRLib:TransferCallback', resName, 'client', name)
            Citizen.Await(clib.CallbacksPromises[name])

            callback = clib.Callbacks[name]

            if callback == nil then return end
        else
            return
        end
    end

    if type(callback) == 'function' or (type(callback) == 'table' and callback['__cfx_functionReference']) then
        return callback(...)
    else
        return callback
    end
end

if serverSide then
    local NUICallbacks <const> = {}

    ---@param name string the callback name
    ---@param playerId integer? An existing player server Id or nil (if nil, the player server Id will be set to -1 or if the player server Id does not exist, it will be set to -1)
    ---@param ... any?
    ---@return ...|any?
    hrlib.ClientCallback = function(name, playerId, ...)
        clib.CallbacksPromises[name] = promise.new()

        local callback

        if resName ~= 'HRLib' then
            TriggerClientEvent(sendCallback, clib.DoesIdExist(playerId --[[@as integer]]) and playerId or -1, name, ...)
            Citizen.Await(clib.CallbacksPromises[name])

            callback = clib.ClientCallbacks[name]

            if callback == nil then
                TriggerClientEvent('__HRLib:TransferCallback', clib.DoesIdExist(playerId --[[@as integer]]) and playerId or -1, resName, 'server', name, ...)
                Citizen.Await(clib.CallbacksPromises[name])

                callback = clib.ClientCallbacks[name]
            end
        else
            TriggerClientEvent('__HRLib:SendCallback', clib.DoesIdExist(playerId --[[@as integer]]) and playerId or -1, name, ...)
            Citizen.Await(clib.CallbacksPromises[name])

            callback = clib.ClientCallbacks[name]
        end

        if callback == nil then
            warn(resName == 'HRLib' and ('Resource ^2%s^3 tried to use non-existent client callback!'):format(GetInvokingResource()) or 'This resource tried to use non-existent client callback!')

            return
        end

        return table.unpack(callback)
    end

    RegisterNetEvent(loadCallback, function(empty, key, value)
        clib.ClientCallbacks[key] = empty and nil or value

        if clib.CallbacksPromises[key] then
            clib.CallbacksPromises[key]:resolve(not empty)
        end
    end)

    RegisterNetEvent(sendCallback, function(name, ...)
        if type(clib.Callbacks[name]) == 'function' or (type(clib.Callbacks[name]) == 'table' and clib.Callbacks[name]['__cfx_functionReference']) then
            TriggerClientEvent(loadCallback, source, clib.Callbacks[name] == nil, name, clib.Callbacks[name] ~= nil and table.pack(clib.Callbacks[name](source, ...)) or nil)
        else
            TriggerClientEvent(loadCallback, source, clib.Callbacks[name] == nil, name, clib.Callbacks[name] ~= nil and table.pack(clib.Callbacks[name]) or nil)
        end
    end)

    RegisterNetEvent(('__%s:CommandsSuggestions'):format(resName), function()
        for k,v in pairs(clib.RegisteredCmds) do
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

    RegisterNetEvent(('__%s:Set_clibValues'):format(resName), function(parent, key, value)
        if IsDuplicityVersion() and GetInvokingResource() == resName then
            if parent == 'CallbacksPromises' then
                clib.CallbacksPromises[key] = promise.new()
            else
                clib[parent][key] = value
            end
        end
    end)

    RegisterNetEvent(('__%s:getNUIValue'):format(resName), function(key, value)
        if not NUICallbacks[source] then
            NUICallbacks[source] = { [key] = value }
        else
            NUICallbacks[source][key] = value
        end
    end)

    hrlib.CreateCallback(('__%s:HRLibDoesIdExist'):format(resName), true, function(_, playerId) ---@diagnostic disable-line: deprecated
        return clib.DoesIdExist(playerId) or false
    end)

    hrlib.CreateCallback(('__%s:allPlayers'):format(resName), true, function() ---@diagnostic disable-line: deprecated
        return GetPlayers()
    end)

    hrlib.OnStart(nil, function()
        for k,v in pairs(clib.RegisteredCmds) do
            if type(v.suggestions) == 'table' and table.type(v.suggestions) ~= 'empty' then
                TriggerClientEvent('chat:addSuggestion', -1, ('/%s'):format(k), v.suggestions.help or '', v.suggestions.args or {})
            end
        end
    end)

    hrlib.GetNUICallback = function(playerId, key)
        return NUICallbacks[playerId]?[key]
    end
else
    local NUICallbacks <const> = setmetatable({}, {
        __newindex = function(self, k, v)
            TriggerServerEvent(('__%s:getNUIValue'):format(resName), k, v)
        end
    })

    ---@param name string the callback name
    ---@param ... any
    ---@changelog version 1.0.0
    ---@version 1.0.0
    ---@return ...|any?
    hrlib.ServerCallback = function(name, ...)
        clib.CallbacksPromises[name] = promise.new()

        local callback

        if resName == 'HRLib' then
            TriggerServerEvent('__HRLib:SendCallback', name, ...)
            Citizen.Await(clib.CallbacksPromises[name])

            callback = clib.ServerCallbacks[name]

            if callback == nil then return end
        else
            TriggerServerEvent(sendCallback, name, ...)
            Citizen.Await(clib.CallbacksPromises[name])

            callback = clib.ServerCallbacks[name]

            if callback == nil then
                TriggerServerEvent('__HRLib:TransferCallback', resName, 'client', name, ...)
                Citizen.Await(clib.CallbacksPromises[name])

                callback = clib.ServerCallbacks[name]

                if callback == nil then return end
            end
        end

        if callback == nil then
            warn(resName == 'HRLib' and ('Resource ^2%s^3 tried to use non-existent client callback!'):format(GetInvokingResource()) or 'This resource tried to use non-existent client callback!')

            return
        end

        return table.unpack(callback)
    end

    RegisterNetEvent(loadCallback, function(empty, key, value)
        clib.ServerCallbacks[key] = empty and nil or value

        if clib.CallbacksPromises[key] then
            clib.CallbacksPromises[key]:resolve(not empty)
        end
    end)

    RegisterNetEvent(sendCallback, function(name, ...)
        if type(clib.Callbacks[name]) == 'function' or (type(clib.Callbacks[name]) == 'table' and clib.Callbacks[name]['__cfx_functionReference']) then
            TriggerServerEvent(loadCallback, clib.Callbacks[name] == nil, name, clib.Callbacks[name] ~= nil and table.pack(clib.Callbacks[name](...)) or nil)
        else
            TriggerServerEvent(loadCallback, clib.Callbacks[name] == nil, name, clib.Callbacks[name] ~= nil and table.pack(clib.Callbacks[name]) or nil)
        end
    end)

    hrlib.CreateCallback(('__%s:AllVehicleModels'):format(resName), true, function() ---@diagnostic disable-line: deprecated
        return GetAllVehicleModels()
    end)

    hrlib.OnPlSpawn(function()
        TriggerServerEvent(('__%s:CommandsSuggestions'):format(resName))

        for k,v in pairs(clib.RegisteredCmds) do
            if type(v.suggestions) == 'table' and table.type(v.suggestions) ~= 'empty' then
                TriggerEvent('chat:addSuggestion', ('/%s'):format(k), v.suggestions.help or '', v.suggestions.args or {})
            end
        end
    end)

    hrlib.OnStart(nil, function()
        for k,v in pairs(clib.RegisteredCmds) do
            if type(v.suggestions) == 'table' and table.type(v.suggestions) ~= 'empty' then
                TriggerEvent('chat:addSuggestion', ('/%s'):format(k), v.suggestions.help or '', v.suggestions.args or {})
            end
        end
    end)

    ---@param key string
    hrlib.getNUIValue = function(key)
        return NUICallbacks[key]
    end

    RegisterNUICallback('lib:loadCallback', function(data)
        if type(data) == 'table' then
            for k,v in pairs(data) do
                NUICallbacks[k] = v
            end
        end
    end)
end

HRLib = hrlib

if not GetResourceMetadata(resName, 'remove_translator_import', 0) then
    hrlib.require('@HRLib/translator.lua')
end

if IsDuplicityVersion() then
    if not GetResourceMetadata(resName, 'remove_versionCheck', 0) then
        local repository, matchCode <const> = GetResourceMetadata(resName, 'repository', 0), '%d+%.%d+%.%d+'
        if type(repository) == 'string' then
            repository = repository:sub(#repository - #'https://github.com/', #repository)
            if repository:find('/') then
                local currVersion <const> = (GetResourceMetadata(resName, 'version', 0) or ''):match(matchCode)
                if currVersion then
                    SetTimeout(1500, function()
                        PerformHttpRequest(('https://api.github.com/repos%s/releases/latest'):format(repository), function(status, body)
                            if status ~= 200 then return end

                            body = json.decode(body)

                            if not body.prerelease then
                                local latestVersion <const> = body.tag_name:match(matchCode)

                                if not latestVersion or latestVersion == currVersion then return end

                                if tonumber(hrlib.string.gather(HRLib.string.split(latestVersion, '.', nil, true), '')) > tonumber(hrlib.string.gather(HRLib.string.split(currVersion, '.', nil, true), '')) then
                                    print(('^3The resource %s is outdated. Current version: %s. Please update it! \nURL: %s^0'):format(resName, currVersion, body.html_url))
                                end
                            end
                        end)
                    end)
                end
            end
        end
    end
end