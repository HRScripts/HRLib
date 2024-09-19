local config <const> = load(LoadResourceFile('HRLib', 'config.lua'), '@@HRLib/config.lua')() --[[@as HRLibConfig]]

---@param description string?
---@param type 'success'|'error'|'warning'|'info'?
---@param duration integer? in miliseconds
---@param pos 'top-right'|'center-right'|'bottom-right'|'frombelow-right'|'top-left'|'left-center'|'frombelow-left'?
---@param sound boolean?
return function(description, type, duration, pos, sound)
    if not type or not string.find('successerrorwarninginfo', type, nil, true) then
        type = 'info'
    elseif not description then
        description = 'Text'
    elseif not duration then
        duration = 1500
    end

    if pos and not string.find('top-rightcenter-rightbottom-rightfrombelow-righttop-leftleft-centerfrombelow-left', pos or 'left-center', nil, true) or not pos then
        pos = config.defaultNotificationsPosition
    end

    SendNUIMessage({
        text = description,
        type = type,
        time = duration,
        position = pos,
        sound = sound or false
    })
end