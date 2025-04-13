if IsDuplicityVersion() then return end

---Get the status for each door of the given vehicle
---@param vehicle integer
---@return boolean[]? statusList true for each value means the door's closed and false for each value means the door's opened
HRLib.GetVehicleDoorStatus = function(vehicle)
    local doorsStatus <const> = {}

    for i=0, GetVehicleModelNumberOfSeats(GetEntityModel(vehicle)) do
        doorsStatus[#doorsStatus+1] = GetVehicleDoorAngleRatio(vehicle, i) == 0
    end

    return #doorsStatus > 0 and doorsStatus or nil
end