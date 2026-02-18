if IsDuplicityVersion() then
    ---@param playerId integer
    ---@return string[]
    HRLib.GetPedWeapons = function(playerId)
        if not HRLib.DoesIdExist(playerId, true) then error('^4HRLib:^1 This resource tried to execute HRLib.GetPedWeapons, providing an invalid playerId.\nPlease make sure to always check the id\'s existance before using this function.') end

        return HRLib.ClientCallback('__HRLib_getPedWeapons', playerId)
    end
else
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

    HRLib.CreateCallback('__HRLib_getPedWeapons', true, function()
        if TriggerSide == 'server' then
            return HRLib.GetPedWeapons()
        end
    end)
end