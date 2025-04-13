if IsDuplicityVersion() then return end

---@param vehicle integer
---@return integer[]?
HRLib.GetPedsInVehicle = function(vehicle)
    if DoesEntityExist(vehicle) then
        local seatsCount <const> = GetVehicleModelNumberOfSeats(GetEntityModel(vehicle))
        local peds <const> = {}

        for i=-1, seatsCount do
            local currPed <const> = GetPedInVehicleSeat(vehicle, i)
            if DoesEntityExist(currPed) then
                peds[#peds+1] = currPed
            end
        end

        return #peds > 0 and peds or nil
    end
end