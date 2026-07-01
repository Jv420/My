import Stripe from 'stripe';
import crypto from 'crypto';
import { redirect } from 'next/navigation';
import { getProduct } from '../../../lib/products';
import { createPendingOrder } from '../../../lib/db';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);

export async function POST(request) {
  const formData = await request.formData();
  const productId = String(formData.get('productId') || '');
  const playerIdentifier = String(formData.get('playerIdentifier') || '').trim();
  const playerName = String(formData.get('playerName') || '').trim();
  const product = getProduct(productId);

  if (!product || !playerIdentifier || !playerName) {
    return Response.json({ error: 'Ongeldige aanvraag.' }, { status: 400 });
  }

  const siteUrl = process.env.NEXT_PUBLIC_SITE_URL;
  const orderId = crypto.randomUUID();

  const session = await stripe.checkout.sessions.create({
    mode: 'payment',
    payment_method_types: ['card', 'ideal', 'bancontact'],
    line_items: [
      {
        quantity: 1,
        price_data: {
          currency: product.currency,
          unit_amount: product.price,
          product_data: {
            name: product.name,
            description: product.description
          }
        }
      }
    ],
    metadata: {
      orderId,
      productId: product.id,
      playerIdentifier,
      playerName
    },
    success_url: `${siteUrl}/success?order=${orderId}`,
    cancel_url: `${siteUrl}/cancel`
  });

  await createPendingOrder({
    orderId,
    product,
    playerIdentifier,
    playerName,
    stripeSessionId: session.id
  });

  redirect(session.url);
}
