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
end