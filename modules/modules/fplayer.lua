local isServer <const> = IsDuplicityVersion()
local fplayer <const> = setmetatable({
    id = nil
}, {
    __index = function(self, key)
        if not self.id then
            return 'FPlayer Id\'s not set'
        else
            return rawget(self, key)
        end
    end
})

---@param id integer
function fplayer:newObject(id)
    if not HRLib.DoesIdExist(tonumber(id)) then return end

    local newObject <const> = HRLib.table.deepclone(fplayer)
    newObject.id = id

    return newObject
end

---@param coords vector3
function fplayer:Teleport(coords)
    if type(coords) ~= 'vector3' then return end

    SetEntityCoordsNoOffset(GetPlayerPed(isServer and self.id or GetPlayerFromServerId(self.id)), coords) ---@diagnostic disable-line: missing-parameter, param-type-mismatch
end

if isServer then
    ---@param vehModel string|integer vehicle model
    ---@param spawnPlayerInside boolean? spawn ped inside the vehicle
    ---@param saveVehicle boolean? save the old vehicle
    ---@return integer? vehicle
    function fplayer:SpawnVehicle(vehModel, spawnPlayerInside, saveVehicle)
        local ped <const> = GetPlayerPed(self.id)

        if not saveVehicle then
            local oldVeh <const> = GetVehiclePedIsIn(ped, false)
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

    ---@param description string content of the notice
    ---@param type 'success'|'error'|'info'|'warning' notification type
    ---@param duration number? notification duration in msec, default is 2500
    ---@param pos 'top-right'|'center-right'|'bottom-right'|'frombelow-right'|'top-left'|'left-center'|'frombelow-left'?
    ---@param sound boolean? default is true
    function fplayer:Notify(description, type, duration, pos, sound)
        HRLib.Notify(self.id, description, type, duration, pos, sound)
    end

    ---@param eventName any the event name
    ---@param ... any the event parameters
    function fplayer:FocusedEvent(eventName, ...)
        if type(eventName) ~= 'string' then return end

        TriggerClientEvent(eventName, self.id, ...)
    end

    ---@return HRLibServerFPlayer[]?
    HRLib.AllFPlayers = function()
        local allFPlayers <const> = {}

        local players <const> = GetPlayers()
        for i=1, #players do
            allFPlayers[#allFPlayers+1] = fplayer:newObject(tonumber(players[i]) --[[@as integer]])
        end

        return #allFPlayers > 0 and allFPlayers or nil
    end

    ---Function to get FPlayer's list of methods
    ---@param playerId integer?
    ---@return HRLibServerFPlayer?
    HRLib.GetFPlayer = function(playerId)
        if playerId and HRLib.DoesIdExist(playerId) then
            return fplayer:newObject(playerId)
        end
    end
else
    ---@param vehModel string|integer vehicle spawn code or model hash
    ---@param spawnPlayerInside boolean?
    ---@param saveVehicle boolean?
    ---@return integer? vehicle
    function fplayer:SpawnVehicle(vehModel, spawnPlayerInside, saveVehicle)
        local model <const>, ped <const> = joaat(vehModel), GetPlayerPed(GetPlayerFromServerId(self.id))

        HRLib.RequestModel(model)

        if not saveVehicle then
            local oldVeh <const> = GetVehiclePedIsIn(ped, false)
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
    function fplayer:Freeze(toggle)
        local ped <const> = GetPlayerPed(GetPlayerFromServerId(self.id))
        toggle = toggle or false

        FreezeEntityPosition(ped, toggle)
        SetEntityCollision(ped, not toggle, false)
        SetEntityCanBeDamaged(ped, not toggle)
        SetPlayerControl(GetPlayerFromServerId(self.id), not toggle) ---@diagnostic disable-line: missing-parameter
    end

    ---Function to get FPlayer's list of methods
    ---@return HRLibClientFPlayer?
    HRLib.GetFPlayer = function()
        return fplayer:newObject(GetPlayerServerId(PlayerId()))
    end
end

---@param health number? value of the player health
function fplayer:SetHealth(health)
    local ped <const> = GetPlayerPed(isServer and self.id or GetPlayerFromServerId(self.id))
    SetEntityHealth(ped, type(health) == 'number' and health or GetEntityMaxHealth(ped))
end

---@param toggle boolean? toggle player invincible
function fplayer:SetInvincibility(toggle)
    SetPlayerInvincible(isServer and self.id or GetPlayerFromServerId(self.id), toggle or false)
end