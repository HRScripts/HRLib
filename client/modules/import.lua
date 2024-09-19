local hrlib <const>, clib <const> = {}, load(LoadResourceFile('HRLib', 'client/modules/local.lua'), '@@HRLib/client/modules/local.lua')()

---@param path string the file path (format: '@MyResource/server/server.lua')
---@changelog version 1.0.0
---@version 1.0.0
---@return any?
hrlib.require = function(path)
    if type(path) ~= 'string' or not string.find(path, '@') or not string.find(path, '/') then return end

    local splittedPath <const> = clib.splitString(path, '/', 'string', true) --[[@as table[] ]] ---@diagnostic disable-line: deprecated
    local resourceName, filePath <const> = nil, path:sub(#splittedPath[1] + 2, #path)

    if splittedPath[1]:sub(1, 1) == '@' then
        local name <const> = splittedPath[1]:sub(2, #splittedPath[1])
        resourceName = GetResourceState(name) ~= 'missing' and name or false

        if not resourceName then
            return error(('This resource (%s) does not exist! The path format is: \'@MyResource/example/example.lua\''):format(name))
        end
    else
        return error('Invalid path format! The path format is: \'@MyResource/example/example.lua\'')
    end

    local file <const> = LoadResourceFile(resourceName, filePath)

    if not file then
        return error(('The file %s does not exist in this resource (%s)!'):format(splittedPath[#splittedPath], resourceName))
    end

    local value <const>, err <const> = load(file, ('@%s'):format(path))

    if not value or err then
        return err
    end

    return value()
end

---@param resName string|'any'? string the resource name or nil for the current one
---@param cb function
---@changelog version 1.0.0
---@version 1.0.0
hrlib.OnStart = function(resName, cb)
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
---@changelog version 1.0.0
---@version 1.0.0
hrlib.OnStop = function(resName, cb)
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

---@param resName string|'any'? string the resource name or nil for the current one
---@param cb function
---@changelog version 1.0.0
---@version 1.0.0
hrlib.OnStarting = function(resName, cb)
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

---@param cb fun(playerName: string, setKickReason: string, deferrals: table)
hrlib.OnPlConnecting = function(cb)
    if type(cb) ~= 'function' or (type(cb) == 'table' and not cb['__cfx_functionReference']) then return end

    AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
        cb(playerName, setKickReason, deferrals)
    end)
end

---@param cb function
hrlib.OnPlJoining = function(cb)
    if type(cb) ~= 'function' or (type(cb) == 'table' and not cb['__cfx_functionReference']) then return end

    AddEventHandler('playerJoining', function()
        cb()
    end)
end

---@param cb fun(spawnInfo: { x: number, y: number, z: number, heading: number, idx: integer, model: integer })
hrlib.OnPlSpawn = function(cb)
    if type(cb) ~= 'function' or (type(cb) == 'table' and not cb['__cfx_functionReference']) then return end

    AddEventHandler('playerSpawned', function(spawnInfo)
        cb(spawnInfo)
    end)
end

---@param cb fun(reason: string)
hrlib.OnPlDisc = function(cb)
    if type(cb) ~= 'function' or (type(cb) == 'table' and not cb['__cfx_functionReference']) then return end

    AddEventHandler('playerDropped', function(reason)
        cb(reason)
    end)
end

return hrlib