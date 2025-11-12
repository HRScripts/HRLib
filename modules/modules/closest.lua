if IsDuplicityVersion() then
    ---The server side function to get the closest IPlayer in specific area
    ---@param source integer|vector3|vector4 the source, coords or playerId
    ---@param distance number? Default value is 50
    ---@param returnClosePlayers boolean?
    ---@return HRLibServerIPlayer? closestIPlayer, HRLibServerIPlayer[]? closeIPlayers
    HRLib.ClosestIPlayer = function(source, distance, returnClosePlayers)
        if type(source) ~= 'vector3' and type(source) ~= 'vector4' and (type(source) ~= 'number' or not HRLib.DoesIdExist(source)) then return end

        source = HRLib.DoesIdExist(source) and GetEntityCoords(GetPlayerPed(source --[[@as integer]])) or source.xyz

        local players <const> = GetPlayers()
        if #players > 0 then
            local firstPlayerPed = GetPlayerPed(tonumber(players[1]) --[[@as integer]])
            local firstPlayerDistance = #(source - GetEntityCoords(firstPlayerPed))
            local closestIPlayer, closeIPlayers = { id = tonumber(players[1]), ped = firstPlayerPed, distance = firstPlayerDistance <= distance and firstPlayerDistance or distance + 0.1 }, {}

            if closestIPlayer.distance > distance and #players == 1 then return end

            if #players > 1 then
                for i=2, #players do
                    local curr <const> = tonumber(players[i]) --[[@as integer]]
                    local currPed <const> = GetPlayerPed(curr)
                    local currDistance <const> = #(source - GetEntityCoords(currPed))
                    if closestIPlayer.distance > currDistance then
                        closeIPlayers[#closeIPlayers+1] = closestIPlayer
                        closestIPlayer = { id = curr, ped = currPed, distance = currDistance }
                    end
                end
            end

            if #closeIPlayers > 0 then
                for i=1, #closeIPlayers do
                    closeIPlayers[i] = HRLib.GetIPlayer(closeIPlayers[i].id)
                end
            end

            if returnClosePlayers and #closeIPlayers > 0 then
                return HRLib.GetIPlayer(closestIPlayer.id), closeIPlayers
            else
                return HRLib.GetIPlayer(closestIPlayer.id)
            end
        end
    end
else
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
end