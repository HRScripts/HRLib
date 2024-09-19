local load = load
local language = _VERSION == 'LuaGLM 5.4' and (Config or load(LoadResourceFile(GetCurrentResourceName(), 'config.lua') or 'return {}', ('@@%s/config.lua'):format(GetCurrentResourceName()))()?.language) or (Config or load(LoadResourceFile(GetCurrentResourceName(), 'config.lua') or 'return {}', ('@@%s/config.lua'):format(GetCurrentResourceName()))().language) --[[@as string]] ---@diagnostic disable-line: undefined-global
local locales <const> = load(LoadResourceFile(GetCurrentResourceName(), 'translation.lua') or 'return nil', ('@@%s/translation.lua'):format(GetCurrentResourceName()))() or {} ---@diagnostic disable-line: undefined-global

if type(locales) ~= 'table' or table.type(locales) ~= 'hash' then return end

if type(language) ~= 'string' then
    Translation = setmetatable({}, {
        __index = function(self, k)
            if not rawget(self, k) then
                self[k] = ('Language %s does not exist'):format(language)
            end

            return self[k]
        end
    })

    return
end

if not locales[language] then
    local oldLanguage <const> = language
    local warnMessage <const> = ('The language %s does not exist in resource %s! The current language translation is %s'):format(oldLanguage, GetCurrentResourceName(), language)

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

    warn(warnMessage)
end

::continue::

Translation = setmetatable({}, {
    __index = function(self, k)
        if not rawget(self, k) then
            local curr <const> = locales[language][k]
            if type(curr) == 'table' then
                self[k] = setmetatable({}, {
                    __index = function(underself, key)
                        if not rawget(underself, key) then
                            if curr[key] then
                                underself[key] = ('%s%s'):format(curr[key]:sub(1, 1):upper(), curr[key]:sub(2, #curr[key]))
                            else
                                error(('Translation %s called as Translation.%s.%s does not exist!'):format(key, k, key), 2)
                            end
                        end

                        return underself[key]
                    end
                })
            else
                if curr then
                    self[k] = ('%s%s'):format(curr:sub(1, 1):upper(), curr:sub(2, #curr))
                else
                    error(('Translation %s called as Translation.%s does not exist!'):format(k, k), 2)
                end
            end
        end

        return self[k]
    end
})