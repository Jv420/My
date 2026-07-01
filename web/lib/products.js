export const products = [
  {
    id: 'starter_cash',
    name: 'Starter Cash Pack',
    description: 'Ontvang direct extra cash of bankgeld op de server.',
    price: 499,
    currency: 'eur',
    image: '/cash.png',
    delivery: { type: 'money', account: 'bank', amount: 50000 }
  },
  {
    id: 'vip_30d',
    name: 'VIP 30 dagen',
    description: 'VIP status voor 30 dagen met extra voordelen.',
    price: 999,
    currency: 'eur',
    image: '/vip.png',
    delivery: { type: 'rank', rank: 'vip', days: 30 }
  },
  {
    id: 'sultanrs_car',
    name: 'Sultan RS Voertuig',
    description: 'Een premium voertuig dat automatisch wordt geleverd.',
    price: 1499,
    currency: 'eur',
    image: '/car.png',
    delivery: { type: 'vehicle', model: 'sultanrs' }
  },
  {
    id: 'weapon_pack_1',
    name: 'Weapon Pack 1',
    description: 'Wapenpakket voor roleplay servers waar dit is toegestaan.',
    price: 1299,
    currency: 'eur',
    image: '/weapon.png',
    delivery: { type: 'weapon', weapon: 'WEAPON_PISTOL', ammo: 120 }
  }
];

export function getProduct(productId) {
  return products.find((product) => product.id === productId);
}
