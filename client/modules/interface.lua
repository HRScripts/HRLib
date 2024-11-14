local interface <const> = {}
local callbackStatus

RegisterNUICallback('getTextUIStatus', function(data)
    callbackStatus = data
end)

---@param description string
interface.showTextUI = function(description)
    SendNUIMessage({
        action = 'textUI',
        visible = true,
        content = description
    })
end

---@param returnLastContent boolean?
---@return boolean status, string? textUIContent
interface.isTextUIOpen = function(returnLastContent)
    SendNUIMessage({
        action = 'getTextUIStatus'
    })

    repeat Wait(10) until callbackStatus ~= nil

    local cbStatus = callbackStatus
    callbackStatus = nil

    if returnLastContent then
        return cbStatus.status, cbStatus.content
    else
        return cbStatus.status
    end
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