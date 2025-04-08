---@param coords vector4|number[]
HRLib.ToVector4 = function(coords)
    if type(coords) == 'vector4' then return coords end
    if type(coords) ~= 'table' and (type(coords) == 'table' and table.type(coords) == 'array' and type(coords[1]) ~= 'number' and type(coords[2]) ~= 'number' and type(coords[3]) ~= 'number' and type(coords[4]) ~= 'number') then return end

    return vector4(coords[1], coords[2], coords[3], coords[4])
end

---Convert vector4 type or table array with x, y, z (and w) values in 1, 2, 3 (and 4) indexes to vector3\
---(the value and index in the brackets are not required)\
---(if you give vector3, it will return the same vector)
---@param coords vector4|vector3|number[]
---@return vector3?
HRLib.ToVector3 = function(coords)
    if type(coords) == 'vector3' then return coords end
    if type(coords) ~= 'vector4' and type(coords) ~= 'table' and (type(coords) == 'table' and table.type(coords) == 'array' and type(coords[1]) ~= 'number' and type(coords[2]) ~= 'number' and type(coords[3]) ~= 'number') then return end

    if type(coords) == 'vector4' then
        return vector3(coords.x, coords.y, coords.z)
    else
        return vector3(coords[1], coords[2], coords[3])
    end
end

---@param coords vector4|vector3|vector2|number[]
HRLib.ToVector2 = function(coords)
    if type(coords) == 'vector2' then return coords end
    if type(coords) ~= 'vector4' and type(coords) ~= 'vector3' and type(coords) ~= 'table' and (type(coords) == 'table' and table.type(coords) == 'array' and type(coords[1]) ~= 'number' and type(coords[2]) ~= 'number') then return end

    if type(coords) == 'vector4' or type(coords) == 'vector3' then
        return vector2(coords.x, coords.y)
    else
        return vector2(coords[1], coords[2])
    end
end