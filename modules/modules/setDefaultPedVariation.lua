---@param ped integer
HRLib.SetDefaultPedVariation = function(ped)
    SetPedComponentVariation(ped, 0, 0, 0, 2)
    SetPedComponentVariation(ped, 1, 0, 0, 2)
    SetPedComponentVariation(ped, 2, 0, 0, 2)
    SetPedComponentVariation(ped, 3, 0, 0, 2)
    SetPedComponentVariation(ped, 4, 0, 0, 2)
    SetPedComponentVariation(ped, 5, 0, 0, 2)
    SetPedComponentVariation(ped, 6, 0, 0, 2)
    SetPedComponentVariation(ped, 7, 0, 0, 2)
    SetPedComponentVariation(ped, 8, 0, 0, 2)
    SetPedComponentVariation(ped, 9, 0, 0, 2)
    SetPedComponentVariation(ped, 10, 0, 0, 2)
    SetPedComponentVariation(ped, 11, 0, 0, 2)

    for i = 0, 7 do
        ClearPedProp(ped, i)
    end
end