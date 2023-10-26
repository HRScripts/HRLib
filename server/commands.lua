HRLib.RegCommand('dv', false, true, function(args, rawCommand, IPlayer, FPlayer)
    local veh = GetVehiclePedIsIn(IPlayer.ped, false)

    if veh == 0 then
        FPlayer.Notify('You are not in a vehicle!', 'error', 2500)
    else
        DeleteEntity(veh)
        FPlayer.Notify('You successfully deleted this vehicle!', 'success', 2500)
    end
end, true, {help = 'Delete the vehicle you\'re sitting in'})

HRLib.RegCommand('car', false, true, function(args, rawCommand, IPlayer, FPlayer)
    if clib.nilCheck(args) then
        FPlayer.SpawnVehicle(args[1], true, function(veh)
            SetVehicleNumberPlateText(veh, args[2] or 'AdminVeh')
        end)
    else
        FPlayer.Notify('Invalid value at argument 1! You didn\'t write the vehicle model', 'error', 2500)
    end
end, true, {help = 'Spawn a vehicle (admin only)', args = {{name = 'vehModel', help = 'Model of existing vehicle in the server'}, {name = 'vehPlate', help = 'Plate of the vehicle'}}})

HRLib.RegCommand('giveAccess', true, true, function(args, rawCommand, IPlayer, FPlayer)
    if clib.nilCheck(args) then
        local target, target2, type, cmd = tonumber(args[1]), GetPlayerName(tonumber(args[1])), args[2], args[3]
        if target ~= IPlayer.source then
            if HRLib.DoesIdExist(target) then
                if type == 'oneCmd' then
                    for _,v in pairs(GetRegisteredCommands()) do
                        if string.find(v, cmd) then
                            ExecuteCommand(('add_ace player.%s command.%s allow'):format(target2, cmd))
                            FPlayer.Notify(('You successfully gave a permission for the `%s` command to the %s!'):format(cmd, target2), 'success', 2500)
                            HRLib.Notify(target, ('You successfully receive the permission to use `%s` command in this server from %s!'):format(cmd, GetPlayerName(IPlayer.name)), 'info', 2500)
                        else
                            FPlayer.Notify(cmd..' does not exist as a command!', 'error', 2500)
                        end
                    end
                elseif type == 'allCmds' then
                    ExecuteCommand(('add_ace player.%s command allow'):format(target2))

                    if IPlayer.source ~= 0 then
                        FPlayer.Notify(('You successfully gave the permission of use all commands to %s!'):format(target2), 'success', 2500)
                    else
                        print(('You successfully gave a permission for use all of the commands in this server to ^4%s^0!'):format(target2))
                    end

                    HRLib.Notify(target, ('You successfully receive the permission to use all of the commands in this server. Gave by: %s!'):format(GetPlayerName(IPlayer.name)), 'info', 2500)
                elseif type == nil or type == '' then
                    FPlayer.Notify('Invalid type! Available types: oneCmd ; allCmds', 'error', 2500)
                end
            else
                FPlayer.Notify(('This player server Id (%s) does not exist!'):format(target2), 'error', 2500)
            end
        else
            if IPlayer.source == 0 then
                print('You cannot change your own access!')
            else
                FPlayer.Notify('You cannot change your own access!', 'error', 2500)
            end
        end
    else
        if IPlayer.source == 0 then
            print('^3You have to fill all the required arguments!^0')
        else
            FPlayer.Notify('You have to fill all the required arguments!', 'warning', 2500)
        end
    end
end, true, {help = 'Give access to any command or all commands', args = { {name = 'playerId', help = 'Existing player server Id of the target player'}, {name = 'type', help = 'Types: oneCmd, allCmds'}, {name = 'cmdName', help = 'The command name (only fill if your type is `oneCmd`!!)'} }})

HRLib.RegCommand('removeAccess', true, true, function(args, rawCommand, IPlayer, FPlayer)
    if clib.nilCheck(args) then
        local target, target2, type, cmd = tonumber(args[1]), args[1], args[2], args[3]
        if target ~= IPlayer.source then
            if HRLib.DoesIdExist(target) then
                if type == 'oneCmd' then
                    for _,v in pairs(GetRegisteredCommands()) do
                        if string.find(v, cmd) then
                            ExecuteCommand(('add_ace player.%s command.%s deny'):format(target2, cmd))
                            FPlayer.Notify(('You successfully remove a permission for the `%s` command to the `%s` player!'):format(cmd, target2), 'success', 2500)
                            HRLib.Notify(target, ('Your permission for the `%s` command was removed. Removed by: %s!'):format(IPlayer.name), 'info', 2500)
                        else
                            FPlayer.Notify(cmd..' does not exist as a command!', 'error', 2500)
                        end
                    end
                elseif type == 'allCmds' then
                    ExecuteCommand(('add_ace player.%s command deny'):format(target2))
                    FPlayer.Notify(('You successfully removed the permission for all commands of %s!'):format(target2), 'success', 2500)
                    HRLib.Notify(target, ('Your permission to use all of the commands in this server has been removed by: %s!'):format(IPlayer.name), 'info', 2500)
                elseif type == nil or type == '' then
                    FPlayer.Notify('Invalid type! Available types: oneCmd ; allCmds', 'error', 2500)
                end
            else
                FPlayer.Notify(('This player server Id (%s) does not exist!'):format(target2), 'error', 2500)
            end
        else
            if IPlayer.source == 0 then
                print('^3You cannot change your own permission!')
            else
                FPlayer.Notify('You cannot change your own permission!', 'warning', 2500)
            end
        end
    else
        if IPlayer.source == 0 then
            print('^3You have to fill all the required arguments!^0')
        else
            FPlayer.Notify('You have to fill all the required arguments!', 'warning', 2500)
        end
    end
end, true, {help = 'Remove access to any command or all commands of a player', args = { {name = 'playerId', help = 'Existing player server Id of the target player'}, {name = 'type', help = 'Types: oneCmd, allCmds'}, {name = 'cmdName', help = 'The command name (only fill if your type is `oneCmd`!!)'} }})

HRLib.RegCommand('id', true, true, function(args, rawCommand, IPlayer)
    if IPlayer.source then
        if IPlayer.source == 0 then
            print(('%s'):format(IPlayer.source))
        else
            FPlayer.Notify(('%s'):format(IPlayer.source))
        end
    end
end, true)