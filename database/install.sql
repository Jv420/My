CREATE TABLE IF NOT EXISTS shop_orders (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  order_id VARCHAR(64) NOT NULL,
  stripe_session_id VARCHAR(255) NOT NULL,
  stripe_payment_intent_id VARCHAR(255) NULL,
  product_id VARCHAR(100) NOT NULL,
  product_name VARCHAR(255) NOT NULL,
  player_identifier VARCHAR(100) NOT NULL,
  player_name VARCHAR(100) NOT NULL,
  email VARCHAR(255) NULL,
  amount_total INT NOT NULL,
  currency VARCHAR(10) NOT NULL DEFAULT 'eur',
  status ENUM('pending_payment','paid','delivering','delivered','failed') NOT NULL DEFAULT 'pending_payment',
  delivery_payload JSON NOT NULL,
  delivery_error TEXT NULL,
  paid_at DATETIME NULL,
  delivered_at DATETIME NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_order_id (order_id),
  UNIQUE KEY uq_stripe_session_id (stripe_session_id),
  KEY idx_player_identifier (player_identifier),
  KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS shop_delivery_logs (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  order_id VARCHAR(64) NOT NULL,
  player_identifier VARCHAR(100) NOT NULL,
  message TEXT NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_order_id (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
