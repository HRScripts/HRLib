local GetResourceState, serverSide <const> = GetResourceState, IsDuplicityVersion()
local esxStatus, qbStatus = GetResourceState('es_extended'), GetResourceState('qb-core')

if (esxStatus == 'missing' or esxStatus == 'stopped') and (qbStatus == 'missing' or qbStatus == 'stopped') then return end

if esxStatus == 'starting' or qbStatus == 'starting' or esxStatus == 'stopped' or qbStatus == 'stopped' then
    if esxStatus == 'stopped' or qbStatus == 'stopped' then StartResource(esxStatus == 'stopped' and 'es_extended' or 'qb-core') end

    while not esxStatus == 'started' or qbStatus == 'started' do
        esxStatus, qbStatus = GetResourceState('es_extended'), GetResourceState('qb-core')

        Wait(100)
    end
end

local framework <const> = esxStatus == 'started' and exports.es_extended:getSharedObject() or qbStatus == 'started' and exports['qb-core']:GetCoreObject()

if not framework then
    return error(GetCurrentResourceName() ~= 'HRLib' and 'No framework functions found!?' or ('No framework functions found!? Invoking resource: %s'):format(GetInvokingResource()))
end

HRLib.bridge = {}
HRLib.bridge.framework = framework
HRLib.bridge.type = esxStatus == 'started' and 'esx' or qbStatus == 'started' and 'qb'

if serverSide then
    ---@param playerId integer
    ---@param nameType 'firstname'|'lastname'? Default: 'Firstname Lastname' (both two names in one string)
    ---@return string? playerName
    HRLib.bridge.getName = function(playerId, nameType)
        if HRLib.DoesIdExist(playerId) then
            if HRLib.bridge.type == 'esx' then
                if nameType == nil then
                    return framework.GetPlayerFromId(playerId).getName()
                else
                    return select(nameType == 'firstname' and 1 or 2, HRLib.string.split(framework.GetPlayerFromId(playerId).getName(), ' '))
                end
            elseif HRLib.bridge.type == 'qb' then
                local player <const> = framework.Functions.GetPlayer(playerId)
                return nameType == nil and ('%s %s'):format(player.PlayerData.charinfo.firstname, player.PlayerData.charinfo.lastname) or nameType == 'firstname' and player.PlayerData.charinfo.firstname or player.PlayerData.charinfo.lastname
            end
        end
    end

    ---@param playerId integer
    ---@param returnGrade boolean?
    ---@return string? jobName, integer? jobGrade
    HRLib.bridge.getJob = function(playerId, returnGrade)
        if HRLib.DoesIdExist(playerId) then
            if HRLib.bridge.type == 'esx' then
                local playerJob <const> = framework.GetPlayerFromId(playerId)?.getJob()
                if returnGrade then
                    return playerJob.name, playerJob.grade
                else
                    return playerJob.name
                end
            elseif HRLib.bridge.type == 'qb' then
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
    ---@return integer? moneyBalance
    HRLib.bridge.getMoney = function(playerId, account)
        if HRLib.DoesIdExist(playerId) then
            if HRLib.bridge.type == 'esx' then
                return framework.GetPlayerFromId(playerId)?.getAccount(account == 'cash' and 'money' or account).money
            else
                return framework.Functions.GetPlayer(playerId)?.PlayerData.money[account]
            end
        end
    end

    ---@param playerId integer
    ---@param jobName string
    ---@param jobGrade integer
    HRLib.bridge.setJob = function(playerId, jobName, jobGrade)
        if HRLib.DoesIdExist(playerId) then
            if HRLib.bridge.type == 'esx' then
                local player <const> = framework.GetPlayerFromId(playerId)
                if player then
                    player.setJob(jobName, jobGrade)
                end
            elseif HRLib.bridge.type == 'qb' then
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
    HRLib.bridge.setMoney = function(playerId, account, amount)
        if HRLib.DoesIdExist(playerId) then
            if HRLib.bridge.type == 'esx' then
                framework.GetPlayerFromId(playerId)?.setAccountMoney(account == 'cash' and 'money' or account, amount)
            elseif HRLib.bridge.type == 'qb' then
                framework.Functions.GetPlayer(playerId)?.Functions.SetMoney(account, amount)
            end
        end
    end

    ---Removes money from the given account of the given player server Id
    ---@param playerId integer
    ---@param account 'cash'|'bank'
    ---@param amount integer
    HRLib.bridge.removeMoney = function(playerId, account, amount)
        if account == 'cash' or account == 'bank' and type(amount) == 'number' then
            HRLib.bridge.setMoney(playerId, account, HRLib.bridge.getMoney(playerId, account) - math.tointeger(amount))
        end
    end
else
    --TODO: in test period, test it
    -- HRLib.bridge.playerData = setmetatable(HRLib.bridge.type == 'esx' and HRLib.bridge.framework.GetPlayerData() or HRLib.bridge.framework.Functions.GetPlayerData(), {
    --     __index = function(self, k)
    --         local playerData <const>, oldValue <const> = HRLib.bridge.type == 'esx' and HRLib.bridge.framework.GetPlayerData() or HRLib.bridge.framework.Functions.GetPlayerData(), rawget(self, k)
    --         if type(playerData[k]) ~= 'table' and playerData[k] ~= oldValue or (type(playerData[k]) == 'table' and type(oldValue) == 'table') and not HRLib.table.compare(playerData[k], oldValue) then
    --             rawset(self, k, playerData[k])

    --             return playerData[k]
    --         end

    --         return rawget(self, k)
    --     end
    -- })

    ---@return table playerData
    HRLib.bridge.getPlayerData = function()
        if HRLib.bridge.type == 'esx' then
            return HRLib.bridge.framework.GetPlayerData()
        elseif HRLib.bridge.type == 'qb' then
            return HRLib.bridge.framework.Functions.GetPlayerData()
        end ---@diagnostic disable-line: missing-return
    end
end