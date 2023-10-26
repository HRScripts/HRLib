HRLib.PlayersNum = function()
    return GetNumberOfPlayers()
end

HRLib.ResNum = function()
    return GetNumResources()
end

---@param playerId integer player server Id
HRLib.DoesIdExist = function(playerId)
    for i=1, #GetActivePlayers() do
        if GetPlayerServerId(GetActivePlayers()[i]) == playerId then
            return true
        else
            return false
        end
    end
end

---@param playerId integer existing player server Id
HRLib.GetIPlayer = function(playerId)
    return clib.GetIPlayer(playerId)
end

---@param playerId integer existing player server Id
HRLib.GetFPlayer = function(playerId)
    clib.GetFPlayer(playerId)
end

---@param vehModel string existing vehicle model
---@param coords vector3 vehicle spawn coordinates
---@param heading number vehicle heading when spawn
---@param cb function return created vehicle
HRLib.SpawnVehicle = function(vehModel, coords, heading, cb)
    local veh = CreateVehicle(GetHashKey(vehModel), coords, heading, true, false)

    cb(veh)
end

---@param playerId integer existing player server Id
---@param coords vector3
---@param clearedArea boolean true or false for clear the area whether player is spawning
HRLib.Teleport = function(playerId, coords, clearedArea)
    local clearedArea = clearedArea or false
    SetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerId)), coords, true, false, true, clearedArea or false)
end

---@param Id integer existing player server Id
---@param radius number default value: 2.0
HRLib.ClosestPed = function(Id, radius)
    local ped = GetPlayerPed(GetPlayerFromServerId(Id))
    local pedCoords = GetEntityCoords(ped)
    local peds = GetGamePool('CPed')

    for _,v in pairs(peds) do
        local pedsCoords = GetEntityCoords(v)
        local distance = #(pedCoords - pedsCoords)

        if distance < radius then
            return v
        end
    end
end

---@param Id integer existing player server Id
---@param radius number default value: 2.0
HRLib.ClosestIPlayer = function(Id, radius)
    local closestPed = HRLib.ClosestPed(Id, radius)
    
    return clib.GetIPlayer(GetPlayerServerId(GetPlayerFromIndex(NetworkGetPlayerIndexFromPed(closestPed))))
end

---@param Id integer existing player server Id
---@param radius number default value: 2.0
HRLib.ClosestFPlayer = function(Id, radius)
    local closestPed = HRLib.ClosestPed(Id, radius)
    
    return clib.GetFPlayer(GetPlayerServerId(GetPlayerFromIndex(NetworkGetPlayerIndexFromPed(closestPed))))
end

---@param Id integer existing player server Id
---@param radius number default value: 5.0
HRLib.ClosestVehicle = function(Id, radius)
    local ped = GetPlayerPed(GetPlayerFromServerId(Id))
    local vehs = GetGamePool('CVehicle')

    for _,v in pairs(vehs) do
        local pedCoords, vehsCoords = GetEntityCoords(ped), GetEntityCoords(v)
        local distance = #(pedCoords - vehsCoords)

        if distance < radius then
            return v
        end
    end
end

---@param Id integer player server Id or ped
---@param health integer health value
HRLib.Health = function(Id, health)
    if Id > GetNumberOfPlayers() then
        if health then
            SetEntityHealth(Id, health)
        else
            if IsPedMale(Id) then
                SetEntityHealth(Id, 200)
            else
                SetEntityHealth(Id, 100)
            end
        end
    else
        local ped = GetPlayerPed(GetPlayerFromServerId(Id))
        
        if health then
            SetEntityHealth(ped, health)
        else
            if IsPedMale(ped) then
                SetEntityHealth(ped, 200)
            else
                SetEntityHealth(ped, 100)
            end
        end
    end
end

---@param msg string notice content
---@param type string notice type ( success ; error ; info ; warning )
---@param time number time until notice closes (in miliseconds)
HRLib.Notify = function(msg, type, time)
    clib.Notify(msg, type, time)
end

---@param name string name of the command
---@param cb function function arguments: args, rawCommand, IPlayer
---@param enableAce boolean allow only the players with `command.cmdName` permission to have access to the command 
---@param suggestions table table format: {help = 'STRING', args = { {name = 'STRING', help = 'STRING'} } }
HRLib.RegCommand = function(name, cb, enableAce, suggestions)

    if name == nil or name == '' then
        print(('^3!WARNING!^5 %s ^1tried^5 to register a ^1client^5 command without name! ^3!WARNING!^0'):format(GetInvokingResource()))
        print(('^3!WARNING!^5 %s ^1tried^5 to register a ^1client^5 command without name! ^3!WARNING!^0'):format(GetInvokingResource()))
        print(('^3!WARNING!^5 %s ^1tried^5 to register a ^1client^5 command without name! ^3!WARNING!^0'):format(GetInvokingResource()))
        return
    end

    if clib.RegisteredCmds[name] then
        table.remove(clib.RegisteredCmds, tonumber(name))
        TriggerEvent('chat:removeSuggestion', '/'..name)
        clib.RegisteredCmds[name] = {cb = cb, suggestions = suggestions}
    else
        clib.RegisteredCmds[name] = {cb = cb, suggestions = suggestions}
    end
    
    if suggestions then if not suggestions.help then suggestions.help = '' elseif not suggestions.args then suggestions.args = {} end
        TriggerEvent('chat:addSuggestion', '/'..name, suggestions.help, suggestions.args) 
    end

    if enableAce == nil or type(enableAce) ~= 'boolean' then
        enableAce = false
    end

    RegisterCommand(name, function(source, args, rawCommand)
        IPlayer = clib.GetIPlayer(GetPlayerServerId(PlayerId()))
        FPlayer = clib.GetFPlayer(GetPlayerServerId(PlayerId()))

        cb(
            args,
            rawCommand,
            IPlayer,
            FPlayer
        )
    end, enableAce or false)GetPlayerPed(GetPlayerFromServerId(FPlayer.id))
end

---@param coords vector3
---@param clearedArea boolean true or false for clear the area whether player is spawning
FPlayer.Teleport = function(coords, clearedArea)
    local clearedArea = clearedArea or false
    SetEntityCoords(GetPlayerPed(GetPlayerFromServerId(FPlayer.id)), coords, true, false, true, clearedArea)
end

---@param vehModel string vehicle model
---@param spawnPedInside boolean true or false for spawn ped inside the vehicle
---@param cb function return the vehicle
FPlayer.SpawnVehicle = function(vehModel, spawnPedInside, cb)
    local ped = GetPlayerPed(GetPlayerFromServerId(FPlayer.id))
    local veh = CreateVehicle(GetHashKey(vehModel), GetEntityCoords(ped), GetEntityHeading(ped), true, false)
    if spawnPedInside then
        SetPedIntoVehicle(ped, veh, 1)
    end

    cb(veh)
end

---@param toggle boolean Toggle the ped status
FPlayer.Freeze = function(toggle)
    if toggle == nil or type(toggle) ~= 'boolean' then return end
    FreezeEntityPosition(GetPlayerPed(GetPlayerFromServerId(playerId)), toggle)
end

---@param msg string content of the notice
---@param type string type of the notice
---@param time number time until notice closes
FPlayer.Notify = function(msg, type, time)
    clib.Notify(msg, type, time)
end

---@param health number value of the player health
FPlayer.Health = function(health)
    local ped = GetPlayerPed(GetPlayerFromServerId(FPlayer.id))

    if health == nil then
        if IsPedMale(ped) then
            SetEntityHealth(ped, 200)
        else
            SetEntityHealth(ped, 100)
        end
    else
        SetEntityHealth(ped, health)
    end
end

---@param toggle boolean toggle player invincible
FPlayer.Invincible = function(toggle)
    SetPlayerInvincible(FPlayer.id, toggle or false)
end