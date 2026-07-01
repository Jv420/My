import Stripe from 'stripe';
import { markOrderPaid } from '../../../../lib/db';
import { sendDiscordLog } from '../../../../lib/discord';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);

export async function POST(request) {
  const body = await request.text();
  const signature = request.headers.get('stripe-signature');

  let event;
  try {
    event = stripe.webhooks.constructEvent(body, signature, process.env.STRIPE_WEBHOOK_SECRET);
  } catch (error) {
    return Response.json({ error: `Webhook error: ${error.message}` }, { status: 400 });
  }

  if (event.type === 'checkout.session.completed') {
    const session = event.data.object;

    await markOrderPaid({
      stripeSessionId: session.id,
      paymentIntentId: session.payment_intent,
      email: session.customer_details?.email
    });

    await sendDiscordLog('Nieuwe FiveM aankoop betaald', [
      { name: 'Product', value: session.metadata?.productId, inline: true },
      { name: 'Speler', value: session.metadata?.playerName, inline: true },
      { name: 'Identifier', value: session.metadata?.playerIdentifier, inline: false },
      { name: 'Order', value: session.metadata?.orderId, inline: false }
    ]);
  }

  return Response.json({ received: true });
}
