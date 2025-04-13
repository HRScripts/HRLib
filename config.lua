local config <const> = {}

config.defaultWebHook = 'https://discord.com/api/webhooks/********************' -- Default webhook URL for the `HRLib.DiscordMsg` function (not required)

config.defaultNotificationsPosition = 'left-center' -- available positions - 'top-right', 'center-right', 'bottom-right', 'frombelow-right', 'top-left', 'left-center', 'frombelow-left'

config.defaultProgressBarPosition = 'bottom-center' -- available positions - 'center-left', 'center', 'center-right', 'bottom-left', 'bottom-center', 'bottom-right'

config.alertDialogueTranslation = {
    agreeButton = 'Agree',
    cancelButton = 'Cancel'
}

config.inputDialogueTranslation = {
    confirmButton = 'Confirm',
    cancelButton = 'Cancel'
}

config.debug = {
    enable = true,
    commandName = 'hrlib_debug',
    commandHelp = 'Debug command of HRLib',
    args = {
        type = {
            name = 'functionType',
            help = 'Available types: showTextUI, isTextUIOpen, hideTextUI, progressBar, alertDialogue, inputDialogue, notify'
        },
        secondParameter = {
            name = '...',
            help = 'it changes according to the chosen function type'
        }
    }
}

return config