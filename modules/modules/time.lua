local limits <const> = { [24] = 23, [12] = 11 }

---@param p1 table
---@param clockType 12|24
local checkParameters = function(p1, clockType)
    if HRLib.table.getHashLength(p1) > 2 then
        for k,v in pairs(p1) do
            if (k ~= 'hour' and k ~= 'minute' and k ~= 'second') or type(v) ~= 'number' or v < 0 or (k == 'hour' and v > limits[clockType] or (k == 'minute' or k == 'second') and v > 59) then
                return true
            end
        end

        return false
    end

    return true
end

local mainFn = function(clockTime, addition, clockType)
    if (type(clockTime) ~= 'table' or table.type(clockTime) ~= 'hash' or type(clockTime.hour) ~= 'number' or checkParameters(clockTime, clockType)) or (type(addition) ~= 'table' or table.type(addition) ~= 'hash' or checkParameters(addition, clockType)) then return end

    clockTime.minute = clockTime.minute or 0
    clockTime.second = clockTime.second or 0

    local modules <const> = { 'hour', 'minute', 'second' }
    for i=1, #modules do
        if modules[i] == 'hour' then
            addition[modules[i]] = addition[modules[i]] or 0
            goto continue
        end

        addition[modules[i]] = addition[modules[i]] or 0
        clockTime[modules[i]] = clockTime[modules[i]] or 0

        ::continue::
    end

    local hourModified, minuteModified, secondModified = clockTime.hour + addition.hour, clockTime.minute + addition.minute, clockTime.second + addition.minute

    if secondModified > 59 then
        local times = 0

        if secondModified >= 120 then
            while secondModified > 60 do
                secondModified -= 60
                times += 1

                Wait(0)
            end
        else
            secondModified -= 60
            times += 1
        end

        minuteModified += times
    end

    if minuteModified > 59 then
        local times = 0

        if minuteModified >= 120 then
            while minuteModified > 60 do
                minuteModified -= 60
                times += 1

                Wait(0)
            end
        else
            minuteModified -= 60
            times += 1
        end

        hourModified += times
    end

    if hourModified > 23 then
        if hourModified >= 28 then
            while hourModified > 24 do
                hourModified -= 24
            end
        else
            hourModified -= 24
        end
    end

    return { hour = hourModified, minute = minuteModified, second = secondModified }
end

---@param clockTime { hour: number, minute: number?, second: number? } the time to add the addition to (each of the non required parameters will be set to zero if not declared)
---@param addition { hour: number?, minute: number?, second: number? } a table with the addition values (none of them is absolutely required but at least one is required)
---@return { hour: number<24>, minute: number<59>, second: number<59> }?
HRLib.Calc24ClockAddition = function(clockTime, addition)
    return mainFn(clockTime, addition, 24)
end

---@param clockTime { hour: number, minute: number?, second: number? } the time to add the addition to (each of the non required parameters will be set to zero if not declared)
---@param addition { hour: number?, minute: number?, second: number? } a table with the addition values (none of them is absolutely required but at least one is required)
---@return { hour: number<12>, minute: number<59>, second: number<59> }?
HRLib.Calc12ClockAddition = function(clockTime, addition)
    return mainFn(clockTime, addition, 12)
end