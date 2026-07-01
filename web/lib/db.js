import mysql from 'mysql2/promise';

let pool;

export function getPool() {
  if (!pool) {
    pool = mysql.createPool({
      host: process.env.MYSQL_HOST,
      port: Number(process.env.MYSQL_PORT || 3306),
      database: process.env.MYSQL_DATABASE,
      user: process.env.MYSQL_USER,
      password: process.env.MYSQL_PASSWORD,
      waitForConnections: true,
      connectionLimit: 10,
      queueLimit: 0,
      charset: 'utf8mb4'
    });
  }

  return pool;
}

export async function createPendingOrder({ orderId, product, playerIdentifier, playerName, email, stripeSessionId }) {
  const db = getPool();
  await db.execute(
    `INSERT INTO shop_orders
      (order_id, stripe_session_id, product_id, product_name, player_identifier, player_name, email, amount_total, currency, status, delivery_payload)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'pending_payment', ?)`,
    [
      orderId,
      stripeSessionId,
      product.id,
      product.name,
      playerIdentifier,
      playerName,
      email || null,
      product.price,
      product.currency,
      JSON.stringify(product.delivery)
    ]
  );
}

export async function markOrderPaid({ stripeSessionId, paymentIntentId, email }) {
  const db = getPool();
  await db.execute(
    `UPDATE shop_orders
     SET status = 'paid', stripe_payment_intent_id = ?, email = COALESCE(email, ?), paid_at = NOW()
     WHERE stripe_session_id = ? AND status = 'pending_payment'`,
    [paymentIntentId || null, email || null, stripeSessionId]
  );
}
