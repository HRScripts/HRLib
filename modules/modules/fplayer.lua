local isServer <const> = IsDuplicityVersion()
local fplayer <const> = setmetatable({
    id = nil
}, {
    __index = function(self, key)
        if not self.id then
            return 'FPlayer Id\'s not set'
        else
            return self[key]
        end
    end
})

function fplayer:newObject(id)
    local newObject <const> = HRLib.table.deepclone(fplayer)
    newObject.id = id

    return newObject
end

---@param coords vector3
function fplayer:teleport(coords)
    if type(coords) ~= 'vector3' then return end

    SetEntityCoordsNoOffset(GetPlayerPed(GetPlayerFromServerId(self.id)), coords) ---@diagnostic disable-line: missing-parameter, param-type-mismatch
end

if isServer then
    ---@param vehModel string|integer vehicle model
    ---@param spawnPlayerInside boolean? spawn ped inside the vehicle
    ---@param saveVehicle boolean? save the old vehicle
    ---@return integer
    function fplayer:spawnVehicle(vehModel, spawnPlayerInside, saveVehicle)
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
    function fplayer:notify(msg, type, time)
        HRLib.Notify(self.id, msg, type, time)
    end

    ---@return HRLibServerFPlayer[]|{}
    HRLib.AllFPlayers = function()
        local allFPlayers <const> = {}

        local players <const> = GetPlayers()
        for i=1, #players do
            allFPlayers[#allFPlayers+1] = fplayer:newObject(tonumber(players[i]))
        end

        return allFPlayers
    end
else
    ---@param vehModel string|integer vehicle spawn code or model hash
    ---@param spawnPlayerInside boolean?
    ---@param saveVehicle boolean?
    ---@return integer?
    function fplayer:spawnVehicle(vehModel, spawnPlayerInside, saveVehicle)
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

        if spawnPlayerInside then
            SetPedIntoVehicle(ped, veh, -1)
        end

        return veh
    end

    ---Freeze the current player
    ---@param toggle boolean? toggle the ped status
    function fplayer:freeze(toggle)
        local ped <const> = GetPlayerPed(GetPlayerFromServerId(self.id))
        toggle = toggle or false

        FreezeEntityPosition(ped, toggle)
        SetEntityCollision(ped, not toggle, false)
        SetEntityCanBeDamaged(ped, not toggle)
        SetPlayerControl(GetPlayerFromServerId(self.id), not toggle) ---@diagnostic disable-line: missing-parameter
    end
end

---@param health number value of the player health
function fplayer:setHealth(health)
    local ped <const> = GetPlayerPed(GetPlayerFromServerId(self.id))
    SetEntityHealth(ped, health or (IsPedMale(ped) and 200 or 100))
end

---@param toggle boolean? toggle player invincible
function fplayer:setInvincibility(toggle)
    SetPlayerInvincible(GetPlayerFromServerId(self.id), toggle or false)
end

---@param playerId integer?
---@return HRLibClientFPlayer?
HRLib.GetFPlayer = function(playerId)
    if playerId and HRLib.DoesIdExist(playerId) then
        return fplayer:newObject(playerId)
    elseif not playerId then
        return fplayer:newObject(GetPlayerServerId(PlayerId()))
    end
end