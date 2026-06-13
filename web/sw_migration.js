'use strict';

// Killer SW for installs that still have an old Flutter caching worker.
// index.html no longer registers a SW; this file is only fetched when an
// existing worker checks for updates. Bump when killer logic changes.
const MIGRATION_ID = 'remind-ai-v3-killer';

self.addEventListener('install', function () {
  self.skipWaiting();
});

self.addEventListener('message', function (event) {
  if (event.data && event.data.type === 'SKIP_WAITING') {
    self.skipWaiting();
  }
});

self.addEventListener('activate', function (event) {
  event.waitUntil((async function () {
    var keys = await caches.keys();
    await Promise.all(keys.map(function (k) {
      return caches.delete(k);
    }));

    var clients = await self.clients.matchAll({
      type: 'window',
      includeUncontrolled: true,
    });

    await self.registration.unregister();

    for (var i = 0; i < clients.length; i++) {
      var client = clients[i];
      if (client.url && 'navigate' in client) {
        await client.navigate(client.url);
      }
    }
  })());
});
