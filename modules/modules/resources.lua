local isServer <const>, res <const> = IsDuplicityVersion(), GetCurrentResourceName()

---@param path string the file path (format: '@MyResource/server/server.lua')
---@return any? result
HRLib.require = function(path)
    if type(path) ~= 'string' or not string.find(path, '@') or not string.find(path, '/') then return end

    local splittedPath <const> = HRLib.string.split(path, '/', 'string', true) --[[@as string[] ]]
    local resourceName, filePath <const> = nil, path:sub(#splittedPath[1] + 2, #path)

    if splittedPath[1]:sub(1, 1) == '@' then
        local name <const> = splittedPath[1]:sub(2, #splittedPath[1])
        resourceName = GetResourceState(name) ~= 'missing' and name or false

        if not resourceName then
            return error(('This resource (%s) does not exist! The path format is: \'@MyResource/example/example.lua\''):format(name), 2)
        end
    else
        return error('Invalid path format! The path format is: \'@MyResource/example/example.lua\'', 2)
    end

    local file <const> = LoadResourceFile(resourceName, filePath)

    if not file then
        return error(('The file %s does not exist in this resource (%s)!'):format(splittedPath[#splittedPath], resourceName), 2)
    end

    local fileFormat <const> = HRLib.string.split(filePath, '.', nil, true)[2]
    if fileFormat == 'json' then
        return json.decode(file)
    elseif fileFormat == 'lua' then
        local value <const>, err <const> = load(file, ('@%s'):format(path))

        if not value or err then
            return err
        end

        return value()
    else
        error(('The file format %s is not supported from HRLib.require function!'):format(fileFormat), 2)
    end
end

require = HRLib.require

---@param resName string|'any'? string the resource name or nil for the current one
---@param cb function
HRLib.OnStop = function(resName, cb)
    if type(cb) ~= 'function' or (type(cb) == 'table' and not cb['__cfx_functionReference']) then return end

    resName = resName or GetCurrentResourceName()

    AddEventHandler('onResourceStop', function(resource)
        if resource == resName then
            cb(resource)
        elseif resName == 'any' then
            cb(resource)
        end
    end)
end

if not isServer then
    ---@param resName string|'any' string the resource name or nil for the current one
    ---@param cb function
    HRLib.OnStart = function(resName, cb)
        if type(cb) ~= 'function' or (type(cb) == 'table' and not cb['__cfx_functionReference']) then return end

        AddEventHandler('onResourceStart', function(resource)
            if resource == resName then
                cb(resource)
            elseif resName == 'any' then
                cb(resource)
            end
        end)
    end

    ---@param resName string|'any' string the resource name or nil for the current one
    ---@param cb function
    HRLib.OnStarting = function(resName, cb)
        if type(cb) ~= 'function' or (type(cb) == 'table' and not cb['__cfx_functionReference']) then return end

        AddEventHandler('onResourceStarting', function(resource)
            if resource == resName then
                cb(resource)
            elseif resName == 'any' then
                cb(resource)
            end
        end)
    end

    ---@param cb fun(playerName: string, setKickReason: string, deferrals: table)
    HRLib.OnPlConnecting = function(cb)
        if type(cb) ~= 'function' or (type(cb) == 'table' and not cb['__cfx_functionReference']) then return end

        AddEventHandler('playerConnecting', function(...)
            cb(...)
        end)
    end

    ---@param cb function
    HRLib.OnPlJoining = function(cb)
        if type(cb) ~= 'function' or (type(cb) == 'table' and not cb['__cfx_functionReference']) then return end

        AddEventHandler('playerJoining', cb)
    end

    ---@param cb fun(reason: string)
    HRLib.OnPlDisc = function(cb)
        if type(cb) ~= 'function' or (type(cb) == 'table' and not cb['__cfx_functionReference']) then return end

        AddEventHandler('playerDropped', function(...)
            cb(...)
        end)
    end

    ---@param cb fun(spawnInfo: { x: number, y: number, z: number, heading: number, idx: integer, model: integer })
    HRLib.OnPlSpawn = function(cb)
        if type(cb) ~= 'function' or (type(cb) == 'table' and not cb['__cfx_functionReference']) then return end

        AddEventHandler('playerSpawned', function(spawnInfo)
            cb(spawnInfo)
        end)
    end
else
    ---@param resName string|'any'? string the resource name or nil for the current one
    ---@param cb function
    HRLib.OnStart = function(resName, cb)
        if type(cb) ~= 'function' or (type(cb) == 'table' and not cb['__cfx_functionReference']) then return end

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
    ---@param cb function
    HRLib.OnStarting = function(resName, cb)
        if type(cb) ~= 'function' or (type(cb) == 'table' and not cb['__cfx_functionReference']) then return end

        resName = resName or GetCurrentResourceName()

        AddEventHandler('onResourceStarting', function(resource)
            if resource == resName then
                cb(resource)
            elseif resName == 'any' then
                cb(resource)
            end
        end)
    end

    ---@param cb function
    HRLib.OnRefresh = function(cb)
        if type(cb) == 'function' or type(cb) == 'table' and cb['__cfx_functionReference'] then
            AddEventHandler('onResourceListRefresh', cb --[[@as function]])
        end
    end

    ---@param cb fun(source: integer, playerName: string, setKickReason: string, deferrals: table)
    HRLib.OnPlConnecting = function(cb)
        if type(cb) ~= 'function' or (type(cb) == 'table' and not cb['__cfx_functionReference']) then return end

        AddEventHandler('playerConnecting', function(...)
            cb(source, ...)
        end)
    end

    ---@param cb fun(source: integer)
    HRLib.OnPlJoining = function(cb)
        if type(cb) ~= 'function' or (type(cb) == 'table' and not cb['__cfx_functionReference']) then return end

        AddEventHandler('playerJoining', function()
            cb(source)
        end)
    end

    ---@param cb fun(source: integer, reason: string)
    HRLib.OnPlDisc = function(cb)
        if type(cb) ~= 'function' or (type(cb) == 'table' and not cb['__cfx_functionReference']) then return end

        AddEventHandler('playerDropped', function(...)
            cb(source, ...)
        end)
    end

    ---@param msgtype 'warn'|'error'
    ---@param msg string
    HRLib.StopMyself = function(msgtype, msg)
        TriggerEvent('__HRLib:StopMyself', GetCurrentResourceName(), msgtype, msg)
    end

    ---@param resName string|'any'? string the resource name or nil for the current one
    ---@param cb fun(resource: string)
    ---@changelog version 1.0.0
    ---@version 1.0.0
    HRLib.OnServerStart = function(resName, cb)
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
    HRLib.OnServerStop = function(resName, cb)
        resName = resName or GetCurrentResourceName()

        AddEventHandler('onServerResourceStop', function(resource)
            if resource == resName then
                cb(resource)
            elseif resName == 'any' then
                cb(resource)
            end
        end)
    end
end

---@param includeStoppedResources boolean? default value is for not including the stopped resources
---@return string[] resourcesList
HRLib.GetAllResources = function(includeStoppedResources)
    local resourcesList <const> = {}

    for i=1, GetNumResources() - 1 do
        local currResource <const> = GetResourceByFindIndex(i)
        if GetResourceState(currResource) == 'started' or includeStoppedResources then
            resourcesList[#resourcesList+1] = GetResourceByFindIndex(i)
        end
    end

    return resourcesList
end