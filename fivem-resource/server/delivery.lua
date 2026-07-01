JVShop = JVShop or {}

local function logDiscord(title, description)
  local webhook = GetConvar(Config.DiscordWebhookConvar, '')
  if webhook == '' then return end

  PerformHttpRequest(webhook, function() end, 'POST', json.encode({
    embeds = {{
      title = title,
      description = description,
      color = 5763719,
      timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ')
    }}
  }), { ['Content-Type'] = 'application/json' })
end

function JVShop.DeliverProduct(source, order)
  local product = Config.Products[order.product_id]
  if not product then
    return false, 'unknown_product'
  end

  if product.type == 'money' then
    return JVShop.AddMoney(source, product.account or 'bank', tonumber(product.amount) or 0)
  end

  if product.type == 'item' then
    return JVShop.AddItem(source, product.item, tonumber(product.amount) or 1)
  end

  if product.type == 'weapon' then
    return JVShop.AddWeapon(source, product.weapon, tonumber(product.ammo) or 0)
  end

  if product.type == 'rank' and Config.CustomDelivery.rank then
    return Config.CustomDelivery.rank(source, order, product)
  end

  if product.type == 'vehicle' and Config.CustomDelivery.vehicle then
    return Config.CustomDelivery.vehicle(source, order, product)
  end

  return false, 'unsupported_product_type'
end

function JVShop.MarkDelivered(orderId, identifier, message)
  MySQL.update.await(
    "UPDATE shop_orders SET status = 'delivered', delivered_at = NOW(), delivery_error = NULL WHERE order_id = ?",
    { orderId }
  )

  MySQL.insert.await(
    'INSERT INTO shop_delivery_logs (order_id, player_identifier, message) VALUES (?, ?, ?)',
    { orderId, identifier, message or 'Delivered' }
  )

  logDiscord('FiveM webshop levering gelukt', ('Order `%s` geleverd aan `%s`'):format(orderId, identifier))
end

function JVShop.MarkFailed(orderId, identifier, errorMessage)
  MySQL.update.await(
    "UPDATE shop_orders SET status = 'failed', delivery_error = ? WHERE order_id = ?",
    { errorMessage or 'unknown_error', orderId }
  )

  MySQL.insert.await(
    'INSERT INTO shop_delivery_logs (order_id, player_identifier, message) VALUES (?, ?, ?)',
    { orderId, identifier, errorMessage or 'Failed' }
  )

  logDiscord('FiveM webshop levering mislukt', ('Order `%s` voor `%s`: %s'):format(orderId, identifier, errorMessage or 'unknown_error'))
end
