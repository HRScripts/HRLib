local hrlib <const>, clib <const> = { string = {} }, load(LoadResourceFile('HRLib', 'server/modules/local.lua'), '@@HRLib/server/modules/local.lua')()

---@param text string the text you want to split
---@param delimiter string the key which splits the text
---@param returnAllAs 'string'|'number'?
---@param isArray boolean? true for return every string/number in array
---@changelog version 1.0.0, version 2.0.0
---@version 2.0.0
---@return string[]|number[]|...?
hrlib.string.split = function(text, delimiter, returnAllAs, isArray)
    if not text or not delimiter then return end

    return clib.splitString(text, delimiter, returnAllAs, isArray)
end

---@param texts string[] all the texts in an array
---@param delimiter string? the key that gather the text (text). nil (nothing) means interval
---@changelog version 1.0.0
---@version 1.0.0
---@return string?
hrlib.string.gather = function(texts, delimiter)
    if not type(texts) == 'table' then return end
    if type(delimiter) == 'nil' then delimiter = ' ' end

    local gatheredText = texts[1]

    for i=2, #texts do
        if type(texts[i]) == 'nil' then break end

        gatheredText = ('%s%s%s'):format(gatheredText, delimiter, texts[i])
    end

    return gatheredText
end

return hrlib