local isServer <const> = IsDuplicityVersion()
if isServer then
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

    ---Function to spawn a vehicle on the coords of the current player
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

        local pedCoords <const> = GetEntityCoords(ped)
        local veh <const> = CreateVehicle(type(vehModel) == 'string' and joaat(vehModel) or vehModel, pedCoords.x, pedCoords.y, pedCoords.z, GetEntityHeading(ped), true, false)

        if spawnPlayerInside == true then
            SetPedIntoVehicle(ped, veh, -1)
        end

        return veh
    end

    ---Function to notify the current player
    ---@param description string content of the notice
    ---@param type 'success'|'error'|'info'|'warning' notification type
    ---@param duration number? notification duration in msec, default is 2500
    ---@param pos 'top-left'|'top-center'|'top-right'|'center-left'|'center'|'center-right'|'bottom-left'|'bottom-center'|'bottom-right'?
    ---@param sound boolean? default is true
    function fplayer:Notify(description, type, duration, pos, sound)
        HRLib.Notify(self.id, description, type, duration, pos, sound)
    end

    ---Function to execute a client event for the current player
    ---@param eventName any the event name
    ---@param ... any the event parameters
    function fplayer:FocusedEvent(eventName, ...)
        if type(eventName) ~= 'string' then return end

        TriggerClientEvent(eventName, self.id, ...)
    end

    ---Function to set current player's coords
    ---@param coords vector3|vector4
    function fplayer:SetCoords(coords)
        local playerPed <const> = GetPlayerPed(self.id)

        SetEntityCoordsNoOffset(playerPed, table.unpack(coords.xyz))

        if type(coords) == 'vector4' then
            SetEntityHeading(playerPed, coords.w)
        end
    end

    ---Function to get an array of FPlayer for all players
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

    ---@param health number? value of the player health
    function fplayer:SetHealth(health)
        local ped <const> = GetPlayerPed(isServer and self.id or GetPlayerFromServerId(self.id))
        SetEntityHealth(ped, type(health) == 'number' and health or GetEntityMaxHealth(ped))
    end

    ---@param toggle boolean? toggle player invincible
    function fplayer:SetInvincibility(toggle)
        SetPlayerInvincible(isServer and self.id or GetPlayerFromServerId(self.id), toggle or false)
    end
else
    HRLib.FPlayer = {}

    ---Function to spawn a vehicle on the coords of the current player, containing a few options
    ---@param model string|integer
    ---@param spawnPlayerInside boolean
    ---@param saveVehicle boolean Save the old vehicle if 
    ---@return integer? vehicle
    HRLib.FPlayer.SpawnVehicle = function(model, spawnPlayerInside, saveVehicle)
        model = type(model) == 'string' and joaat(model) or type(model) == 'number' and model or -1

        if IsModelValid(model) and IsModelAVehicle(model) then
            local ped <const> = PlayerPedId()

            if not saveVehicle then
                local oldVeh <const> = GetVehiclePedIsIn(ped, false)
                if oldVeh then
                    DeleteEntity(oldVeh)
                end
            end

            HRLib.RequestModel(model)

            local pedCoords <const> = GetEntityCoords(ped)
            local veh <const> = CreateVehicle(type(model) == 'string' and joaat(model) or model, pedCoords.x, pedCoords.y, pedCoords.z, GetEntityHeading(ped), true, false)

            if spawnPlayerInside then
                SetPedIntoVehicle(ped, veh, -1)
            end

            return veh
        end
    end

    ---Function to set current player's coords
    ---@param coords vector3|vector4
    HRLib.FPlayer.SetCoords = function(coords)
        local playerPed <const> = PlayerPedId()

        SetEntityCoordsNoOffset(playerPed, coords.x, coords.y, coords.z) ---@diagnostic disable-line: missing-parameter

        if type(coords) == 'vector4' then
            SetEntityHeading(playerPed, coords.w)
        end
    end

    ---Function to set current player's health
    ---@param health number?
    HRLib.FPlayer.SetHealth = function(health)
        local ped <const> = PlayerPedId()
        SetEntityHealth(ped, type(health) == 'number' and health or GetEntityMaxHealth(ped))
    end
end