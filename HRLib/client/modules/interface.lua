local interface <const> = {}

---@param description string
interface.showTextUI = function(description)
    SendNUIMessage({
        action = 'textUI',
        visible = true,
        content = description
    })
end

interface.hideTextUI = function()
    SendNUIMessage({
        action = 'textUI',
        visible = false,
    })
end

---@param type 'circle'|'horizontal'|'vertical'
---@param options { duration: number, description: string?, position: 'center-left'|'center'|'center-right'|'bottom-left'|'bottom-center'|'bottom-right' }
interface.progressBar = function(type, options)
    if not options.duration or tonumber(options.duration) == nil then return end

    SendNUIMessage({
        action = 'progressBar',
        barType = type,
        duration = options.duration,
        content = options.description,
        position = options.position
    })
end

return interface