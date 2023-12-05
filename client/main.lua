Main = {}
registered = 0

local CurrentCops = 0

RegisterNetEvent('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

CreateThread(function()
    for k,v in pairs(Config.Settings.ATMs) do
        Main:Int(v)
    end
end)

function Main:Int(Model)
    exports['qb-target']:AddTargetModel(Model, {
        options = {
            {
                event = 'bbv-robatm:rob',
                type = 'client',
                icon = "fa-solid fa-money-bill",
                label = 'Rob',
            },
        },
        distance = 2.5
    })
end

RegisterNetEvent('bbv-robatm:rob',function()
    local hasitem = QBCore.Functions.HasItem(Config.Settings.BombItemName)
    if CurrentCops < Config.Settings.CopsNeeded then 
        Wrapper:Notify("Not enougth cops.")
        return
    end
    if not hasitem then
        Wrapper:Notify("You don't have a bomb")
        return
    end
    if Main:Cooldown() then
        Wrapper:Notify("Robbery is on cooldown")
        return 
    end
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(PlayerPedId())
    for k,v in pairs(Config.Settings.ATMs) do
        objectId = GetClosestObjectOfType(pedCoords, 2.0, GetHashKey(Config.Settings.ATMs[k]), false)
        if DoesEntityExist(objectId) then
            SetEntityDrawOutlineColor(255, 1, 1, 255)
            SetEntityDrawOutlineShader(0)
            TriggerEvent('bbv-atmrob:alarm')
            QBCore.Functions.Progressbar("rob_atm", "Planting the Explosive", 30000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = true,
                disableCombat = true,
             }, {
                animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                anim = "machinic_loop_mechandplayer",
                flags = 49,
             }, {}, {}, function()
                Main:Plant(objectId)
                StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
             end, function() -- Cancel
                StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
             end)
        end
    end
end)

function Main:Plant(ent)
   Wrapper:RemoveItem(Config.Settings.BombItemName, 1)
   Wrapper:Log('ATM ROBBERY')
   local entpos = GetEntityCoords(ent)
   local entf = GetEntityForwardVector(ent)
   local pos = vector4(entpos.x ,entpos.y ,entpos.z + 1, 90.0)
   local prop = 'prop_bomb_01'
   RequestModel(prop)
   while not HasModelLoaded(prop) do
     Wait(0)
   end
   Wrapper:CreateObject('thebomb',prop,pos,true,false)
   Wrapper:Notify("The bomb will detonate in 10 seconds")
   Wait(10000)
   Wrapper:DeleteObject('thebomb')
   AddExplosion(pos.x,pos.y,pos.z,2,15.0,true,false,false)
   local droppos = vector3(entpos.x - (entf.x - 0.1),entpos.y - (entf.y - 0.1) ,entpos.z)
   self:MoneyDrop(droppos)
end

function Main:MoneyDrop(pos)
    local pos1 = vector3(pos.x - 0.1,pos.y + 0.1,pos.z)
    local pos2 = vector3(pos.x - 0.0,pos.y + 0.0,pos.z)
    local pos3  = vector3(pos.x - 0.4,pos.y - 0.3,pos.z)
    local prop = 'prop_anim_cash_pile_01'
    RequestModel(prop)
    while not HasModelLoaded(prop) do
      Wait(0)
    end
    SetEntityDrawOutlineColor(1, 255, 1, 255)
    SetEntityDrawOutlineShader(0)
    Wrapper:CreateObject('id' .. 1,prop,pos1,true,false)
    Wrapper:CreateObject('id' .. 2,prop,pos2,true,false)
    Wrapper:CreateObject('id' .. 3,prop,pos3,true,false)
    Wrapper:Target('id' .. 1,'Pick Up',pos1,'bbv-atmrob:moneypickup:'..'id' .. 1)
    Wrapper:Target('id' .. 2,'Pick Up',pos2,'bbv-atmrob:moneypickup:'..'id' .. 2)
    Wrapper:Target('id' .. 3,'Pick Up',pos3,'bbv-atmrob:moneypickup:'..'id' .. 3)
    if registered < 3 then
        for i=1, 3 do
            RegisterNetEvent('bbv-atmrob:moneypickup:'..'id'..i, function()
                registered = registered + 1
                Wrapper:TargetRemove('id'..i)
                Wrapper:DeleteObject('id'..i)
                Wait(100)
                QBCore.Functions.TriggerCallback('bbv-atmaddmoney', function(data)
                    return
                end)
            end)
        end
    end
end

function Main:Cooldown()
    QBCore.Functions.TriggerCallback('bbv-atm:cooldown', function(data)
        _result = data
        return
    end)
    Wait(500)
    return _result
end

RegisterNetEvent('bbv-atmrob:alarm',function()
    -- put your police dispatch export here
    for i=1, 30 do
        PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1)
        Wait(1000)
    end
end)