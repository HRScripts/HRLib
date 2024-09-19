local fplayer <const>, clib <const> = setmetatable({
    id = nil
}, {
    __index = function(self, key)
        if not self.id then
            return 'FPlayer Id\'s not set'
        else
            return self[key]
        end
    end
}), load(LoadResourceFile('HRLib', 'client/modules/local.lua'), '@@HRLib/client/modules/local.lua')()

function fplayer:newObject(id)
    local newObject <const> = table.clone(fplayer)
    newObject.id = id

    return newObject
end

---@param coords vector3
---@changelog version 1.0.0, version 2.0.0
---@version 2.0.0
function fplayer:Teleport(coords)
    if type(coords) ~= 'vector3' or not clib.DoesIdExist(self.id) then return end

    SetEntityCoordsNoOffset(GetPlayerPed(GetPlayerFromServerId(self.id)), coords) ---@diagnostic disable-line: missing-parameter, param-type-mismatch
end

---@param vehModel string|integer vehicle spawn code or model hash
---@param spawnPedInside boolean?
---@param saveVehicle boolean?
---@return integer?
---@changelog version 1.0.0
---@version 1.0.0
function fplayer:SpawnVehicle(vehModel, spawnPedInside, saveVehicle)
    if not clib.DoesIdExist(self.id) then return end

    local model <const>, ped <const> = joaat(vehModel), GetPlayerPed(GetPlayerFromServerId(self.id))

    RequestModel(model)

    while not HasModelLoaded(model) do
        Wait(50)
    end

    if not saveVehicle then
        local oldVeh = GetVehiclePedIsIn(ped, false)
        if oldVeh then
            DeleteEntity(oldVeh)
        end
    end

    local veh <const> = CreateVehicle(model, GetEntityCoords(ped), GetEntityHeading(ped), true, false) ---@diagnostic disable-line: missing-parameter, param-type-mismatch
    SetModelAsNoLongerNeeded(model)

    if spawnPedInside then
        SetPedIntoVehicle(ped, veh, -1)
    end

    return veh
end

---@param toggle boolean? toggle the ped status
---@changelog version 1.0.0
---@version 1.0.0
function fplayer:Freeze(toggle)
    if not clib.DoesIdExist(self.id) then return end

    local ped <const> = GetPlayerPed(GetPlayerFromServerId(self.id))
    toggle = toggle or false

    FreezeEntityPosition(ped, toggle)
    SetEntityCollision(ped, not toggle, false)
    SetEntityCanBeDamaged(ped, not toggle)
    SetPlayerControl(GetPlayerFromServerId(self.id), not toggle) ---@diagnostic disable-line: missing-parameter
end

---@param health number value of the player health
---@changelog version 1.0.0
---@version 1.0.0
function fplayer:Health(health)
    if not clib.DoesIdExist(self.id) then return end

    local ped <const> = GetPlayerPed(GetPlayerFromServerId(self.id))
    SetEntityHealth(ped, health or (IsPedMale(ped) and 200 or 100))
end

---@param toggle boolean toggle player invincible
---@changelog version 1.0.0
---@version 1.0.0
function fplayer:Invincible(toggle)
    if not clib.DoesIdExist(self.id) then return end

    SetPlayerInvincible(GetPlayerFromServerId(self.id), toggle or false)
end

return fplayer