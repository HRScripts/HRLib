---@param webHook string URL of Discord WebHook bot
---@param botName string name of the bot
---@param title string title of the notification
---@param message string message of the notification
---@param type string if type nil then type is rich
---@param color number color of the message
---@param icon string URL of an image
---@param author string author of the message
HRLib.DiscordMsg = function(webHook, botName, title, message, type, color, icon, author)
    if not webHook and Config.DefaultWebHook then
        Bot = webHook or Config.DefaultWebHook
    elseif not webHook and not Config.DefaultWebHook then return end

    if type == nil then
        type = 'rich'
    elseif color == nil then
        color = 555555
    elseif not string.find(tostring(icon), 'https://') or not string.find(tostring(icon), 'http://') then
        icon = ''
    elseif author == nil then
        author = ''
    elseif title == nil then
        title = ''
    end

    local msg = message

    PerformHttpRequest(Bot, function(error, text, headers)end, 'POST', json.encode({ username = botName or 'Information', embeds = {
        {
            ["title"]       = title,
            ["type"]        = type,
            ["color"]       = color,
            ["description"] = msg,
            ["footer"]      = {
                ["text"]    = author,
                ["icon_url"]= icon
            }
        }
    }}), { ['Content-Type'] = 'application/json' })
end

---@param playerId integer existing player server Id
---@param identifier string identifier type. Identifier types: steam ; license ; licens2 ; fivem ; discord ; xbl ; live ; ip
HRLib.PlayerIdentifier = function(playerId, identifier)
    if playerId == nil or identifier == nil or playerId == '' or identifier == '' then return end
    return clib.PlI(playerId, identifier)
end

---@param playerId integer existing player server Id
---@param identifier integer identifier index ( 1-8 )
HRLib.PlayerIdentifierByIndex = function(playerId, identifier)
    if playerId == nil or identifier == nil or playerId == '' or tonumber(identifier) > 8 then return end
    return GetPlayerIdentifier(tonumber(playerId), tonumber(identifier))
end

---@param playerId integer existing player server Id
HRLib.GetIPlayer = function(playerId)
    return clib.GetIPlayer(tonumber(playerId))
end

---@param playerId integer existing player server Id
HRLib.GetFPlayer = function(playerId)
    return clib.GetFPlayer(tonumber(playerId))
end

---@param vehModel string existing vehicle model
---@param coords vector3 vehicle spawn coordinates
---@param heading number vehicle heading when spawn
---@param cb function return created vehicle
HRLib.SpawnVehicle = function(vehModel, coords, heading, cb)
    local veh = CreateVehicle(GetHashKey(vehModel), coords, heading, true, false)

    cb(veh)
end

---@param playerId integer
---@param coords vector3
---@param clearedArea boolean
HRLib.Teleport = function(playerId, coords, clearedArea)
    if playerId == nil then return end

    SetEntityCoords(GetPlayerPed(playerId), coords, true, false, false, clearedArea)
end

HRLib.ResNum = function()
    return GetNumResources()
end

HRLib.PlayersNum = function()
    return #GetPlayers()
end

---@param playerId integer existing player server Id
---@param msg string message content
---@param type string notify type. Available types: success ; info ; error ; warning
---@param time number time until notice closes
HRLib.Notify = function(playerId, msg, type, time)
    clib.Notify(playerId, msg, type, time)
end

HRLib.AllIPlayers = function()
    for k,v in pairs(GetPlayers()) do
        return clib.GetIPlayer(v)
    end
end

HRLib.AllFPlayers = function()
    for k,v in pairs(GetPlayers()) do
        return clib.GetFPlayer(v)
    end
end

---@param playerId integer player server Id
HRLib.DoesIdExist = function(playerId)
    for _,v in pairs(GetPlayers()) do
        if string.find(v, playerId) then
            return true
        else
            return false
        end
    end
end

---@param name string the name of the command
---@param accessFromConsole boolean allow access to the command from the console
---@param accessFromInGame boolean allow access to the command from the game
---@param cb function return values: args, rawCommand, IPlayer, FPlayer
---@param enableAce boolean only ace allowed players can access the command ( command.cmdName )
---@param suggestions table table format: {help = 'STRING', args = { {name = 'STRING', help = 'STRING'} } }
HRLib.RegCommand = function(name, accessFromConsole, accessFromInGame, cb, enableAce, suggestions)

    if name == nil or name == '' then
        print(('^3!WARNING!^5 %s ^1tried^5 to register a ^1server^5 command without name! ^3!WARNING!^0'):format(GetInvokingResource()))
        print(('^3!WARNING!^5 %s ^1tried^5 to register a ^1server^5 command without name! ^3!WARNING!^0'):format(GetInvokingResource()))
        print(('^3!WARNING!^5 %s ^1tried^5 to register a ^1server^5 command without name! ^3!WARNING!^0'):format(GetInvokingResource()))
        return
    end

    if clib.RegisteredCmds[name] then
        table.remove(clib.RegisteredCmds, name)
        TriggerClientEvent('chat:removeSuggestion', '/'..name)
        clib.RegisteredCmds[name] = {cb = cb, accessFromConsole = accessFromConsole, accessFromInGame = accessFromInGame, suggestions = suggestions}
    else
        clib.RegisteredCmds[name] = {cb = cb, accessFromConsole = accessFromConsole, accessFromInGame = accessFromInGame, suggestions = suggestions}
        command = clib.RegisteredCmds[name]
    end

    if accessFromConsole == false and accessFromInGame == false then
        table.remove(clib.RegisteredCmds, name)
        local args, rawCommand, IPlayer, FPlayer = {[1] = nil, [2] = nil, [3] = nil}, nil, nil, nil
        cb(args, rawCommand, IPlayer, FPlayer)
        TriggerClientEvent('chat:removeSuggestion', '/'..name)
    else
        if suggestions then if not suggestions.help then suggestions.help = '' elseif not suggestions.args then suggestions.args = {} end
            TriggerClientEvent('chat:addSuggestion', -1, '/'..name, suggestions.help, suggestions.args) 
        end

        if enableAce == nil or enableAce then
            enableAce = false
        end

        RegisterCommand(name, function(source, args, rawCommand)
            if source == 0 and not command.accessFromConsole then
                print('You cannot use this command from the console!')
                return
            elseif source > 0 and not command.accessFromInGame then
                TriggerClientEvent('chatMessage', source, '^1SYSTEM', {255, 155, 155}, 'You cannot use this command from the game!')
                return
            elseif source == 0 and command.accessFromConsole then
                local IPlayer = {
                    source = source,
                    name = 'txAdmin Control Panel',
                }

                cb(
                    args,
                    rawCommand,
                    IPlayer
                )
            elseif source ~= 0 and command.accessFromInGame then
                local IPlayer, FPlayer = clib.GetIPlayer(source), clib.GetFPlayer(source)
                cb(
                    args,
                    rawCommand,
                    IPlayer,
                    FPlayer
                )
            end

        end, enableAce)
    end
end

---@param coords vector3 coords that are the coords where player be teleported to
---@param clearedArea boolean true or false for clear the area whether player is spawning
FPlayer.Teleport = function(coords, clearedArea)
    local clearedArea = clearedArea or false
    SetEntityCoords(GetPlayerPed(FPlayer.id), coords, true, false, true, clearedArea)
end

---@param vehModel string vehicle model
---@param spawnPedInside boolean true or false for spawn ped inside the vehicle
---@param cb function return the vehicle
FPlayer.SpawnVehicle = function(vehModel, spawnPedInside, cb)
    local ped = GetPlayerPed(FPlayer.id)
    local veh = CreateVehicle(GetHashKey(vehModel), GetEntityCoords(ped), GetEntityHeading(ped), true, false)
    if spawnPedInside then
        SetPedIntoVehicle(ped, veh, -1)
    end

    cb(veh)
end

---@param msg string content of the notice
---@param type string notice type ( success ; error ; info ; warning )
---@param time number time until notice closes (in miliseconds)
FPlayer.Notify = function (msg, type, time)
    clib.Notify(FPlayer.id, msg, type, time)
end
