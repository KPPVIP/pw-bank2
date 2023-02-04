ESX = nil


Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(200)
    end
    PlayerData = ESX.GetPlayerData()
end)

Controlkey = {["generalUse"] = {38,"E"}} 
RegisterNetEvent('event:control:update')
AddEventHandler('event:control:update', function(table)
  Controlkey["generalUse"] = table["generalUse"]
end)

-- ATMS
local atms = {
  [1] = -1126237515,
  [2] = 506770882,
  [3] = -870868698,
  [4] = 150237004,
  [5] = -239124254,
  [6] = -1364697528,  
}


v_5_b_atm1=150237004 
v_5_b_atm2=-239124254 

prop_atm_03=-1364697528 

RegisterNetEvent('bank:checkATM')
AddEventHandler('bank:checkATM', function()
  if IsNearATM() then
    openGui()
  else
    TriggerEvent("notification","No ATM Near", 2)
  end
end)

function IsNearATM()
  for i = 1, #atms do
    local objFound = GetClosestObjectOfType( GetEntityCoords(PlayerPedId()), 0.75, atms[i], 0, 0, 0)

    if DoesEntityExist(objFound) then
      TaskTurnPedToFaceEntity(PlayerPedId(), objFound, 3.0)
      return true
    end
  end

  return false
end
-- Banks
local banks = {
  {name="Bank", id=108, x=150.266, y=-1040.203, z=29.374},
  {name="Bank", id=108, x=-1212.980, y=-330.841, z=37.787},
  {name="Bank", id=108, x=-2962.582, y=482.627, z=15.703},

  {name="Bank", id=108, x=314.187, y=-278.621, z=54.170},
  {name="Bank", id=108, x=-351.534, y=-49.529, z=49.042},
  {name="Bank", id=108, x=241.727, y=220.706, z=106.286},
  {name="Bank", id=108, x=1176.0833740234, y=2706.3386230469, z=37.157722473145},
  {name="Bank", id=108, x=-113.50, y=6469.70, z=31.62},
}

RegisterCommand('bankapw', function()
  openGui()
end)

function openGui()
  TriggerServerEvent('banking:get-infos')
  SendNUIMessage({type = "open"})
  SetNuiFocus(true, true)
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)

    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)
    local closestbank = 1000.0
    local scanid = 0

    if not (IsInVehicle()) and not bankOpen then
      for i = 1, #banks do
        local distance = #(vector3(banks[i].x, banks[i].y, banks[i].z) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
        if(distance < closestbank) then
          scanid = i
          closestbank = distance
        end
      end
    end



    if(closestbank < 5.5 and scanid ~= 0) then

      if lastTrigger == 0 then
        lastTrigger = scanid
        TriggerEvent("robbery:scanbank",scanid)
      end

      local cdst = closestbank
      while cdst < 1.5 do
        Citizen.Wait(1)

        local plyCoords = GetEntityCoords(ply, 0)
        cdst = #(vector3(banks[scanid].x, banks[scanid].y, banks[scanid].z) -  vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
        
             DrawText3D(banks[scanid].x, banks[scanid].y, banks[scanid].z,"To Use The Bank ["..Controlkey["generalUse"][2].."] Press Key.")
            atBank = true
            if IsControlJustPressed(1, Controlkey["generalUse"][1])  then -- IF INPUT_PICKUP Is pressed
                openGui()
            end
      end
      Citizen.Wait(math.ceil(closestbank*5))
    end
  end
end)

function IsInVehicle()
  local ply = PlayerPedId()
  if IsPedSittingInAnyVehicle(ply) then
    return true
  else
    return false
  end
end

-- Check if player is near a bank
function IsNearBank()
  local ply = PlayerPedId()
  local plyCoords = GetEntityCoords(ply, 0)
  for _, item in pairs(banks) do
    local distance = #(vector3(item.x, item.y, item.z) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
    if(distance <= 2) then
      return true
    end
  end
end

RegisterNetEvent('pw-bank:reloaddata', function()
  TriggerServerEvent('banking:get-infos')
end)

RegisterNUICallback('closeapp', function()
  SetNuiFocus(false, false)
end)

RegisterNetEvent('pw-bank:reloadcleintdata', function()
  TriggerServerEvent('banking:get-infos')
end)

RegisterNetEvent("banking:infos")
AddEventHandler("banking:infos",
    function(firstname, lastname, job, bank, cash, bankid, profilepicture)
    SendNUIMessage({
        type = "infos",
        firstname = firstname,
        lastname = lastname,
        job = job,
        bank = bank,
        cash = cash,
        bankid = bankid,
        profilepicture = profilepicture
    })
end)

RegisterNUICallback('yatir', function(miktar)
  local checkpara = miktar['para']
  TriggerServerEvent('pw-bank:server:parayatir', checkpara)
end)

RegisterNUICallback('cek', function(miktar)
  local checkpara = miktar['para']
  TriggerServerEvent('pw-bank:server:paracek', checkpara)
end)


RegisterNUICallback('transfer', function(data)
  local money = tonumber(data["para"])
  local iban = tonumber(data["iban"])
  TriggerServerEvent('pw-bank:server:TransferMoney', iban, money)
end)


RegisterNetEvent('pw-bank:banklog')
AddEventHandler('pw-bank:banklog', function(name, action, iban, para, renk, profilepicture) -- LOG İŞLEMLERİN
  SendNUIMessage({
    type = "log",
    name = name,
    action = action,
    iban = iban,
    para = para,
    renk = renk,
    profilepicture = profilepicture
  })  
end)

RegisterNetEvent('pw-bank:banklogtransfer')
AddEventHandler('pw-bank:banklogtransfer', function(name, foto, iban) -- LOG İŞLEMLERİN
  SendNUIMessage({
    type = "logtransfer",
    name = name,
    foto = foto,
    iban = iban
  })  
end)

RegisterNetEvent('pw-bank:ui:clear')
AddEventHandler('pw-bank:ui:clear', function()
  SendNUIMessage({
    type = "clearui"
  })
end)

RegisterNetEvent('pw-bank:addbill')
AddEventHandler('pw-bank:addbill', function(id, sender, money, label)
  SendNUIMessage({
    type = "addbill",
    billid = id,
    sender = sender,
    money = money,
    label = label
  })
end)

RegisterNUICallback('PayInvoice', function(data, cb)
  local sender = data.sender
  local amount = data.amount
  local invoiceId = data.invoiceId

  PayInvoice(cb,invoiceId)
end)



function PayInvoice(cb,invoiceId)
  cb(true)

  ESX.TriggerServerCallback('esx_billing:payBill', function()
  end, invoiceId)

  TriggerServerEvent('banking:get-infos')
end

function DrawText3D(x,y,z, text)
  local onScreen,_x,_y=World3dToScreen2d(x,y,z)
  local px,py,pz=table.unpack(GetGameplayCamCoords())
  
  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)

  SetTextEntry("STRING")
  SetTextCentre(1)
  AddTextComponentString(text)
  DrawText(_x,_y)
  local factor = (string.len(text)) / 370
  DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end


RegisterCommand("atm", function(src, args, raw)
  TriggerEvent('bank:checkATM')
end)
