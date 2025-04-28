if IsDuplicityVersion() then return end

local disabledKeysCmds <const> = {}

HRLib.cDisable = {}

---@param key string|string[]
---@param processId any
HRLib.cDisable.registerProcess = function(key, processId)
    if (type(key) == 'string' and not HRLib.Keys[key] or type(key) == 'table' and (table.type(key) ~= 'array' or not HRLib.table.find(HRLib.Keys, key, false, true))) or (not processId or HRLib.table.find(disabledKeysCmds, { processId = processId })) then return end

    if type(key) == 'table' then
        for i=1, #key do
            if not HRLib.Keys[key[i]] then
                table.remove(key, i)
            end
        end
    end

    CreateThread(function(threadId)
        local index <const> = #disabledKeysCmds+1

        disabledKeysCmds[index] = {
            key = key,
            processId = processId,
            threadId = threadId
        }

        if type(key) == 'table' then
            for i=1, #key do
                key[i] = HRLib.Keys[key[i]] ---@diagnostic disable-line: assign-type-mismatch
            end

            while disabledKeysCmds[index] do
                for i=1, #key do
                    DisableControlAction(0, key[i] --[[@as integer]], true)
                    Wait(0)
                end
            end
        else
            key = HRLib.Keys[key] ---@diagnostic disable-line: cast-local-type

            while disabledKeysCmds[index] do
                DisableControlAction(0, key, true)
                Wait(0)
            end
        end
    end)
end

---@param processId any
---@return boolean
HRLib.cDisable.doesProcessExist = function(processId)
    return HRLib.table.find(disabledKeysCmds, { processId = processId })
end

---@return { key: string|string[], processId: any }[]?
HRLib.cDisable.getAllProcesses = function()
    if #disabledKeysCmds > 0 then
        local copy <const> = HRLib.table.deepclone(disabledKeysCmds)

        for i=1, #copy do
            copy[i].threadId = nil
        end

        return copy
    end
end

---@return boolean? # success or not
HRLib.cDisable.removeProcess = function(processId)
    if not processId then return end

    local found <const>, index <const> = HRLib.table.find(disabledKeysCmds, { processId = processId }, true)
    if found then
        TerminateThread(disabledKeysCmds[index].threadId)
        table.remove(disabledKeysCmds, index --[[@as integer]])

        return true
    end

    return false
end