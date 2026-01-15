Citizen.CreateThreadNow(function() -- Adding the code in a thread so the awaits for existing framework core script starting are not interrupting with the starting of HRLib
    local GetResourceState, serverSide <const> = GetResourceState, IsDuplicityVersion()
    local esxStatus, qbStatus = GetResourceState('es_extended'), GetResourceState('qb-core')

    if esxStatus == 'missing' and qbStatus == 'missing' then return end

    if esxStatus == 'starting' or qbStatus == 'starting' or esxStatus == 'stopped' or qbStatus == 'stopped' then
        if esxStatus == 'stopped' or qbStatus == 'stopped' then
            Wait(50)

            esxStatus, qbStatus = GetResourceState('es_extended'), GetResourceState('qb-core')

            if esxStatus ~= 'started' and qbStatus ~= 'started' then
                StartResource(esxStatus == 'stopped' and 'es_extended' or 'qb-core')
            else
                goto continue
            end
        end

        while esxStatus ~= 'started' and qbStatus ~= 'started' do
            esxStatus, qbStatus = GetResourceState('es_extended'), GetResourceState('qb-core')

            Wait(100)
        end
    end

    ::continue::

    local framework <const> = esxStatus == 'started' and exports.es_extended:getSharedObject() or qbStatus == 'started' and exports['qb-core']:GetCoreObject()

    if not framework then
        HRLib.bridge = setmetatable({
            framework = 'unknown_unusedBridge',
            type = 'unknown_unusedBridge'
        }, {
            __index = function()
                local invokingResource <const> = GetInvokingResource()
                warn(('HRLib\'s bridge functions aren\'t available currently due to missing framework!%s%s'):format(invokingResource and ' Invoking resource: ', invokingResource or ''))
            end
        })

        return warn(('^1%s^0'):format(('No framework functions found!?%s%s\nThe script will not provide its bridge functions until there\'s started core resource of the qb or esx legacy frameworks!'):format(GetInvokingResource() and ' Invoking resource: ', GetInvokingResource() or '')))
    end

    HRLib.bridge = {}
    HRLib.bridge.inv = {}
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
            if HRLib.DoesIdExist(playerId) and (account == 'cash' or account == 'bank') and type(amount) == 'number' then
                if HRLib.bridge.type == 'esx' then
                    framework.GetPlayerFromId(playerId)?.setAccountMoney(account == 'cash' and 'money' or account, amount)
                elseif HRLib.bridge.type == 'qb' then
                    framework.Functions.GetPlayer(playerId)?.Functions.SetMoney(account, amount)
                end
            end
        end

        ---@param playerId integer
        ---@param account 'cash'|'bank'
        ---@param amount integer
        HRLib.bridge.giveMoney = function(playerId, account, amount)
            if HRLib.DoesIdExist(playerId) and (account == 'cash' or account == 'bank') and type(amount) == 'number' then
                if HRLib.bridge.type == 'esx' then
                    framework.GetPlayerFromId(playerId)?.addAccountMoney(account == 'cash' and 'money' or account, amount)
                elseif HRLib.bridge.type == 'qb' then
                    framework.Functions.GetPlayer(playerId)?.Functions.AddMoney(account, amount)
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

        ---@param jobName string
        ---@param jobGrade string?
        ---@return boolean
        HRLib.bridge.doesJobExist = function(jobName, jobGrade)
            if HRLib.bridge.type == 'esx' then
                return framework.DoesJobExist(jobName, jobGrade or 0)
            elseif HRLib.bridge.type == 'qb' then
                local found <const>, index <const> = HRLib.table.find(framework.Shared.Jobs, jobName, true, true)
                if found and jobGrade then
                    return framework.Shared.Jobs[index].grades[tostring(jobGrade)] ~= nil
                elseif found then
                    return true
                end
            end

            return false
        end
    else
        ---@return table playerData
        HRLib.bridge.getPlayerData = function()
            if HRLib.bridge.type == 'esx' then
                return HRLib.bridge.framework.GetPlayerData()
            elseif HRLib.bridge.type == 'qb' then
                return HRLib.bridge.framework.Functions.GetPlayerData()
            end ---@diagnostic disable-line: missing-return
        end

        ---@param cb function
        HRLib.bridge.onPlSpawn = function(cb)
            (HRLib.bridge.type == 'esx' and AddEventHandler or RegisterNetEvent)(HRLib.bridge.type == 'esx' and 'esx:onPlayerSpawn' or 'QBCore:Client:OnPlayerLoaded', function(...)
                HRLib.bridge.isPlayerSpawned = true

                if type(cb) == 'function' or type(cb) == 'table' and cb['__cfx_functionReference'] then
                    cb(...)
                end
            end)
        end

        HRLib.bridge.playerLoaded = function()
            return HRLib.bridge.type == 'esx' and HRLib.bridge.framework.IsPlayerLoaded() or LocalPlayer.state.isLoggedIn
        end

        if HRLib.bridge.playerLoaded() then
            HRLib.bridge.isPlayerSpawned = true
        end
    end

    local inventory <const> = GetResourceState('ox_inventory') == 'started' and 'ox' or GetResourceState('qb-inventory') == 'started' and 'qb'
    if inventory then
        local invFns = inventory == 'ox' and exports.ox_inventory or exports['qb-inventory']

        ---@param playerId integer
        ---@param itemName string
        ---@param count integer
        ---@return boolean success
        HRLib.bridge.inv.addItem = function(playerId, itemName, count)
            return select(1, invFns:AddItem(playerId, itemName, count))
        end

        HRLib.bridge.inv.type = inventory
    else
        HRLib.bridge.inv = nil
    end
end)