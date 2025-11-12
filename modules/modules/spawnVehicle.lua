local isServer <const> = IsDuplicityVersion()

if isServer then
    ---Function to spawn a vehicle from the server side
    ---@param vehModel string|integer existing vehicle model or model hash
    ---@param coords vector4 vehicle spawn coordinates
    ---@param vehType string? Required parameter which's only not required when there is more than one player in the server
    ---@return integer? vehicle
    HRLib.SpawnVehicle = function(vehModel, coords, vehType)
        do
            local currRes <const> = GetInvokingResource() or GetCurrentResourceName()
            if type(coords) ~= 'vector4' then
                return warn(('Resource %s tried to spawn a vehicle without providing spawn coords'):format(currRes))
            elseif not vehType and #GetPlayers() == 0 then
                return warn(('Resource %s tried to spawn a vehicle without providing vehicle type while there are no players in the server!'):format(currRes))
            elseif not vehType then
                vehType = HRLib.ClientCallback('____g_hr_spvgh_c_mdl', HRLib.ClosestIPlayer(coords, 500, false)?.id or GetPlayers()[1], vehModel)
            end
        end

        return CreateVehicleServerSetter(type(vehModel) == 'number' and vehModel or joaat(vehModel), vehType, table.unpack(coords))
    end
else
    HRLib.CreateCallback('____g_hr_spvgh_c_mdl', true, function(model)
        model = type(model) == 'string' and joaat(model) or model
        if not IsModelValid(model) or not IsModelAVehicle(model) then return end

        local found

        local prefix, modules = 'IsThisModelA%s', { 'Bicycle', 'Bike', 'Boat', 'Car', 'Heli', 'Jetski', 'Plane', 'Quadbike', 'Train' }
        for i=1, #modules do
            if _ENV[(prefix):format(modules[i])](model) then
                found = modules[i]

                break
            end
        end

        found = found == 'Bicycle' and 'automobile' or found
        found = found == 'Bike' and 'bike' or found
        found = found == 'Boat' and 'boat' or found
        found = found == 'Car' and 'automobile' or found
        found = found == 'Heli' and 'heli' or found
        found = found == 'Plane' and 'plane' or found
        found = found == 'Quadbike' and 'bike' or found
        found = found == 'Train' and 'train' or found

        return found
    end)

    ---@param vehModel string|integer existing vehicle model or model hash
    ---@param coords vector4 vehicle spawn coordinates
    ---@return integer? vehicle
    HRLib.SpawnVehicle = function(vehModel, coords)
        local modelHash <const> = type(vehModel) == 'number' and vehModel or joaat(vehModel)

        if not IsModelValid(modelHash) or type(coords) ~= 'vector4' then return end

        HRLib.RequestModel(vehModel)

        return CreateVehicle(modelHash, coords.x, coords.y, coords.z, coords.w, true, true)
    end
end