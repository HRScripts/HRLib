---Function to return a metatable that allows when being modified, to change its __call function so it represents a hookable function
---@param initialFunction function?
---@return HRLibHookableFunction
HRLib.HookableFunction = function(initialFunction)
    return setmetatable({
        set = function(self, isJustAddition, fn)
            local old___call = getmetatable(self).__call
            setmetatable(self, {
                __call = function(_, ...)
                    if isJustAddition then
                        if fn(...) == false then return end

                        return old___call(self, ...)
                    end

                    return fn(...)
                end
            })
        end
    }, {
        __call = function(_, ...)
            return (HRLib.IsFunction(initialFunction) and initialFunction or (function(_)end))(...)
        end
    })
end