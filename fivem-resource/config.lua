Config = {}

-- auto, esx of qbcore
Config.Framework = 'auto'

-- Hoe vaak de server betaalde orders controleert voor online spelers.
Config.CheckIntervalSeconds = 60

-- Gebruik license, citizenid of beide. Voor ESX is license vaak het veiligst. Voor QBCore meestal citizenid.
Config.IdentifierMode = 'auto'

Config.DiscordWebhookConvar = 'jv_shop_discord_webhook'

Config.Products = {
  starter_cash = {
    type = 'money',
    account = 'bank',
    amount = 50000
  },
  vip_30d = {
    type = 'rank',
    rank = 'vip',
    days = 30
  },
  sultanrs_car = {
    type = 'vehicle',
    model = 'sultanrs',
    garage = 'pillboxgarage'
  },
  weapon_pack_1 = {
    type = 'weapon',
    weapon = 'WEAPON_PISTOL',
    ammo = 120
  }
}

-- Pas deze functies aan naar jouw exacte garage/rank systeem.
Config.CustomDelivery = {
  rank = function(source, order, product)
    -- Voorbeeld: exports['jouw-rank-script']:GiveRank(source, product.rank, product.days)
    print(('[JV Shop] Rank delivery placeholder: %s %s dagen'):format(product.rank, product.days or 0))
    return true
  end,

  vehicle = function(source, order, product)
    -- Voorbeeld: insert in owned_vehicles/player_vehicles afhankelijk van ESX/QBCore garage.
    print(('[JV Shop] Vehicle delivery placeholder: %s'):format(product.model))
    return true
  end
}
