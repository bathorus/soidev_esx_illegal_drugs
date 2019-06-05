ESX                             = nil
local CopsConnected             = 0
-- Weed
local PlayersHarvestingWeed     = {}
local PlayersTransformingWeed   = {}
local PlayersSellingWeed        = {}
-- Opium
local PlayersHarvestingOpium    = {}
local PlayersTransformingOpium  = {}
local PlayersSellingOpium       = {}
-- Coke
local PlayersHarvestingCoke     = {}
local PlayersTransformingCoke   = {}
local PlayersSellingCoke        = {}
-- Meth
local PlayersHarvestingMeth     = {}
local PlayersTransformingMeth   = {}
local PlayersSellingMeth        = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Count Cops
function CountCops()
  local xPlayers = ESX.GetPlayers()
  CopsConnected = 0
  for i = 1, #xPlayers, 1 do
    local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
    if xPlayer.job.name == 'police' then
      CopsConnected = CopsConnected + 1
    end
  end
  SetTimeout(120 * 1000, CountCops)
end

-- Call Count Cops
CountCops()

-------------------------------------------------------
-----------------------WEED----------------------------
-------------------------------------------------------

-- Harvest Weed
local function HarvestWeed(source)
  if CopsConnected < Config.RequiredCopsWeed then
    TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsWeed))
    return
  end

  SetTimeout(Config.TimeToFarmWeed, function()
    if PlayersHarvestingWeed[source] == true then
      local _source = source
      local xPlayer = ESX.GetPlayerFromId(_source)
      local weed = xPlayer.getInventoryItem('weed')

      if weed.limit ~= -1 and weed.count >= weed.limit then
        TriggerClientEvent('esx:showNotification', source, _U('inv_full_weed'))
      else
        xPlayer.addInventoryItem('weed', 1)
        HarvestWeed(source)
      end
    end
  end)
end

-- Start Harvest Weed
RegisterServerEvent('esx_illegal_drugs:startHarvestWeed')
AddEventHandler('esx_illegal_drugs:startHarvestWeed', function()
  local _source = source
  PlayersHarvestingWeed[_source] = true
  TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))
  HarvestWeed(_source)
end)

-- Stop Harvest Weed
RegisterServerEvent('esx_illegal_drugs:stopHarvestWeed')
AddEventHandler('esx_illegal_drugs:stopHarvestWeed', function()
  local _source = source
  PlayersHarvestingWeed[_source] = false
end)

-- Transform Weed
local function TransformWeed(source)
  if CopsConnected < Config.RequiredCopsWeed then
    TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsWeed))
    return
  end

  SetTimeout(Config.TimeToProcessWeed, function()
    if PlayersTransformingWeed[source] == true then
      local _source = source
      local xPlayer = ESX.GetPlayerFromId(_source)
      local weedQuantity = xPlayer.getInventoryItem('weed').count
      local poochQuantity = xPlayer.getInventoryItem('weed_pooch').count

      if poochQuantity > 15 then
        TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
      elseif weedQuantity < 28 then
        TriggerClientEvent('esx:showNotification', source, _U('not_enough_weed'))
      else
        xPlayer.removeInventoryItem('weed', 28)
        xPlayer.addInventoryItem('weed_pooch', 1)
        TransformWeed(source)
      end
    end
  end)
end

-- Start Transform Weed
RegisterServerEvent('esx_illegal_drugs:startTransformWeed')
AddEventHandler('esx_illegal_drugs:startTransformWeed', function()
  local _source = source
  PlayersTransformingWeed[_source] = true
  TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))
  TransformWeed(_source)
end)

-- Stop Transform Weed
RegisterServerEvent('esx_illegal_drugs:stopTransformWeed')
AddEventHandler('esx_illegal_drugs:stopTransformWeed', function()
  local _source = source
  PlayersTransformingWeed[_source] = false
end)

-- Sell Weed
local function SellWeed(source)
  if CopsConnected < Config.RequiredCopsWeed then
    TriggerClientEvent('esx:showNotifiation', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsWeed))
    return
  end

  SetTimeout(Config.TimeToSellWeed, function()
    if PlayersSellingWeed[source] == true then
      local _source = source
      local xPlayer = ESX.GetPlayerFromId(_source)
      local poochQuantity = xPlayer.getInventoryItem('weed_pooch').count

      if poochQuantity == 0 then
        TriggerClientEvent('esx:showNotification', source, _U('no_pouches_weed_sale'))
      else
        xPlayer.removeInventoryItem('weed_pooch', 1)

        local totalPrice = 0
        local initialWeed = Config.WeedPriceBase
        if CopsConnected < 8 then
          totalPrice = initialWeed + ((CopsConnected + 1) * 25)
        else
          totalPrice = initialWeed + ((CopsConnected - 2) * 100)
        end
        xPlayer.addAccountMoney('black_money', totalPrice)
        TriggerClientEvent('esx:showNotification', source, _U('sold_one_weed'))
        SellWeed(source)
      end
    end
  end)
end

-- Start Sell Weed
RegisterServerEvent('esx_illegal_drugs:startSellWeed')
AddEventHandler('esx_illegal_drugs:startSellWeed', function()
  local _source = source
  PlayersSellingWeed[_source] = true
  TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))
  SellWeed(_source)
end)

-- Stop Sell Weed
RegisterServerEvent('esx_illegal_drugs:stopSellWeed')
AddEventHandler('esx_illegal_drugs:stopSellWeed', function()
  local _source = source
  PlayersSellingWeed[_source] = false
end)

-------------------------------------------------------
-----------------------OPIUM---------------------------
-------------------------------------------------------

-- Harvest Opium
local function HarvestOpium(source)
  if CopsConnected < Config.RequiredCopsOpium then
    TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsOpium))
    return
  end

  SetTimeout(Config.TimeToFarmOpium, function()
    if PlayersHarvestingOpium[source] == true then
      local _source = source
      local xPlayer = ESX.GetPlayerFromId(_source)
      local opium = xPlayer.getInventoryItem('opium')

      if opium.limit ~= -1 and opium.count >= opium.limit then
        TriggerClientEvent('esx:showNotification', source, _U('inv_full_opium'))
      else
        xPlayer.addInventoryItem('opium', 1)
        HarvestOpium(source)
      end
    end
  end)
end

-- Start Harvest Opium
RegisterServerEvent('esx_illegal_drugs:startHarvestOpium')
AddEventHandler('esx_illegal_drugs:startHarvestOpium', function()
  local _source = source
  PlayersHarvestingOpium[_source] = true
  TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))
  HarvestOpium(_source)
end)

-- Stop Harvest Opium
RegisterServerEvent('esx_illegal_drugs:stopHarvestOpium')
AddEventHandler('esx_illegal_drugs:stopHarvestOpium', function()
  local _source = source
  PlayersHarvestingOpium[_source] = false
end)

-- Transform Opium
local function TransformOpium(source)
  if CopsConnected < Config.RequiredCopsOpium then
    TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsOpium))
    return
  end

  SetTimeout(Config.TimeToProcessOpium, function()
    if PlayersTransformingOpium[source] == true then
      local _source = source
      local xPlayer = ESX.GetPlayerFromId(_source)
      local opiumQuantity = xPlayer.getInventoryItem('opium').count
      local poochQuantity = xPlayer.getInventoryItem('opium_pooch').count

      if poochQuantity > 15 then
        TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
      elseif opiumQuantity < 28 then
        TriggerClientEvent('esx:showNotification', source, _U('not_enough_opium'))
      else
        xPlayer.removeInventoryItem('opium', 28)
        xPlayer.addInventoryItem('opium_pooch', 1)
        TransformOpium(source)
      end
    end
  end)
end

-- Start Transform Opium
RegisterServerEvent('esx_illegal_drugs:startTransformOpium')
AddEventHandler('esx_illegal_drugs:startTransformOpium', function()
  local _source = source
  PlayersTransformingOpium[_source] = true
  TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))
  TransformOpium(_source)
end)

-- Stop Transform Opium
RegisterServerEvent('esx_illegal_drugs:stopTransformOpium')
AddEventHandler('esx_illegal_drugs:stopTransformOpium', function()
  local _source = source
  PlayersTransformingOpium[_source] = false
end)

-- Sell Opium
local function SellOpium(source)
  if CopsConnected < Config.RequiredCopsOpium then
    TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsOpium))
    return
  end

  SetTimeout(Config.TimeToSellOpium, function()
    if PlayersSellingOpium[source] == true then
      local _source = source
      local xPlayer = ESX.GetPlayerFromId(_source)
      local poochQuantity = xPlayer.getInventoryItem('opium_pooch').count

      if poochQuantity == 0 then
        TriggerClientEvent('esx:showNotification', source, _U('no_pouches_opium_sale'))
      else
        xPlayer.removeInventoryItem('opium_pooch', 1)

        local totalPrice = 0
        local initialOpium = Config.OpiumPriceBase
        if CopsConnected < 8 then
          totalPrice = initialOpium + ((CopsConnected + 1) * 25)
        else
          totalPrice = initialOpium + ((CopsConnected - 2) * 100)
        end

        xPlayer.addAccountMoney('black_money', totalPrice)
        TriggerClientEvent('esx:showNotification', source, _U('sold_one_opium'))
        SellOpium(source)
      end
    end
  end)
end

-- Start Sell Opium
RegisterServerEvent('esx_illegal_drugs:startSellOpium')
AddEventHandler('esx_illegal_drugs:startSellOpium', function()
  local _source = source
  PlayersSellingOpium[_source] = true
  TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))
  SellOpium(_source)
end)

-- Stop Sell Opium
RegisterServerEvent('esx_illegal_drugs:stopSellOpium')
AddEventHandler('esx_illegal_drugs:stopSellOpium', function()
  local _source = source
  PlayersSellingOpium[_source] = false
end)

-------------------------------------------------------
-----------------------COKE----------------------------
-------------------------------------------------------

-- Harvest Coke
local function HarvestCoke(source)
  if CopsConnected < Config.RequiredCopsCoke then
    TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsCoke))
    return
  end

  SetTimeout(Config.TimeToFarmCoke, function()
    if PlayersHarvestingCoke[source] == true then
      local xPlayer = ESX.GetPlayerFromId(source)
      local coke = xPlayer.getInventoryItem('coke')

      if coke.limit ~= -1 and coke.count >= coke.limit then
        TriggerClientEvent('esx:showNotification', source, _U('inv_full_code'))
      else
        xPlayer.addInventoryItem('coke', 1)
        HarvestCoke(source)
      end
    end
  end)
end

-- Start Harvest Coke
RegisterServerEvent('esx_illegal_drugs:startHarvestCoke')
AddEventHandler('esx_illegal_drugs:startHarvestCoke', function()
  local _source = source
  PlayersHarvestingCoke[_source] = true
  TriggerClientEvent('esx:showNotification', source, _U('pickup_in_prog'))
  HarvestCoke(_source)
end)

-- Stop Harvest Coke
RegisterServerEvent('esx_illegal_drugs:stopHarvestCoke')
AddEventHandler('esx_illegal_drugs:stopHarvestCoke', function()
  local _source = source
  PlayersHarvestingCoke[_source] = false
end)

-- Transform Coke
local function TransformCoke(source)
  if CopsConnected < Config.RequiredCopsCoke then
    TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsCoke))
    return
  end

  SetTimeout(Config.TimeToProcessCoke, function()
    if PlayersTransformingCoke[source] == true then
      local _source = source
      local xPlayer = ESX.GetPlayerFromId(_source)
      local cokeQuantity = xPlayer.getInventoryItem('coke').count
      local poochQuantity = xPlayer.getInventoryItem('coke_pooch').count

      if poochQuantity > 15 then
        TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
      elseif cokeQuantity < 28 then
        TriggerClientEvent('esx:showNotification', source, _U('not_enough_coke'))
      else
        xPlayer.removeInventoryItem('coke', 28)
        xPlayer.addInventoryItem('coke_pooch', 1)
        TransformCoke(source)
      end
    end
  end)
end

-- Start Transform Coke
RegisterServerEvent('esx_illegal_drugs:startTransformCoke')
AddEventHandler('esx_illegal_drugs:startTransformCoke', function()
  local _source = source
  PlayersTransformingCoke[_source] = true
  TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))
  TransformCoke(_source)
end)

-- Stop Transfrom Coke
RegisterServerEvent('esx_illegal_drugs:stopTransformCoke')
AddEventHandler('esx_illegal_drugs:stopTransformCoke', function()
  local _source = source
  PlayersTransformingCoke[_source] = false
end)

-- Sell Coke
local function SellCoke(source)
  if CopsConnected < Config.RequiredCopsCoke then
    TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsCoke))
    return
  end

  SetTimeout(Config.TimeToSellCoke, function()
    if PlayersSellingCoke[source] == true then
      local _source = source
      local xPlayer = ESX.GetPlayerFromId(_source)
      local poochQuantity = xPlayer.getInventoryItem('coke_pooch').count

      if poochQuantity == 0 then
        TriggerClientEvent('esx:showNotification', source, _U('no_pouches_coke_sale'))
      else
        xPlayer.removeInventoryItem('coke_pooch', 1)

        local totalPrice = 0
        local initialCoke = Config.CokePriceBase
        if CopsConnected < 8 then
          totalPrice = initialCoke + ((CopsConnected + 1) * 25)
        else
          totalPrice = initialCoke + ((CopsConnected - 2) * 100)
        end

        xPlayer.addAccountMoney('black_money', totalPrice)
        TriggerClientEvent('esx:showNotification', source, _U('sold_one_coke'))
        SellCoke(source)
      end
    end
  end)
end

-- Start Sell Coke
RegisterServerEvent('esx_illegal_drugs:startSellCoke')
AddEventHandler('esx_illegal_drugs:startSellCoke', function()
  local _source = source
  PlayersSellingCoke[_source] = true
  TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))
  SellCoke(_source)
end)

-- Stop Sell Coke
RegisterServerEvent('esx_illegal_drugs:stopSellCoke')
AddEventHandler('esx_illegal_drugs:stopSellCoke', function()
  local _source = source
  PlayersSellingCoke[_source] = false
end)

-------------------------------------------------------
----------------------METH-----------------------------
-------------------------------------------------------

-- Harvest Meth
local function HarvestMeth(source)
  if CopsConnected < Config.RequiredCopsMeth then
    TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsMeth))
    return
  end

  SetTimeout(Config.TimeToFarmMeth, function()
    if PlayersHarvestingMeth[source] == true then
      local _source = source
      local xPlayer = ESX.GetPlayerFromId(_source)
      local meth = xPlayer.getInventoryItem('meth')

      if meth.limit ~= -1 and meth.count >= meth.limit then
        TriggerClientEvent('esx:showNotification', source, _U('inv_full_meth'))
      else
        xPlayer.addInventoryItem('meth', 1)
        HarvestMeth(source)
      end
    end
  end)
end

-- Start Harvest Meth
RegisterServerEvent('esx_illegal_drugs:startHarvestMeth')
AddEventHandler('esx_illegal_drugs:startHarvestMeth', function()
  local _source = source
  PlayersHarvestingMeth[_source] = true
  TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))
  HarvestMeth(_source)
end)

-- Stop Harvest Meth
RegisterServerEvent('esx_illegal_drugs:stopHarvestMeth')
AddEventHandler('esx_illegal_drugs:stopHarvestMeth', function()
  local _source = source
  PlayersHarvestingMeth[_source] = false
end)

-- Transform Meth
local function TransformMeth(source)
  if CopsConnected < Config.RequiredCopsMeth then
    TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsMeth))
    return
  end

  SetTimeout(Config.TimeToProcessMeth, function()
    if PlayersTransformingMeth[source] == true then
      local _source = source
      local xPlayer = ESX.GetPlayerFromId(_source)
      local methQuantity = xPlayer.getInventoryItem('meth').count
      local poochQuantity = xPlayer.getInventoryItem('meth_pooch').count

      if poochQuantity > 28 then
        TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
      elseif methQuantity < 15 then
        TriggerClientEvent('esx:showNotification', source, _U('not_enough_meth'))
      else
        xPlayer.removeInventoryItem('meth', 28)
        xPlayer.addInventoryItem('meth_pooch', 1)
        TransformMeth(source)
      end
    end
  end)
end

-- Start Transform Meth
RegisterServerEvent('esx_illegal_drugs:startTransformMeth')
AddEventHandler('esx_illegal_drugs:startTransformMeth', function()
  local _source = source
  PlayersTransformingMeth[_source] = true
  TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))
  TransformMeth(_source)
end)

-- Stop Harvest Meth
RegisterServerEvent('esx_illegal_drugs:stopTransformMeth')
AddEventHandler('esx_illegal_drugs:stopTransformMeth', function()
  local _source = source
  PlayersTransformingMeth[_source] = false
end)

-- Sell Meth
local function SellMeth(source)
  if CopsConnected < Config.RequiredCopsMeth then
    TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsMeth))
    return
  end

  SetTimeout(Config.TimeToSellMeth, function()
    if PlayersSellingMeth[source] == true then
      local _source = source
      local xPlayer = ESX.GetPlayerFromId(_source)
      local poochQuantity = xPlayer.getInventoryItem('meth_pooch').count

      if poochQuantity == 0 then
        TriggerClientEvent('esx:showNotification', _source, _U('no_pouches_meth_sale'))
      else
        xPlayer.removeInventoryItem('meth_pooch', 1)

        local totalPrice = 0
        local initialMeth = Config.MethPriceBase
        if CopsConnected < 8 then
          totalPrice = initialMeth + ((CopsConnected + 1) * 25)
        else
          totalPrice = initialMeth + ((CopsConnected - 2) * 100)
        end
        xPlayer.addAccountMoney('black_money', totalPrice)
        TriggerClientEvent('esx:showNotification', source, _U('sold_one_meth'))
        SellMeth(source)
      end
    end
  end)
end

-- Start Sell Meth
RegisterServerEvent('esx_illegal_drugs:startSellMeth')
AddEventHandler('esx_illegal_drugs:startSellMeth', function()
  local _source = source
  PlayersSellingMeth[_source] = true
  TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))
  SellMeth(_source)
end)

-- Stop Sell Meth
RegisterServerEvent('esx_illegal_drugs:stopSellMeth')
AddEventHandler('esx_illegal_drugs:stopSellMeth', function()
  local _source = source
  PlayersSellingMeth[_source] = false
end)

-- User Inventory
RegisterServerEvent('esx_illegal_drugs:GetUserInventory')
AddEventHandler('esx_illegal_drugs:GetUserInventory', function(currentZone)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  TriggerClientEvent('esx_illegal_drugs:ReturnInventory',
    _source,
    xPlayer.getInventoryItem('coke').count,
    xPlayer.getInventoryItem('coke_pooch').count,
    xPlayer.getInventoryItem('meth').count,
    xPlayer.getInventoryItem('meth_pooch').count,
    xPlayer.getInventoryItem('weed').count,
    xPlayer.getInventoryItem('weed_pooch').count,
    xPlayer.getInventoryItem('opium').count,
    xPlayer.getInventoryItem('opium_pooch').count,
    xPlayer.job.name,
    currentZone
  )
end)

-- Usable Weed
ESX.RegisterUsableItem('weed', function(source)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.removeInventoryItem('weed', 1)
  TriggerClientEvent('esx_illegal_drugs:onPot', _source)
  TriggerClientEvent('esx:showNotification', _source, _U('used_one_weed'))
end)

-- Usable Opium
ESX.RegisterUsableItem('opium', function(source)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.removeInventoryItem('opium', 1)
  TriggerClientEvent('esx_illegal_drugs:onOpium', _source)
  TriggerClientEvent('esx:showNotification', _source, _U('used_one_opium'))
end)

-- Usable Coke
ESX.RegisterUsableItem('coke', function(source)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.removeInventoryItem('coke', 1)
  TriggerClientEvent('esx_illegal_drugs:onCoke', _source)
  TriggerClientEvent('esx:showNotification', _source, _U('used_one_coke'))
end)

-- Usable Meth
ESX.RegisterUsableItem('meth', function(source)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.removeInventoryItem('meth', 1)
  TriggerClientEvent('esx_illegal_drugs:onMeth', _source)
  TriggerClientEvent('esx:showNotification', _source, _U('used_one_meth'))
end)
