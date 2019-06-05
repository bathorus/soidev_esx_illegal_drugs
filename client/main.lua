local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX                           = nil
local weedQTE                 = 0
local weed_poochQTE           = 0
local opiumQTE                = 0
local opium_poochQTE          = 0
local cokeQTE                 = 0
local coke_poochQTE           = 0
local methQTE                 = 0
local meth_poochQTE           = 0
local myJob                   = nil
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local isInZone                = false
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local isAction                = false

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

-- Enter Marker
AddEventHandler('esx_illegal_drugs:hasEnteredMarker', function(zone)
  if myJob == 'police' or myJob == 'ambulance' then
    return
  end

  ESX.UI.Menu.CloseAll()

  -- Exit Marker
  if zone == 'exitMarker' then
    CurrentAction = zone
    CurrentActionMsg = _U('exit_marker')
    CurrentActionData = {}
  end

  -- Weed
  if zone == 'WeedField' then
    CurrentAction = zone
    CurrentActionMsg = _U('press_collect_weed')
    CurrentActionData = {}
  end

  if zone == 'WeedProcessing' then
    if weedQTE >=5 then
      CurrentAction = zone
      CurrentActionMsg = _U('press_process_weed')
      CurrentActionData = {}
    end
  end

  if zone == 'WeedDealer' then
    if weed_poochQTE >= 1 then
      CurrentAction = zone
      CurrentActionMsg = _U('press_sell_weed')
      CurrentActionData = {}
    end
  end

  -- Opium
  if zone == 'OpiumField' then
    CurrentAction = zone
    CurrentActionMsg = _U('press_collect_opium')
    CurrentActionData = {}
  end

  if zone == 'OpiumProcessing' then
    if opiumQTE >= 5 then
      CurrentAction = zone
      CurrentActionMsg = _U('press_process_opium')
      CurrentActionData = {}
    end
  end

  if zone == 'OpiumDealer' then
    if opium_poochQTE >= 1 then
      CurrentAction = zone
      CurrentActionMsg = _U('press_sell_opium')
      CurrentActionData = {}
    end
  end

  -- Coke
  if zone == 'CokeField' then
    CurrentAction = zone
    CurrentActionMsg = _U('press_collect_coke')
    CurrentActionData = {}
  end

  if zone == 'CokeProcessing' then
    if cokeQTE >= 5 then
      CurrentAction = zone
      CurrentActionMsg = _U('press_process_coke')
      CurrentActionData = {}
    end
  end

  if zone == 'CokeDealer' then
    if coke_poochQTE >= 1 then
      CurrentAction = zone
      CurrentActionMsg = _U('press_sell_coke')
      CurrentActionData = {}
    end
  end

  -- Meth
  if zone == 'MethField' then
    CurrentAction = zone
    CurrentActionMsg = _U('press_collect_meth')
    CurrentActionData = {}
  end

  if zone == 'MethProcessing' then
    if methQTE >= 5 then
      CurrentAction = zone
      CurrentActionMsg = _U('press_process_meth')
      CurrentActionData = {}
    end
  end

  if zone == 'MethDealer' then
    if meth_poochQTE >= 1 then
      CurrentAction = zone
      CurrentActionMsg = _U('press_sell_meth')
      CurrentActionData = {}
    end
  end
end)

-- Exit Marker
AddEventHandler('esx_illegal_drugs:hasExitedMarker', function(zone)
  CurrentAction = nil
  ESX.UI.Menu.CloseAll()

  -- Weed
  TriggerServerEvent('esx_illegal_drugs:stopHarvestWeed')
  TriggerServerEvent('esx_illegal_drugs:stopTransformWeed')
  TriggerServerEvent('esx_illegal_drugs:stopSellWeed')
  -- Opium
  TriggerServerEvent('esx_illegal_drugs:stopHarvestOpium')
  TriggerServerEvent('esx_illegal_drugs:stopTransformOpium')
  TriggerServerEvent('esx_illegal_drugs:stopSellOpium')
  -- Coke
  TriggerServerEvent('esx_illegal_drugs:stopHarvestCoke')
  TriggerServerEvent('esx_illegal_drugs:stopTransformCoke')
  TriggerServerEvent('esx_illegal_drugs:stopSellCoke')
  -- Meth
  TriggerServerEvent('esx_illegal_drugs:stopHarvestMeth')
  TriggerServerEvent('esx_illegal_drugs:stopTransformMeth')
  TriggerServerEvent('esx_illegal_drugs:stopSellMeth')
end)

-- Activate Menu
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)

    local coords = GetEntityCoords(GetPlayerPed(-1))
    local isInMarker = false
    local currentZone = nil

    if not isAction then
      isAction = true
      for k, v in pairs(Config.Zones) do
        if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.ZoneSize.x / 2) then
          isInMarker = true
          currentZone = k
        end
      end

      if isInMarker and not HasAlreadyEnteredMarker then
        HasAlreadyEnteredMarker = true
        LastZone = currentZone
        TriggerServerEvent('esx_illegal_drugs:GetUserInventory', currentZone)
      end

      if not isInMarker and HasAlreadyEnteredMarker then
        HasAlreadyEnteredMarker = false
        TriggerEvent('esx_illegal_drugs:hasExitedMarker', LastZone)
      end

      if isInMarker and isInZone then
        TriggerEvent('esx_illegal_drugs:hasEnteredMarker', 'exitMarker')
      end
      isAction = false
    end
  end
end)

-- Stop Menu
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    local ped = GetPlayerPed(-1)
    if (IsControlJustPressed(0, 177) or IsControlPressed(0, 154)) then
      -- Weed
      TriggerServerEvent('esx_illegal_drugs:stopHarvestWeed')
      TriggerServerEvent('esx_illegal_drugs:stopTransformWeed')
      TriggerServerEvent('esx_illegal_drugs:stopSellWeed')
      -- Opium
      TriggerServerEvent('esx_illegal_drugs:stopHarvestOpium')
      TriggerServerEvent('esx_illegal_drugs:stopTransformOpium')
      TriggerServerEvent('esx_illegal_drugs:stopSellOpium')
      -- Coke
      TriggerServerEvent('esx_illegal_drugs:stopHarvestCoke')
      TriggerServerEvent('esx_illegal_drugs:stopTransformCoke')
      TriggerServerEvent('esx_illegal_drugs:stopSellCoke')
      -- Meth
      TriggerServerEvent('esx_illegal_drugs:stopHarvestMeth')
      TriggerServerEvent('esx_illegal_drugs:stopTransformMeth')
      TriggerServerEvent('esx_illegal_drugs:stopSellMeth')

      isAction = false
    end
  end
end)

-- Key Controls
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    local playerPed = PlayerPedId(-1)
    Citizen.Wait(10)
    if CurrentAction ~= nil then
      SetTextComponentFormat('STRING')
      AddTextComponentString(CurrentActionMsg)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)

      local controlPressed = false
      if IsControlJustReleased(0, 26) then
        if not controlPressed then
          controlPressed = true
          if CurrentAction == 'exitMarker' then
            TriggerEvent('esx_illegal_drugs:hasExitedMarker', LastZone)
            Citizen.Wait(1000)
            controlPressed = false
            break
          elseif CurrentAction == 'WeedField' then
            TriggerServerEvent('esx_illegal_drugs:startHarvestWeed')
            TriggerEvent('esx_illegal_drugs:HarvestAnimation')
          elseif CurrentAction == 'WeedProcessing' then
            TriggerServerEvent('esx_illegal_drugs:startTransformWeed')
            TriggerEvent('esx_illegal_drugs:TransformAnimation')
          elseif CurrentAction == 'WeedDealer' then
            TriggerServerEvent('esx_illegal_drugs:startSellWeed')
          elseif CurrentAction == 'OpiumField' then
            TriggerServerEvent('esx_illegal_drugs:startHarvestOpium')
            TriggerEvent('esx_illegal_drugs:HarvestAnimation')
          elseif CurrentAction == 'OpiumProcessing' then
            TriggerServerEvent('esx_illegal_drugs:startTransformOpium')
            TriggerEvent('esx_illegal_drugs:TransformAnimation')
          elseif CurrentAction == 'OpiumDealer' then
            TriggerServerEvent('esx_illegal_drugs:startSellOpium')
          elseif CurrentAction == 'CokeField' then
            TriggerServerEvent('esx_illegal_drugs:startHarvestCoke')
            TriggerEvent('esx_illegal_drugs:HarvestAnimation')
          elseif CurrentAction == 'CokeProcessing' then
            TriggerServerEvent('esx_illegal_drugs:startTransformCoke')
            TriggerEvent('esx_illegal_drugs:TransformAnimation')
          elseif CurrentAction == 'CokeDealer' then
            TriggerServerEvent('esx_illegal_drugs:startSellCoke')
          elseif CurrentAction == 'MethField' then
            TriggerServerEvent('esx_illegal_drugs:startHarvestMeth')
            TriggerEvent('esx_illegal_drugs:HarvestAnimation')
          elseif CurrentAction == 'MethProcessing' then
            TriggerServerEvent('esx_illegal_drugs:startTransformMeth')
            TriggerEvent('esx_illegal_drugs:TransformAnimation')
          elseif CurrentAction == 'MethDealer' then
            TriggerServerEvent('esx_illegal_drugs:startSellMeth')
          else
            isInZone = false
          end
          CurrentAction = nil
          Wait(1000)
          controlPressed = false
        end
      end
    end
  end
end)

-- Check Inventory
RegisterNetEvent('esx_illegal_drugs:ReturnInventory')
AddEventHandler('esx_illegal_drugs:ReturnInventory', function(cokeNum, cokepNum, methNum, methpNum, weedNum, weedpNum, opiumNum, opiumpNum, jobName, currentZone)
  cokeQTE = cokeNum
  coke_poochQTE = cokepNum
  methQTE = methNum
  meth_poochQTE = methpNum
  weedQTE = weedNum
  weed_poochQTE = weedpNum
  opiumQTE = opiumNum
  opium_poochQTE = opiumpNum
  myJob = jobName
  TriggerEvent('esx_illegal_drugs:hasEnteredMarker', currentZone)
end)

-- Disable Controls
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    local playerPed = PlayerPedId(-1)

    if HasAlreadyEnteredMarker then
      DisableControlAction(0, 24, true) -- Attack
      DisableControlAction(0, 257, true) -- Attack 2
      DisableControlAction(0, 25, true) -- Aim
      DisableControlAction(0, 263, true) -- Melee Attack 1
      DisableControlAction(0, 47, true) -- Disable Weapon
      DisableControlAction(0, 264, true) -- Disable Melee
      DisableControlAction(0, 257, true) -- Disable Melee
      DisableControlAction(0, 140, true) -- Disable Melee
      DisableControlAction(0, 141, true) -- Disable Melee
      DisableControlAction(0, 142, true) -- Disable Melee
      DisableControlAction(0, 143, true) -- Disable Melee
    else
      Citizen.Wait(500)
    end
  end
end)

-- Harvest Animation
RegisterNetEvent('esx_illegal_drugs:HarvestAnimation')
AddEventHandler('esx_illegal_drugs:HarvestAnimation', function()
  local ped = GetPlayerPed(-1)
  local coords = GetEntityCoords(ped)
  local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
  if not IsEntityPlayingAnim(ped, 'anim@amb@business@weed@weed_inspecting_lo_med_hi@', 'weed_stand_checkingleaves_kneeling_01_inspector', 3) then
    RequestAnimDict('anim@amb@business@weed@weed_inspecting_lo_med_hi@')
    while not HasAnimDictLoaded('anim@amb@business@weed@weed_inspecting_lo_med_hi@') do
      Citizen.Wait(100)
    end
    SetEntityCoords(PlayerPedId(), coords)
    Wait(100)
    TaskPlayAnim(ped, 'anim@amb@business@weed@weed_inspecting_lo_med_hi@', 'weed_stand_checkingleaves_kneeling_01_inspector', 8.0, -8, -1, 49, 0, 0, 0, 0)
    Wait(2000)
    while IsEntityPlayingAnim(ped, 'anim@amb@business@weed@weed_inspecting_lo_med_hi@', 'weed_stand_checkingleaves_kneeling_01_inspector', 3) do
      Wait(1)
      if (IsControlPressed(0, 177) or IsControlPressed(0, 154)) then
        ClearPedTasksImmediately(ped)
        break
      end
    end
  end
end)

-- Transform Animation
RegisterNetEvent('esx_illegal_drugs:TransformAnimation')
AddEventHandler('esx_illegal_drugs:TransformAnimation', function()
  local ped = GetPlayerPed(-1)
  local coords = GetEntityCoords(ped)
  local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
  if not IsEntityPlayingAnim(ped, 'anim@amb@business@weed@weed_sorting_seated@', 'sorter_right_sort_v3_sorter02', 3) then
    RequestAnimDict('anim@amb@business@weed@weed_sorting_seated@')
    DisableControlAction(0, Keys['W'], false) -- W
    DisableControlAction(0, Keys['A'], false) -- A
    DisableControlAction(0, 31, false) -- S (fault in Keys table!)
    DisableControlAction(0, 30, false) -- D (fault in Keys table!)
    DisableControlAction(0, Keys['SPACE'], true) -- Jump
    DisableControlAction(0, Keys['Q'], true) -- Cover
    DisableControlAction(0, Keys['F'], true) -- Also 'enter'?
    while not HasAnimDictLoaded('anim@amb@business@weed@weed_sorting_seated@') do
      Citizen.Wait(100)
    end
    SetEntityCoords(PlayerPedId(), coords)
    Wait(100)
    TaskPlayAnim(ped, 'anim@amb@business@weed@weed_sorting_seated@', 'sorter_right_sort_v3_sorter02', 8.0, -8, -1, 49, 0, 0, 0, 0)
    Wait(2000)
    while IsEntityPlayingAnim(ped, 'anim@amb@business@weed@weed_sorting_seated@', 'sorter_right_sort_v3_sorter02', 3) do
      Wait(1)
      if (IsControlPressed(0, 177) or IsControlPressed(0, 154)) then
        ClearPedTasksImmediately(ped)
        break
      end
    end
  end
end)

-- Create Blips
Citizen.CreateThread(function()
  for i = 1, #Config.Map, 1 do
    local blip = AddBlipForCoord(Config.Map[i].x, Config.Map[i].y, Config.Map[i].z)
    SetBlipSprite(blip, Config.Map[i].id)
    SetBlipDisplay(blip, 4)
    SetBlipColour(blip, Config.Map[i].color)
    SetBlipScale(blip, Config.Map[i].scale)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(Config.Map[i].name)
    EndTextCommandSetBlipName(blip)
  end
end)

-- Render Markers
Citizen.CreateThread(function()
  while true do
    Wait(0)
    local coords = GetEntityCoords(GetPlayerPed(-1))

    for k, v in pairs(Config.Zones) do
      if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.DrawDistance) then
        DrawMarker(Config.MarkerType, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.ZoneSize.x, Config.ZoneSize.y, Config.ZoneSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
      end
    end
  end
end)

-- Weed Effect
RegisterNetEvent('esx_illegal_drugs:onPot')
AddEventHandler('esx_illegal_drugs:onPot', function()
  RequestAnimSet('MOVE_M@DRUNK@SLIGHTLYDRUNK')
  while not HasAnimSetLoaded('MOVE_M@DRUNK@SLIGHTLYDRUNK') do
    Citizen.Wait(0)
  end
  TaskStartScenarioInPlace(GetPlayerPed(-1), 'WORLD_HUMAN_SMOKING_POT', 0, true)
  Citizen.Wait(50000)
  DoScreenFadeOut(1000)
  Citizen.Wait(1000)
  ClearPedTasksImmediately(GetPlayerPed(-1))
  SetTimecycleModifier('spectator5')
  SetPedMotionBlur(GetPlayerPed(-1), true)
  SetPedMovementClipSet(GetPlayerPed(-1), 'MOVE_M@DRUNK@SLIGHTLYDRUNK', true)
  SetPedIsDrunk(GetPlayerPed(-1), true)
  DoScreenFadeIn(1000)
  Citizen.Wait(600000)
  DoScreenFadeOut(1000)
  Citizen.Wait(1000)
  DoScreenFadeIn(1000)
  ClearTimecycleMofifier()
  ResetScenearioTypesEnabled()
  ResetPedMovementClipset(GetPlayerPed(-1), 0)
  SetPedIsDrunk(GetPlayerPed(-1), false)
  SetPedMotionBlur(GetPlayerPed(-1), false)
end)

-- Opium Effect
RegisterNetEvent('esx_illegal_drugs:onOpium')
AddEventHandler('esx_illegal_drugs:onOpium', function()
  RequestAnimSet('MOVE_M@DRUNK@SLIGHTLYDRUNK')
  while not HasAnimSetLoaded('MOVE_M@DRUNK@SLIGHTLYDRUNK') do
    Citizen.Wait(0)
  end
  TaskStartScenarioInPlace(GetPlayerPed(-1), 'WORLD_HUMAN_SMOKING_POT', 0, true)
  Citizen.Wait(50000)
  DoScreenFadeOut(1000)
  Citizen.Wait(1000)
  ClearPedTasksImmediately(GetPlayerPed(-1))
  SetTimecycleModifier('spectator5')
  SetPedMotionBlur(GetPlayerPed(-1), true)
  SetPedMovementClipSet(GetPlayerPed(-1), 'MOVE_M@DRUNK@SLIGHTLYDRUNK', true)
  SetPedIsDrunk(GetPlayerPed(-1), true)
  DoScreenFadeIn(1000)
  Citizen.Wait(600000)
  DoScreenFadeOut(1000)
  Citizen.Wait(1000)
  DoScreenFadeIn(1000)
  ClearTimecycleMofifier()
  ResetScenearioTypesEnabled()
  ResetPedMovementClipset(GetPlayerPed(-1), 0)
  SetPedIsDrunk(GetPlayerPed(-1), false)
  SetPedMotionBlur(GetPlayerPed(-1), false)
end)

-- Coke Effect
RegisterNetEvent('esx_illegal_drugs:onCoke')
AddEventHandler('esx_illegal_drugs:onCoke', function()
	RequestAnimSet("MOVE_M@DRUNK@SLIGHTLYDRUNK")
	while not HasAnimSetLoaded("MOVE_M@DRUNK@SLIGHTLYDRUNK") do
		Citizen.Wait(0)
	end
	TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_SMOKING_POT", 0, true)
	Citizen.Wait(50000)
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	ClearPedTasksImmediately(GetPlayerPed(-1))
	SetTimecycleModifier("spectator5")
	SetPedMotionBlur(GetPlayerPed(-1), true)
	SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
	SetPedIsDrunk(GetPlayerPed(-1), true)
	DoScreenFadeIn(1000)
	Citizen.Wait(600000)
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	DoScreenFadeIn(1000)
	ClearTimecycleModifier()
	ResetScenarioTypesEnabled()
	ResetPedMovementClipset(GetPlayerPed(-1), 0)
	SetPedIsDrunk(GetPlayerPed(-1), false)
	SetPedMotionBlur(GetPlayerPed(-1), false)
end)

-- Meth Effect
RegisterNetEvent('esx_illegal_drugs:onMeth')
AddEventHandler('esx_illegal_drugs:onMeth', function()
	RequestAnimSet("MOVE_M@DRUNK@SLIGHTLYDRUNK")
	while not HasAnimSetLoaded("MOVE_M@DRUNK@SLIGHTLYDRUNK") do
		Citizen.Wait(0)
	end
	TaskStartScenarioInPlace(GetPlayerPed(-1), "mp_player_intdrink", 0, true)
	Citizen.Wait(50000)
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	ClearPedTasksImmediately(GetPlayerPed(-1))
	SetTimecycleModifier("spectator5")
	SetPedMotionBlur(GetPlayerPed(-1), true)
	SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
	SetPedIsDrunk(GetPlayerPed(-1), true)
	DoScreenFadeIn(1000)
	Citizen.Wait(600000)
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	DoScreenFadeIn(1000)
	ClearTimecycleModifier()
	ResetScenarioTypesEnabled()
	ResetPedMovementClipset(GetPlayerPed(-1), 0)
	SetPedIsDrunk(GetPlayerPed(-1), false)
	SetPedMotionBlur(GetPlayerPed(-1), false)
end)
