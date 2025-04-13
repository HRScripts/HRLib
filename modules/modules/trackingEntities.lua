local trackedEntities <const> = {}

local deleteEntity = DeleteEntity

---Delete an entity from any entity types with given entityId
---@param entity integer
DeleteEntity = function(entity)
    if not DoesEntityExist(entity) then return end

    local entityType = GetEntityType(entity)
    entityType = entityType == 1 and 'ped' or entityType == 2 and 'vehicle' or entityType == 3 and 'object' ---@diagnostic disable-line: cast-local-type

    if not HRLib.table.find(trackedEntities, { entity = entity }) then
        TriggerEvent('HRLib:RemovedEntity', entityType, entity)
    end

    deleteEntity(entity)
end

---Delete vehicle with given vehicleId
---@param vehicle integer
DeleteVehicle = function(vehicle)
    DeleteEntity(vehicle)
end

---Delete ped with given pedId
---@param ped integer
DeletePed = function(ped)
    DeleteEntity(ped)
end

---Delete an object with given objectId
---@param object integer
DeleteObject = function(object)
    DeleteEntity(object)
end

if not IsDuplicityVersion() then
    ---Function to track an entity's deletion with given entityId.\
    ---It is important to understand that a delay of 100ms may exist between the event execution and the entity's deletion (it's necessary for the optimization)
    ---@param entityId integer
    ---@param attachedInfo table<string, any>?
    ---@param cb fun(entityType: 'vehicle'|'ped'|'object')? The callback function to trigger while the entity is still existing (if you want to check something each time for the entity you should use function)
    HRLib.TrackEntity = function(entityId, attachedInfo, cb)
        if not DoesEntityExist(entityId) then return end

        local entityType = GetEntityType(entityId)
        entityType = entityType == 1 and 'ped' or entityType == 2 and 'vehicle' or entityType == 3 and 'object' ---@diagnostic disable-line: cast-local-type
        CreateThread(function(threadId)
            local currIndex <const>, properties = #trackedEntities+1, nil
            trackedEntities[currIndex] = { threadId = threadId, entity = entityId }

            while trackedEntities[currIndex] do
                if not DoesEntityExist(entityId) then
                    TriggerEvent('HRLib:TrackedEntityDeleted', entityType, entityId, properties)

                    trackedEntities[currIndex] = nil
                elseif not IsDuplicityVersion() then
                    local state <const> = HRLib.table.cloneStateBag(('%s:%s'):format((entityType == 'ped' and IsPedAPlayer(entityId)) and 'player' or 'entity', (entityType == 'ped' and IsPedAPlayer(entityId)) and GetPlayerServerId(NetworkGetPlayerIndexFromPed(entityId)) or NetworkGetNetworkIdFromEntity(entityId)))
                    if entityType == 'vehicle' then
                        properties = HRLib.GetVehicleProperties(entityId)
                        properties.state = state ---@diagnostic disable-line: inject-field
                    elseif entityType == 'ped' then
                        properties = {
                            pedModel = GetEntityModel(entityId),
                            pedType = GetPedType(entityId),
                            isPlayer = IsPedAPlayer(entityId),
                            pedMoney = GetPedMoney(entityId),
                            lastCoords = GetEntityCoords(entityId),
                            isFreezed = IsEntityPositionFrozen(entityId),
                            state = state
                        }
                    elseif entityType == 'object' then
                        properties = {
                            objectModel = GetEntityModel(entityId),
                            isObjectLocal = NetworkGetEntityIsLocal(entityId),
                            lastCoords = GetEntityCoords(entityId),
                            isFreezed = IsEntityPositionFrozen(entityId),
                            state = state
                        }
                    end

                    if type(attachedInfo) == 'table' and table.type(attachedInfo) == 'hash' then
                        for k,v in pairs(attachedInfo) do
                            properties[k] = v
                        end
                    end

                    if type(cb) == 'function' or type(cb) == 'table' and cb['__cfx_functionReference'] then
                        local result <const> = cb(entityType --[[@as 'vehicle'|'ped'|'object' ]])
                        if type(result) == 'table' and table.type(result) ~= 'empty' then
                            for k,v in pairs(result) do
                                properties[k] = v
                            end
                        end
                    end

                    trackedEntities[currIndex].properties = properties
                end

                Wait(100)
            end
        end)
    end

    ---@param entityId integer
    ---@return boolean
    HRLib.GetIsEntityTracked = function(entityId)
        return HRLib.table.find(trackedEntities, { entity = entityId })
    end

    ---@param entity integer
    ---@param index string? if nil, it will return all current properties
    ---@return any?
    HRLib.GetTrackedEntityProperties = function(entity, index)
        local value

        HRLib.table.focusedArray(trackedEntities, { entity = entity }, function(i, curr)
            if index and curr.properties[index] then
                value = curr.properties[index] ---@diagnostic disable-line: redundant-return-value
            elseif index == nil then
                value = curr.properties
            end
        end)

        return value
    end

    ---Remove the tracker from the entity, created from HRLib.TrackEntity
    ---@param entityId integer
    HRLib.RemoveEntityTracker = function(entityId)
        local found <const>, index <const> = HRLib.table.find(trackedEntities, { entity = entityId }, true)
        if found then
            trackedEntities[index --[[@as integer]]] = nil
        end
    end

    RegisterNetEvent('HRLib:TrackedEntityDeleted')
end

RegisterNetEvent('HRLib:RemovedEntity')