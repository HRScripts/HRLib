---@param text string the text you want to split
---@param delimiter string the key which splits the text
---@param returnAllAs 'string'|'number'?
---@param isArray boolean? true for return every string/number in array
---@return ...|string[]|number[]?
HRLib.string.split = function(text, delimiter, returnAllAs, isArray)
    if type(text) ~= 'string' or type(delimiter) ~= 'string' then return end

    returnAllAs = not returnAllAs and 'string' or returnAllAs
    local results <const> = {}

    local start = 1
    for _=1, #text do
        local from <const>, to <const> = text:find(delimiter, start, true)

        if not from then
            results[#results+1] = returnAllAs == 'string' and text:sub(start) or (tonumber(text:sub(start)) or text:sub(start))

            break
        end

        results[#results+1] = returnAllAs == 'string' and text:sub(start, from - 1) or (tonumber(text:sub(start, from - 1)) or text:sub(start, from - 1))

        start = to + 1
    end

    if isArray then
        return results
    else
        return table.unpack(results)
    end
end

---@param source string[] the text that you want to gather. Table format: {'text1', 'text2', 'text2'}
---@param delimiter string the key that gather the text (text). nil (nothing) means interval
---@return string?
HRLib.string.gather = function(source, delimiter)
    if not type(source) == 'table' then return end
    if type(delimiter) == 'nil' then delimiter = ' ' end

    local gatheredText = source[1]

    for i=2, #source do
        if type(source[i]) == 'nil' then break end

        gatheredText = ('%s%s%s'):format(gatheredText, delimiter, source[i])
    end

    return gatheredText
end