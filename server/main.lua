local QBCore = exports['qb-core']:GetCoreObject()
local robberyBusy = false
local timeOut = false
local blackoutActive = false

-- Functions

local function TableKeysToArray(tbl)
    local array = {}
    for k in pairs(tbl) do
        array[#array+1] = k
    end
    return array
end

local function CheckStationHits()
    local policeHits = {}
    local bankHits = {}

    for k, v in pairs(Config.CameraHits) do
        local allStationsHitPolice = false
        local allStationsHitBank = false
        if type(v.type) == 'table' then
            for _, cameraType in pairs(v.type) do
                if cameraType == 'police' then
                    if type(v.stationsToHitPolice) == 'table' then
                        local hits = 0
                        for _, station in pairs(v.stationsToHitPolice) do
                            if type(station) == 'table' then
                                local hits2 = 0
                                for _, station2 in pairs(station) do
                                    if Config.PowerStations[station2].hit then hits2 += 1 end
                                    if hits2 == #station then allStationsHitPolice = true end
                                end
                            else
                                if Config.PowerStations[station].hit then hits += 1 end
                                if hits == #v.stationsToHitPolice then allStationsHitPolice = true end
                            end
                        end
                    else
                        allStationsHitPolice = Config.PowerStations[v.stationsToHitPolice].hit
                    end
                elseif cameraType == 'bank' then
                    if type(v.stationsToHitBank) == 'table' then
                        local hits = 0
                        for _, station in pairs(v.stationsToHitBank) do
                            if type(station) == 'table' then
                                local hits2 = 0
                                for _, station2 in pairs(station) do
                                    if Config.PowerStations[station2].hit then hits2 += 1 end
                                    if hits2 == #station then allStationsHitBank = true end
                                end
                            else
                                if Config.PowerStations[station].hit then hits += 1 end
                                if hits == #v.stationsToHitBank then allStationsHitBank = true end
                            end
                        end
                    else
                        allStationsHitBank = Config.PowerStations[v.stationsToHitBank].hit
                    end
                end
            end
        else
            if v.type == 'police' then
                if type(v.stationsToHitPolice) == 'table' then
                    local hits = 0
                    for _, station in pairs(v.stationsToHitPolice) do
                        if type(station) == 'table' then
                            local hits2 = 0
                            for _, station2 in pairs(station) do
                                if Config.PowerStations[station2].hit then hits2 += 1 end
                                if hits2 == #station then allStationsHitPolice = true end
                            end
                        else
                            if Config.PowerStations[station].hit then hits += 1 end
                            if hits == #v.stationsToHitPolice then allStationsHitPolice = true end
                        end
                    end
                else
                    allStationsHitPolice = Config.PowerStations[v.stationsToHitPolice].hit
                end
            elseif v.type == 'bank' then
                if type(v.stationsToHitBank) == 'table' then
                    local hits = 0
                    for _, station in pairs(v.stationsToHitBank) do
                        if type(station) == 'table' then
                            local hits2 = 0
                            for _, station2 in pairs(station) do
                                if Config.PowerStations[station2].hit then hits2 += 1 end
                                if hits2 == #station then allStationsHitBank = true end
                            end
                        else
                            if Config.PowerStations[station].hit then hits += 1 end
                            if hits == #v.stationsToHitBank then allStationsHitBank = true end
                        end
                    end
                else
                    allStationsHitBank = Config.PowerStations[v.stationsToHitBank].hit
                end
            end
        end

        if allStationsHitPolice then
            policeHits[k] = true
        end

        if allStationsHitBank then
            bankHits[k] = true
        end
    end

    policeHits = TableKeysToArray(policeHits)
    bankHits = TableKeysToArray(bankHits)

    -- table.type checks if it's empty as well, if it's empty it will return the type 'empty' instead of 'array'
    if table.type(policeHits) == 'array' then TriggerClientEvent("police:client:SetCamera", -1, policeHits, false) end
    if table.type(bankHits) == 'array' then TriggerClientEvent("qb-bankrobbery:client:BankSecurity", -1, bankHits, false) end
end

local function AllStationsHit()
    local hit = 0
    for k in pairs(Config.PowerStations) do
        if Config.PowerStations[k].hit then
            hit += 1
        end
    end
    return hit >= Config.HitsNeeded
end

local function IsNearPowerStation(coords, dist)
    for _, v in pairs(Config.PowerStations) do
        if #(coords - v.coords) < dist then
            return true
        end
    end
    return false
end

-- Events

RegisterNetEvent('qb-bankrobbery:server:setBankState', function(bankId)
    if robberyBusy then return end
    TriggerClientEvent('qb-bankrobbery:client:setBankState', -1, bankId, true)
    if bankId == "paleto" then
        Config.BigBanks["paleto"]["isOpened"] = true
        TriggerEvent('qb-scoreboard:server:SetActivityBusy', "paleto", true)
        TriggerEvent('qb-bankrobbery:server:setTimeout')
    elseif bankId == "pacific" then
        Config.BigBanks["pacific"]["isOpened"] = true
        TriggerEvent('qb-scoreboard:server:SetActivityBusy', "pacific", true)
        TriggerEvent('qb-bankrobbery:server:setTimeout')
    else
        Config.SmallBanks[bankId]["isOpened"] = true
        TriggerEvent('qb-banking:server:SetBankClosed', bankId, true)
        TriggerEvent('qb-scoreboard:server:SetActivityBusy', "bankrobbery", true)
        TriggerEvent('qb-bankrobbery:server:SetSmallbankTimeout', bankId)
    end
    robberyBusy = true
end)

RegisterNetEvent('qb-bankrobbery:server:setLockerState', function(bankId, lockerId, state, bool)
    if bankId == "paleto" then
        Config.BigBanks["paleto"]["lockers"][lockerId][state] = bool
    elseif bankId == "pacific" then
        Config.BigBanks["pacific"]["lockers"][lockerId][state] = bool
    else
        Config.SmallBanks[bankId]["lockers"][lockerId][state] = bool
    end
    TriggerClientEvent('qb-bankrobbery:client:setLockerState', -1, bankId, lockerId, state, bool)
end)

RegisterNetEvent('qb-bankrobbery:server:recieveItem', function(type)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)
    if not ply then return end
    if type == "small" then
        local itemType = math.random(#Config.RewardTypes)
        local WeaponChance = math.random(1, 50)
        local odd1 = math.random(1, 50)
        local tierChance = math.random(1, 100)
        local tier
        if tierChance < 50 then tier = 1 elseif tierChance >= 50 and tierChance < 80 then tier = 2 elseif tierChance >= 80 and tierChance < 95 then tier = 3 else tier = 4 end
        if WeaponChance ~= odd1 then
            if tier ~= 4 then
                 if Config.RewardTypes[itemType].type == "item" then
                    local item = Config.LockerRewards["tier"..tier][math.random(#Config.LockerRewards["tier"..tier])]
                    local itemAmount = math.random(item.minAmount, item.maxAmount)
                    ply.Functions.AddItem(item.item, itemAmount)
                    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.item], "add")
                 elseif Config.RewardTypes[itemType].type == "money" then
                    local info = {
                        worth = math.random(2300, 3200)
                    }
                    ply.Functions.AddItem('markedbills', math.random(2,3), false, info)
                    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['markedbills'], "add")
                end
            else
                ply.Functions.AddItem('security_card_01', 1)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['security_card_01'], "add")
            end
        else
            ply.Functions.AddItem('weapon_stungun', 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['weapon_stungun'], "add")
        end
    elseif type == "paleto" then
        local itemType = math.random(#Config.RewardTypes)
        local tierChance = math.random(1, 100)
        local WeaponChance = math.random(1, 10)
        local odd1 = math.random(1, 10)
        local tier
        if tierChance < 25 then tier = 1 elseif tierChance >= 25 and tierChance < 70 then tier = 2 elseif tierChance >= 70 and tierChance < 95 then tier = 3 else tier = 4 end
        if WeaponChance ~= odd1 then
            if tier ~= 4 then
                 if Config.RewardTypes[itemType].type == "item" then
                    local item = Config.LockerRewardsPaleto["tier"..tier][math.random(#Config.LockerRewardsPaleto["tier"..tier])]
                    local itemAmount = math.random(item.minAmount, item.maxAmount)
                    ply.Functions.AddItem(item.item, itemAmount)
                    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.item], "add")
                 elseif Config.RewardTypes[itemType].type == "money" then
                    local info = {
                        worth = math.random(4000, 6000)
                    }
                    ply.Functions.AddItem('markedbills', math.random(1,4), false, info)
                    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['markedbills'], "add")
                 end
            else
                ply.Functions.AddItem('security_card_02', 1)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['security_card_02'], "add")
            end
        else
            ply.Functions.AddItem('weapon_vintagepistol', 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['weapon_vintagepistol'], "add")
        end
    elseif type == "pacific" then
        local itemType = math.random(#Config.RewardTypes)
        local WeaponChance = math.random(1, 100)
        local odd1 = math.random(1, 100)
        local odd2 = math.random(1, 100)
        local tierChance = math.random(1, 100)
        local tier
        if tierChance < 10 then tier = 1 elseif tierChance >= 25 and tierChance < 50 then tier = 2 elseif tierChance >= 50 and tierChance < 95 then tier = 3 else tier = 4 end
        if WeaponChance ~= odd1 or WeaponChance ~= odd2 then
            if tier ~= 4 then
                if Config.RewardTypes[itemType].type == "item" then
                    local item = Config.LockerRewardsPacific["tier"..tier][math.random(#Config.LockerRewardsPacific["tier"..tier])]
                    local maxAmount
                    if tier == 3 then maxAmount = 7 elseif tier == 2 then maxAmount = 18 else maxAmount = 25 end
                    local itemAmount = math.random(maxAmount)
                    ply.Functions.AddItem(item.item, itemAmount)
                    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.item], "add")
                elseif Config.RewardTypes[itemType].type == "money" then
                    local info = {
                        worth = math.random(19000, 21000)
                    }
                    ply.Functions.AddItem('markedbills', math.random(1,4), false, info)
                    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['markedbills'], "add")
                end
            else
                local info = {
                    worth = math.random(19000, 21000)
                }
                ply.Functions.AddItem('markedbills', math.random(1,4), false, info)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['markedbills'], "add")
                info = {
                    crypto = math.random(1, 3)
                }
                ply.Functions.AddItem("cryptostick", 1, false, info)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['cryptostick'], "add")
            end
        else
            local chance = math.random(1, 2)
            local odd = math.random(1, 2)
            if chance == odd then
                ply.Functions.AddItem('weapon_microsmg', 1)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['weapon_microsmg'], "add")
            else
                ply.Functions.AddItem('weapon_minismg', 1)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['weapon_minismg'], "add")
            end
        end
    end
end)

RegisterNetEvent('qb-bankrobbery:server:setTimeout', function()
    if source or source ~= '' or robberyBusy or timeOut then return end -- This event can only be triggered server side so we have to make sure that is checked
    timeOut = true
    CreateThread(function()
        SetTimeout(60000 * 90, function()
            timeOut = false
            robberyBusy = false
            TriggerEvent('qb-scoreboard:server:SetActivityBusy', "bankrobbery", false)
            TriggerEvent('qb-scoreboard:server:SetActivityBusy', "pacific", false)
            for k in pairs(Config.BigBanks["pacific"]["lockers"]) do
                Config.BigBanks["pacific"]["lockers"][k]["isBusy"] = false
                Config.BigBanks["pacific"]["lockers"][k]["isOpened"] = false
            end
            for k in pairs(Config.BigBanks["paleto"]["lockers"]) do
                Config.BigBanks["paleto"]["lockers"][k]["isBusy"] = false
                Config.BigBanks["paleto"]["lockers"][k]["isOpened"] = false
            end
            TriggerClientEvent('qb-bankrobbery:client:ClearTimeoutDoors', -1)
            Config.BigBanks["paleto"]["isOpened"] = false
            Config.BigBanks["pacific"]["isOpened"] = false
        end)
    end)
end)

RegisterNetEvent('qb-bankrobbery:server:SetSmallbankTimeout', function(BankId)
    if not robberyBusy then
        if not timeOut then
            timeOut = true
            CreateThread(function()
                SetTimeout(60000 * 30, function()
                    timeOut = false
                    robberyBusy = false
                    for k in pairs(Config.SmallBanks[BankId]["lockers"]) do
                        Config.SmallBanks[BankId]["lockers"][k]["isOpened"] = false
                        Config.SmallBanks[BankId]["lockers"][k]["isBusy"] = false
                    end
                    timeOut = false
                    robberyBusy = false
                    TriggerClientEvent('qb-bankrobbery:client:ResetFleecaLockers', -1, BankId)
                    TriggerEvent('qb-banking:server:SetBankClosed', BankId, false)
                end)
            end)
		end
    end
end)

RegisterNetEvent('qb-bankrobbery:server:callCops', function(type, bank, streetLabel, coords)
    local cameraId
    local bankLabel
    local msg = ""
    if type == "small" then
        cameraId = Config.SmallBanks[bank]["camId"]
        bankLabel = "Fleeca"
        msg = "The Alarm has been activated at "..bankLabel.. " " ..streetLabel.." (CAMERA ID: "..cameraId..")"
    elseif type == "paleto" then
        cameraId = Config.BigBanks["paleto"]["camId"]
        bankLabel = "Blaine County Savings"
        msg = "The Alarm has been activated at "..bankLabel.. " Paleto Bay (CAMERA ID: "..cameraId..")"
    elseif type == "pacific" then
        bankLabel = "Pacific Standard Bank"
        msg = "The Alarm has been activated at "..bankLabel.. " Alta St (CAMERA ID: 1/2/3)"
    end
    local alertData = {
        title = "Bank robbery",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("qb-bankrobbery:client:robberyCall", -1, type, bank, streetLabel, coords)
    TriggerClientEvent("qb-phone:client:addPoliceAlert", -1, alertData)
end)

RegisterNetEvent('qb-bankrobbery:server:SetStationStatus', function(key, isHit)
    Config.PowerStations[key].hit = isHit
    TriggerClientEvent("qb-bankrobbery:client:SetStationStatus", -1, key, isHit)
    if AllStationsHit() then
        exports["qb-weathersync"]:setBlackout(true)
        TriggerClientEvent("police:client:DisableAllCameras", -1)
        TriggerClientEvent("qb-bankrobbery:client:disableAllBankSecurity", -1)
        blackoutActive = true
        CreateThread(function()
            SetTimeout(60000 * Config.BlackoutTimer, function()
                exports["qb-weathersync"]:setBlackout(false)
                TriggerClientEvent("police:client:EnableAllCameras", -1)
                TriggerClientEvent("qb-bankrobbery:client:enableAllBankSecurity", -1)
                blackoutActive = false
            end)
        end)
    else
        CheckStationHits()
    end
end)

RegisterNetEvent('qb-bankrobbery:server:removeElectronicKit', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    Player.Functions.RemoveItem('electronickit', 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["electronickit"], "remove")
    Player.Functions.RemoveItem('trojan_usb', 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["trojan_usb"], "remove")
end)

RegisterNetEvent('qb-bankrobbery:server:removeBankCard', function(number)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    Player.Functions.RemoveItem('security_card_'..number, 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['security_card_'..number], "remove")
end)

RegisterNetEvent('thermite:StartServerFire', function(coords, maxChildren, isGasFire)
    local src = source
    local ped = GetPlayerPed(src)
    local coords2 = GetEntityCoords(ped)
    local thermiteCoords = Config.BigBanks['pacific'].thermite[1].coords
    local thermite2Coords = Config.BigBanks['pacific'].thermite[2].coords
    local thermite3Coords = Config.BigBanks['paleto'].thermite[1].coords
    if #(coords2 - thermiteCoords) < 10 or #(coords2 - thermite2Coords) < 10 or #(coords2 - thermite3Coords) < 10 or IsNearPowerStation(coords2, 10) then
        TriggerClientEvent("thermite:StartFire", -1, coords, maxChildren, isGasFire)
    end
end)

RegisterNetEvent('thermite:StopFires', function()
    TriggerClientEvent("thermite:StopFires", -1)
end)

-- Callbacks

QBCore.Functions.CreateCallback('qb-bankrobbery:server:isRobberyActive', function(_, cb)
    cb(robberyBusy)
end)

QBCore.Functions.CreateCallback('qb-bankrobbery:server:GetConfig', function(_, cb)
    cb(Config)
end)

QBCore.Functions.CreateCallback("thermite:server:check", function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return cb(false) end
    if Player.Functions.RemoveItem("thermite", 1) then
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["thermite"], "remove")
        cb(true)
    else
        cb(false)
    end
end)

-- Items

QBCore.Functions.CreateUseableItem("thermite", function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player or not Player.Functions.GetItemByName('thermite') then return end
	if Player.Functions.GetItemByName('lighter') then
        TriggerClientEvent("thermite:UseThermite", source)
    else
        TriggerClientEvent('QBCore:Notify', source, "You're missing ignition source", "error")
    end
end)

QBCore.Functions.CreateUseableItem("security_card_01", function(source)
    local Player = QBCore.Functions.GetPlayer(source)
	if not Player or not Player.Functions.GetItemByName('security_card_01') then return end
    TriggerClientEvent("qb-bankrobbery:UseBankcardA", source)
end)

QBCore.Functions.CreateUseableItem("security_card_02", function(source)
    local Player = QBCore.Functions.GetPlayer(source)
	if not Player or not Player.Functions.GetItemByName('security_card_02') then return end
    TriggerClientEvent("qb-bankrobbery:UseBankcardB", source)
end)

QBCore.Functions.CreateUseableItem("electronickit", function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player or not Player.Functions.GetItemByName('electronickit') then return end
    TriggerClientEvent("electronickit:UseElectronickit", source)
end)

-- Threads

CreateThread(function()
    while true do
        if not blackoutActive then
            TriggerClientEvent("qb-bankrobbery:client:enableAllBankSecurity", -1)
            TriggerClientEvent("police:client:EnableAllCameras", -1)
        end
        Wait(60000 * 30)
    end
end)
