local closestStation = 0
local currentStation = 0
local currentFires = {}
local currentGate = 0
local requiredItems = {[1] = {name = QBCore.Shared.Items["thermite"]["name"], image = QBCore.Shared.Items["thermite"]["image"]}}

-- Functions

local function CreateFire(coords, time)
    for _ = 1, math.random(1, 7), 1 do
        TriggerServerEvent("thermite:StartServerFire", coords, 24, false)
    end
    Wait(time)
    TriggerServerEvent("thermite:StopFires")
end

local function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
end

-- Events

RegisterNetEvent('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

RegisterNetEvent('thermite:StartFire', function(coords, maxChildren, isGasFire)
    if #(vector3(coords.x, coords.y, coords.z) - GetEntityCoords(PlayerPedId())) < 100 then
        local pos = {
            x = coords.x,
            y = coords.y,
            z = coords.z,
        }
        pos.z = pos.z - 0.9
        local fire = StartScriptFire(pos.x, pos.y, pos.z, maxChildren, isGasFire)
        currentFires[#currentFires+1] = fire
    end
end)

RegisterNetEvent('thermite:StopFires', function()
    for _, v in ipairs(currentFires) do
        RemoveScriptFire(v)
    end
end)

RegisterNetEvent('thermite:UseThermite', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    if closestStation ~= 0 then
        if math.random(1, 100) <= 85 and not QBCore.Functions.IsWearingGloves() then
            TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
        end
        local dist = #(pos - Config.PowerStations[closestStation].coords)
        if dist < 1.5 then
            if CurrentCops >= Config.MinimumThermitePolice then
                if not Config.PowerStations[closestStation].hit then
                    loadAnimDict("weapon@w_sp_jerrycan")
                    TaskPlayAnim(PlayerPedId(), "weapon@w_sp_jerrycan", "fire", 3.0, 3.9, 180, 49, 0, 0, 0, 0)
                    TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                    SetNuiFocus(true, true)
                    SendNUIMessage({
                        action = "openThermite",
                        amount = math.random(5, 10),
                    })
                    currentStation = closestStation
                else
                    QBCore.Functions.Notify("It seems that the fuses have blown.", "error")
                end
            else
                QBCore.Functions.Notify('Minimum Of '..Config.MinimumThermitePolice..' Police Needed', "error")
            end
        end
    elseif currentThermiteGate ~= 0 then
        if math.random(1, 100) <= 85 and not QBCore.Functions.IsWearingGloves() then
            TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
        end
        if CurrentCops >= Config.MinimumThermitePolice then
            currentGate = currentThermiteGate
            loadAnimDict("weapon@w_sp_jerrycan")
            TaskPlayAnim(PlayerPedId(), "weapon@w_sp_jerrycan", "fire", 3.0, 3.9, -1, 49, 0, 0, 0, 0)
            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
            SetNuiFocus(true, true)
            SendNUIMessage({
                action = "openThermite",
                amount = math.random(5, 10),
            })
        else
            QBCore.Functions.Notify('Minimum Of '..Config.MinimumThermitePolice..' Police Needed', "error")
        end
    end
end)

RegisterNetEvent('qb-bankrobbery:client:SetStationStatus', function(key, isHit)
    Config.PowerStations[key].hit = isHit
end)

-- NUI Callbacks

RegisterNUICallback('thermiteclick', function()
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback('thermitefailed', function()
    QBCore.Functions.TriggerCallback("thermite:server:check", function(success)
        if success then
            PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
            ClearPedTasks(PlayerPedId())
            local coords = GetEntityCoords(PlayerPedId())
            local randTime = math.random(10000, 15000)
            CreateFire(coords, randTime)
        end
    end)
end)

RegisterNUICallback('thermitesuccess', function()
    QBCore.Functions.TriggerCallback("thermite:server:check", function(success)
        if success then
            ClearPedTasks(PlayerPedId())
            local time = 3
            local coords = GetEntityCoords(PlayerPedId())
            while time > 0 do
                QBCore.Functions.Notify("Thermite is going off in " .. time .. "..")
                Wait(1000)
                time -= 1
            end
            local randTime = math.random(10000, 15000)
            CreateFire(coords, randTime)
            if currentStation ~= 0 then
                QBCore.Functions.Notify("The fuses are broken", "success")
                TriggerServerEvent("qb-bankrobbery:server:SetStationStatus", currentStation, true)
            elseif currentGate ~= 0 then
                QBCore.Functions.Notify("The door is open", "success")
                TriggerServerEvent('qb-doorlock:server:updateState', currentGate, false, false, false, true, false, false)
                currentGate = 0
            end
        end
    end)
end)

RegisterNUICallback('closethermite', function()
    SetNuiFocus(false, false)
end)

-- Threads

CreateThread(function()
    for k = 1, #Config.PowerStations do
        local stationZone = BoxZone:Create(Config.PowerStations[k].coords, 1.0, 1.0, {
            name = 'powerstation_coords_'..k,
            heading = 90.0,
            minZ = Config.PowerStations[k].coords.z - 1,
            maxZ = Config.PowerStations[k].coords.z + 1,
            debugPoly = false
        })
        stationZone:onPlayerInOut(function(inside)
            if inside and not Config.PowerStations[k].hit then
                closestStation = k
                TriggerEvent('inventory:client:requiredItems', requiredItems, true)
            else
                if closestStation == k then
                    closestStation = 0
                    TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                end
            end
        end)
    end
end)
