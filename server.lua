local QBCore = exports['qb-core']:GetCoreObject()

local pinkcage = {
    [1] = {locked = true},
    [2] = {locked = true},
    [3] = {locked = true},
    [4] = {locked = true},
    [5] = {locked = true},
    [6] = {locked = true},
    [7] = {locked = true},
    [8] = {locked = true},
    [9] = {locked = true},
    [10] = {locked = true},
    [11] = {locked = true},
    [12] = {locked = true},
    [13] = {locked = true},
    [14] = {locked = true},
}

-- Send lock states to the client when requested (e.g., when player joins)
RegisterNetEvent('m3:motel:server:getLockStates')
AddEventHandler('m3:motel:server:getLockStates', function()
    local src = source
    TriggerClientEvent('m3:motel:client:sendDoorlockState', src, pinkcage)
end)

-- Toggle door lock state and broadcast to all clients
RegisterNetEvent('m3:motel:server:toggleDoorlock')
AddEventHandler('m3:motel:server:toggleDoorlock', function(doorid, lockstate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player then
        pinkcage[doorid].locked = lockstate
        TriggerClientEvent('m3:motel:client:sendDoorlockState2', -1, doorid, lockstate)
    end
end)

-- Get player wardrobe data using qb-clothing
QBCore.Functions.CreateCallback('m3:motel:server:getPlayerDressing', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)

    exports.oxmysql:execute('SELECT * FROM player_clothing WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
        local outfits = {}
        for i = 1, #result, 1 do
            table.insert(outfits, {label = result[i].outfitname, skin = result[i].skin})
        end
        cb(outfits)
    end)
end)

-- Get a specific outfit
QBCore.Functions.CreateCallback('m3:motel:server:getPlayerOutfit', function(source, cb, num)
    local Player = QBCore.Functions.GetPlayer(source)

    exports.oxmysql:execute('SELECT * FROM player_clothing WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
        if result[num] then
            cb(result[num].skin)
        else
            cb(nil)
        end
    end)
end)

-- Remove a specific outfit from wardrobe
RegisterServerEvent('m3:motel:server:removeOutfit')
AddEventHandler('m3:motel:server:removeOutfit', function(num)
    local Player = QBCore.Functions.GetPlayer(source)

    exports.oxmysql:execute('DELETE FROM player_clothing WHERE citizenid = ? AND id = ?', {Player.PlayerData.citizenid, num}, function(affectedRows)
        if affectedRows > 0 then
            TriggerClientEvent('QBCore:Notify', source, 'Outfit removed!', 'success')
        else
            TriggerClientEvent('QBCore:Notify', source, 'Failed to remove outfit.', 'error')
        end
    end)
end)
