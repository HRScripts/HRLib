---@param value function|table?
---@return boolean
HRLib.IsFunction = function(value)
    return type(value) == 'function' or (type(value) == 'table' and type(getmetatable(value)?.__call) == 'function')
end