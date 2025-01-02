local hrlib <const>, clib <const> = { table = {} }, load(LoadResourceFile('HRLib', 'server/modules/local.lua'), '@@HRLib/server/modules/local.lua')()

---this function helps you focus in array of tables by one or couple of identifiers in each table of the array and if the identifiers's value match, the cb function is triggered
---@param array table<string, any>[]
---@param focus table<string, any>
---@param cb fun(i: integer, curr: any)? i: the current loop consecutive number; curr: the current loop value taken from the array via the loop's consecutive number
hrlib.table.focusedArray = function(array, focus, cb)
    if (type(array) == 'table' and table.type(array) == 'array') and focus and type(focus) == 'table' and table.type(focus) == 'hash' then
        local focusString

        for k,v in pairs(focus) do
            if type(focusString) == 'string' then
                focusString = ('%s | %s = %s'):format(focusString, k, v)
            else
                focusString = ('%s = %s'):format(k, v)
            end
        end

        local focusInArray <const> = clib.splitString(focusString, ' | ', nil, true) or {}
        for i=1, #array do
            local curr <const> = array[i]
            if #focusInArray > 1 then
                local falseValues = #focusInArray
                for l=1, #focusInArray do
                    local current <const> = clib.splitString(focusInArray[l], ' = ', nil, true)
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
                local focusValue = clib.splitString(focusString, ' = ', nil, true)
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
---@param hash table
---@param focus table|any
---@param cb fun(key: string, value: any, arrayInfo: { i: integer, curr: any })
hrlib.table.focusedHash = function(hash, focus, cb)
    for k,v in pairs(hash) do
        if type(focus) == 'table' and table.type(focus) == 'hash' then
            hrlib.table.focusedArray(v, focus, function(i, curr)
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
hrlib.table.getHashLength = function(hash)
    local length = 0

    for _,_ in pairs(hash) do
        length += 1
    end

    return length
end

---this function is about to match a value from array with the given value as any type or as array again
---@param tbl any[]|table the array to search in
---@param value any|any[]|table the value or other array to match the main array with
---@param returnIndex boolean|boolean? default: false
---@param isValueKey boolean? it changes the function meaning at all with seeking key names match
---@return boolean isFound, integer|integer[]? tblIndex
hrlib.table.find = function(tbl, value, returnIndex, isValueKey)
    local indexes <const> = {}

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
                        for tblK,tblV in pairs(tableV) do
                            if valueK == tblK and tblV == v then
                                indexes[#indexes+1] = k
                            end
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
        if returnIndex then
            return true, #indexes == 1 and table.unpack(indexes) or indexes
        else
            return true
        end
    end

    return false
end

---@param tbl table
hrlib.table.deepclone = function(tbl)
    local table = {}

    for k,v in pairs(tbl) do
        table[k] = type(v) == 'table' and hrlib.table.deepclone(v) or v
    end

    return table
end

return hrlib