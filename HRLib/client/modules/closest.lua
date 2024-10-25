local closestFuncs <const>, clib <const> = {}, load(LoadResourceFile('HRLib', 'client/modules/local.lua'), '@@HRLib/client/local.lua')()

---@param Id integer? An existing player server Id or nil for the current player server Id or the ped
---@param returnClosePeds boolean returns the peds found in this radius
---@changelog version 1.0.0, version 2.0.0
---@version 2.0.0
---@return { ped: integer, distance: number }? closestPed, { ped: integer, distance: number }[]? closePeds
closestFuncs.ClosestPed = function(Id, returnClosePeds)
    local ped <const> = (type(Id) == 'number' and clib.DoesIdExist(Id)) and GetPlayerPed(GetPlayerFromServerId(Id)) or type(Id) == 'nil' and PlayerPedId() or Id --[[@as integer]]
    local pedCoords <const> = GetEntityCoords(ped)
    local closestPed

    local peds <const> = GetGamePool('CPed')
    for i=1, #peds do
        peds[i] = { ped = peds[i], distance = #(pedCoords - GetEntityCoords(peds[i])) }

        local curr <const> = peds[i]
        if not closestPed then
            if curr.ped ~= ped then
                closestPed = curr
            end
        else
            if curr.ped ~= ped and closestPed.distance > curr.distance then
                closestPed = curr
            end
        end
    end

    if returnClosePeds then
        return closestPed, peds
    end

    return closestPed
end

---@param Id integer? existing player server Id or nil for the current player server Id
---@param returnCloseVehs boolean
---@changelog version 1.0.0, version 2.0.0
---@version 2.0.0
---@return { vehicle: integer, distance: number }? closestVehicle, { vehicle: integer, distance: number }[]? closeVehs
closestFuncs.ClosestVehicle = function(Id, returnCloseVehs)
    local ped <const>, vehs <const> = Id and GetPlayerPed(GetPlayerFromServerId(Id)) or PlayerPedId(), GetGamePool('CVehicle')
    local closestVehicle

    for i=1, #vehs do
        vehs[i] = { vehicle = vehs[i], distance = #(GetEntityCoords(ped) - GetEntityCoords(vehs[i])) }

        local curr <const> = vehs[i]
        if not closestVehicle then
            closestVehicle = curr
        else
            if closestVehicle.distance > curr.distance then
                closestVehicle = curr
            end
        end
    end

    if returnCloseVehs then
        return closestVehicle, vehs
    end

    return closestVehicle
end

---@param Id integer? existing player server Id or nil for the current player server Id
---@param returnCloseObjects boolean?
---@changelog version 1.0.0
---@version 1.0.0
---@return { entity: integer, distance: number }? closestObject, { entity: integer, distance: number }[]? closeObjects
closestFuncs.ClosestObject = function(Id, returnCloseObjects)
    local objects <const>, playerCoords <const> = GetGamePool('CObject'), Id and (clib.DoesIdExist(Id) and GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(Id))) or GetEntityCoords(PlayerPedId())) or GetEntityCoords(PlayerPedId())
    local closestObject

    for i=1, #objects do
        objects[i] = { entity = objects[i], distance = #(playerCoords - GetEntityCoords(objects[i])) }

        local curr <const> = objects[i]
        if type(closestObject) == 'nil' or table.type(closestObject) == 'empty' then
            closestObject = curr
        else
            if closestObject.distance > curr.distance then
                closestObject = curr
            end
        end
    end

    if returnCloseObjects then
        return closestObject, objects
    end

    return closestObject
end

---@param Id integer? An existing player server Id or nil for the current player server Id
---@param returnCloseIPlayers boolean?
---@changelog version 1.0.0
---@version 1.0.0
---@return HRLibCloseIPlayer? closestIPlayer, HRLibCloseIPlayer[]? closeIPlayers
closestFuncs.ClosestIPlayer = function(Id, returnCloseIPlayers)
    local closestPed <const>, closePeds <const> = closestFuncs.ClosestPed(Id, true) ---@diagnostic disable-line: deprecated
    if closestPed and closePeds then
        if IsPedAPlayer(closestPed.ped) then
            return clib.GetIPlayer(GetPlayerServerId(NetworkGetPlayerIndexFromPed(closestPed.ped)))
        else
            local closeIPlayers <const>, closestIPlayer = {}, nil

            for i=1, #closePeds do
                local curr <const> = closePeds[i]
                if IsPedAPlayer(curr.ped) then
                    closeIPlayers[#closeIPlayers+1] = clib.GetIPlayer(GetPlayerServerId(NetworkGetPlayerIndexFromPed(curr.ped)))
                    closeIPlayers[#closeIPlayers].distance = curr.distance
                end
            end

            closestIPlayer = closeIPlayers[1]

            if table.type(closeIPlayers) == 'array' then
                for i=2, #closeIPlayers do
                    local curr <const> = closeIPlayers[i]
                    if closestIPlayer.distance > curr.distance then
                        closestIPlayer = curr
                    end
                end

                if returnCloseIPlayers then
                    return closestIPlayer, closeIPlayers
                end

                return closestIPlayer
            end
        end
    end
end

---@param Id integer? An existing player server Id or nil for the current player server Id
---@changelog version 1.0.0
---@version 1.0.0
---@return HRLibCloseFPlayer? closestFPlayer, HRLibCloseFPlayer[]? closeFPlayers
closestFuncs.ClosestFPlayer = function(Id, returnCloseFPlayers)
    local closestPed <const>, closePeds <const> = closestFuncs.ClosestPed(Id, true) ---@diagnostic disable-line: deprecated
    if closestPed and closePeds then
        if IsPedAPlayer(closestPed.ped) then
            return clib.GetIPlayer(GetPlayerServerId(NetworkGetPlayerIndexFromPed(closestPed.ped)))
        else
            local closeFPlayers <const>, closestIPlayer = {}, nil

            for i=1, #closePeds do
                local curr <const> = closePeds[i]
                if IsPedAPlayer(curr.ped) then
                    closeFPlayers[#closeFPlayers+1] = clib.GetIPlayer(GetPlayerServerId(NetworkGetPlayerIndexFromPed(curr.ped)))
                    closeFPlayers[#closeFPlayers].distance = curr.distance
                end
            end

            closestIPlayer = closeFPlayers[1]

            if table.type(closeFPlayers) == 'array' then
                for i=2, #closeFPlayers do
                    local curr <const> = closeFPlayers[i]
                    if closestIPlayer.distance > curr.distance then
                        closestIPlayer = curr
                    end
                end

                if returnCloseFPlayers then
                    return closestIPlayer, closeFPlayers
                end

                return closestIPlayer
            end
        end
    end
end

return closestFuncs