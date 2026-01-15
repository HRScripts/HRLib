local load, currentResource <const> = load, GetCurrentResourceName()
local language

if Config then ---@diagnostic disable-line: undefined-global
    language = Config.language ---@diagnostic disable-line: undefined-global
else
    local returnedConfig <const> = load(LoadResourceFile(currentResource, 'config.lua'), ('@@%s/config.lua'):format(currentResource))
    if returnedConfig then
        local config <const> = returnedConfig()
        if type(config) == 'table' then
            language = config.language
        end
    end
end

local locales <const> = load(LoadResourceFile(currentResource, 'translation.lua') or 'return nil', ('@@%s/translation.lua'):format(currentResource))() or {} ---@diagnostic disable-line: undefined-global

if type(locales) ~= 'table' or table.type(locales) ~= 'hash' then return end

if type(language) ~= 'string' then
    Translation = setmetatable({}, {
        __index = function()
            return ('Language %s does not exist'):format(language)
        end
    })

    return
end

if not locales[language] then
    local oldLanguage <const> = language
    local warnMessage <const> = ('The language %s does not exist in resource %s! The current language translation is %s'):format(oldLanguage, currentResource, '%s')

    if locales['en'] then
        language = 'en'

        warn(warnMessage)

        goto continue
    end

    language = 'notFound'

    for k,_ in pairs(locales) do
        language = k

        break
    end

    if language == 'notFound' then return end

    warn(warnMessage:format(language))
end

::continue::

local languageTranslations <const> = locales[language]

---@param self fun(self: function, tbl: table, initialKey: string): table
---@param tbl table
---@param initialKey string
---@return table
local setUnderTablesMetatables = function(self, tbl, initialKey)
    local tblCopy <const> = HRLib.table.deepclone(tbl, true)

    for k,v in pairs(tblCopy) do
        if type(v) == 'table' then
            tblCopy[k] = self(self, v, ('%s.%s'):format(initialKey, k))
        elseif type(v) == 'string' then
            tblCopy[k] = #v > 1 and ('%s%s'):format(v:sub(1,1):upper(), v:sub(2, #v)) or v:upper()
        end
    end

    return setmetatable({}, {
        __index = function(actualSelf, k)
            if tblCopy[k] then
                rawset(actualSelf, k, tblCopy[k])

                return tblCopy[k]
            else
                error(('Translation %s called as Translation.%s.%s does not exist!'):format(k, initialKey, k), 2)
            end
        end
    })
end

Translation = setmetatable({}, {
    __newindex = function(self, k, v)
        if type(v) == 'table' then
            rawset(self, k, setUnderTablesMetatables(setUnderTablesMetatables, v, k))
        else
            rawset(self, k, #v > 1 and ('%s%s'):format(v:sub(1,1):upper(), v:sub(2, #v)) or v:upper())
        end
    end,
    __index = function(self, k)
        local curr <const> = languageTranslations[k]
        if curr then
            if type(curr) == 'table' then
                local value <const> = setUnderTablesMetatables(setUnderTablesMetatables, curr, k)

                rawset(self, k, value)

                return value
            elseif type(curr) == 'string' then
                local translation <const> = #curr > 1 and ('%s%s'):format(curr:sub(1,1):upper(), curr:sub(2, #curr)) or curr:upper()

                rawset(self, k, translation)

                return translation
            end
        else
            error(('Translation %s called as Translation.%s does not exist!'):format(k, k), 2)
        end
    end,
    __call = function(_, name)
        if locales[language] then
            if HRLib.string.find(name, '.') then
                local path <const> = HRLib.string.split(name, '.', nil, true) --[[@as string[] ]]
                local value = locales[language][path[1]]
                for i=2, #path do
                    value = value[path[i]]
                end

                return value
            else
                return locales[language][name]
            end
        else
            warn('The currently chosen language is not set in the provided translations! Source: use of Translation call method.')
        end
    end
})