if IsDuplicityVersion() then return end

---Function to get the closest ped to the player
---@param returnClosePeds boolean? returns the peds found in this radius
---@return { ped: integer, distance: number }? closestPed, { ped: integer, distance: number }[]? closePeds
HRLib.ClosestPed = function(returnClosePeds)
    local ped <const> = PlayerPedId()
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

---Function to get the closest vehicle to the player
---@param returnCloseVehs boolean?
---@return { vehicle: integer, distance: number }? closestVehicle, { vehicle: integer, distance: number }[]? closeVehicles
HRLib.ClosestVehicle = function(returnCloseVehs)
    local ped <const>, vehs <const> = PlayerPedId(), GetGamePool('CVehicle')
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

---Function to get the closest object to the player
---@param returnCloseObjects boolean?
---@return { entity: integer, distance: number }? closestObject, { entity: integer, distance: number }[]? closeObjects
HRLib.ClosestObject = function(returnCloseObjects)
    local objects <const>, playerCoords <const> = GetGamePool('CObject'), GetEntityCoords(PlayerPedId())
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

---Function to get the closest IPlayer to the player
---@param returnCloseIPlayers boolean?
---@return HRLibCloseIPlayer? closestIPlayer, HRLibCloseIPlayer[]? closeIPlayers
HRLib.ClosestIPlayer = function(returnCloseIPlayers)
    local closestPed <const>, closePeds <const> = HRLib.ClosestPed(true)
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