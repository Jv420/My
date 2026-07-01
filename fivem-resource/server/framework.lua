JVShop = JVShop or {}
JVShop.Framework = nil
JVShop.FrameworkName = nil

local function detectFramework()
  if Config.Framework ~= 'auto' then
    return Config.Framework
  end

  if GetResourceState('qb-core') == 'started' then
    return 'qbcore'
  end

  if GetResourceState('es_extended') == 'started' then
    return 'esx'
  end

  return 'standalone'
end

CreateThread(function()
  local framework = detectFramework()
  JVShop.FrameworkName = framework

  if framework == 'qbcore' then
    JVShop.Framework = exports['qb-core']:GetCoreObject()
    print('[JV Shop] QBCore framework geladen')
  elseif framework == 'esx' then
    JVShop.Framework = exports['es_extended']:getSharedObject()
    print('[JV Shop] ESX framework geladen')
  else
    print('[JV Shop] Geen framework gevonden, standalone mode actief')
  end
end)

function JVShop.GetPlayer(source)
  if JVShop.FrameworkName == 'qbcore' then
    return JVShop.Framework.Functions.GetPlayer(source)
  end

  if JVShop.FrameworkName == 'esx' then
    return JVShop.Framework.GetPlayerFromId(source)
  end

  return nil
end

function JVShop.GetIdentifier(source)
  local player = JVShop.GetPlayer(source)

  if JVShop.FrameworkName == 'qbcore' and player and player.PlayerData then
    if Config.IdentifierMode == 'citizenid' or Config.IdentifierMode == 'auto' then
      return player.PlayerData.citizenid
    end
  end

  if JVShop.FrameworkName == 'esx' and player then
    return player.identifier
  end

  for _, identifier in ipairs(GetPlayerIdentifiers(source)) do
    if identifier:find('license:') == 1 then
      return identifier
    end
  end

  return nil
end

function JVShop.AddMoney(source, account, amount)
  local player = JVShop.GetPlayer(source)
  if not player then return false, 'player_not_found' end

  if JVShop.FrameworkName == 'qbcore' then
    player.Functions.AddMoney(account == 'cash' and 'cash' or 'bank', amount, 'webshop-purchase')
    return true
  end

  if JVShop.FrameworkName == 'esx' then
    if account == 'cash' then
      player.addMoney(amount)
    else
      player.addAccountMoney(account or 'bank', amount)
    end
    return true
  end

  return false, 'unsupported_framework'
end

function JVShop.AddItem(source, item, amount)
  local player = JVShop.GetPlayer(source)
  if not player then return false, 'player_not_found' end

  if JVShop.FrameworkName == 'qbcore' then
    player.Functions.AddItem(item, amount or 1)
    return true
  end

  if JVShop.FrameworkName == 'esx' then
    player.addInventoryItem(item, amount or 1)
    return true
  end

  return false, 'unsupported_framework'
end

function JVShop.AddWeapon(source, weapon, ammo)
  local player = JVShop.GetPlayer(source)
  if not player then return false, 'player_not_found' end

  if JVShop.FrameworkName == 'qbcore' then
    player.Functions.AddItem(weapon, 1)
    return true
  end

  if JVShop.FrameworkName == 'esx' then
    player.addWeapon(weapon, ammo or 0)
    return true
  end

  return false, 'unsupported_framework'
end
