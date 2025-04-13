if IsDuplicityVersion() then return end

---@return string[]?
HRLib.GetPedWeapons = function()
    local pedWeapons <const> = {}

    local playerPed <const> = PlayerPedId()
    for i=1, #HRLib.Weapons do
        if HasPedGotWeapon(playerPed, joaat(HRLib.Weapons[i]), false) then
            pedWeapons[#pedWeapons+1] = HRLib.Weapons[i]
        end
    end

    return #pedWeapons > 0 and pedWeapons or nil
end