local QBCore = exports['qb-core']:GetCoreObject()

Citizen.CreateThread(function()
    while QBCore == nil do
        Citizen.Wait(0)
    end
    QBCore.PlayerData = QBCore.Functions.GetPlayerData()
end)

local currentmotel = nil
local pinkcagecoord = vector3(326.747, -208.35, 54.0866)
local pinkcage = {
    [1] = {door = vector3(307.57, -213.29, 54.22), h = 68.9096, doortext = vector3(307.318, -213.26, 54.2199), stash = vector3(306.71, -208.50, 54.22), obj = nil, clothe = vector3(302.58, -207.35, 54.22), locked = true},
    [2] = {door = vector3(311.36, -203.46, 54.22), h = 68.9096, doortext = vector3(311.108, -203.39, 54.2199), stash = vector3(310.51, -198.61, 54.22), obj = nil, clothe = vector3(306.32, -197.45, 54.22), locked = true},
    [3] = {door = vector3(315.79, -194.79, 54.22), h = 338.946, doortext = vector3(315.829, -194.65, 54.2267), stash = vector3(320.45, -194.13, 54.22), obj = nil, clothe = vector3(321.79, -189.81, 54.22), locked = true},
    [4] = {door = vector3(315.84, -219.66, 58.02), h = 158.946, doortext = vector3(314.827, -219.78, 58.0220), stash = vector3(310.17, -220.36, 58.02), obj = nil, clothe = vector3(308.85, -224.63, 58.02), locked = true},
    [5] = {door = vector3(307.35, -213.24, 58.02), h = 68.9096, doortext = vector3(307.322, -213.25, 58.0151), stash = vector3(306.78, -208.53, 58.02), obj = nil, clothe = vector3(302.52, -207.23, 58.02), locked = true},
    [6] = {door = vector3(311.22, -203.35, 58.02), h = 68.9096, doortext = vector3(311.107, -203.40, 58.0151), stash = vector3(310.64, -198.74, 58.02), obj = nil, clothe = vector3(306.33, -197.41, 58.02), locked = true},
    [7] = {door = vector3(315.78, -194.62, 58.02), h = 338.946, doortext = vector3(315.817, -194.64, 58.0151), stash = vector3(320.51, -194.11, 58.02), obj = nil, clothe = vector3(321.73, -189.70, 58.02), locked = true},
    [8] = {door = vector3(339.20, -219.47, 54.22), h = 248.909, doortext = vector3(339.316, -219.52, 54.2199), stash = vector3(339.93, -224.19, 54.22), obj = nil, clothe = vector3(344.24, -225.47, 54.22), locked = true},
    [9] = {door = vector3(342.93, -209.50, 54.22), h = 248.909, doortext = vector3(343.130, -209.61, 54.2199), stash = vector3(343.61, -214.35, 54.22), obj = nil, clothe = vector3(348.01, -215.56, 54.22), locked = true},
    [10]= {door = vector3(346.78, -199.66, 54.22), h = 248.909, doortext = vector3(346.927, -199.74, 54.2199), stash = vector3(347.34, -204.44, 54.22), obj = nil, clothe = vector3(351.86, -205.67, 54.22), locked = true},
    [11]= {door = vector3(335.00, -227.38, 58.02), h = 158.946, doortext = vector3(334.916, -227.47, 58.0150), stash = vector3(330.27, -228.04, 58.02), obj = nil, clothe = vector3(328.99, -232.40, 58.02), locked = true},
    [12]= {door = vector3(339.27, -219.49, 58.02), h = 248.909, doortext = vector3(339.301, -219.53, 58.0150), stash = vector3(339.85, -224.16, 58.02), obj = nil, clothe = vector3(344.21, -225.51, 58.02), locked = true},
    [13]= {door = vector3(343.08, -209.54, 58.02), h = 248.909, doortext = vector3(343.094, -209.64, 58.0150), stash = vector3(343.63, -214.27, 58.02), obj = nil, clothe = vector3(347.95, -215.52, 58.02), locked = true},
    [14]= {door = vector3(346.69, -199.66, 58.02), h = 248.909, doortext = vector3(346.924, -199.73, 58.0150), stash = vector3(347.49, -204.41, 58.02), obj = nil, clothe = vector3(351.77, -205.64, 58.02), locked = true},
}

local firstSpawn = true
AddEventHandler('playerSpawned', function()
    if firstSpawn then
        currentmotel = math.random(1, #pinkcage)
        QBCore.Functions.Notify('You have been given a new motel room! Your room number is: '..currentmotel)
        firstSpawn = false
    end
end)

RegisterCommand('newmotelroom', function()
    currentmotel = math.random(1, #pinkcage)
    QBCore.Functions.Notify('You have been given a new motel room! Your room number is: '..currentmotel)
end)

RegisterCommand('leavemotel', function()
    local player = PlayerPedId()
    local playercoords = GetEntityCoords(player)
    local moteldistance = #(playercoords - pinkcagecoord)

    if moteldistance <= 45.0 then
        SetEntityCoords(player, 311.491, -206.25, 58.0151, 0, 0, 0, 0)
        SetEntityHeading(player, 242.37)
        QBCore.Functions.Notify('You have left the room.')
    end
end)

Citizen.CreateThread(function()
    local gblip = AddBlipForCoord(pinkcagecoord)
    SetBlipSprite(gblip, 475)
    SetBlipDisplay(gblip, 4)
    SetBlipScale(gblip, 0.6)
    SetBlipColour(gblip, 27)
    SetBlipAsShortRange(gblip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Pink Cage Motel")
    EndTextCommandSetBlipName(gblip)
end)

-- Target system integration for doors, stash, and wardrobe using qb-target
Citizen.CreateThread(function()
    for k, v in pairs(pinkcage) do
        -- Target interaction for doors
        exports['qb-target']:AddBoxZone("MotelDoor_"..k, v.doortext, 1.5, 1.5, {
            name = "MotelDoor_"..k,
            heading = v.h,
            debugPoly = false,
            minZ = v.doortext.z - 1,
            maxZ = v.doortext.z + 1
        }, {
            options = {
                {
                    type = "client",
                    event = 'm3:motel:client:toggleDoor',
                    icon = "fas fa-door-open",
                    label = "Open/Close Door",
                    room = k,
                }
            },
            distance = 2.0
        })

        -- Target interaction for stash
        exports['qb-target']:AddBoxZone("MotelStash_"..k, v.stash, 1.5, 1.5, {
            name = "MotelStash_"..k,
            heading = v.h,
            debugPoly = false,
            minZ = v.stash.z - 1,
            maxZ = v.stash.z + 1
        }, {
            options = {
                {
                    type = "client",
                    event = 'm3:motel:client:openStash',
                    icon = "fas fa-box",
                    label = "Open Stash",
                    room = k,
                }
            },
            distance = 1.5
        })

        -- Target interaction for wardrobe
        exports['qb-target']:AddBoxZone("MotelWardrobe_"..k, v.clothe, 1.5, 1.5, {
            name = "MotelWardrobe_"..k,
            heading = v.h,
            debugPoly = false,
            minZ = v.clothe.z - 1,
            maxZ = v.clothe.z + 1
        }, {
            options = {
                {
                    type = "client",
                    event = 'm3:motel:client:openWardrobe',
                    icon = "fas fa-tshirt",
                    label = "Open Wardrobe",
                    room = k,
                }
            },
            distance = 1.5
        })
    end
end)

-- Toggle door lock event
RegisterNetEvent('m3:motel:client:toggleDoor')
AddEventHandler('m3:motel:client:toggleDoor', function(data)
    local room = data.room
    local locked = pinkcage[room].locked
    pinkcage[room].locked = not locked
    TriggerServerEvent('m3:motel:server:toggleDoorlock', room, not locked)
end)

-- Open motel wardrobe using qb-clothing
RegisterNetEvent('m3:motel:client:openWardrobe')
AddEventHandler('m3:motel:client:openWardrobe', function()
    TriggerEvent('qb-clothing:client:openOutfitMenu')
end)

-- Open motel stash
RegisterNetEvent('m3:motel:client:openStash')
AddEventHandler('m3:motel:client:openStash', function(data)
    local room = data.room
    TriggerEvent('inventory:client:SetCurrentStash', 'MotelRoom_'..room)
    TriggerServerEvent('inventory:server:OpenInventory', 'stash', 'MotelRoom_'..room, {
        maxweight = 1000000,
        slots = 50,
    })
end)

-- Function to notify players
function notify(type, text, time)
    if length == nil then length = 5000 end 
    QBCore.Functions.Notify(text, type)
end

-- Draw 3D text utility
function DrawText3D(coord, text)
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(coord.x, coord.y, coord.z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local scale = 0.3
    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 380
        DrawRect(_x, _y + 0.0120, 0.0 + factor, 0.025, 41, 11, 41, 100)
    end
end
