local resName <const> = GetCurrentResourceName()
local hrlib <const>, clib <const>, _ <const> = load(LoadResourceFile('HRLib', 'client/modules/functions.lua'), '@@HRLib/client/modules/functions.lua')()

-- Events

RegisterNetEvent('__HRLib:LoadCallback', function(empty, key, value)
    clib.ServerCallbacks[key] = empty and nil or value

    if clib.CallbacksPromises[key] then
        clib.CallbacksPromises[key]:resolve(not empty)
    end

    TriggerEvent(('__%s:Receive_clibValues'):format(resName), 'ServerCallbacks', key, value)
    TriggerEvent(('__%s:Receive_clibValues'):format(resName), 'CallbacksPromises', key, not empty)
end)

RegisterNetEvent('__HRLib:SendCallback', function(name, ...)
    if type(clib.Callbacks[name]) == 'function' or (type(clib.Callbacks[name]) == 'table' and clib.Callbacks[name]['__cfx_functionReference']) then
        TriggerServerEvent('__HRLib:LoadCallback', clib.Callbacks[name] == nil, name, clib.Callbacks[name] ~= nil and table.pack(clib.Callbacks[name](...)) or nil)
    else
        TriggerServerEvent('__HRLib:LoadCallback', clib.Callbacks[name] == nil, name, clib.Callbacks[name] ~= nil and table.pack(clib.Callbacks[name]) or nil)
    end
end)

RegisterNetEvent('__HRLib:TransferCallback', function(resource, side, name, ...)
    local triggerEvent <const> = side == 'server' and TriggerServerEvent or TriggerEvent
    if type(clib.Callbacks[name]) == 'function' or (type(clib.Callbacks[name]) == 'table' and clib.Callbacks[name]['__cfx_functionReference']) then
        triggerEvent(('__%s:LoadHRLibCallback'):format(resource), clib.Callbacks[name] == nil, name, clib.Callbacks[name] ~= nil and table.pack(clib.Callbacks[name](...)) or nil)
    else
        triggerEvent(('__%s:LoadHRLibCallback'):format(resource), clib.Callbacks[name] == nil, name, clib.Callbacks[name] ~= nil and table.pack(clib.Callbacks[name]) or nil)
    end
end)

RegisterNetEvent('HRLib:freeze', function(toggle)
    local ped <const> = PlayerPedId()
    FreezeEntityPosition(ped, toggle)
    SetEntityCollision(ped, not toggle, false)
    SetEntityCanBeDamaged(ped, not toggle)
    SetPlayerControl(PlayerId(), not toggle) ---@diagnostic disable-line: missing-parameter
end)

RegisterNetEvent('HRLib:revive', function(ped, coords, heading)
    DoScreenFadeOut(300)

    while not IsScreenFadedOut() do
        Wait(60)
    end

    SetEntityCoordsNoOffset(ped, coords, false, false, false) ---@diagnostic disable-line: missing-parameter, param-type-mismatch
    NetworkResurrectLocalPlayer(coords, heading, true, false) ---@diagnostic disable-line: missing-parameter, param-type-mismatch
    DoScreenFadeIn(1000)
end)

RegisterNetEvent('HRLib:Notify', clib.Notify)

RegisterNetEvent('__HRLib:Set_clibValues', function(parent, key, value)
    if not IsDuplicityVersion() and GetInvokingResource() == 'HRLib' then
        clib[parent][key] = value
    end
end)

-- Callbacks

hrlib.CreateCallback('__HRLib:AllVehicleModels', true, function()
    return GetAllVehicleModels()
end)

hrlib.OnPlSpawn(function()
    TriggerServerEvent('__HRLib:CommandsSuggestions')

    for k,v in pairs(clib.RegisteredCmds) do
        if type(v.suggestions) == 'table' and table.type(v.suggestions) ~= 'empty' then
            TriggerEvent('chat:addSuggestion', ('/%s'):format(k), v.suggestions.help or '', v.suggestions.args or {})
        end
    end
end)

-- Exports

exports('getLibFunctions', function()
    return hrlib()
end)