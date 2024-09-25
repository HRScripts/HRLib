local resName <const> = GetCurrentResourceName()
local hrlib <const>, clib <const>, _ <const> = load(LoadResourceFile(resName, 'server/modules/functions.lua'), '@@hrlib/server/modules/functions.lua')()

-- Events

AddEventHandler('onResourceStart', function(resource)
    if resource == resName and resource ~= 'HRLib' then
        warn(('^HRLib^3 is with different name (^1%s^3)! Please change this name because this will stop the working of all our resources!'):format(resName))

        for k,v in pairs(clib.RegisteredCmds) do
            if type(v.suggestions) == 'table' and table.type(v.suggestions) ~= 'empty' then
                TriggerEvent('chat:addSuggestion', ('/%s'):format(k), v.suggestions.help or '', v.suggestions.args or {})
            end
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == resName then
        warn('The restarting/stopping of ^5hrlib^3 is not recommended! You may have error at our other scripts and the commands from the other resources will not be registered!')
    end
end)

RegisterNetEvent('__HRLib:LoadCallback', function(empty, key, value)
    clib.ClientCallbacks[key] = empty and nil or value

    if clib.CallbacksPromises[key] then
        clib.CallbacksPromises[key]:resolve(not empty)
    end

    TriggerEvent(('__%s:Receive_clibValues'):format(resName), 'ClientCallbacks', key, value)
    TriggerEvent(('__%s:Receive_clibValues'):format(resName), 'CallbacksPromises', key, not empty)
end)

RegisterNetEvent('__HRLib:SendCallback', function(name, ...)
    if type(clib.Callbacks[name]) == 'function' or (type(clib.Callbacks[name]) == 'table' and clib.Callbacks[name]['__cfx_functionReference']) then
        TriggerClientEvent('__HRLib:LoadCallback', source, clib.Callbacks[name] == nil, name, table.pack(clib.Callbacks[name](source, ...)))
    else
        TriggerClientEvent('__HRLib:LoadCallback', source, clib.Callbacks[name] == nil, name, table.pack(clib.Callbacks[name]))
    end
end)

RegisterNetEvent('__HRLib:TransferCallback', function(resource, side, name, ...)
    if type(clib.Callbacks[name]) == 'function' or (type(clib.Callbacks[name]) == 'table' and clib.Callbacks[name]['__cfx_functionReference']) then
        if side == 'client' then
            TriggerClientEvent(('__%s:LoadHRLibCallback'):format(resource), source, clib.Callbacks[name] == nil, name, clib.Callbacks[name] ~= nil and table.pack(clib.Callbacks[name](...)) or nil)
        else
            TriggerEvent(('__%s:LoadHRLibCallback'):format(resource), clib.Callbacks[name] == nil, name, clib.Callbacks[name] ~= nil and table.pack(clib.Callbacks[name](...)) or nil)
        end
    else
        if side == 'client' then
            TriggerClientEvent(('__%s:LoadHRLibCallback'):format(resource), source, clib.Callbacks[name] == nil, name, clib.Callbacks[name] ~= nil and table.pack(clib.Callbacks[name]) or nil)
        else
            TriggerEvent(('__%s:LoadHRLibCallback'):format(resource), clib.Callbacks[name] == nil, name, clib.Callbacks[name] ~= nil and table.pack(clib.Callbacks[name]) or nil)
        end
    end
end)

RegisterNetEvent('__HRLib:Set_clibValues', function(parent, key, value)
    if IsDuplicityVersion() and GetInvokingResource() == 'HRLib' then
        clib[parent][key] = value
    end
end)

RegisterNetEvent('__HRLib:CommandsSuggestions', function()
    for k,v in pairs(clib.RegisteredCmds) do
        if type(v.suggestions) == 'table' and table.type(v.suggestions) ~= 'empty' then
            TriggerClientEvent('chat:addSuggestion', source, ('/%s'):format(k), v.suggestions.help or '', v.suggestions.args or {})
        end
    end
end)

RegisterNetEvent('__HRLib:StopMyself', function(resourceName, msgtype, msg)
    Wait(1000)

    if msgtype == 'warn' or msgtype == 'error' and type(msg) == 'string' then
        (msgtype == 'warn' and warn or error)(('%s: %s'):format(resourceName, msg))
    end

    StopResource(resourceName)
end)

-- Callbacks

hrlib.CreateCallback('__HRLib:allPlayers', true, function()
    return GetPlayers()
end)

-- Exports

exports('getLibFunctions', function()
    return hrlib
end)
