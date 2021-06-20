PaletoDoor = function() -- THIS IS ONLY FOR PALETO DOORS
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)

    if Config.BigBanks["paleto"]["isOpened"] then -- This should leave door open if the door state is true
        -- we dont wanna set door open because that way it closes them and then opens them again and it will break the loops for the depsoit boxes and trolly with money
        -- so will will just end the if statment to avoide conflict with loops
    end

    if not Config.BigBanks["paleto"]["isOpened"] then -- if the starte is false set door closed
        local object = GetClosestObjectOfType(Config.BigBanks["paleto"]["coords"]["x"], Config.BigBanks["paleto"]["coords"]["y"], Config.BigBanks["paleto"]["coords"]["z"], 5.0, Config.BigBanks["paleto"]["object"], false, false, false)

        print('closing the door')
        SetEntityHeading(object, Config.BigBanks["paleto"]["heading"].closed)
    end
end


RegisterNetEvent('qb-bankrobbery:client:ClearTimeoutDoors')
AddEventHandler('qb-bankrobbery:client:ClearTimeoutDoors', function()
    TriggerServerEvent('qb-doorlock:server:updateState', 85, true)
    local PaletoObject = GetClosestObjectOfType(Config.BigBanks["paleto"]["coords"]["x"], Config.BigBanks["paleto"]["coords"]["y"], Config.BigBanks["paleto"]["coords"]["z"], 5.0, Config.BigBanks["paleto"]["object"], false, false, false)
    if PaletoObject ~= 0 then
        SetEntityHeading(PaletoObject, Config.BigBanks["paleto"]["heading"].closed)
    end

    local object = GetClosestObjectOfType(Config.BigBanks["pacific"]["coords"][2]["x"], Config.BigBanks["pacific"]["coords"][2]["y"], Config.BigBanks["pacific"]["coords"][2]["z"], 20.0, Config.BigBanks["pacific"]["object"], false, false, false)
    if object ~= 0 then
        SetEntityHeading(object, Config.BigBanks["pacific"]["heading"].closed)
    end

    for k, v in pairs(Config.BigBanks["pacific"]["lockers"]) do
        Config.BigBanks["pacific"]["lockers"][k]["isBusy"] = false
        Config.BigBanks["pacific"]["lockers"][k]["isOpened"] = false
    end

    for k, v in pairs(Config.BigBanks["paleto"]["lockers"]) do
        Config.BigBanks["paleto"]["lockers"][k]["isBusy"] = false
        Config.BigBanks["paleto"]["lockers"][k]["isOpened"] = false
    end

    Config.BigBanks["paleto"]["isOpened"] = false
    Config.BigBanks["pacific"]["isOpened"] = false
end)
