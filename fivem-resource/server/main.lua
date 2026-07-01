JVShop = JVShop or {}

local function fetchPaidOrdersForIdentifier(identifier)
  return MySQL.query.await(
    "SELECT order_id, product_id, player_identifier, player_name FROM shop_orders WHERE status = 'paid' AND player_identifier = ? ORDER BY created_at ASC LIMIT 10",
    { identifier }
  ) or {}
end

local function processPlayerOrders(playerSource)
  local identifier = JVShop.GetIdentifier(playerSource)
  if not identifier then return end

  local orders = fetchPaidOrdersForIdentifier(identifier)
  for _, order in ipairs(orders) do
    MySQL.update.await("UPDATE shop_orders SET status = 'delivering' WHERE order_id = ? AND status = 'paid'", { order.order_id })

    local ok, err = JVShop.DeliverProduct(playerSource, order)
    if ok then
      JVShop.MarkDelivered(order.order_id, identifier, 'Delivered while player was online')
      TriggerClientEvent('jv-shop:notify', playerSource, 'Je webshop aankoop is geleverd!')
    else
      JVShop.MarkFailed(order.order_id, identifier, err or 'delivery_failed')
      TriggerClientEvent('jv-shop:notify', playerSource, 'Webshop levering mislukt. Neem contact op met staff.')
    end
  end
end

RegisterNetEvent('jv-shop:playerReady', function()
  local playerSource = source
  SetTimeout(5000, function()
    processPlayerOrders(playerSource)
  end)
end)

CreateThread(function()
  while true do
    Wait((Config.CheckIntervalSeconds or 60) * 1000)
    for _, playerId in ipairs(GetPlayers()) do
      processPlayerOrders(tonumber(playerId))
    end
  end
end)
