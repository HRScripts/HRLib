---@param playerId integer? player server Id
---@return boolean
HRLib.DoesIdExist = function(playerId)
    if playerId == nil or type(playerId) ~= 'number' or type(playerId) == 'string' and type(tonumber(playerId)) ~= 'number' then return false end

    playerId = tonumber(playerId) --[[@as integer]]

    local players <const> = IsDuplicityVersion() and GetPlayers() or HRLib.GetPlayers()
    for i=1, #players do
        if tonumber(players[i]) == playerId then
            return true
        end
    end

    return false
end