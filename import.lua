local resName <const>, isServer <const>, load, LoadResourceFile = GetCurrentResourceName(), IsDuplicityVersion(), load, LoadResourceFile

load(LoadResourceFile('HRLib', 'modules/import.lua'), '@@HRLib/modules/import.lua')()

_ENV.HRLib = HRLib()

local modules <const> = load(LoadResourceFile('HRLib', 'modules/modulesList.lua'), '@@HRLib/modules/modulesList.lua')()
for i=1, #modules do
    if modules[i] ~= 'interface' then
        local path <const> = ('modules/modules/%s.lua'):format(modules[i])
        load(LoadResourceFile('HRLib', path), ('@@HRLib/%s'):format(path))()
    else
        local libFunctions <const> = exports.HRLib:getLibFunctions()
        local interfaceModules <const> = isServer and { 'Notify' } or { 'showTextUI', 'isTextUIOpen', 'hideTextUI', 'progressBar', 'createAlertDialogue', 'createInputDialogue', 'Notify' }
        for l=1, #interfaceModules do
            HRLib[interfaceModules[l]] = libFunctions[interfaceModules[l]]
        end
    end
end

if not GetResourceMetadata(resName, 'remove_translator_import', 0) then
    HRLib.require('@HRLib/translator.lua')
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

                                if tonumber(HRLib.string.gather(HRLib.string.split(latestVersion, '.', nil, true) --[[@as string[] ]], '')) > tonumber(HRLib.string.gather(HRLib.string.split(currVersion, '.', nil, true) --[[@as string[] ]], '')) then
                                    warn(('The resource %s is outdated. Please update it!\nCurrent version: %s. Latest version: %s\nURL: %s'):format(resName, currVersion, latestVersion, body.html_url))
                                end
                            end
                        end)
                    end)
                end
            end
        end
    end

    ---Function to trigger a client registered net event
    ---@param eventName string
    ---@param playerId integer|integer[]|-1
    ---@param ... any?
    TriggerClientEvent = function(eventName, playerId, ...)
        if #GetPlayers() > 0 then
            local eventPayload <const> = msgpack.pack_args(...)
            local length <const> = #eventPayload

            if type(playerId) == 'table' and table.type(playerId) == 'array' then
                for i=1, #playerId do
                    if HRLib.DoesIdExist(playerId[i]) then
                        TriggerClientEventInternal(eventName, playerId[i], eventPayload, length) ---@diagnostic disable-line: param-type-mismatch
                    else
                        local info <const> = debug.getinfo(3, 'Sl')
                        warn(('^1%s:%s: Triggered client event, providing an invalid player id^3'):format(info.source:sub(2), info.currentline))
                    end
                end
            elseif HRLib.DoesIdExist(playerId --[[@as integer]]) then
                TriggerClientEventInternal(eventName, playerId, eventPayload, length) ---@diagnostic disable-line: param-type-mismatch
            elseif playerId == -1 then
                TriggerClientEventInternal(eventName, playerId, eventPayload, length) ---@diagnostic disable-line: param-type-mismatch
            else
                local info <const> = debug.getinfo(3, 'Sl')
                warn(('^1%s:%s: Triggered client event, providing an invalid player id^3'):format(info.source:sub(2), info.currentline))
            end
        end
    end
else
    local permissionIndex <const> = math.random(1, 1000000000000)

    SetNUIStatusDefaultMessage = setmetatable({
        set = function(self, message)
            if type(message) == 'table' and table.type(message) == 'hash' and HRLib.table.find(message, 'status') then
                rawset(self, 'message', { permissionIndex = permissionIndex, message = message })
            end
        end
    }, {
        __newindex = function(self, key, value)
            if type(value) == 'table' and value.permissionIndex == permissionIndex then
                rawset(self, key, value.message)
            end
        end,
    })

    ---Function implemented by HRLib's import method that sets the nui focus in the client side to specific value and sends nui message (not required)\
    ---@param status boolean the nui focus status
    ---@param message table|'no'? if no even the default message won't be used
    SetNUIStatus = function(status, message)
        SetNuiFocus(status, status)

        if message and type(message) == 'table' then
            SendNUIMessage(message)
        elseif SetNUIStatusDefaultMessage.message and message ~= 'no' then
            SendNUIMessage(SetNUIStatusDefaultMessage.message)
        end
    end
end