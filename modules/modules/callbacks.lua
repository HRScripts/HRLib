local isHRLib <const>, isServer <const>, resName <const> = GetCurrentResourceName() == 'HRLib', IsDuplicityVersion(), GetCurrentResourceName()

-- Functions

---@param name string the callback name
---@param isLocal boolean? Make the callback local for the current resource or global (doesn't work on HRLib export method)
---@param cb fun(...: any): any|fun(source: integer, ...: any): any|any the callback value
HRLib.CreateCallback = function(name, isLocal, cb)
    if type(name) ~= 'string' or type(cb) == 'nil' then return end

    HRLib.callbacks[name] = cb

    if not isHRLib and not isLocal then
        TriggerEvent('__HRLib:LoadCallback', false, name, cb, true)
    end
end

if isServer then
    ---@param name string the callback name
    ---@param source integer?
    ---@param ... any
    ---@return any?
    HRLib.Callback = function(name, source, ...)
        local callback = HRLib.callbacks[name]

        if callback == nil then
            if not isHRLib then
                if HRLib.callbacksPromises[name] and (HRLib.callbacksPromises[name] --[[@as promise]]).state ~= 3 then
                    Citizen.Await(HRLib.callbacksPromises[name])
                end

                HRLib.callbacksPromises[name] = promise.new()

                TriggerEvent('__HRLib:TransferCallback', resName, 'client', name)
                Citizen.Await(HRLib.callbacksPromises[name])

                callback = HRLib.callbacks[name]

                if callback == nil then return end
            else
                return
            end
        end

        if type(callback) == 'function' or (type(callback) == 'table' and callback['__cfx_functionReference']) then
            return callback(source, ...)
        else
            return callback
        end
    end

    ---@param name string the callback name
    ---@param playerId integer? An existing player server Id or nil (if nil, the player server Id will be set to -1 or if the player server Id does not exist, it will be set to -1)
    ---@param ... any?
    ---@return ...|any?
    HRLib.ClientCallback = function(name, playerId, ...)
        if HRLib.callbacksPromises[name] and (HRLib.callbacksPromises[name] --[[@as promise]]).state ~= 3 then
            Citizen.Await(HRLib.callbacksPromises[name])
        end

        HRLib.callbacksPromises[name] = promise.new()

        local callback

        TriggerClientEvent(('__%s:SendCallback'):format(resName), HRLib.DoesIdExist(playerId --[[@as integer]]) and playerId or -1, name, ...)
        Citizen.Await(HRLib.callbacksPromises[name])

        callback = HRLib.clientCallbacks[name]

        if callback == nil and not isHRLib then
            TriggerClientEvent('__HRLib:TransferCallback', HRLib.DoesIdExist(playerId --[[@as integer]]) and playerId or -1, resName, 'server', name, ...)
            Citizen.Await(HRLib.callbacksPromises[name])

            callback = HRLib.clientCallbacks[name]
        end

        if callback == nil then
            warn(isHRLib and ('Resource ^2%s^3 tried to use non-existent client callback!'):format(GetInvokingResource()) or 'This resource tried to use non-existent client callback!')

            return
        end

        return table.unpack(callback)
    end
else
    ---@param name string the callback name
    ---@param ... any
    ---@return any?
    HRLib.Callback = function(name, ...)
        local callback = HRLib.callbacks[name]

        if callback == nil then
            if not isHRLib then
                HRLib.callbacksPromises[name] = promise.new()

                TriggerEvent('__HRLib:TransferCallback', resName, 'client', name)
                Citizen.Await(HRLib.callbacksPromises[name])

                callback = HRLib.callbacks[name]

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

    ---@param name string the callback name
    ---@param ... any
    ---@return ...|any?
    HRLib.ServerCallback = function(name, ...)
        if HRLib.callbacksPromises[name] and (HRLib.callbacksPromises[name] --[[@as promise]]).state ~= 3 then
            Citizen.Await(HRLib.callbacksPromises[name])
        end

        HRLib.callbacksPromises[name] = promise.new()

        TriggerServerEvent(('__%s:SendCallback'):format(resName), name, ...)
        Citizen.Await(HRLib.callbacksPromises[name])

        local callback = HRLib.serverCallbacks[name]

        if callback == nil then
            if not isHRLib then
                TriggerServerEvent('__HRLib:TransferCallback', resName, 'client', name, ...)
                Citizen.Await(HRLib.callbacksPromises[name])

                callback = HRLib.serverCallbacks[name]
            end

            if callback == nil then
                return warn(isHRLib and ('Resource ^2%s^3 tried to use non-existent client callback (%s)!'):format(GetInvokingResource(), name) or ('This resource tried to use non-existent client callback (%s)!'):format(name))
            end
        end

        return table.unpack(callback)
    end
end

-- Events

RegisterNetEvent(('__%s:LoadCallback'):format(resName), function(empty, key, value, isLoadOtherScriptCallback)
    HRLib[isLoadOtherScriptCallback and 'callbacks' or (isServer and 'clientCallbacks' or 'serverCallbacks')][key] = empty and nil or value
    if not isLoadOtherScriptCallback then
        if HRLib.callbacksPromises[key] then
            HRLib.callbacksPromises[key]:resolve(not empty)
        end
    end
end)

if isServer then
    RegisterNetEvent(('__%s:SendCallback'):format(resName), function(name, ...)
        local source, params = source, nil
        local callback <const> = HRLib.callbacks[name]

        if callback ~= nil then
            params = (type(callback) == 'function' or (type(callback) == 'table' and callback['__cfx_functionReference'])) and { false, name, { callback(source, ...) } } or { false, name, { callback } }
        else
            params = { true, name, nil }
        end

        TriggerClientEvent(('__%s:LoadCallback'):format(resName), source, table.unpack(params))
    end)
else
    RegisterNetEvent(('__%s:SendCallback'):format(resName), function(name, ...)
        local params
        local callback <const> = HRLib.callbacks[name]

        if callback ~= nil then
            params = (type(callback) == 'function' or (type(callback) == 'table' and callback['__cfx_functionReference'])) and { false, name, { callback(...) } } or { false, name, { callback } }
        else
            params = { true, name, nil }
        end

        TriggerServerEvent(('__%s:LoadCallback'):format(resName), table.unpack(params))
    end)
end

if isHRLib then
    RegisterNetEvent('__HRLib:TransferCallback', function(resource, side, name, ...)
        local evName <const>, isClient <const> = ('__%s:LoadHRLibCallback'):format(resource), side == 'client'
        local params <const> = (type(HRLib.callbacks[name]) == 'function' or (type(HRLib.callbacks[name]) == 'table' and HRLib.callbacks[name]['__cfx_functionReference'])) and { source, HRLib.callbacks[name] == nil, name, HRLib.callbacks[name] ~= nil and table.pack(HRLib.callbacks[name](...)) or nil } or { source, HRLib.callbacks[name] == nil, name, HRLib.callbacks[name] ~= nil and table.pack(HRLib.callbacks[name]) or nil }
        local triggerFn <const> = _G[isServer and (isClient and 'TriggerClientEvent' or 'TriggerEvent') or (isClient and 'TriggerEvent' or 'TriggerServerEvent')] --[[@as function]]
        triggerFn(evName, table.unpack(params, (isServer and isClient) and nil or 2))
    end)
end