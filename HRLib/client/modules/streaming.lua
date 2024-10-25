local streaming <const> = {}

---@param model string|integer|string[]|integer[]
streaming.RequestModel = function(model)
    if type(model) ~= 'string' and type(model) ~= 'number' and type(model) ~= 'table' then return end

    if type(model) ~= 'table' then
        model = type(model) == 'number' and model or joaat(model)

        if model then
            RequestModel(model)

            local timesChecked = 0
            while not HasModelLoaded(model) do
                if timesChecked >= 100 then return end

                Wait(20)

                timesChecked += 1
            end
        end
    elseif table.type(model) == 'array' then
        for i=1, #model do
            model[i] = type(model[i]) == 'number' and model[i] or joaat(model[i])

            if model[i] then
                RequestModel(model[i])

                local timesChecked = 0
                while not HasModelLoaded(model[i]) do
                    if timesChecked >= 100 then break end

                    Wait(20)

                    timesChecked += 1
                end
            end
        end
    end
end

---@param dict string|string[]
streaming.RequestAnimDict = function(dict)
    if type(dict) ~= 'string' and type(dict) ~= 'table' then return end

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
            if type(dict[i]) == 'string' then
                RequestAnimDict(dict[i])

                local timesChecked = 0
                while not HasAnimDictLoaded(dict[i]) do
                    if timesChecked >= 100 then break end

                    Wait(20)

                    timesChecked += 1
                end
            end
        end
    end
end

return streaming