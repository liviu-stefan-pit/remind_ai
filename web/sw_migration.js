'use strict';

// Bump this string in vercel buildCommand whenever migration logic changes
// to force browsers with any prior SW to pick up the new script.
const MIGRATION_ID = 'remind-ai-v1';

self.addEventListener('install', () => {
  self.skipWaiting();
});

self.addEventListener('message', (event) => {
  if (event.data?.type === 'SKIP_WAITING') {
    self.skipWaiting();
  }
});

self.addEventListener('activate', (event) => {
  event.waitUntil((async () => {
    const keys = await caches.keys();
    await Promise.all(keys.map((k) => caches.delete(k)));

    const clients = await self.clients.matchAll({ type: 'window' });

    await self.registration.unregister();

    await Promise.all(
      clients.map((client) => {
        if (client.url && 'navigate' in client) {
          return client.navigate(client.url);
        }
      }),
    );
  })());
});
