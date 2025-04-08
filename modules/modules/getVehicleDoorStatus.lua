if IsDuplicityVersion() then return end

---Get the status of all doors of a vehicle
---@param vehicle integer
---@return boolean[]|{} statusList true for each value means the door's closed and false for each value means the door's openned
HRLib.GetVehicleDoorStatus = function(vehicle)
    local doorsStatus <const> = {}

    for i=0, GetVehicleModelNumberOfSeats(GetEntityModel(vehicle)) do
        doorsStatus[#doorsStatus+1] = GetVehicleDoorAngleRatio(vehicle, i) == 0
    end

    return doorsStatus
end