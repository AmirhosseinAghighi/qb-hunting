local QBCore = exports['qb-core']:GetCoreObject()

peds = {}
takingSking = false

CreateThread(function ()
    for ped, _ in pairs(Config.Peds) do
        peds[#peds + 1] = ped
    end
    print(json.encode(peds))
    exports['qb-target']:AddTargetModel(peds, {
        options = {
            {
                icon = "fas fa-knife-kitchen",
                label = "take skin",
                canInteract = function(entity)
                    return GetSelectedPedWeapon(PlayerPedId()) == `WEAPON_KNIFE` and IsPedDeadOrDying(entity)
                end,
                action = function(entity)
                    local netEntity = PedToNet(entity)
                    QBCore.Functions.TriggerCallback('qb-hunting:server:CheckPed', function(result)
                        if not result then
                            QBCore.Functions.Notify('Taked Before', 'error', 7500)
                            return
                        end
                        takingSking = true
                        TriggerServerEvent('qb-hunting:server:TakeSkin', netEntity, 'taking')
                        exports['progressbar']:Progress({
                            name = 'Take_Skin',
                            duration = 5000,
                            label = 'Taking animal skin',
                            useWhileDead = false,
                            canCancel = true,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            },
                            animation = {
                                animDict = 'anim@gangops@facility@servers@bodysearch@',
                                anim = 'player_search',
                                flags = 1,
                            },
                            prop = {},
                            propTwo = {},
                        }, function(cancelled)
                            takingSking = false
                            local ped = PlayerPedId()
                            SetCurrentPedWeapon(ped, GetHashKey("WEAPON_KNIFE"), true)
                            ClearPedTasks(ped)
                            
                            TriggerServerEvent('qb-hunting:server:TakeSkin', netEntity, 'taked')
                            
                            if cancelled then return end
                        end)
                    end, netEntity)
                end
            },
        },
        distance = 2.5,
    })
end)
