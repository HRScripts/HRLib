local isServer <const> = IsDuplicityVersion()

---@param vehModel string|integer existing vehicle model or model hash
---@param coords vector4 vehicle spawn coordinates
---@return integer? vehicle
HRLib.SpawnVehicle = function(vehModel, coords)
    local modelHash <const> = type(vehModel) == 'number' and vehModel or joaat(vehModel)

    if type(coords) ~= 'vector4' or (isServer and type(modelHash) ~= 'number' or (not isServer and not IsModelValid(modelHash))) then return end

    if not isServer then
        RequestModel(modelHash)

        while not HasModelLoaded(modelHash) do
            Wait(10)
        end
    end

    if isServer then
        if #GetPlayers() == 0 then return end

        return CreateVehicleServerSetter(modelHash, HRLib.ClientCallback('____g_hr_spvgh_c_mdl', HRLib.ClosestIPlayer(coords, 500, false).id, vehModel), coords) ---@diagnostic disable-line: missing-parameter, param-type-mismatch
    end

    return CreateVehicle(modelHash, coords, true, true) ---@diagnostic disable-line: missing-parameter, param-type-mismatch
end

if not isServer then
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
end