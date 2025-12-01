local ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent('t3k.vending:pay', function(Price)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local success = xPlayer.getAccount('money') >= Price
        if success then
            xPlayer.removeAccountMoney('money', Price)
        end
    end
end)