---this function helps you focus in array of tables by one or couple of identifiers in each table of the array and if the identifiers's value match, the cb function is triggered
---@param array table<string, any>[]
---@param focus table<string, any>
---@param cb fun(i: integer, curr: any)? i: the current loop consecutive number; curr: the current loop value taken from the array via the loop's consecutive number
HRLib.table.focusedArray = function(array, focus, cb)
    if (type(array) == 'table' and table.type(array) == 'array') and focus and type(focus) == 'table' and table.type(focus) == 'hash' then
        local focusString

        for k,v in pairs(focus) do
            if type(focusString) == 'string' then
                focusString = ('%s | %s = %s'):format(focusString, k, v)
            else
                focusString = ('%s = %s'):format(k, v)
            end
        end

        local focusInArray <const> = HRLib.string.split(focusString, ' | ', nil, true) --[[@as string[] ]] or {}
        for i=1, #array do
            local curr <const> = array[i]
            if #focusInArray > 1 then
                local falseValues = #focusInArray
                for l=1, #focusInArray do
                    local current <const> = HRLib.string.split(focusInArray[l], ' = ', nil, true) --[[@as string[] ]]
                    if curr[current[1]] == current[2] then
                        falseValues -= 1
                    end
                end

                if falseValues == 0 then
                    if type(cb) == 'function' then
                        cb(i, curr)
                    end
                end
            else
                local focusValue = HRLib.string.split(focusString, ' = ', nil, true) --[[@as string[] ]]
                if tostring(curr[focusValue[1]]) == tostring(focusValue[2]) then
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

---Finds if the given value is included in the table
---@param tbl any[]|table the array to search in
---@param value any|any[]|table the value or other array to match the main array with
---@param returnIndex boolean? default: false
---@param isValueKey boolean? it changes the function meaning at all with seeking key names match
---@param returnUnderIndex boolean?
---@return boolean isFound, integer|integer[]? index, string|string[]? underIndex
HRLib.table.find = function(tbl, value, returnIndex, isValueKey, returnUnderIndex)
    local indexes <const>, underIndexes <const> = {}, {}

    if not isValueKey then
        for k,tableV in pairs(tbl) do
            if type(value) == 'table' then
                if type(tableV) ~= 'table' then
                    for valueK,v in pairs(value) do
                        if valueK == k and tableV == v then
                            indexes[#indexes+1] = k
                        end
                    end
                else
                    for valueK,v in pairs(value) do
                        local found <const>, index <const> = HRLib.table.find(tableV, { [valueK] = v }, true)
                        if found then
                            indexes[#indexes+1] = k
                            underIndexes[#underIndexes+1] = ('%s.%s'):format(k, index)
                        end
                    end
                end
            else
                if type(tableV) ~= 'table' then
                    if tableV == value then
                        indexes[#indexes+1] = k
                    end
                else
                    for _,v in pairs(tableV) do
                        if v == value then
                            indexes[#indexes+1] = k
                        end
                    end
                end
            end
        end
    else
        for k,v in pairs(tbl) do
            if k == value then
                indexes[#indexes+1] = k
            end

            if type(v) == 'table' then
                local valueCheck = function(self, subject)
                    for vKey, vValue in pairs(subject) do
                        if vKey == value then
                            indexes[#indexes+1] = k

                            return
                        elseif vValue == 'table' then
                            self(self, vValue)
                        end
                    end
                end

                valueCheck(valueCheck, v)
            end
        end
    end

    if #indexes > 0 then
        local returnTbl <const> = {
            true,
            returnIndex and #indexes > 1 and indexes or #indexes == 1 and table.unpack(indexes),
            returnUnderIndex and #underIndexes > 1 and indexes or table.unpack(underIndexes)
        }
        return table.unpack(returnTbl) ---@diagnostic disable-line: return-type-mismatch, redundant-return-value
    end

    return false
end

---@param tbl table
HRLib.table.deepclone = function(tbl)
    local table = {}

    for k,v in pairs(tbl) do
        table[k] = type(v) == 'table' and HRLib.table.deepclone(v) or v
    end

    if getmetatable(tbl) then
        local mtbl = {}

        for k,v in pairs(getmetatable(tbl)) do
            mtbl[k] = type(v) == 'table' and HRLib.table.deepclone(v) or v
        end

        setmetatable(table, mtbl)
    end

    return table
end

---@param bagName string
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
---@return boolean
HRLib.table.compare = function(tbl1, tbl2)
    if tbl1 == tbl2 then return true end
    if type(tbl1) ~= 'table' or type(tbl2) ~= 'table' or table.type(tbl1) == 'empty' and table.type(tbl2) ~= 'empty' or table.type(tbl1) ~= 'empty' and table.type(tbl2) == 'empty' then return false end

    for k,v in pairs(tbl1) do
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

    return true
end