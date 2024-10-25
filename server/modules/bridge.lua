local GetResourceState = GetResourceState
local framework <const> = (GetResourceState('ox_core'):find('start') and setmetatable({}, {
    __index = function(self, k)
        if not rawget(self, k) then
            self[k] = function(...)
                return exports.ox_core[k](...)
            end
        end

        return self[k]
    end
}) or GetResourceState('es_extended'):find('start') and exports.es_extended:getSharedObject() or GetResourceState('qb-core'):find('start')) and exports['qb-core']:GetCoreObject()

if not framework then return false end

local bridge <const>, clib <const> = {}, load(LoadResourceFile('HRLib', 'server/modules/local.lua'), '@@HRLib/server/modules/local.lua')()
bridge.framework = framework
bridge.type = GetResourceState('ox_core'):find('start') and 'ox' or GetResourceState('es_extended'):find('start') and 'esx' or GetResourceState('qb-core'):find('start') and 'qb'

---@param playerId integer
---@param nameType 'firstname'|'lastname'? Default: 'Firstname Lastname' (both two names in one string)
---@return string?
bridge.getName = function(playerId, nameType)
    if clib.DoesIdExist(playerId) then
        if bridge.type == 'ox' then
            return framework.CallPlayer(playerId, 'get', type(nameType) == 'nil' and 'name' or nameType == 'firstname' and 'firstName' or nameType == 'lastname' and 'lastName')
        elseif bridge.type == 'esx' then
            if nameType == nil then
                return framework.GetPlayerFromId(playerId).getName()
            else
                return select(nameType == 'firstname' and 1 or 2, clib.splitString(framework.GetPlayerFromId(playerId).getName(), ' '))
            end
        elseif bridge.type == 'qb' then
            local player <const> = framework.GetPlayer(playerId)
            return nameType == nil and ('%s %s'):format(player.PlayerData.charinfo.firstname, player.PlayerData.charinfo.lastname) or nameType == 'firstname' and player.PlayerData.charinfo.firstname or player.PlayerData.charinfo.lastname
        end
    end
end

---@param playerId integer
---@param returnGrade boolean?
---@return string? jobName, integer? jobGrade
bridge.getJob = function(playerId, returnGrade)
    if clib.DoesIdExist(playerId) then
        if bridge.type == 'ox' then
            local playerGroups <const> = framework.CallPlayer(playerId, 'getGroups')
            return type(playerGroups) == 'function' and playerGroups() or nil
        elseif bridge.type == 'esx' then
            local playerJob <const> = framework.GetPlayerFromId(playerId)?.getJob()
            if returnGrade then
                return playerJob.name, playerJob.grade
            else
                return playerJob.name
            end
        elseif bridge.type == 'qb' then
            local playerJob <const> = framework.Functions.GetPlayer(playerId)?.PlayerData?.job
            if returnGrade then
                return playerJob.name, playerJob.grade
            else
                return playerJob.name
            end
        end
    end
end

---@param playerId integer
---@param account 'cash'|'bank'
---@return integer?
bridge.getMoney = function(playerId, account)
    if clib.DoesIdExist(playerId) then
        if bridge.type == 'ox' then
            if account == 'bank' then
                return framework.CallPlayer(playerId, 'getAccount')?.balance
            elseif account == 'cash' then
                return exports.ox_inventory:GetItemCount(playerId, 'money')
            end
        elseif bridge.type == 'esx' or bridge.type == 'qb' then
            return bridge.type == 'esx' and framework.GetPlayerFromId(playerId)?.getAccount(account == 'cash' and 'money' or account).money or bridge.type == 'qb' and framework.Functions.GetPlayer(playerId)?.PlayerData.money[account] or nil
        end
    end
end

---@param playerId integer
---@param jobName string
---@param jobGrade integer
bridge.setJob = function(playerId, jobName, jobGrade)
    if clib.DoesIdExist(playerId) then
        if bridge.type == 'ox' then
            local setJob <const> = framework.CallPlayer(playerId, 'setGroup')
            if setJob then
                setJob(jobName, jobGrade)
            end
        elseif bridge.type == 'esx' then
            local player <const> = framework.GetPlayerFromId(playerId)
            if player then
                player.setJob(jobName, jobGrade)
            end
        elseif bridge.type == 'qb' then
            local player <const> = framework.Functions.GetPlayer(playerId)
            if player then
                player.Functions.SetJob(jobName, jobGrade)
            end
        end
    end
end

---@param playerId integer
---@param account 'cash'|'bank'
---@param amount integer
bridge.setMoney = function(playerId, account, amount)
    if clib.DoesIdExist(playerId) then
        if bridge.type == 'ox' then
            if account == 'cash' then
                local moneyBalance <const> = exports.ox_inventory:GetItemCount(playerId, 'money')
                if moneyBalance then
                    exports.ox_inventory[moneyBalance > amount and 'RemoveItem' or 'AddItem'](playerId, 'money', moneyBalance > amount and moneyBalance - amount or amount - moneyBalance)
                end
            elseif account == 'bank' then
                local playerAccount <const> = framework.CallPlayer(playerId, 'getAccount')
                if playerAccount then
                    framework[playerAccount.balance > amount and 'RemoveAccountBalance' or 'AddAccountBalance'](playerAccount.id, playerAccount.balance > amount and playerAccount.balance - amount or amount - playerAccount.balance)
                end
            end
        elseif bridge.type == 'esx' then
            framework.GetPlayerFromId(playerId)?.setAccountMoney(account == 'cash' and 'money' or account, amount)
        elseif bridge.type == 'qb' then
            framework.Functions.GetPlayer(playerId)?.Functions.SetMoney(account, amount)
        end
    end
end

return bridge