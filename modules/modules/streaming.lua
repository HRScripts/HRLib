if IsDuplicityVersion() then return end

---@param model string|integer|string[]|integer[]
HRLib.RequestModel = function(model)
    if type(model) ~= 'table' and not IsModelValid(model) then
        return error(('The script couldn\'t load non-existent model (%s)'):format(model or 'undefined'), 2)
    end

    if type(model) ~= 'table' then
        model = type(model) == 'number' and model or joaat(model)

        if model and IsModelValid(model) then
            RequestModel(model)

            local timesChecked = 0
            while not HasModelLoaded(model) do
                if timesChecked >= 100 then return end

                Wait(20)

                timesChecked += 1
            end
        else
            return error(('The script couldn\'t load non-existent model (%s)'):format(model or 'undefined'), 2)
        end
    elseif table.type(model) == 'array' then
        for i=1, #model do
            model[i] = type(model[i]) == 'number' and model[i] or joaat(model[i])

            if model[i] and IsModelValid(model[i]) then
                RequestModel(model[i])

                local timesChecked = 0
                while not HasModelLoaded(model[i]) do
                    if timesChecked >= 100 then break end

                    Wait(20)

                    timesChecked += 1
                end
            else
                return error(('The script couldn\'t load non-existent model (%s)'):format(model or 'undefined'), 2)
            end
        end
    end
end

---@param dict string|string[]
HRLib.RequestAnimDict = function(dict)
    if type(dict) ~= 'table' and not DoesAnimDictExist(dict) then
        return error(('The script couldn\'t load non-existent animation dictionary (%s)'):format(dict or 'undefined'), 2)
    end

    if type(dict) ~= 'table' then
        RequestAnimDict(dict)

        local timesChecked = 0
        while not HasAnimDictLoaded(dict) do
            if timesChecked >= 100 then return end

            Wait(20)

            timesChecked += 1
        end
    elseif table.type(dict) == 'array' then
        for i=1, #dict do
            if type(dict[i]) == 'string' and DoesAnimDictExist(dict[i]) then
                RequestAnimDict(dict[i])

                local timesChecked = 0
                while not HasAnimDictLoaded(dict[i]) do
                    if timesChecked >= 100 then break end

                    Wait(20)

                    timesChecked += 1
                end
            else
                return error(('The script couldn\'t load non-existent animation dictionary (%s)'):format(dict or 'undefined'), 2)
            end
        end
    end
end