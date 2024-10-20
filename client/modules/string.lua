local hrlib <const>, clib <const> = {
    string = {}
}, load(LoadResourceFile('HRLib', 'client/modules/local.lua'), '@@HRLib/client/modules/local.lua')()

---@param text string the text you want to split
---@param delimiter string the key which splits the text
---@param returnAllAs 'string'|'number'?
---@param isArray boolean? true for return every string/number in array
---@changelog version 1.0.0, version 2.0.0
---@version 2.0.0
---@return ...|string[]|number[]?
hrlib.string.split = function(text, delimiter, returnAllAs, isArray)
    if not text or not delimiter then return end

    return clib.splitString(text, delimiter, returnAllAs, isArray)
end

---@param source string[] the text that you want to gather. Table format: {'text1', 'text2', 'text2'}
---@param delimiter string the key that gather the text (text). nil (nothing) means interval
---@changelog version 1.0.0
---@version 1.0.0
---@return string?
hrlib.string.gather = function(source, delimiter)
    if not type(source) == 'table' then return end
    if type(delimiter) == 'nil' then delimiter = ' ' end

    local gatheredText = source[1]

    for i=2, #source do
        if type(source[i]) == 'nil' then break end

        gatheredText = ('%s%s%s'):format(gatheredText, delimiter, source[i])
    end

    return gatheredText
end

return hrlib