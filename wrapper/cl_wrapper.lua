
Wrapper = {
    blip = {},
    cam = {},
    zone = {},
    cars = {},
    object = {},
    ServerCallbacks = {}
}


function Wrapper:CreateObject(id,prop,coords,network,misson) -- Create object / prop
    Wrapper.object[id] = CreateObject(GetHashKey(prop), coords, network or false,misson or false)
    -- PlaceObjectOnGroundProperly(Wrapper.object[id])
    SetEntityHeading(Wrapper.object[id], coords.w)
    FreezeEntityPosition(Wrapper.object[id], true)
    SetEntityAsMissionEntity(Wrapper.object[id], true, true)
    if Config.Debug then 
        SetEntityDrawOutline(Wrapper.object[id],true)
    end
end


function Wrapper:DeleteObject(id)
    DeleteObject(Wrapper.object[id])
end

function Wrapper:LoadModel(model) -- Load Model
    local modelHash = model
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
      Wait(0)
      print(modelHash)
    end
end


function Wrapper:Target(id,label,pos,event,type) -- QBTarget target create
    if Config.Settings.Target == "QB" then 
        local sizex = 1
        local sizey = 1
        exports["qb-target"]:AddBoxZone(id, pos, sizex, sizey, {
            name = id,
            heading = "90.0",
            minZ = pos - 5,
            maxZ = pos + 5
        }, {
            options = {
                {
                    type = "client",
                    event = event,
                    icon = "fas fa-button",
                    label = label,
                }
            },
            distance = 1.5
        })
    end
    if Config.Settings.Target == "OX" then 
        Wrapper.zone[id] = exports["ox_target"]:addBoxZone({
        coords = vec3(pos.x,pos.y,pos.z),
        size = vec3(1, 1, 1),
        rotation = 45,
        debug = false,
        options = {
            {
                name = id,
                event = event,
                icon = "fa-solid fa-cube",
                label = label,
            },
        }
    })
    end
    if Config.Settings.Target == "BT" then 
        local _id = id
        exports["bt-target"]:AddBoxZone(_id, vector3(pos.x,pos.y,pos.z), 0.4, 0.6, {
            name=_id,
            heading=91,
            minZ = pos.z - 1,
            maxZ = pos.z + 1
            }, {
                options = {
                    {
                        type = "client",
                        event = event,
                        icon = "fa-solid fa-cube",
                        label = label,
                    },
                },
                distance = 1.5
            })
    end
end

function Wrapper:TargetRemove(sendid) -- Remove QBTarget target
    if Config.Settings.Target == "QB" then 
    exports["qb-target"]:RemoveZone(sendid)
    end 
    if Config.Settings.Target == "OX" then 
        exports["ox_target"]:removeZone(Wrapper.zone[sendid])
    end
    if Config.Settings.Target == "BT" then 
        exports["bt-taget"]:RemoveZone(sendid)
    end
end


function Wrapper:Notify(txt,tp,time) -- QBCore notify
    if Config.Settings.Framework == "QB" then 
    QBCore.Functions.Notify(txt, tp, time)
    end
    if Config.Settings.Framework == "ESX" then 
        ESX.ShowNotification(txt)
    end
    if Config.Settings.Framework == "ST" then 
        SetNotificationTextEntry('STRING')
        AddTextComponentString(txt)
        DrawNotification(0,1)    
    end
end

function Wrapper:RemoveItem(item,amount)
    if item == nil then 
        return 
    end
    TriggerServerEvent("Wrapper:atmrob:RemoveItem", item, amount)
end


function Wrapper:Log(txt) -- Log all of your abusive staff
    TriggerServerEvent("Wrapper:atmrob:Log",txt)
end


AddEventHandler("onResourceStop", function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    for k,v in pairs(Wrapper.cars) do 
        DeleteVehicle(v)
    end
    for k,v in pairs(Wrapper.object) do 
        DeleteObject(v)
    end
end)
