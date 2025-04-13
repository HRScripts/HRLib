---@param values any[]
---@param createRandomValue fun(): any
---@return any randomValue
HRLib.RandomValueWithNoRepetition = function(values, createRandomValue)
    values = type(values) == 'table' and values or {}
    if type(createRandomValue) == 'function' then
        local randomValue = createRandomValue()
        if randomValue then
            local newCheckingValues = {}
            for i=1, #values do
                newCheckingValues = createRandomValue()
            end

            if not HRLib.table.compare(values, newCheckingValues, true) then
                local found

                for i=1, #values do
                    if randomValue == values[i] then
                        found = true
                    end
                end

                if found then
                    randomValue = HRLib.RandomValueWithNoRepetition(values, createRandomValue)
                end

                return randomValue
            end
        end
    end
end