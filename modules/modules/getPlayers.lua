local eventName <const> = ('__%s:allPlayers'):format(GetCurrentResourceName())
if IsDuplicityVersion() then
    HRLib.CreateCallback(eventName, true, function()
        return GetPlayers()
    end)
else
    ---@return integer[]?
    HRLib.GetPlayers = function()
        local players <const> = HRLib.ServerCallback(eventName)

        for i=1, #players do
            players[i] = tonumber(players[i]) --[[@as integer]]
        end

        return #players > 0 and players or nil
    end
end