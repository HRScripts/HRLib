local resName <const> = GetCurrentResourceName()

load(LoadResourceFile('HRLib', 'modules/import.lua'), '@@HRLib/modules/import.lua')()

local modules <const> = load(LoadResourceFile('HRLib', 'modules/modulesList.lua'), '@@HRLib/modules/modulesList.lua')()
for i=1, #modules do
    local path <const> = ('modules/modules/%s.lua'):format(modules[i])
    load(LoadResourceFile('HRLib', path), ('@@HRLib/%s'):format(path))()
end

local config <const> = HRLib.require('@HRLib/config.lua') --[[@as HRLibConfig]]
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

    RegisterNetEvent('__HRLib:StopMyself', function(resourceName, msgtype, msg)
        Wait(1000)

        if msgtype == 'warn' or msgtype == 'error' and type(msg) == 'string' then
            (msgtype == 'warn' and warn or error)(('%s: %s'):format(resourceName, msg))
        end

        StopResource(resourceName)
    end)

    AddEventHandler('onResourceStart', function(resource)
        if resource == resName and resource ~= 'HRLib' then
            warn(('^HRLib^3 is with different name (^1%s^3)! Please change this name because this will stop the working of all our resources!'):format(resName))
        end
    end)

    AddEventHandler('onResourceStop', function(resource)
        if resource == resName then
            warn('The restarting/stopping of ^5hrlib^3 is not recommended! You may have error at our other scripts and the commands from the other resources will not be registered!')
        end
    end)
elseif config.debug.enable == true then
    HRLib.RegCommand(config.debug.commandName, function(args, rawCommand, IPlayer, FPlayer)
        local fnType = args[1]
        local paramsText = ''

        if #args > 1 then
            for i=2, #args do
                paramsText = ('%s%s%s'):format(paramsText, i == 2 and '' or ' ', args[i])
            end
        end

        if fnType == 'showTextUI' then
            HRLib.showTextUI(#paramsText > 0 and paramsText or 'this is a test')
        elseif fnType == 'isTextUIOpen' then
            print('isTextUIOpen debug with returned last textUI content:', HRLib.isTextUIOpen(true))
        elseif fnType == 'hideTextUI' then
            HRLib.hideTextUI()
        elseif fnType == 'progressBar' then
            HRLib.progressBar(args[2] or 'horizontal', {
                duration = 2500,
                description = args[3] or 'Progress Bar'
            })
        elseif fnType == 'alertDialogue' then
            HRLib.createAlertDialogue({
                title = 'Alert Dialogue',
                description = 'This is a test dialogue, do you agree?',
                onAgree = function()
                    print('You agreed!')
                end,
                onCancel = function()
                    print('You didn\'t want to agree :(')
                end
            })
        elseif fnType == 'inputDialogue' then
            local result <const> = HRLib.createInputDialogue({
                title = 'Input Dialogue',
                questions = {
                    {
                        type = 'text',
                        options = {
                            label = 'Test input',
                            placeholder = 'fill in the blank'
                        }
                    }
                },
                onCancel = function()
                    print('Why did you canceled?')
                end
            })
            if result then
                print('You said:', result[1])
            end
        elseif fnType == 'notify' then
            HRLib.Notify(paramsText or 'Test notification', HRLib.table.find({ 'success', 'error', 'info', 'warning' }, args[#args]) and args[#args] or ({ 'success', 'error', 'info', 'warning' })[math.random(1, 4)])
        else
            print('Invalid debug type! The type must be in the exact way as in the description to use it')
        end
    end, { help = config.debug.commandHelp, args = { { name = config.debug.args.type.name, help = config.debug.args.type.help }, { name = config.debug.args.secondParameter.name, help = config.debug.args.secondParameter.help } } })
end

exports('getLibFunctions', function()
    return HRLib(true)
end)