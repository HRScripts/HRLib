local currentAlertDialogue, currentInputDialogue = {}, {}
local isServer <const> = IsDuplicityVersion()
local config <const> = load(LoadResourceFile('HRLib', 'config.lua'), '@@HRLib/config.lua')() --[[@as HRLibConfig]]

if isServer then
    ---Notify player with HRLib's custom notification system
    ---@param playerId integer
    ---@param description string? notification content
    ---@param type 'success'|'error'|'warning'|'info'? notification type
    ---@param duration integer? notification duration in msec, default is 2500
    ---@param pos 'top-left'|'top-center'|'top-right'|'center-left'|'center'|'center-right'|'bottom-left'|'bottom-center'|'bottom-right'? notification position, default is found in HRLib/config.lua
    ---@param sound boolean?
    HRLib.Notify = function(playerId, description, type, duration, pos, sound)
        TriggerClientEvent('HRLib:Notify', playerId, description, type, duration, pos, sound)
    end
else
    local textUI <const> = {}

    -- Functions

    ---@param description string
    HRLib.showTextUI = function(description)
        SendNUIMessage({
            action = 'textUI',
            visible = true,
            content = description
        })

        textUI.description = description
        textUI.isOpened = true
    end

    ---@param returnLastDescription boolean?
    ---@return boolean status, string? textUIContent
    HRLib.isTextUIOpen = function(returnLastDescription)
        if returnLastDescription then
            return textUI.isOpened, textUI.description
        end

        return textUI.isOpened
    end

    HRLib.hideTextUI = function()
        SendNUIMessage({
            action = 'textUI',
            visible = false
        })

        textUI.isOpened = false
    end

    ---@param type 'circle'|'horizontal'|'vertical'
    ---@param options { duration: number, description: string?, position: 'center-left'|'center'|'center-right'|'bottom-left'|'bottom-center'|'bottom-right' }
    ---@param await boolean?
    ---@param animation { duration: number?, animName: string, animDict: string, animFlag: integer? }?
    HRLib.progressBar = function(type, options, await, animation)
        local p, animExists <const>, positions <const> = promise.new(), (animation and type(animation.animName) == 'string' and DoesAnimDictExist(type(animation.animDict) and animation.animDict or '')) and animation, { 'center-left', 'center', 'center-right', 'bottom-left', 'bottom-center', 'bottom-right' }

        if not options.duration or tonumber(options.duration) == nil then return end

        if not HRLib.table.find(positions, options.position) then
            options.position = nil
        end

        if options.position == nil and not HRLib.table.find(positions, config.defaultProgressBarPosition) then
            options.position = 'bottom-center'
        end

        if animExists then
            HRLib.RequestAnimDict(animExists.animDict)
            TaskPlayAnim(PlayerPedId(), animExists.animDict, animExists.animName, 8.0, 8.0, _G.type(animExists.duration) == 'number' and animExists.duration or -1, _G.type(animExists.animFlag) == 'number' and animExists.animFlag or 1, 1.0, false, false, false)
        end

        SetTimeout(options.duration, function()
            if await then
                p:resolve(true)
            end

            if animExists then
                StopAnimTask(PlayerPedId(), animExists.animDict, animExists.animName, 8.0)
            end
        end)

        SendNUIMessage({
            action = 'progressBar',
            barType = type,
            duration = options.duration,
            content = options.description,
            position = options.position or config.defaultProgressBarPosition
        })

        if await then
            Citizen.Await(p)
        end
    end

    ---@param options { title: string, description: string?, onAgree: function?, onCancel: function? }
    HRLib.createAlertDialogue = function(options)
        if table.type(currentAlertDialogue) == 'empty' and table.type(currentInputDialogue) == 'empty' then
            currentAlertDialogue = HRLib.table.deepclone(options)

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

    ---@param options { title: string, questions: { type: 'text'|'number', options: HRLibInputDialogueTextOptions }[], onCancel: function? }
    ---@return string[]?
    HRLib.createInputDialogue = function(options)
        if table.type(currentAlertDialogue) == 'empty' and table.type(currentInputDialogue) == 'empty' then
            currentInputDialogue = {
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
            Citizen.Await(currentInputDialogue.promise)

            local value <const> = type(currentInputDialogue.promise.value) == 'table' and HRLib.table.deepclone(currentInputDialogue.promise.value)

            currentInputDialogue = {}

            if type(value) == 'table' and table.type(value) ~= 'empty' then
                return value
            end
        end
    end

    ---Notify player with HRLib's custom notification system
    ---@param description string? notification content
    ---@param type 'success'|'error'|'warning'|'info'? notification type
    ---@param duration integer? notification duration in msec, default is 2500
    ---@param pos 'top-left'|'top-center'|'top-right'|'center-left'|'center'|'center-right'|'bottom-left'|'bottom-center'|'bottom-right'? notification position, default is found in HRLib/config.lua
    ---@param sound boolean?
    HRLib.Notify = function(description, type, duration, pos, sound)
        if not type or not string.find('successerrorwarninginfo', type, nil, true) then
            type = 'info'
        elseif not description then
            description = 'Text'
        elseif not duration then
            duration = 1500
        end

        if _G.type(pos) ~= 'string' or not string.find('top-lefttop-centertop-rightcenter-leftcentercenter-rightbottom-leftbottom-centerbottom-right', pos or 'left-center', nil, true) then
            pos = config.defaultNotificationsPosition
        end

        SendNUIMessage({
            text = description,
            type = type,
            time = duration,
            position = pos,
            sound = sound or true
        })
    end

    -- Notify Event and NUI callbacks

    RegisterNetEvent('HRLib:Notify', HRLib.Notify)

    RegisterNUICallback('getConfig', function(_, cb)
        cb(HRLib.require('@HRLib/config.lua'))
    end)

    RegisterNUICallback('getButtonsTranslation', function(data, cb)
        cb({
            confirmLabel = data.type == 'alert' and config.alertDialogueTranslation.agreeButton or config.inputDialogueTranslation.confirmButton,
            cancelLabel = config[data.type == 'alert' and 'alertDialogueTranslation' or 'inputDialogueTranslation'].cancelButton
        })
    end)

    RegisterNUICallback('closeDialogue', function(data)
        SetNuiFocus(false, false)

        if data.dialogueType == 'alert' then
            local currentFunction <const> = currentAlertDialogue[data.type == 'cancel' and 'onCancel' or 'onAgree']
            if type(currentFunction) == 'function' or type(currentFunction) == 'table' and currentFunction.__cfx_functionReference then
                currentFunction()
            end

            currentAlertDialogue = {}
        elseif data.dialogueType == 'input' then
            if data.type == 'cancel' then
                if type(currentInputDialogue.onCancel) == 'function' or type(currentInputDialogue.onCancel) == 'table' and currentInputDialogue.onCancel.__cfx_functionReference then
                    currentInputDialogue.onCancel()
                end

                currentInputDialogue.promise:resolve(false)

                return
            end

            currentInputDialogue.promise:resolve(data.answers)
        end
    end)
end