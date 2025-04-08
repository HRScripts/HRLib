---@param plate string<8>
---@return integer|integer[]? entityId
HRLib.GetVehicleFromPlate = function(plate)
    local vehicles <const> = IsDuplicityVersion() and GetAllVehicles() or GetGamePool('CVehicle')
    local focusedVehicles <const> = {}

    for i=1, #vehicles do
        if GetVehicleNumberPlateText(vehicles[i]) == plate then
            focusedVehicles[#focusedVehicles+1] = vehicles[i]
        end
    end

    if #focusedVehicles > 1 then
        return focusedVehicles
    elseif #focusedVehicles == 1 then
        return focusedVehicles[1]
    end
end