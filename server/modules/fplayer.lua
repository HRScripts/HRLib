local fplayer <const>, clib <const> = setmetatable({
    id = nil
}, {
    __index = function(self, key)
        if not self.id then
            return 'FPlayer Id\'s not set'
        else
            return rawget(self, key)
        end
    end
}), load(LoadResourceFile('HRLib', 'server/modules/local.lua'), '@@HRLib/server/modules/local.lua')()

function fplayer:newObject(id)
    local newObject <const> = table.clone(fplayer)
    newObject.id = id

    return newObject
end

---teleport the current player to any given coords
---@param coords vector3 coords that are the coords where player be teleported to
---@changelog version 1.0.0
---@version 1.0.0
function fplayer:Teleport(coords)
    SetEntityCoords(GetPlayerPed(self.id), coords) ---@diagnostic disable-line: missing-parameter, param-type-mismatch
end

---trigger a fucused client event to the current player
---@param eventName string
---@param ... any?
function fplayer:FocusedEvent(eventName, ...)
    TriggerClientEvent(eventName, self.id, ...)
end

---@param vehModel string|integer vehicle model
---@param spawnPlayerInside boolean? spawn ped inside the vehicle
---@param saveVehicle boolean? save the old vehicle
---@changelog version 1.0.0, version 2.0.0, version 2.1.0
---@version 2.1.0 removed the cb method and add the return method
---@return integer
function fplayer:SpawnVehicle(vehModel, spawnPlayerInside, saveVehicle)
    local ped <const> = GetPlayerPed(self.id)

    if not saveVehicle then
        local oldVeh = GetVehiclePedIsIn(ped, false)
        if oldVeh then
            DeleteEntity(oldVeh)
        end
    end

    local veh <const> = CreateVehicle(type(vehModel) == 'string' and joaat(vehModel) or vehModel, GetEntityCoords(ped), GetEntityHeading(ped), true, false) ---@diagnostic disable-line: missing-parameter, param-type-mismatch

    if spawnPlayerInside == true then
        SetPedIntoVehicle(ped, veh, -1)
    end

    return veh
end

---@param msg string content of the notice
---@param type string notice type ( success ; error ; info ; warning )
---@param time number time until notice closes (in miliseconds)
---@changelog version 1.0.0
---@version 1.0.0
function fplayer:Notify(msg, type, time)
    clib.Notify(self.id, msg, type, time)
end

return fplayer