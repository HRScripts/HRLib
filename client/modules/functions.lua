local hrlib <const>, clib <const>, fplayer <const> = setmetatable({
    string = {},
    table = {}
}, {
    __call = function(self)
        local exportableHRLib <const> = {}

        for k,v in pairs(self) do
            if k ~= 'require' or k:sub(1, 2) ~= 'On' then
                exportableHRLib[k] = v
            end
        end

        return exportableHRLib
    end
}), load(LoadResourceFile('HRLib', 'client/modules/local.lua'), '@@HRLib/client/modules/local.lua')() --[[@as table]], load(LoadResourceFile('HRLib', 'client/modules/fplayer.lua'), '@@HRLib/client/modules/fplayer.lua')()

---@param playerId integer? player server Id
---@changelog version 1.0.0
---@version 1.0.0
---@return boolean
hrlib.DoesIdExist = function(playerId)
    return clib.DoesIdExist(playerId)
end

---@param playerId integer existing player server Id
---@changelog version 1.0.0
---@version 1.0.0
---@return HRLibClientIPlayer?
hrlib.GetIPlayer = function(playerId)
    return clib.GetIPlayer(playerId)
end

---@param playerId integer existing player server Id
---@changelog version 1.0.0
---@version 1.0.0
---@return HRLibClientFPlayer?
hrlib.GetFPlayer = function(playerId)
    return fplayer:newObject(playerId)
end

---@param vehModel string|integer existing vehicle model or model hash
---@param coords vector4 vehicle spawn coordinates
---@changelog version 1.0.0, version 2.0.0
---@version 2.0.0
---@return integer? vehicleModel
hrlib.SpawnVehicle = function(vehModel, coords)
    if vehModel == nil or type(coords) ~= 'vector4' then return end

    local modelHash <const> = type(vehModel) == 'number' and vehModel or joaat(vehModel)

    RequestModel(modelHash)

    while not HasModelLoaded(modelHash) do
        Wait(10)
    end

    return CreateVehicle(modelHash, coords, true, false) ---@diagnostic disable-line: missing-parameter, param-type-mismatch
end

---@param playerId integer existing player server Id
---@param coords vector3
---@changelog version 1.0.0, version 2.0.0
---@version 2.0.0
hrlib.Teleport = function(playerId, coords)
    SetEntityCoordsNoOffset(GetPlayerPed(GetPlayerFromServerId(playerId)), coords) ---@diagnostic disable-line: missing-parameter, param-type-mismatch
end

---@type fun(description: string, type: 'success'|'info'|'error'|'warning', duration: number, pos: 'top-right'|'center-right'|'bottom-right'|'frombelow-right'|'top-left'|'left-center'|'frombelow-left'?, sound: boolean?)
hrlib.Notify = clib.Notify

---@param name string name of the command
---@param cb fun(args: string[]|any[], rawCommand: any, IPlayer: HRLibClientIPlayer, FPlayer: HRLibClientFPlayer) function arguments: args, rawCommand, IPlayer
---@param suggestion { help: string?, restricted: boolean?, args: table[]? }?
---@changelog version 1.0.0, version 2.0.0
---@version 2.0.0
hrlib.RegCommand = function(name, cb, suggestion)
    suggestion = type(suggestion) == 'table' and suggestion or {}

    if not name or name == '' then
        warn(('^1%s^3 tried to register a client command ^1without^3 name!^0'):format(GetInvokingResource()))
        return
    end

    if clib.RegisteredCmds[name] then
        TriggerEvent('chat:removeSuggestion', ('/%s'):format(name))
    end

    clib.RegisteredCmds[name] = { cb = cb, suggestions = suggestion }

    TriggerEvent('chat:addSuggestion', ('/%s'):format(name), suggestion.help or '', suggestion.args or {})

    RegisterCommand(name, function(_, args, rawCommand)
        local IPlayer <const> = clib.GetIPlayer(GetPlayerServerId(PlayerId()))

        cb(
            args,
            rawCommand,
            IPlayer,
            fplayer:newObject(GetPlayerServerId(PlayerId())) ---@diagnostic disable-line: param-type-mismatch
        )
    end, false)
end

if GetCurrentResourceName() == 'HRLib' then
    ---@param name string the callback name
    ---@param cb any the callback value
    ---@changelog version 1.0.0
    ---@version 1.0.0
    hrlib.CreateCallback = function(name, cb)
        if type(name) ~= 'string' or cb == nil then return end

        clib.Callbacks[name] = cb
    end

    ---@param name string the callback name
    ---@param ... any
    ---@changelog version 1.0.0
    ---@version 1.0.0
    ---@return any?
    hrlib.Callback = function(name, ...)
        local callback = clib.Callbacks[name]

        if callback == nil then
            return
        end

        if type(callback) == 'function' or (type(callback) == 'table' and callback['__cfx_functionReference']) then
            return callback(...)
        else
            return callback
        end
    end

    ---@param name string the callback name
    ---@param ... any
    ---@changelog version 1.0.0
    ---@version 1.0.0
    ---@return any?
    hrlib.ServerCallback = function(name, ...)
        clib.CallbacksPromises[name] = promise.new()

        local callback

        TriggerServerEvent('__HRLib:SendCallback', name, ...)
        Citizen.Await(clib.CallbacksPromises[name])

        callback = clib.ServerCallbacks[name]

        if callback == nil then
            warn(('Resource ^2%s^3 tried to use non-existent client callback!'):format(GetInvokingResource()))

            return
        end

        return table.unpack(callback)
    end
end

---@changelog version 1.0.0
---@version 1.0.0
---@return integer[]
hrlib.GetPlayers = function()
    local players <const> = hrlib.ServerCallback(('__%s:allPlayers'):format(GetCurrentResourceName())) ---@diagnostic disable-line: deprecated

    for i=1, #players do
        players[i] = tonumber(players[i]) --[[@as integer]]
    end

    return players
end

---@return string[]
hrlib.GetAllPedWeapons = function()
    local pedWeapons <const> = {}

    local playerPed <const> = PlayerPedId()
    for i=1, #clib.allWeapons do
        if HasPedGotWeapon(playerPed, joaat(clib.allWeapons[i]), false) then
            pedWeapons[#pedWeapons+1] = clib.allWeapons[i]
        end
    end

    return pedWeapons
end

---@param blip integer
---@param blipName string
hrlib.SetBlipName = function(blip, blipName)
    local commandId <const> = ('blip_%s_%s'):format(blip, blipName)

    BeginTextCommandSetBlipName(commandId)
    AddTextEntry(commandId, blipName)
    EndTextCommandSetBlipName(blip)
end

---@param data { type: 'forCoord'|'forEntity'|'forArea'|'forPickup', label: string?, specificOptions: HRLibBlipForCoordOptions|HRLibBlipForEntityOptions|HRLibBlipForAreaOptions|HRLibBlipForPickupOptions, options: HRLibBlipOptions }
---@return integer? blip
hrlib.CreateBlip = function(data)
    local blip
    local options <const>, specificOptions <const> = data.options, data.specificOptions

    if type(specificOptions) == 'table' then
        if data.type == 'forCoord' then
            blip = AddBlipForCoord(specificOptions.coords or vector3(0.0, 0.0, 0.0)) ---@diagnostic disable-line: missing-parameter, param-type-mismatch
        elseif data.type == 'forEntity' then
            blip = AddBlipForEntity(specificOptions.entity)
        elseif data.type == 'forArea' then
            blip = AddBlipForArea(specificOptions.coords, specificOptions.width, specificOptions.height) ---@diagnostic disable-line: missing-parameter, param-type-mismatch
        elseif data.type == 'forPickup' then
            blip = AddBlipForPickup(specificOptions.pickup)
        end
    end

    if type(options) == 'table' then
        if data.label then hrlib.SetBlipName(blip, data.label) end
        if options.sprite then SetBlipSprite(blip, options.sprite) end
        if options.colour then SetBlipColour(blip, options.colour) end
        if options.alpha then SetBlipAlpha(blip, options.alpha) end
        if options.asShortRange then SetBlipAsShortRange(blip, options.asShortRange) end
        if options.category then SetBlipCategory(blip, options.category) end
        if options.displayId then SetBlipDisplay(blip, options.displayId) end
        if options.flashBlip then SetBlipFlashes(blip, options.flashBlip) end
        if options.flashInterval then SetBlipFlashInterval(blip, options.flashInterval) end
        if options.scale then SetBlipScale(blip, options.scale) end
    end

    return blip
end

---@changelog version 1.0.0, version 1.1.0
---@version 1.1.0
hrlib.Keys = clib.keys

---@changelog version 1.0.0
---@version 1.0.0
hrlib.AllWeapons = clib.allWeapons

---@changelog version 1.0.0
---@version 1.0.0
hrlib.AllPickups = clib.allPickups

local modules <const> = { 'closest', 'import', 'interface', 'streaming', 'string', 'table' }
for i=1, #modules do
    local module <const> = load(LoadResourceFile('HRLib', ('client/modules/%s.lua'):format(modules[i])), ('@@HRLib/client/modules/%s.lua'):format(modules[i]))()
    if module then
        for k,v in pairs(module) do
            hrlib[k] = v
        end
    end
end

return hrlib --[[@as HRLibClientFunctions]], clib, fplayer --[[@as HRLibClientFPlayer]]