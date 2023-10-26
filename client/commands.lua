HRLib.RegCommand('giveWeapon', function(args, rawCommand, IPlayer, FPlayer)
    if clib.nilCheck(args) then
        local target, targetPed, weapon, ammo = tonumber(args[1]), GetPlayerPed(GetPlayerFromServerId(tonumber(args[1]))), GetHashKey(args[2]), tonumber(args[3])
        
        if IsWeaponValid(weapon) then
            if target == IPlayer.source then
                if HasPedGotWeapon(IPlayer.ped, weapon, false) then
                    SetPedAmmo(IPlayer.ped, weapon, ammo)
                else
                    GiveWeaponToPed(IPlayer.ped, weapon, ammo, false, false)
                end
            else
                if HasPedGotWeapon(targetPed, weapon, false) then
                    SetPedAmmo(targetPed, weapon, ammo)
                else
                    GiveWeaponToPed(targetPed, weapon, ammo, false, false)
                end
            end
        else
            FPlayer.Notify('This weapon does not exist!', 'error', 2500)
        end
    else
        if IPlayer.source == 0 then
            print('^3You have to fill all the required arguments!^0')
        else
            FPlayer.Notify('You have to fill all the required arguments!', 'warning', 2500)
        end
    end
end, true, {help = 'Give a weapon to someone.', args = { {name = 'playerId', help = 'Existing player server Id'}, {name = 'weaponName', help = 'Existing weapon name'}, {name = 'ammoCount', help = 'Count of the weapon ammo (max: 250)'} } })

HRLib.RegCommand('fixVeh', function(args, rawCommand, IPlayer, FPlayer)
    local veh = GetVehiclePedIsIn(IPlayer.ped, false)
    
    SetVehicleFixed(veh)
    SetVehicleDirtLevel(veh, 0.0)
    SetVehicleFuelLevel(veh, 1000.0)
    SetVehicleEngineOn(veh, true, true, true)
end, false, {help = 'Repair the vehicle you are sitting in'})

HRLib.RegCommand('teleport', function(args, rawCommand, IPlayer, FPlayer)
    local target = tonumber(args[2])

    if HRLib.DoesIdExist(target) then
        if target ~= IPlayer.source then
            if args[1] == 'me' then
                local tCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target)))

                FPlayer.Teleport(tCoords, false)
            elseif args[1] == 'him' then
                HRLib.Teleport(target, IPlayer.coords, false)
            end
        else
            FPlayer.Notify('You cannot teleport to yourself!', 'error', 2500)
        end
    else
        FPlayer.Notify(('This player server Id (%s) does not exist!'):format(args[2]), 'error', 2500)
    end
end, true, {help = 'Teleport someone to you or teleport yourself to someone', args = { {name = 'who', help = 'Choose who to teleport ( me - teleport you to the guy ; him - teleport the guy to you )'}, {name = 'playerId', 'Existing player server Id'} } })

HRLib.RegCommand('heal', function(args, rawCommand, IPlayer, FPlayer)
    if args[1] == nil then
        FPlayer.Health(nil)
    else
        local target = tonumber(args[1])

        if HRLib.DoesIdExist(target) then
            local targetPed = GetPlayerPed(GetPlayerFromServerId(target))

            if IsPedMale(targetPed) then
                SetEntityHealth(targetPed, 200)
            else
                SetEntityHealth(targetPed, 100)
            end
        else
            FPlayer.Notify(('This player server Id (%s) does not exist!'):format(args[1]), 'error', 2500)
        end
    end
end, true, {help = 'Heal yourself or someone else', args = { {name = 'playerId', help = 'Player server Id of the target player to heal (do not fill if you want to heal yourself)'} } })

HRLib.RegCommand('freeze', function(args, rawCommand, IPlayer, FPlayer)
    if clib.nilCheck(args) then
        local targetId = tonumber(args[1])
        
        if HRLib.DoesIdExist(targetId) then
            if IPlayer.source == 0 then
                local targetIPlayer = HRLib.GetIPlayer(targetId)

                if targetId == IPlayer.source then
                    print('^3You cannot freeze yourself because you\'re from the txAdmin console!')
                end

                if targetIPlayer.entity.isFreezed then
                    FreezeEntityPosition(targetIPlayer, false)
                else
                    FreezeEntityPosition(targetIPlayer, true)
                end
            else
                local targetIPlayer = HRLib.GetIPlayer(targetId)

                if targetId == IPlayer.source then
                    if IPlayer.entity.isFreezed then
                        FPlayer.Freeze(false)
                    else
                        FPlayer.Freeze(true)
                    end
                end

                if targetIPlayer.entity.isFreezed then
                    FreezeEntityPosition(targetIPlayer.ped, false)
                else
                    FreezeEntityPosition(targetIPlayer.ped, true)
                end
            end
        end
    else
        if IPlayer.source == 0 then
            print('^3You have to fill all the required arguments!^0')
        else
            FPlayer.Notify('You have to fill all the required arguments!', 'warning', 2500)
        end
    end
end, true, {help = 'Freeze someone. If this one\'s already freezed then you\'ll unfreeze it!', args = { {name = 'playerId', help = 'Existing player server Id'} }})