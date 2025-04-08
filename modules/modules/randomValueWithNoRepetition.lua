---@param values any[]
---@param createRandomValue fun(): any
---@return any randomValue
HRLib.RandomValueWithNoRepetition = function(values, createRandomValue)
    if type(createRandomValue) == 'function' then
        local randomValue = createRandomValue()
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