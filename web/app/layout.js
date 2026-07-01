import './styles.css';

export const metadata = {
  title: 'FiveM Webshop',
  description: 'FiveM Stripe webshop met automatische levering'
};

export default function RootLayout({ children }) {
  return (
    <html lang="nl">
      <body>{children}</body>
    </html>
  );
}
