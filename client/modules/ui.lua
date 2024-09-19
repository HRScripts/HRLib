local ui <const>, callbacks <const> = {}, {}

---@param key string
ui.getNUIValue = function(key)
    return callbacks[key]
end

RegisterNUICallback('lib:loadCallback', function(data)
    callbacks[data.key] = data.value
end)

return ui