local load = load
local language = _VERSION == 'LuaGLM 5.4' and (Config or load(LoadResourceFile(GetCurrentResourceName(), 'config.lua') or 'return {}', ('@@%s/config.lua'):format(GetCurrentResourceName()))()?.language) or (Config or load(LoadResourceFile(GetCurrentResourceName(), 'config.lua') or 'return {}', ('@@%s/config.lua'):format(GetCurrentResourceName()))().language) --[[@as string]] ---@diagnostic disable-line: undefined-global
local locales <const> = load(LoadResourceFile(GetCurrentResourceName(), 'translation.lua') or 'return nil', ('@@%s/translation.lua'):format(GetCurrentResourceName()))() or {} ---@diagnostic disable-line: undefined-global

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
    local warnMessage <const> = ('The language %s does not exist in resource %s! The current language translation is %s'):format(oldLanguage, GetCurrentResourceName(), '%s')

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

---@param self function
---@param tbl table
---@param cb fun(value: string): string
local getIntoUnderTables = function(self, tbl, cb)
    for k,v in pairs(tbl) do
        if type(v) == 'string' then
            tbl[k] = cb(v)
        elseif type(v) == 'table' then
            self(self, tbl, cb)
        end
    end
end

Translation = setmetatable({}, {
    __newindex = function(self, k, v)
        if type(v) == 'table' then
            getIntoUnderTables(getIntoUnderTables, v, function(value)
                return ('%s%s'):format(value:sub(1,1):upper(), value:sub(2, #value))
            end)

            setmetatable(v, {
                __index = function(_, key)
                    error(('Translation %s called as Translation.%s.%s does not exist!'):format(key, k, key), 2)
                end
            })
        else
            v = ('%s%s'):format(v:sub(1,1):upper(), v:sub(2, #v))
        end

        rawset(self, k, v)
    end,
    __index = function(_, k)
        error(('Translation %s called as Translation.%s does not exist!'):format(k, k), 2)
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