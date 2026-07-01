# Setup Guide

## 1. Database

Importeer dit bestand in dezelfde MySQL database die je FiveM server gebruikt:

```txt
database/install.sql
```

## 2. Vercel

Zet de map `web/` als Vercel project.

Environment variables op Vercel:

```txt
NEXT_PUBLIC_SITE_URL
NEXT_PUBLIC_SERVER_NAME
STRIPE_SECRET_KEY
STRIPE_WEBHOOK_SECRET
MYSQL_HOST
MYSQL_PORT
MYSQL_DATABASE
MYSQL_USER
MYSQL_PASSWORD
DISCORD_WEBHOOK_URL
SHOP_DELIVERY_SERVER_KEY
```

## 3. Stripe

Maak een webhook endpoint aan:

```txt
https://jouwdomein.nl/api/stripe/webhook
```

Events:

```txt
checkout.session.completed
```

## 4. FiveM resource

Plaats de resource zo:

```txt
resources/[local]/jv-fivem-shop/
```

Kopieer de inhoud van `fivem-resource/` daarin.

`server.cfg`:

```cfg
ensure oxmysql
ensure jv-fivem-shop
```

## 5. ESX of QBCore

In `fivem-resource/config.lua` kun je dit zetten:

```lua
Config.Framework = 'auto'
```

Of handmatig:

```lua
Config.Framework = 'esx'
Config.Framework = 'qbcore'
```

## 6. Producten aanpassen

Pas producten op twee plekken gelijk aan:

```txt
web/lib/products.js
fivem-resource/config.lua
```

De `id` moet exact hetzelfde zijn.

## 7. Voertuigen en ranks

Voertuigen en ranks verschillen per FiveM server. Pas daarom deze functies aan:

```lua
Config.CustomDelivery.rank
Config.CustomDelivery.vehicle
```

Voorbeelden staan al in `fivem-resource/config.lua`.
