if not IsDuplicityVersion() then return end

local config <const> = HRLib.require('@HRLib/config.lua') --[[@as HRLibConfig]]

---@param webHook string URL of Discord WebHook bot
---@param botName string name of the bot
---@param title string title of the notification
---@param message string message of the notification
---@param type string? if type nil then type is rich
---@param color number color of the message
---@param icon string URL of an image
---@param author string author of the message
HRLib.DiscordMsg = function(webHook, botName, title, message, type, color, icon, author)
    local Bot <const> = webHook or config.defaultWebHook

    if not Bot then return end

    type = not type and 'rich' or type
    color = not color and 555555 or color
    icon = (not tostring(icon):sub(1, 8) == 'https://' or tostring(icon):sub(1, 8) == 'http://') and '' or icon
    author = not author and '' or author
    title = not title and '' or title

    local msg <const> = message
    PerformHttpRequest(Bot, function()end, 'POST', json.encode({ username = botName or 'Information', embeds = {
        {
            title = title,
            type = type,
            color = color,
            description = msg,
            footer = {
                text = author,
                icon_url = icon
            }
        }
    }}), { ['Content-Type'] = 'application/json' })
end