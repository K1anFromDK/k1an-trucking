local progress = 0
local supplyLocations = {}
local trailerEntity = nil

CreateThread(function()
    for k, v in pairs(Config.PickupLocations) do
        lib.requestModel("a_m_m_farmer_01")
        local npc = CreatePed(1, GetHashKey("a_m_m_farmer_01"), v.npcxyz.x, v.npcxyz.y, v.npcxyz.z - 1, v.npcxyz.w, false, true)
        FreezeEntityPosition(npc, true)
        SetEntityInvincible(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)

        exports.ox_target:addLocalEntity(npc, {{
            label = "Snak med " .. v.name,
            icon = "fas fa-user",
            canInteract = function()
                if progress == 0 then
                    return true
                else
                    return false
                end
            end,
            onSelect = function()
                StartMission(v)
            end
        }, {
            label = "Aflever Trailer",
            icon = "fas fa-user",
            canInteract = function()
                if progress == 3 then
                    return true
                else
                    return false
                end
            end,
            onSelect = function()
                local data = lib.callback.await('lastbiljob:rewardworker', false, v)
                if data then
                    DeleteVehicle(trailerEntity)
                    Config.Notify("success", "Du har modtaget " .. data .. " DKK", 5000)
                    UpdateProgress(0)
                else
                    Config.Notify("error", "Der skete en fejl!", 5000)
                end
            end
        }})
    end
end)

function CreateBlip(coords, name)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 1)
    SetBlipColour(blip, 5)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
    return blip
end

function StartMission(v)
    local trailermodel = Config.TrailerModel
    lib.requestModel(trailermodel)
    local trailer = CreateVehicle(GetHashKey(trailermodel), v.trailerxyz.x, v.trailerxyz.y, v.trailerxyz.z, v.trailerxyz.w, true, false)
    trailerEntity = trailer
    SetEntityAsMissionEntity(trailer, true, true)
    SetVehicleOnGroundProperly(trailer)
    UpdateProgress(1)
    Config.Notify("success", "Der er blevet markeret nogen steder på dit map. Der er varerne hent dem!", 5000)

    local usedLocations = {}
    for i = 1, math.random(Config.MinMaxSupplies.min, Config.MinMaxSupplies.max) do
        local random
        repeat random = math.random(1, #Config.SupplyLocations) 
        until not usedLocations[random]
        usedLocations[random] = true

        local supply = Config.SupplyLocations[random]
        local varerBlip = CreateBlip(supply, "Varer")
        table.insert(supplyLocations, {
            id = i,
            supply = supply,
            blip = varerBlip
        })
        local point = lib.points.new({
            coords = supply,
            distance = 20
        })
        if progress == 1 then
            local marker = lib.marker.new({
                type = 2,
                coords = vec3(supply.x, supply.y, supply.z),
                color = {
                    r = 255,
                    g = 144,
                    b = 0,
                    a = 200
                }
            })
            lib.zones.box({
                coords = vec3(supply.x, supply.y, supply.z),
                size = vec3(10, 10, 3.5),
                rotation = 60,
                debug = Config.Debug,
                inside = function()
                    if progress == 1 then
                        marker:draw()
                        if IsPedInAnyVehicle(PlayerPedId()) then
                            lib.showTextUI('Tryk E for at samle varer op')
                            if IsControlJustPressed(0, 38) then
                                PickupPackage(supply, varerBlip)
                            end
                        end
                    end
                end,
                onExit = function()
                    lib.hideTextUI()
                end
            })
        end
    end
end

function StartDelivery()
    local randomDelivery = math.random(1, #Config.RandomDeliveryLocations)
    local delivery = Config.RandomDeliveryLocations[randomDelivery]
    local deliveryBlip = CreateBlip(delivery, "Leveringssted")
    SetNewWaypoint(delivery.x, delivery.y)
    if progress == 2 then
        local deliveryMarker = lib.marker.new({
            type = 2,
            coords = vec3(delivery.x, delivery.y, delivery.z),
            color = {
                r = 255,
                g = 144,
                b = 0,
                a = 200
            }
        })
    lib.zones.box({
        coords = vec3(delivery.x, delivery.y, delivery.z),
        size = vec3(10, 10, 3.5),
        rotation = 60,
        debug = Config.Debug,
        inside = function()
            if progress == 2 then
                deliveryMarker:draw()
                if IsPedInAnyVehicle(PlayerPedId()) then
                    lib.showTextUI('Tryk E for at aflever varerene')
                    if IsControlJustPressed(0, 38) then
                        DeliverPackage(deliveryBlip)
                    end
                end
            end
        end,
        onExit = function()
            lib.hideTextUI()
        end
    })
    end
end

function DeliverPackage(blip)
    RemoveBlip(blip)
    UpdateProgress(3)
    Config.Notify("success", "Varerne blevet afleveret. Tag tilbage og aflever traileren", 5000)
end

function PickupPackage(supply, blip)
    RemoveBlip(blip)
    for k, v in pairs(supplyLocations) do
        if v.supply == supply then
            table.remove(supplyLocations, k)
        end
    end

    if #supplyLocations == 0 then
        UpdateProgress(2)
        Config.Notify("success", "Kør til leveringsstedet og aflever varerne ved markeringen på mappet!", 5000)
        StartDelivery()
    else
        Config.Notify("success", "Varerne er blevet hentet. Der er dog stadig nogen varer, der skal hentes!", 5000)
    end
end

function UpdateProgress(newProgress)
    progress = newProgress
end

function ToggleUI(toggle)
    SetNuiFocus(toggle, toggle)
    SendNUIMessage({
        action = "setVisible",
        data = toggle
    })
    SendNUIMessage({
        action = "updateProgress",
        data = progress
    })
end

RegisterNuiCallback('afbryd_opgave', function()
    ToggleUI(false)
    UpdateProgress(0)
    for k, v in pairs(supplyLocations) do
        RemoveBlip(v.blip)
    end
    supplyLocations = {}
    Config.Notify("success", "Opgaven er blevet afbrudt!", 5000)
end)

RegisterCommand("trucking", function()
    ToggleUI(true)
end, false)

RegisterNUICallback("hide", function(_, cb)
    ToggleUI(false)
    cb("ok")
end)
