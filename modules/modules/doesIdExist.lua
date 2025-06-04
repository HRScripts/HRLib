---@param playerId integer|string? player server Id
---@param onlyIdsOfJoinedPlayers boolean? default: false. Sets whether or not the check must be over the ids of the joined/spawned players in the game. Available in server side only
---@return boolean
HRLib.DoesIdExist = function(playerId, onlyIdsOfJoinedPlayers)
    if playerId == nil or type(playerId) ~= 'number' or type(playerId) == 'string' and type(tonumber(playerId)) ~= 'number' then return false end

    playerId = tonumber(playerId) --[[@as integer]]

    local isServer <const> = IsDuplicityVersion()
    if HRLib.table.find(isServer and GetPlayers() or HRLib.GetPlayers() --[[@as table]], isServer and tostring(playerId) or playerId) then
        return true
    elseif not onlyIdsOfJoinedPlayers and isServer and GetPlayerName(playerId) then
        return true
    end

    return false
end