if IsDuplicityVersion() then return end

---@param data { type: 'forCoord'|'forEntity'|'forArea'|'forPickup', options: HRLibBlipOptions, specificOptions: HRLibBlipForCoordOptions|HRLibBlipForEntityOptions|HRLibBlipForAreaOptions|HRLibBlipForPickupOptions, options: HRLibBlipOptions }
---@return integer? blip
HRLib.CreateBlip = function(data)
    local blip
    local options <const>, specificOptions <const> = data.options, data.specificOptions

    if type(specificOptions) == 'table' then
        if data.type == 'forCoord' then
            blip = AddBlipForCoord(specificOptions.coords or vector3(0.0, 0.0, 0.0)) ---@diagnostic disable-line: missing-parameter, param-type-mismatch
        elseif data.type == 'forEntity' then
            blip = AddBlipForEntity(specificOptions.entity)
        elseif data.type == 'forArea' then
            blip = AddBlipForArea(specificOptions.coords, specificOptions.width, specificOptions.height) ---@diagnostic disable-line: missing-parameter, param-type-mismatch
        elseif data.type == 'forPickup' then
            blip = AddBlipForPickup(specificOptions.pickup)
        end
    end

    if type(options) == 'table' then
        if options.sprite then SetBlipSprite(blip, options.sprite) end
        if options.colour then SetBlipColour(blip, options.colour) end
        if options.alpha then SetBlipAlpha(blip, options.alpha) end
        if options.asShortRange then SetBlipAsShortRange(blip, options.asShortRange) end
        if options.category then SetBlipCategory(blip, options.category) end
        if options.displayId then SetBlipDisplay(blip, options.displayId) end
        if options.flashBlip then SetBlipFlashes(blip, options.flashBlip) end
        if options.flashInterval then SetBlipFlashInterval(blip, options.flashInterval) end
        if options.scale then SetBlipScale(blip, options.scale) end
    end

    return blip
end