local requiredItemsShowed = false
local requiredItemsShowed2 = false

CreateThread(function()
    Wait(2000)
    local requiredItems = {
        [1] = {name = QBCore.Shared.Items["security_card_01"]["name"], image = QBCore.Shared.Items["security_card_01"]["image"]},
    }

    local requiredItems2 = {
        [1] = {name = QBCore.Shared.Items["thermite"]["name"], image = QBCore.Shared.Items["thermite"]["image"]},
    }
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inRange = false
        if QBCore ~= nil then
            if #(pos - Config.BigBanks["paleto"]["coords"]) < 20.0 then
                inRange = true
                if not Config.BigBanks["paleto"]["isOpened"] then
                    local dist = #(pos - Config.BigBanks["paleto"]["coords"])
                    if dist < 1 then
                        if not requiredItemsShowed then
                            requiredItemsShowed = true
                            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
                        end
                    else
                        if requiredItemsShowed then
                            requiredItemsShowed = false
                            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                        end
                    end
                end
                if Config.BigBanks["paleto"]["isOpened"] then
                    for k, v in pairs(Config.BigBanks["paleto"]["lockers"]) do
                        local lockerDist = #(pos - Config.BigBanks["paleto"]["lockers"][k]["coords"])
                        if not Config.BigBanks["paleto"]["lockers"][k]["isBusy"] then
                            if not Config.BigBanks["paleto"]["lockers"][k]["isOpened"] then
                                if lockerDist < 5 then
                                    DrawMarker(2, Config.BigBanks["paleto"]["lockers"][k]["coords"].x, Config.BigBanks["paleto"]["lockers"][k]["coords"].y, Config.BigBanks["paleto"]["lockers"][k]["coords"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                                    if lockerDist < 0.5 then
                                        DrawText3Ds(Config.BigBanks["paleto"]["lockers"][k]["coords"].x, Config.BigBanks["paleto"]["lockers"][k]["coords"].y, Config.BigBanks["paleto"]["lockers"][k]["coords"].z + 0.3, '[E] Crack the vault')
                                        if IsControlJustPressed(0, 38) then
                                            if CurrentCops >= Config.MinimumPaletoPolice then
                                                openLocker("paleto", k)
                                            else
                                                QBCore.Functions.Notify('Minimum Of '..Config.MinimumPaletoPolice..' Police Needed', "error")
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if #(pos - Config.BigBanks["paleto"]["thermite"][1]["coords"]) < 10.0 then
                inRange = true
                if not Config.BigBanks["pacific"]["thermite"][1]["isOpened"] then
                    local dist = #(pos - Config.BigBanks["paleto"]["thermite"][1]["coords"])
                    if dist < 1 then
                        currentThermiteGate = Config.BigBanks["paleto"]["thermite"][1]["doorId"]
                        if not requiredItemsShowed2 then
                            requiredItemsShowed2 = true
                            TriggerEvent('inventory:client:requiredItems', requiredItems2, true)
                        end
                    else
                        currentThermiteGate = 0
                        if requiredItemsShowed2 then
                            requiredItemsShowed2 = false
                            TriggerEvent('inventory:client:requiredItems', requiredItems2, false)
                        end
                    end
                end
            end
            if not inRange then
                Wait(2500)
            end
        end
        Wait(1)
    end
end)

RegisterNetEvent('qb-bankrobbery:UseBankcardA', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local dist = #(pos - Config.BigBanks["paleto"]["coords"])
    if math.random(1, 100) <= 85 and not IsWearingHandshoes() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
    end
    if dist < 1.5 then
        QBCore.Functions.TriggerCallback('qb-bankrobbery:server:isRobberyActive', function(isBusy)
            if not isBusy then
                if CurrentCops >= Config.MinimumPaletoPolice then
                    if not Config.BigBanks["paleto"]["isOpened"] then
                        TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                        QBCore.Functions.Progressbar("security_pass", "Validitating card..", math.random(5000, 10000), false, true, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {
                            animDict = "anim@gangops@facility@servers@",
                            anim = "hotwire",
                            flags = 16,
                        }, {}, {}, function() -- Done
                            StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
                            TriggerServerEvent('qb-bankrobbery:server:setBankState', "paleto", true)
                            TriggerServerEvent("QBCore:Server:RemoveItem", "security_card_01", 1)
                            TriggerServerEvent('qb-doorlock:server:updateState', 4, false)
                            if not copsCalled then
								local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
                                local street1 = GetStreetNameFromHashKey(s1)
                                local street2 = GetStreetNameFromHashKey(s2)
                                local streetLabel = street1
                                if street2 ~= nil then
                                    streetLabel = streetLabel .. " " .. street2
                                end
                                if Config.BigBanks["paleto"]["alarm"] then
                                    TriggerServerEvent("qb-bankrobbery:server:callCops", "paleto", 0, streetLabel, pos)
                                    copsCalled = true
                                end
                            end
                        end, function() -- Cancel
                            StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
                            QBCore.Functions.Notify("Canceled..", "error")
                        end)
                    else
                        QBCore.Functions.Notify("It looks like the bank is already opened..", "error")
                    end
                else
                    QBCore.Functions.Notify('Minimum Of '..Config.MinimumPaletoPolice..' Police Needed', "error")
                end
            else
                QBCore.Functions.Notify("The security lock is active, the door cannot be opened at the moment..", "error", 5500)
            end
        end)
    end
end)