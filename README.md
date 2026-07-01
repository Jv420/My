# FiveM Stripe Webshop + Auto Delivery

Complete basis voor een eigen FiveM webshop op Vercel met Stripe, MySQL, Discord meldingen en automatische levering naar ESX of QBCore servers.

## Wat zit erin

- Next.js webshop voor Vercel
- Stripe Checkout API
- Stripe webhook voor succesvolle betalingen
- MySQL order database
- Discord webhook meldingen
- FiveM resource met ESX + QBCore support
- Offline delivery bij volgende login
- Anti-duplicate levering via order status
- Productconfiguratie voor cash, bank, items, wapens, voertuigen en ranks

## Structuur

```txt
web/                 Vercel / Next.js webshop
fivem-resource/      FiveM resource voor levering
database/            MySQL install script
.env.example         Voorbeeld environment variables
```

## Installatie kort

1. Importeer `database/install.sql` in je MySQL database.
2. Zet `web/` op Vercel.
3. Vul je Vercel environment variables in vanaf `.env.example`.
4. Maak in Stripe een webhook naar:

```txt
https://jouwdomein.nl/api/stripe/webhook
```

5. Zet de FiveM resource in je server:

```txt
resources/[local]/jv-fivem-shop
```

6. Voeg toe aan `server.cfg`:

```cfg
ensure oxmysql
ensure jv-fivem-shop
```

7. Controleer `fivem-resource/config.lua` voor jouw framework en producten.

## Belangrijk

Zet nooit Stripe secrets, database wachtwoorden of Discord webhooks direct in GitHub. Gebruik Vercel Environment Variables en FiveM server.cfg convars.

## FiveM server.cfg voorbeeld

```cfg
set mysql_connection_string "mysql://USER:PASSWORD@HOST:3306/DATABASE?charset=utf8mb4"
set jv_shop_discord_webhook "https://discord.com/api/webhooks/xxx/yyy"
set jv_shop_server_key "maak-hier-een-lange-random-key"
ensure oxmysql
ensure jv-fivem-shop
```

## Product voorbeelden

De website gebruikt `web/lib/products.js`. De FiveM resource gebruikt dezelfde product IDs in `fivem-resource/config.lua`.

Voorbeeld IDs:

- `starter_cash`
- `vip_30d`
- `sultanrs_car`
- `weapon_pack_1`

## Status

Basis klaar om verder te koppelen aan jouw exacte ESX/QBCore inventory, garage en rank systeem.
