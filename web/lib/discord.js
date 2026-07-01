export async function sendDiscordLog(title, fields = []) {
  const webhookUrl = process.env.DISCORD_WEBHOOK_URL;
  if (!webhookUrl) return;

  const payload = {
    embeds: [
      {
        title,
        color: 5763719,
        fields: fields.map((field) => ({
          name: field.name,
          value: String(field.value || '-'),
          inline: Boolean(field.inline)
        })),
        timestamp: new Date().toISOString()
      }
    ]
  };

  await fetch(webhookUrl, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload)
  }).catch(() => null);
}
