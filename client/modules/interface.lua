local interface <const>, tableFunctions <const> = {}, load(LoadResourceFile('HRLib', 'client/modules/table.lua'), '@@HRLib/client/modules/table.lua')()
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

---@param returnLastDescription boolean?
---@return boolean status, string? textUIContent
interface.isTextUIOpen = function(returnLastDescription)
    SendNUIMessage({
        action = 'getTextUIStatus'
    })

    repeat Wait(10) until callbackStatus ~= nil

    local cbStatus = type(callbackStatus) == 'table' and tableFunctions.table.deepclone(callbackStatus) or callbackStatus
    callbackStatus = nil

    if returnLastDescription then
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

---@param options { title: string, description: string?, onAgree: function?, onCancel: function? }
interface.createAlertDialogue = function(options)
    if table.type(CurrentAlertDialogue) == 'empty' and table.type(CurrentInputDialogue) == 'empty' then
        CurrentAlertDialogue = tableFunctions.table.deepclone(options)

        options.onAgree = nil
        options.onCancel = nil
        options.action = 'alertDialogue' ---@diagnostic disable-line: inject-field
        options.data = { ---@diagnostic disable-line: inject-field
            title = options.title,
            description = options.description
        }

        SendNUIMessage(options)
        SetNuiFocus(true, true)
    end
end

---@param options { title: string, questions: { type: 'text', options: HRLibInputDialogueTextOptions }[], onCancel: function? }
---@return string[]?
interface.createInputDialogue = function(options)
    if table.type(CurrentAlertDialogue) == 'empty' and table.type(CurrentInputDialogue) == 'empty' then
        CurrentInputDialogue = {
            promise = promise.new(),
            onCancel = options.onCancel
        }

        options.onCancel = nil
        options = {
            action = 'inputDialogue',
            data = options
        }

        SendNUIMessage(options)
        SetNuiFocus(true, true)
        Citizen.Await(CurrentInputDialogue.promise)

        local value <const> = CurrentInputDialogue.promise.value == 'table' and tableFunctions.table.deepclone(CurrentInputDialogue.promise.value) or CurrentInputDialogue.promise.value

        CurrentInputDialogue = {}

        if type(value) == 'table' and table.type(value) ~= 'empty' then
            return value
        end
    end
end

return interface