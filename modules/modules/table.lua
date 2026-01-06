---this function helps you focus in array of tables by one or couple of identifiers in each table of the array and if the identifiers's value match, the cb function is triggered
---@param array table<string, any>[]
---@param focus table<string, any>
---@param cb fun(i: integer, curr: any)? i: the current loop consecutive number; curr: the current loop value taken from the array via the loop's consecutive number
HRLib.table.focusedArray = function(array, focus, cb)
    if (type(array) == 'table' and table.type(array) == 'array') and focus and type(focus) == 'table' and table.type(focus) == 'hash' then
        local focusInArray <const> = {}

        for k,v in pairs(focus) do
            focusInArray[#focusInArray+1] = {
                key = k,
                value = v
            }
        end

        for i=1, #array do
            local curr <const> = array[i]
            if type(curr) == 'table' then
                local falseValues = #focusInArray

                for l=1, #focusInArray do
                    if curr[focusInArray[l].key] == focusInArray[l].value then
                        falseValues -= 1
                    end
                end

                if falseValues == 0 then
                    if type(cb) == 'function' then
                        cb(i, curr)
                    end
                end
            end
        end
    end
end

---this function helps you focus in hash of arrays by identifier in each value of the array and if the identifier's value match with one of the array values, the cb function is triggered
---@param hash table<string, table<string, any>[]>
---@param focus table|any
---@param cb fun(key: string, value: any, arrayInfo: { i: integer, curr: any })
HRLib.table.focusedHash = function(hash, focus, cb)
    for k,v in pairs(hash) do
        if type(focus) == 'table' and table.type(focus) == 'hash' then
            HRLib.table.focusedArray(v, focus, function(i, curr)
                if type(cb) == 'function' then
                    cb(k, v, { i = i, curr = curr })
                end
            end)
        else
            for i=1, #v do
                if v[i] == focus then
                    if type(cb) == 'function' then
                        cb(k, v, { i = i, curr = v[i] })
                    end
                end
            end
        end
    end
end

---this function gets the length of a hash table
---@param hash table
---@return integer
HRLib.table.getHashLength = function(hash)
    local length = 0

    for _,_ in pairs(hash) do
        length += 1
    end

    return length
end

--- ## Function to find different values in a table
---
--- * **Full Indexes are strings that point to the exact position of the found value in the given table. Use HRLib.table.convertFullIndex to use the value of a fullIndex**
--- # HRLib Official Documentation
---@param tbl table
---@param value any|table<string|number, any> the value to seek for in the table
---@param returnIndexes boolean? sets whether or not the indexes found should be returned
---@param returnFullIndexes boolean? sets whether or not the full indexes should be returned
---@param isValueAnActualTblValue boolean? if the given value is a table this sets whether or not the value should be again be treated as any other values types (without table type) or should be treated as a table with specific keys and values inside
---@return boolean found, integer|string|table<integer, integer|string>? indexes, string|string[]? underIndexes
HRLib.table.find = function(tbl, value, returnIndexes, returnFullIndexes, isValueAnActualTblValue)
    if type(tbl) ~= 'table' or not value then return false end

    local indexes <const>, underIndexes <const> = {}, {}

    if type(value) ~= 'table' or isValueAnActualTblValue then
        for k,v in pairs(tbl) do
            if v == value then
                indexes[#indexes+1] = k
                underIndexes[#underIndexes+1] = ('%s'):format(k)
            elseif type(v) == 'table' then
                for k2,v2 in pairs(v) do
                    if v2 == value then
                        indexes[#indexes+1] = k
                        underIndexes[#underIndexes+1] = ('%s.%s'):format(k, k2)
                    end
                end
            end
        end
    else
        for k,v in pairs(value) do
            if tbl[k] == v then
                indexes[#indexes+1] = k
                underIndexes[#underIndexes+1] = ('%s'):format(k)
            end
        end

        for k,v in pairs(tbl) do
            if type(v) == 'table' then
                local found <const>, _ <const>, underIndexes2 <const> = HRLib.table.find(v, value, true, true)
                if found then
                    indexes[#indexes+1] = k

                    if type(underIndexes2) == 'table' then
                        for i=1, #underIndexes2 do
                            underIndexes[#underIndexes+1] = ('%s.%s'):format(k, underIndexes2[i])
                        end
                    else
                        underIndexes[#underIndexes+1] = ('%s.%s'):format(k, underIndexes2)
                    end
                end
            end
        end
    end

    if #indexes > 0 then
        if returnIndexes then
            if returnFullIndexes then
                return true, #indexes > 1 and indexes or indexes[1], #underIndexes > 1 and underIndexes or underIndexes[1]
            else
                return true, #indexes > 1 and indexes or indexes[1]
            end
        elseif returnFullIndexes then
            return true, nil, #underIndexes > 1 and underIndexes or underIndexes[1]
        else
            return true
        end
    else
        return false
    end
end

---Function to access the addressed point in a table by full indexes (used in the HRLib.table.find function)
--- # HRLib Official Documentation
---@param tbl table the table with the value, the fullIndex points at
---@param fullIndex string the fullIndex to use when returning the value from the given table
---@return any
HRLib.table.convertFullIndex = function(tbl, fullIndex)
    if type(tbl) ~= 'table' or type(fullIndex) ~= 'string' then return end

    if HRLib.string.find(fullIndex, '.') then
        local splittedFullIndexes <const> = HRLib.string.split(fullIndex, '.', 'number', true) --[[@as table<integer, string|integer> ]]
        local value = tbl[splittedFullIndexes[1]]

        for i=2, #splittedFullIndexes do
            value = value[splittedFullIndexes[i]]
        end

        return value
    else
        if tonumber(fullIndex) then
            return tbl[tonumber(fullIndex)]
        else
            return tbl[fullIndex]
        end
    end
end

do
    local changeValue = function(self, table, fullIndexes, actualPosition, numberPosition, value)
        if #fullIndexes - numberPosition > 1 then
            self(self, table, fullIndexes, actualPosition[fullIndexes[numberPosition+1]], numberPosition+1, value)
        else
            actualPosition[fullIndexes[#fullIndexes]] = value
        end
    end

    ---Function that converts fullIndex when it's just a string and replaces it's representive value with `value` parameter in the following given table (`tbl`)
    --- # HRLib Official Documentation
    ---@param tbl table
    ---@param fullIndex string
    ---@param value any
    ---@return boolean
    HRLib.table.changeValueOfFullIndex = function(tbl, fullIndex, value)
        if type(tbl) ~= 'table' or type(fullIndex) ~= 'string' then return false end

        if HRLib.string.find(fullIndex, '.') then
            local splittedIndexes <const> = HRLib.string.split(fullIndex, '.', 'number', true) --[[@as table<integer, string|integer> ]]
            if #splittedIndexes > 2 then
                changeValue(changeValue, tbl, splittedIndexes, tbl[splittedIndexes[1]], 1, value)
            elseif #splittedIndexes == 2 then
                tbl[splittedIndexes[1]][splittedIndexes[2]] = value
            else
                tbl[splittedIndexes[1]] = value
            end

            return true
        elseif tbl[tonumber(fullIndex) or fullIndex] then
            tbl[tonumber(fullIndex) or fullIndex] = value

            return true
        end

        return false
    end
end

---@param tbl table
---@param dontCopyMetatable boolean? if the table you provide has metatable with this, set to true you can choose to not copy the metatable too
---@return table
HRLib.table.deepclone = function(tbl, dontCopyMetatable)
    local table = {}

    for k,v in pairs(tbl) do
        table[k] = type(v) == 'table' and HRLib.table.deepclone(v, dontCopyMetatable) or v
    end

    if getmetatable(tbl) and not dontCopyMetatable then
        local mtbl = {}

        for k,v in pairs(getmetatable(tbl)) do
            mtbl[k] = type(v) == 'table' and HRLib.table.deepclone(v, dontCopyMetatable) or v
        end

        setmetatable(table, mtbl)
    end

    return table
end

---Clones a state bag with table value and returns only the table with all the keys from the table
---@param bagName string Full state bag name
---@return any[]|false
HRLib.table.cloneStateBag = function(bagName)
    local keys <const>, values <const> = GetStateBagKeys(bagName), {}

    if type(keys) == 'table' and #keys > 0 then
        for i=1, #keys do
            local currValue <const> = GetStateBagValue(bagName, keys[i])
            values[#values+1] = type(currValue) == 'table' and HRLib.table.deepclone(currValue) or currValue
        end
    end

    return #values > 0 and values
end

---Returns if tbl1 equals by values or table id to tbl2
---@param tbl1 table
---@param tbl2 table
---@param noKeyCompare boolean? sets whether or not the function should compare the values by their keys or compare only values
---@return boolean
HRLib.table.compare = function(tbl1, tbl2, noKeyCompare)
    if tbl1 == tbl2 then return true end
    if type(tbl1) ~= 'table' or type(tbl2) ~= 'table' or table.type(tbl1) == 'empty' and table.type(tbl2) ~= 'empty' or table.type(tbl1) ~= 'empty' and table.type(tbl2) == 'empty' then return false end

    for k,v in pairs(tbl1) do
        if noKeyCompare then
            if type(v) == 'table' and type(tbl2[k]) == 'table' then
                if not HRLib.table.compare(v, tbl2[k], noKeyCompare) then
                    return false
                end
            elseif type(v) == 'table' and type(tbl2[k]) ~= 'table' or type(v) ~= 'table' and type(tbl2[k]) == 'table' then
                return false
            elseif not HRLib.table.find(tbl2, v) then
                return false
            end
        else
            if HRLib.table.find(tbl2, k, false, true) then
                if type(tbl2[k]) == 'table' and not HRLib.table.compare(v, tbl2[k]) then
                    return false
                elseif type(tbl2[k]) ~= 'table' and tbl2[k] ~= v then
                    return false
                end
            else
                return false
            end
        end
    end

    return true
end

---Returns all keys of the given table
---@param tbl table
---@param isArray boolean? default is false
---@return ...|string[]?
HRLib.table.getKeys = function(tbl, isArray)
    if type(tbl) ~= 'table' or table.type(tbl) == 'empty' then return end

    local keys <const> = {}

    for k,_ in pairs(tbl) do
        keys[#keys+1] = k
    end

    if #keys > 0 then
        if isArray then
            return keys
        else
            return table.unpack(keys)
        end
    end
end

---Function to return the actual string equivalent of a table
---@param tbl table
---@param indent boolean? Whether or not return the table with all the spaces and new roles in the string
---@param rowsSpace integer? The number of new rows before the next value in the table is declared in the string (Default value: 1).<br>This only matters when `indent` param is set to `true`
---@return string?
HRLib.table.toString = function(tbl, indent, rowsSpace)
    if type(tbl) ~= 'table' then return end

    if table.type(tbl) == 'empty' then
        return '{}'
    end

    rowsSpace = (type(rowsSpace) == 'number' and math.tointeger(rowsSpace)) and rowsSpace or 1

    local gapText <const> = '    '
    local tableToString = function(self, target, gap_times)
        local newRowAddition <const> = indent and ('%s%s'):format(('\n'):rep(rowsSpace), gapText:rep(gap_times)) or ' '
        local tableText = '{'
        for k,v in pairs(target) do
            local vString, isVStringWholeText
            if type(v) == 'function' then
                --TODO: This method:
                -- local info <const> = debug.getinfo(v, "S")
                -- if info.source:sub(1,1) == "@" then
                --     local file <const> = io.open(info.source:sub(2), "r")
                --     if file then
                --         local lines = {}

                --         for line in file:lines() do table.insert(lines, line) end

                --         file:close()

                --         vString = table.concat(lines, "\n", info.linedefined, info.lastlinedefined)
                --         isVStringWholeText = true
                --     else
                --         error('Not good happened!')
                --     end
                -- end
                return error('HRLib.table.toString can\'t handle functions in a table!', 0)
            else
                vString = type(v) == 'table' and (table.type(v) == 'empty' and '{}' or self(self, v, gap_times + 1)) or (type(v) == 'string' and ('\'%s\''):format(v) or v)
            end

            if type(k) == 'string' then
                tableText = isVStringWholeText and ('%s%s%s%s'):format(tableText, indent and '\n' or '', indent and vString or vString:gsub('\n', ' '), vString:sub(#vString) ~= ',' and ',' or '') or (k:match("^[%a_][%w_]*$") and '%s%s%s = %s,' or '%s%s[\'%s\'] = %s,'):format(tableText, newRowAddition, k, vString)
            else
                tableText = ('%s%s%s,'):format(tableText, newRowAddition, vString)
            end
        end

        tableText = tableText:sub(1, #tableText-1)
        return ('%s%s}'):format(tableText, indent and ('%s%s'):format(('\n'):rep(rowsSpace), gapText:rep(gap_times-1)) or ' ')
    end

    return tableToString(tableToString, tbl, 1)
end