local config <const> = {}

config.defaultWebHook = 'https://discord.com/api/webhooks/********************' -- Default webhook URL for the `HRLib.DiscordMsg` function (not required)

config.defaultNotificationsPosition = 'left-center' -- available positions - 'top-right', 'center-right', 'bottom-right', 'frombelow-right', 'top-left', 'left-center', 'frombelow-left'

config.alertDialogueTranslation = {
    agreeButton = 'Agree',
    cancelButton = 'Cancel'
}

config.inputDialogueTranslation = {
    confirmButton = 'Confirm',
    cancelButton = 'Cancel'
}

return config