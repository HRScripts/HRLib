if IsDuplicityVersion() then
    HRLib.CreateCallback(('__%s:allPlayers'):format(GetCurrentResourceName()), true, function()
        return GetPlayers()
    end)
else
    ---@return integer[]
    HRLib.GetPlayers = function()
        local players <const> = HRLib.ServerCallback(('__%s:allPlayers'):format(GetCurrentResourceName()))

        for i=1, #players do
            players[i] = tonumber(players[i]) --[[@as integer]]
        end

        return players
    end
end