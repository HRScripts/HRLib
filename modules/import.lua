local resName <const>, isServer <const> = GetCurrentResourceName(), IsDuplicityVersion()

HRLib = setmetatable({
    string = {},
    table = {},
    registeredCmds = {},
    callbacks = {},
    callbacksPromises = {}
}, {
    __call = function(self, ...)
        local lib <const> = {}

        if ... then
            for k,v in pairs(self) do
                if k ~= 'require' or k:sub(1, 2) ~= 'On' or k ~= 'StopMyself' then
                    lib[k] = v
                end
            end
        end

        for k,v in pairs(self) do
            if k ~= 'registeredCmds' or k ~= 'callbacks' or k ~= 'callbacksPromises' or k ~= 'clientCallbacks' or k ~= 'serverCallbacks' then
                lib[k] = v
            end
        end

        return lib
    end
})

if isServer then
    HRLib.clientCallbacks = setmetatable({}, {
        __newindex = function(self, k, v)
            rawset(self, k, v)
            TriggerEvent(('__%s:Receive_clibValues'):format(resName), 'ClientCallbacks', k, v)
        end
    })
else
    HRLib.serverCallbacks = setmetatable({}, {
        __newindex = function(self, k, v)
            rawset(self, k, v)
            TriggerEvent(('__%s:Receive_clibValues'):format(resName), 'ServerCallbacks', k, v)
        end
    })
end