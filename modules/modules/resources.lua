local isServer <const>, res <const> = IsDuplicityVersion(), GetCurrentResourceName()

---Function to require a file from the same or other resource
---@param path string
---@return any
HRLib.require = function(path)
    if type(path) == 'string' and #path > 0 then
        local delimiter <const> = HRLib.string.find(path, '/') and '/' or (HRLib.string.find(path, '.') and '.')
        local stringPath, resourceName = '', ''

        do
            local found <const> = HRLib.string.find(path, '@')
            if found then
                if not delimiter then return error(('Resource %s tried to require a file from another resource, providing an invalid path format'):format(res), 2) end

                local sepPath <const> = delimiter and HRLib.string.split(path, delimiter, nil, true) --[[@as string[] ]]
                local newString = sepPath[2]

                if sepPath[delimiter == '.' and 3 or 2] ~= 'lua' and sepPath[delimiter == '.' and 3 or 2] ~= 'json' then
                    for i=3, (delimiter == '.' and (sepPath[#sepPath] == 'lua' or sepPath[#sepPath] == 'json')) and #sepPath - 1 or #sepPath do
                        newString = ('%s/%s'):format(newString, sepPath[i])
                    end
                else
                    newString = ('%s.%s'):format(sepPath[2], sepPath[3])
                end

                if delimiter == '.' and (newString == 'lua' or newString == 'json') then
                    newString = ('%s.%s'):format(sepPath[1], sepPath[2])
                elseif newString:sub(#newString - 3) ~= '.lua' and newString:sub(#newString - 4) ~= '.json' then
                    newString = ('%s.%s'):format(newString, (sepPath[#sepPath] == 'lua' or sepPath[#sepPath] == 'json') and sepPath[#sepPath] or 'lua')
                end

                resourceName = sepPath[1]:sub(2)
                stringPath = newString
            else
                if path:sub(#path - 3) ~= '.lua' and path:sub(#path - 4) ~= '.json' then
                    stringPath = ('%s.lua'):format(path)
                else
                    stringPath = path
                end

                if delimiter and delimiter == '.' then
                    local sepPath <const> = HRLib.string.split(stringPath, '.', 'string', true) --[[@as string]]
                    local newString = ('%s'):format(sepPath[1])

                    for i=2, #sepPath - 1 do
                        newString('%s/%s'):format(newString, sepPath[i])
                    end

                    stringPath = ('%s.%s'):format(newString, sepPath[#sepPath])
                end

                resourceName = res
            end
        end

        local file <const> = LoadResourceFile(resourceName, stringPath)
        if file then
            if stringPath:sub(#stringPath - 4) == '.json' then
                return json.decode(file)
            else
                return load(file, ('@@%s/%s'):format(resourceName, stringPath))()
            end
        else
            error(('Resource %s tried to require a file, providing invalid file path!'):format(res), 2)
        end
    else
        error(('Resource %s tried to require a file, providing an invalid path'):format(res), 2)
    end
end

require = HRLib.require

---@param resName string|'any'? string the resource name or nil for the current one
---@param cb fun(resName: string)
HRLib.OnStop = function(resName, cb)
    if type(cb) ~= 'function' or (type(cb) == 'table' and not cb['__cfx_functionReference']) then return end

    resName = resName or res
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
    ---@param cb fun(resName: string)
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
    ---@param cb fun(resName: string)
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
    ---@param cb fun(resName: string)
    HRLib.OnStart = function(resName, cb)
        if type(cb) ~= 'function' or (type(cb) == 'table' and not cb['__cfx_functionReference']) then return end

        resName = resName or res

        AddEventHandler('onResourceStart', function(resource)
            if resource == resName then
                cb(resource)
            elseif resName == 'any' then
                cb(resource)
            end
        end)
    end

    ---@param resName string|'any'? string the resource name or nil for the current one
    ---@param cb fun(resName: string)
    HRLib.OnStarting = function(resName, cb)
        if type(cb) ~= 'function' or (type(cb) == 'table' and not cb['__cfx_functionReference']) then return end

        resName = resName or res

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
            cb(tonumber(source) --[[@as integer]], ...)
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

    ---@param msgtype 'warn'|'error'?
    ---@param msg string?
    HRLib.StopMyself = function(msgtype, msg)
        TriggerEvent('HRLib:StopMyself')

        if msg and msgtype and (msgtype == 'warn' or msgtype == 'error') then
            _G[msgtype](msg)
        end
    end

    ---@param msgtype 'warn'|'error'?
    ---@param msg string?
    HRLib.RestartMyself = function(msgtype, msg)
        TriggerEvent('HRLib:RestartMyself')

        if msg and msgtype and (msgtype == 'warn' or msgtype == 'error') then
            _G[msgtype](msg)
        end
    end

    ---@param resName string|'any'? string the resource name or nil for the current one
    ---@param cb fun(resource: string)
    HRLib.OnServerStart = function(resName, cb)
        resName = resName or res

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
        resName = resName or res

        AddEventHandler('onServerResourceStop', function(resource)
            if resource == resName then
                cb(resource)
            elseif resName == 'any' then
                cb(resource)
            end
        end)
    end
end

---@param includeStoppedResources boolean? sets whether or not the search should skip the stopped resources or not (by default it doesn't include them)
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

---@param metadataKey string metadata key to compare the filter parameter with
---@param filter any the value to compare when searching
---@param includeStoppedResources boolean? sets whether or not the search should skip the stopped resources or not (by default it doesn't include them)
---@return string[]|false resourcesList
HRLib.GetAllResourcesFiltered = function(metadataKey, filter, includeStoppedResources)
    local resourcesList <const> = {}

    local resources <const> = HRLib.GetAllResources(includeStoppedResources)
    for i=1, #resources do
        if GetResourceMetadata(resources[i], metadataKey, -1) == filter then
            resourcesList[#resourcesList+1] = resources[i]
        end
    end

    return #resourcesList > 0 and resourcesList
end