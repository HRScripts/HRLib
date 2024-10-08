local config <const> = {}

config.defaultWebHook = 'https://discord.com/api/webhooks/********************' -- Default webhook URL for the `HRLib.DiscordMsg` function (not required)

config.defaultNotificationsPosition = 'left-center' -- available positions - 'top-right', 'center-right', 'bottom-right', 'frombelow-right', 'top-left', 'left-center', 'frombelow-left'

return config --[[@as HRLibConfig]]