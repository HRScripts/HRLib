if IsDuplicityVersion() then return end

---@param Id integer? An existing player server Id or nil for the current player server Id or the ped
---@param returnClosePeds boolean? returns the peds found in this radius
---@return { ped: integer, distance: number }? closestPed, { ped: integer, distance: number }[]? closePeds
HRLib.ClosestPed = function(Id, returnClosePeds)
    local ped <const> = type(Id) == 'number' and GetPlayerPed(GetPlayerFromServerId(Id)) or type(Id) == 'nil' and PlayerPedId() or Id --[[@as integer]]
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
---@param returnCloseVehs boolean?
---@return { vehicle: integer, distance: number }? closestVehicle, { vehicle: integer, distance: number }[]? closeVehs
HRLib.ClosestVehicle = function(Id, returnCloseVehs)
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
---@return { entity: integer, distance: number }? closestObject, { entity: integer, distance: number }[]? closeObjects
HRLib.ClosestObject = function(Id, returnCloseObjects)
    local objects <const>, playerCoords <const> = GetGamePool('CObject'), Id and GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(Id)) or GetEntityCoords(PlayerPedId())) or GetEntityCoords(PlayerPedId())
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
---@return HRLibCloseIPlayer? closestIPlayer, HRLibCloseIPlayer[]? closeIPlayers
HRLib.ClosestIPlayer = function(Id, returnCloseIPlayers)
    local closestPed <const>, closePeds <const> = HRLib.ClosestPed(Id, true)
    if closestPed and closePeds then
        if IsPedAPlayer(closestPed.ped) then
            local closestIPlayer = {}

            if IsPedAPlayer(closestPed.ped) then
                closestIPlayer = HRLib.GetIPlayer(GetPlayerServerId(NetworkGetPlayerIndexFromPed(closestPed.ped))) --[[@as HRLibCloseIPlayer]]
                closestIPlayer.distance = closestPed.distance
            end

            if returnCloseIPlayers then
                local closeIPlayers <const> = {}

                for i=1, #closePeds do
                    local curr <const> = closePeds[i]
                    if IsPedAPlayer(curr.ped) then
                        if table.type(closestIPlayer) == 'empty' then
                            closestIPlayer = HRLib.GetIPlayer(GetPlayerServerId(NetworkGetPlayerIndexFromPed(curr.ped))) --[[@as HRLibCloseIPlayer]]
                            closestIPlayer.distance = curr.distance
                        else
                            closeIPlayers[#closeIPlayers+1] = HRLib.GetIPlayer(GetPlayerServerId(NetworkGetPlayerIndexFromPed(curr.ped)))
                        end
                    end
                end

                return closestIPlayer, closeIPlayers
            else
                return closestIPlayer
            end
        end
    end
end

---@param Id integer? An existing player server Id or nil for the current player server Id
---@param returnCloseFPlayers boolean?
---@return HRLibCloseFPlayer? closestFPlayer, HRLibCloseFPlayer[]? closeFPlayers
HRLib.ClosestFPlayer = function(Id, returnCloseFPlayers)
    local closestPed <const>, closePeds <const> = HRLib.ClosestPed(Id, true)
    if closestPed and closePeds then
        if IsPedAPlayer(closestPed.ped) then
            local closestFPlayer = {}

            if IsPedAPlayer(closestPed.ped) then
                closestFPlayer = HRLib.GetFPlayer(GetPlayerServerId(NetworkGetPlayerIndexFromPed(closestPed.ped))) --[[@as HRLibCloseFPlayer]]
                closestFPlayer.distance = closestPed.distance
            end

            if returnCloseFPlayers then
                local closeFPlayers <const> = {}

                for i=1, #closePeds do
                    local curr <const> = closePeds[i]
                    if IsPedAPlayer(curr.ped) then
                        if table.type(closestFPlayer) == 'empty' then
                            closestFPlayer = HRLib.GetFPlayer(GetPlayerServerId(NetworkGetPlayerIndexFromPed(curr.ped))) --[[@as HRLibCloseFPlayer]]
                            closestFPlayer.distance = curr.distance
                        else
                            closeFPlayers[#closeFPlayers+1] = HRLib.GetFPlayer(GetPlayerServerId(NetworkGetPlayerIndexFromPed(curr.ped)))
                        end
                    end
                end

                return closestFPlayer, closeFPlayers
            else
                return closestFPlayer
            end
        end
    end
end