if GetCurrentResourceName() ~= 'HRLib' then
    local hrlib <const>, clib <const> = {}, load(LoadResourceFile('HRLib', 'server/modules/local.lua'), '@@HRLib/server/modules/local.lua')()

    ---@param msgtype 'warn'|'error'
    ---@param msg string
    hrlib.StopMyself = function(msgtype, msg)
        if IsDuplicityVersion() == 1 then
            TriggerEvent('__HRLib:StopMyself', GetCurrentResourceName(), msgtype, msg)
        end
    end

    ---@param path string the file path (format: '@resourceName/server/server.lua')
    ---@changelog version 1.0.0
    ---@version 1.0.0
    ---@return any?
    hrlib.require = function(path)
        if type(path) ~= 'string' or not string.find(path, '@') or not string.find(path, '/') then return end

        local splittedPath <const> = table.pack(clib.splitString(path, '/')) ---@diagnostic disable-line: deprecated
        local resourceName, filePath <const> = nil, path:sub(#splittedPath[1] + 1, #path)

        if splittedPath[1]:sub(1, 1) == '@' then
            resourceName = GetResourceState(splittedPath[1]:sub(2, #splittedPath[1])) ~= 'missing' and splittedPath[1]:sub(2, #splittedPath[1]) or false

            if not resourceName then
                error(('This resource (%s) does not exist! The path format is: \'@MyResource/example/example.lua\''):format(splittedPath[1]:sub(2, #splittedPath[1])))
            end
        else
            error('Invalid path format! The path format is: \'@MyResource/example/example.lua\'')
        end

        local file <const> = LoadResourceFile(resourceName, filePath)

        if not file then
            error(('The file %s does not exist in this resource (%s)!'):format(splittedPath[#splittedPath], resourceName))
        end

        local value <const>, err <const> = load(file, '@'..path)

        if not value or err then
            return err
        end

        return value()
    end

    ---@param resName string|'any'? string the resource name or nil for the current one
    ---@param cb fun(resource: string)
    ---@changelog version 1.0.0
    ---@version 1.0.0
    hrlib.OnStart = function(resName, cb)
        resName = resName or GetCurrentResourceName()

        AddEventHandler('onResourceStart', function(resource)
            if resource == resName then
                cb(resource)
            elseif resName == 'any' then
                cb(resource)
            end
        end)
    end

    ---@param resName string|'any'? string the resource name or nil for the current one
    ---@param cb fun(resource: string)
    ---@changelog version 1.0.0
    ---@version 1.0.0
    hrlib.OnStop = function(resName, cb)
        resName = resName or GetCurrentResourceName()

        AddEventHandler('onResourceStop', function(resource)
            if resource == resName then
                cb(resource)
            elseif resName == 'any' then
                cb(resource)
            end
        end)
    end

    ---@param resName string|'any'? string the resource name or nil for the current one
    ---@param cb fun(resource: string)
    ---@changelog version 1.0.0, version 2.0.0
    ---@version 2.0.0
    hrlib.OnStarting = function(resName, cb)
        resName = resName or GetCurrentResourceName()

        AddEventHandler('onResourceStarting', function(resource)
            if resource == resName then
                cb(resource)
            elseif resName == 'any' then
                cb(resource)
            end
        end)
    end

    ---@param resName string|'any'? string the resource name or nil for the current one
    ---@param cb fun(resource: string)
    ---@changelog version 1.0.0
    ---@version 1.0.0
    hrlib.OnRefresh = function(resName, cb)
        resName = resName or GetCurrentResourceName()

        AddEventHandler('onResourceListRefresh', function(resource)
            if resource == resName then
                cb(resource)
            elseif resName == 'any' then
                cb(resource)
            end
        end)
    end

    ---@param resName string|'any'? string the resource name or nil for the current one
    ---@param cb fun(resource: string)
    ---@changelog version 1.0.0
    ---@version 1.0.0
    hrlib.OnServerStart = function(resName, cb)
        resName = resName or GetCurrentResourceName()

        AddEventHandler('onServerResourceStart', function(resource)
            if resource == resName then
                cb(resource)
            elseif resName == 'any' then
                cb(resource)
            end
        end)
    end

    ---@param resName string|'any'? string the resource name or nil for the current one
    ---@param cb fun(resource: string)
    ---@changelog version 1.0.0
    ---@version 1.0.0
    hrlib.OnServerStop = function(resName, cb)
        resName = resName or GetCurrentResourceName()

        AddEventHandler('onServerResourceStop', function(resource)
            if resource == resName then
                cb(resource)
            elseif resName == 'any' then
                cb(resource)
            end
        end)
    end

    ---@param cb fun(source: integer, playerName: string, setKickReason: string, deferrals: table)
    hrlib.OnPlConnecting = function(cb)
        if type(cb) ~= 'function' or (type(cb) == 'table' and not cb['__cfx_functionReference']) then return end

        AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
            cb(source, playerName, setKickReason, deferrals)
        end)
    end

    ---@param cb fun(source: integer)
    hrlib.OnPlJoining = function(cb)
        if type(cb) ~= 'function' or (type(cb) == 'table' and not cb['__cfx_functionReference']) then return end

        AddEventHandler('playerJoining', function()
            cb(source)
        end)
    end

    ---@param cb fun(source: integer, reason: string)
    hrlib.OnPlDisc = function(cb)
        if type(cb) ~= 'function' or (type(cb) == 'table' and not cb['__cfx_functionReference']) then return end

        AddEventHandler('playerDropped', function(reason)
            cb(source, reason)
        end)
    end

    return hrlib
end

return false