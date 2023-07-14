local QBCore = exports['qb-core']:GetCoreObject()

function randomNumber(min, max)
    return math.random(min, max)
end

local rewards = {
    [GetHashKey('a_c_mtlion')] = {['meet'] = randomNumber(3, 5)},
    [GetHashKey('a_c_deer')]  = {['meet'] = randomNumber(1, 3)},
}

usedPeds = {}
takingPeds = {}

QBCore.Functions.CreateCallback('qb-hunting:server:CheckPed', function(source, cb, entity)
    local ped = NetworkGetEntityFromNetworkId(entity)
    print (usedPeds[ped] , takingPeds[ped], not usedPeds[ped] and not takingPeds[ped])
    cb(not usedPeds[ped] and not takingPeds[ped])
end)

RegisterNetEvent('qb-hunting:server:TakeSkin', function(entity, status)
    local src = source
    local ped = NetworkGetEntityFromNetworkId(entity)
    if DoesEntityExist(ped) and not usedPeds[entity] then
        if status == 'taked' then
            usedPeds[ped] = true
            takingPeds[ped] = false
            local Player = QBCore.Functions.GetPlayer(src)
            for k, v in pairs(rewards[GetEntityModel(ped)]) do
                Player.Functions.AddItem(k, v, false, {})
            end
        else if status == 'taking' then
            takingPeds[ped] = true
        end
        end
    else
        TriggerEvent('qb-log:server:CreateLog', 'united-hunting-cheat', 'Cheat Warning', 'red', "**"..GetPlayerName(src).."** be dalil ehtemal 99.9% ba injector talash bar abuse ba trigger haye qb-hunting kard! (qb-hunting:server:TakeSkin) @everyone")
    end
end)

