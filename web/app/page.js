import { products } from '../lib/products';

export default function HomePage() {
  const serverName = process.env.NEXT_PUBLIC_SERVER_NAME || 'FiveM Server';

  return (
    <main className="container">
      <section className="hero">
        <div className="badge">Stripe • MySQL • Discord • ESX/QBCore</div>
        <h1>{serverName} Webshop</h1>
        <p>
          Koop veilig extra pakketten voor onze FiveM server. Na betaling wordt je aankoop opgeslagen
          en automatisch geleverd zodra je online bent.
        </p>
      </section>

      <section className="grid">
        {products.map((product) => (
          <form className="card" action="/api/checkout" method="POST" key={product.id}>
            <input type="hidden" name="productId" value={product.id} />
            <h2>{product.name}</h2>
            <p>{product.description}</p>
            <div className="price">€{(product.price / 100).toFixed(2)}</div>
            <input name="playerIdentifier" placeholder="FiveM license of citizenid" required />
            <input name="playerName" placeholder="Spelernaam" required />
            <button type="submit">Kopen met Stripe</button>
          </form>
        ))}
      </section>

      <p className="note">
        Let op: vul je juiste FiveM identifier/citizenid in. Bij fout ingevulde gegevens kan automatische levering mislukken.
      </p>
    </main>
  );
}
