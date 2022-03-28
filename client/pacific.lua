local inBankCardBZone = false
local inElectronickitZone = false
local currentLocker = 0

-- Functions

local function OnHackPacificDone(success)
    if success then
        TriggerEvent('mhacking:hide')
        TriggerServerEvent('qb-bankrobbery:server:setBankState', "pacific", true)
    else
		TriggerEvent('mhacking:hide')
	end
end

-- Events

RegisterNetEvent('qb-bankrobbery:UseBankcardB', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    if math.random(1, 100) <= 85 and not QBCore.Functions.IsWearingGloves() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
    end
    if not inBankCardBZone then return end
    QBCore.Functions.TriggerCallback('qb-bankrobbery:server:isRobberyActive', function(isBusy)
        if not isBusy then
            if CurrentCops >= Config.MinimumPacificPolice then
                if not Config.BigBanks["pacific"]["isOpened"] then
                    TriggerEvent('inventory:client:requiredItems', {
                        [1] = {name = QBCore.Shared.Items["security_card_02"]["name"], image = QBCore.Shared.Items["security_card_02"]["image"]}
                    }, false)
                    QBCore.Functions.Progressbar("security_pass", "Please validate ..", math.random(5000, 10000), false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                        animDict = "anim@gangops@facility@servers@",
                        anim = "hotwire",
                        flags = 16,
                    }, {}, {}, function() -- Done
                        StopAnimTask(ped, "anim@gangops@facility@servers@", "hotwire", 1.0)
                        TriggerServerEvent('qb-doorlock:server:updateState', 1, false, false, false, true, false, false)
                        TriggerServerEvent('qb-bankrobbery:server:removeBankCard', '02')
                        if copsCalled or not Config.BigBanks["pacific"]["alarm"] then return end
                        local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
                        local street1 = GetStreetNameFromHashKey(s1)
                        local street2 = GetStreetNameFromHashKey(s2)
                        local streetLabel = street1
                        if street2 then streetLabel = streetLabel .. " " .. street2 end
                        TriggerServerEvent("qb-bankrobbery:server:callCops", "pacific", 0, streetLabel, pos)
                        copsCalled = true
                    end, function() -- Cancel
                        StopAnimTask(ped, "anim@gangops@facility@servers@", "hotwire", 1.0)
                        QBCore.Functions.Notify("Canceled..", "error")
                    end)
                else
                    QBCore.Functions.Notify("Looks like the bank is already open ..", "error")
                end
            else
                QBCore.Functions.Notify('Minimum Of '..Config.MinimumPacificPolice..' Police Needed', "error")
            end
        else
            QBCore.Functions.Notify("The security lock is active, opening the door is currently not possible.", "error", 5500)
        end
    end)
end)

RegisterNetEvent('electronickit:UseElectronickit', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    if not inElectronickitZone then return end
    QBCore.Functions.TriggerCallback('qb-bankrobbery:server:isRobberyActive', function(isBusy)
        if not isBusy then
            if CurrentCops >= Config.MinimumPacificPolice then
                if not Config.BigBanks["pacific"]["isOpened"] then
                    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
                        if result then
                            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                            QBCore.Functions.Progressbar("hack_gate", "Connecting the hacking device ..", math.random(5000, 10000), false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {
                                animDict = "anim@gangops@facility@servers@",
                                anim = "hotwire",
                                flags = 16,
                            }, {}, {}, function() -- Done
                                TriggerServerEvent('qb-bankrobbery:server:removeElectronicKit')
                                StopAnimTask(ped, "anim@gangops@facility@servers@", "hotwire", 1.0)
                                TriggerEvent("mhacking:show")
                                TriggerEvent("mhacking:start", math.random(5, 9), math.random(10, 15), OnHackPacificDone)
                                if copsCalled or not Config.BigBanks["pacific"]["alarm"] then return end
                                local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
                                local street1 = GetStreetNameFromHashKey(s1)
                                local street2 = GetStreetNameFromHashKey(s2)
                                local streetLabel = street1
                                if street2 then streetLabel = streetLabel .. " " .. street2 end
                                TriggerServerEvent("qb-bankrobbery:server:callCops", "pacific", 0, streetLabel, pos)
                                copsCalled = true
                            end, function() -- Cancel
                                StopAnimTask(ped, "anim@gangops@facility@servers@", "hotwire", 1.0)
                                QBCore.Functions.Notify("Canceled", "error")
                            end)
                        else
                            QBCore.Functions.Notify("You're missing an item ..", "error")
                        end
                    end, "trojan_usb")
                else
                    QBCore.Functions.Notify("Looks like the bank is already open", "error")
                end
            else
                QBCore.Functions.Notify('Minimum Of '..Config.MinimumPacificPolice..' Police Needed', "error")
            end
        else
            QBCore.Functions.Notify("The security lock is active, opening the door is currently not possible.", "error", 5500)
        end
    end)
end)

-- Threads

CreateThread(function()
    local bankCardBZone = BoxZone:Create(Config.BigBanks["pacific"]["coords"][1], 1.0, 1.0, {
        name = 'pacific_coords_bankcardb',
        heading = Config.BigBanks["pacific"]["heading"].closed,
        minZ = Config.BigBanks["pacific"]["coords"][1].z - 1,
        maxZ = Config.BigBanks["pacific"]["coords"][1].z + 1,
        debugPoly = false
    })
    bankCardBZone:onPlayerInOut(function(inside)
        inBankCardBZone = inside
        if inside and not Config.BigBanks["pacific"]["isOpened"] then
            TriggerEvent('inventory:client:requiredItems', {
                [1] = {name = QBCore.Shared.Items["security_card_02"]["name"], image = QBCore.Shared.Items["security_card_02"]["image"]}
            }, true)
        else
            TriggerEvent('inventory:client:requiredItems', {
                [1] = {name = QBCore.Shared.Items["security_card_02"]["name"], image = QBCore.Shared.Items["security_card_02"]["image"]}
            }, false)
        end
    end)
    local electronickitZone = BoxZone:Create(Config.BigBanks["pacific"]["coords"][2], 1.0, 1.0, {
        name = 'pacific_coords_electronickit',
        heading = Config.BigBanks["pacific"]["heading"].closed,
        minZ = Config.BigBanks["pacific"]["coords"][2].z - 1,
        maxZ = Config.BigBanks["pacific"]["coords"][2].z + 1,
        debugPoly = false
    })
    electronickitZone:onPlayerInOut(function(inside)
        inElectronickitZone = inside
        if inside and not Config.BigBanks["pacific"]["isOpened"] then
            TriggerEvent('inventory:client:requiredItems', {
                [1] = {name = QBCore.Shared.Items["electronickit"]["name"], image = QBCore.Shared.Items["electronickit"]["image"]},
                [2] = {name = QBCore.Shared.Items["trojan_usb"]["name"], image = QBCore.Shared.Items["trojan_usb"]["image"]},
            }, true)
        else
            TriggerEvent('inventory:client:requiredItems', {
                [1] = {name = QBCore.Shared.Items["electronickit"]["name"], image = QBCore.Shared.Items["electronickit"]["image"]},
                [2] = {name = QBCore.Shared.Items["trojan_usb"]["name"], image = QBCore.Shared.Items["trojan_usb"]["image"]},
            }, false)
        end
    end)
    local thermite1Zone = BoxZone:Create(Config.BigBanks["pacific"]["thermite"][1]["coords"], 1.0, 1.0, {
        name = 'pacific_coords_thermite_1',
        heading = Config.BigBanks["pacific"]["heading"].closed,
        minZ = Config.BigBanks["pacific"]["thermite"][1]["coords"].z - 1,
        maxZ = Config.BigBanks["pacific"]["thermite"][1]["coords"].z + 1,
        debugPoly = false
    })
    thermite1Zone:onPlayerInOut(function(inside)
        if inside and not Config.BigBanks["pacific"]["thermite"][1]["isOpened"] then
            currentThermiteGate = Config.BigBanks["pacific"]["thermite"][1]["doorId"]
            TriggerEvent('inventory:client:requiredItems', {
                [1] = {name = QBCore.Shared.Items["thermite"]["name"], image = QBCore.Shared.Items["thermite"]["image"]},
            }, true)
        else
            if currentThermiteGate == Config.BigBanks["pacific"]["thermite"][1]["doorId"] then
                currentThermiteGate = 0
                TriggerEvent('inventory:client:requiredItems', {
                    [1] = {name = QBCore.Shared.Items["thermite"]["name"], image = QBCore.Shared.Items["thermite"]["image"]},
                }, false)
            end
        end
    end)
    local thermite2Zone = BoxZone:Create(Config.BigBanks["pacific"]["thermite"][2]["coords"], 1.0, 1.0, {
        name = 'pacific_coords_thermite_2',
        heading = Config.BigBanks["pacific"]["heading"].closed,
        minZ = Config.BigBanks["pacific"]["thermite"][2]["coords"].z - 1,
        maxZ = Config.BigBanks["pacific"]["thermite"][2]["coords"].z + 1,
        debugPoly = false
    })
    thermite2Zone:onPlayerInOut(function(inside)
        if inside and not Config.BigBanks["pacific"]["thermite"][2]["isOpened"] then
            currentThermiteGate = Config.BigBanks["pacific"]["thermite"][2]["doorId"]
            TriggerEvent('inventory:client:requiredItems', {
                [1] = {name = QBCore.Shared.Items["thermite"]["name"], image = QBCore.Shared.Items["thermite"]["image"]},
            }, true)
        else
            if currentThermiteGate == Config.BigBanks["pacific"]["thermite"][2]["doorId"] then
                currentThermiteGate = 0
                TriggerEvent('inventory:client:requiredItems', {
                    [1] = {name = QBCore.Shared.Items["thermite"]["name"], image = QBCore.Shared.Items["thermite"]["image"]},
                }, false)
            end
        end
    end)
    for k in pairs(Config.BigBanks["pacific"]["lockers"]) do
        if Config.UseTarget then
            exports['qb-target']:AddBoxZone('pacific_coords_locker_'..k, Config.BigBanks["pacific"]["lockers"][k]["coords"], 1.0, 1.0, {
                name = 'pacific_coords_locker_'..k,
                heading = Config.BigBanks["pacific"]["heading"].closed,
                minZ = Config.BigBanks["pacific"]["lockers"][k]["coords"].z - 1,
                maxZ = Config.BigBanks["pacific"]["lockers"][k]["coords"].z + 1,
                debugPoly = false
            }, {
                options = {
                    {
                        action = function()
                            openLocker("pacific", k)
                        end,
                        canInteract = function()
                            return Config.BigBanks["pacific"]["isOpened"] and not Config.BigBanks["pacific"]["lockers"][k]["isBusy"] and not Config.BigBanks["pacific"]["lockers"][k]["isOpened"]
                        end,
                        icon = 'fa-solid fa-vault',
                        label = 'Break Safe Open',
                    },
                },
                distance = 1.5
            })
        else
            local lockerZone = BoxZone:Create(Config.BigBanks["pacific"]["lockers"][k]["coords"], 1.0, 1.0, {
                name = 'pacific_coords_locker_'..k,
                heading = Config.BigBanks["pacific"]["heading"].closed,
                minZ = Config.BigBanks["pacific"]["lockers"][k]["coords"].z - 1,
                maxZ = Config.BigBanks["pacific"]["lockers"][k]["coords"].z + 1,
                debugPoly = false
            })
            lockerZone:onPlayerInOut(function(inside)
                if inside and Config.BigBanks["pacific"]["isOpened"] and not Config.BigBanks["pacific"]["lockers"][k]["isBusy"] and not Config.BigBanks["pacific"]["lockers"][k]["isOpened"] then
                    exports['qb-core']:DrawText('[E] Break open the safe', 'right')
                    currentLocker = k
                else
                    if currentLocker == k then
                        currentLocker = 0
                        exports['qb-core']:HideText()
                    end
                end
            end)
        end
    end
    if not Config.UseTarget then
        while true do
            local sleep = 1000
            if isLoggedIn then
                if currentLocker ~= 0 then
                    sleep = 0
                    if IsControlJustPressed(0, 38) then
                        exports['qb-core']:KeyPressed()
                        Wait(500)
                        exports['qb-core']:HideText()
                        if CurrentCops >= Config.MinimumPacificPolice then
                            openLocker("pacific", currentLocker)
                        else
                            QBCore.Functions.Notify('Minimum Of '..Config.MinimumPacificPolice..' Police Needed', "error")
                        end
                        sleep = 1000
                    end
                end
            end
            Wait(sleep)
        end
    end
end)
