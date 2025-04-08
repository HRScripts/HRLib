local isServer <const> = IsDuplicityVersion()

---@param vehModel string|integer existing vehicle model or model hash
---@param coords vector4 vehicle spawn coordinates
---@return integer? vehicleModel
HRLib.SpawnVehicle = function(vehModel, coords)
    local modelHash <const> = type(vehModel) == 'number' and vehModel or joaat(vehModel)

    if type(coords) ~= 'vector4' or (isServer and type(modelHash) ~= 'number' or not IsModelValid(modelHash)) then return end

    if not isServer then
        RequestModel(modelHash)

        while not HasModelLoaded(modelHash) do
            Wait(10)
        end
    end

    return CreateVehicle(modelHash, coords, true, true) ---@diagnostic disable-line: missing-parameter, param-type-mismatch
end