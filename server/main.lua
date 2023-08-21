Main = {}
picked = 0

QBCore.Functions.CreateCallback('bbv-atmaddmoney', function(source, cb, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if picked > 3 then return end -- anti exploit
    picked = picked + 1
    Player.Functions.AddMoney('cash', Config.Settings.Reward) 
end)

QBCore.Functions.CreateCallback('bbv-atm:cooldown', function(source, cb, args)
    if not cooldown then 
        cb(false)
    else
        cb(true)
    end
    Main:Cooldown()
end)

function Main:Cooldown()
    if cooldown then return end 
    cooldown = true
    Wait(Config.Settings.Cooldown * 60000)
    cooldown = false
    picked = 0
end