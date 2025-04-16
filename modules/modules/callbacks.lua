local isHRLib <const>, isServer <const>, resName <const> = GetCurrentResourceName() == 'HRLib', IsDuplicityVersion(), GetCurrentResourceName()

-- Functions

---@param name string the callback name
---@param isLocal boolean? Make the callback local for the current resource or global (doesn't work on HRLib export method)
---@param cb any the callback value
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
            if resName ~= 'HRLib' then
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
        HRLib.callbacksPromises[name] = promise.new()

        local callback

        TriggerClientEvent(('__%s:SendCallback'):format(resName), HRLib.DoesIdExist(playerId --[[@as integer]]) and playerId or -1, name, ...)
        Citizen.Await(HRLib.callbacksPromises[name])

        callback = HRLib.clientCallbacks[name]

        if callback == nil and resName ~= 'HRLib' then
            TriggerClientEvent('__HRLib:TransferCallback', HRLib.DoesIdExist(playerId --[[@as integer]]) and playerId or -1, resName, 'server', name, ...)
            Citizen.Await(HRLib.callbacksPromises[name])

            callback = HRLib.clientCallbacks[name]
        end

        if callback == nil then
            warn(resName == 'HRLib' and ('Resource ^2%s^3 tried to use non-existent client callback!'):format(GetInvokingResource()) or 'This resource tried to use non-existent client callback!')

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
            if resName ~= 'HRLib' then
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
        HRLib.callbacksPromises[name] = promise.new()

        local callback

        if resName == 'HRLib' then
            TriggerServerEvent('__HRLib:SendCallback', name, ...)
            Citizen.Await(HRLib.callbacksPromises[name])

            callback = HRLib.serverCallbacks[name]

            if callback == nil then return end
        else
            TriggerServerEvent(('__%s:SendCallback'):format(resName), name, ...)
            Citizen.Await(HRLib.callbacksPromises[name])

            callback = HRLib.serverCallbacks[name]

            if callback == nil then
                TriggerServerEvent('__HRLib:TransferCallback', resName, 'client', name, ...)
                Citizen.Await(HRLib.callbacksPromises[name])

                callback = HRLib.serverCallbacks[name]

                if callback == nil then return end
            end
        end

        if callback == nil then
            warn(resName == 'HRLib' and ('Resource ^2%s^3 tried to use non-existent client callback!'):format(GetInvokingResource()) or 'This resource tried to use non-existent client callback!')

            return
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

RegisterNetEvent(('__%s:SendCallback'):format(resName), function(name, ...)
    local source = source -- Preventing possible unfocusing from source by the callback function when server side
    local evName <const>, params = ('__%s:LoadCallback'):format(resName)

    local callback <const> = HRLib.callbacks[name]
    local isNil <const> = callback == nil
    if type(callback) == 'function' or (type(callback) == 'table' and callback['__cfx_functionReference']) then
        if isServer then
            params = { isNil, name, not isNil and { callback(source, ...) } or nil }
        else
            params = { isNil, name, not isNil and { callback(...) } or nil }
        end
    else
        params = { isNil, name, not isNil and { callback } or nil }
    end

    if isServer then
        TriggerClientEvent(evName, source, table.unpack(params))
    else
        TriggerServerEvent(evName, table.unpack(params))
    end
end)

if isHRLib then
    RegisterNetEvent('__HRLib:TransferCallback', function(resource, side, name, ...)
        if isServer then
            if type(HRLib.callbacks[name]) == 'function' or (type(HRLib.callbacks[name]) == 'table' and HRLib.callbacks[name]['__cfx_functionReference']) then
                if side == 'client' then
                    TriggerClientEvent(('__%s:LoadHRLibCallback'):format(resource), source, HRLib.callbacks[name] == nil, name, HRLib.callbacks[name] ~= nil and table.pack(HRLib.callbacks[name](...)) or nil)
                else
                    TriggerEvent(('__%s:LoadHRLibCallback'):format(resource), HRLib.callbacks[name] == nil, name, HRLib.callbacks[name] ~= nil and table.pack(HRLib.callbacks[name](...)) or nil)
                end
            else
                if side == 'client' then
                    TriggerClientEvent(('__%s:LoadHRLibCallback'):format(resource), source, HRLib.callbacks[name] == nil, name, HRLib.callbacks[name] ~= nil and table.pack(HRLib.callbacks[name]) or nil)
                else
                    TriggerEvent(('__%s:LoadHRLibCallback'):format(resource), HRLib.callbacks[name] == nil, name, HRLib.callbacks[name] ~= nil and table.pack(HRLib.callbacks[name]) or nil)
                end
            end
        else
            local triggerEvent <const> = side == 'server' and TriggerServerEvent or TriggerEvent
            if type(HRLib.callbacks[name]) == 'function' or (type(HRLib.callbacks[name]) == 'table' and HRLib.callbacks[name]['__cfx_functionReference']) then
                triggerEvent(('__%s:LoadHRLibCallback'):format(resource), HRLib.callbacks[name] == nil, name, HRLib.callbacks[name] ~= nil and table.pack(HRLib.callbacks[name](...)) or nil)
            else
                triggerEvent(('__%s:LoadHRLibCallback'):format(resource), HRLib.callbacks[name] == nil, name, HRLib.callbacks[name] ~= nil and table.pack(HRLib.callbacks[name]) or nil)
            end
        end
    end)
end