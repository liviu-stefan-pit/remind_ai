'use strict';

// Injected per deploy — must change every release so SW update checks install this worker.
var BUILD_ID = '__BUILD_ID__';

self.addEventListener('install', function () {
  self.skipWaiting();
});

self.addEventListener('message', function (event) {
  if (event.data && event.data.type === 'SKIP_WAITING') {
    self.skipWaiting();
  }
});

function bustUrl(url) {
  try {
    var u = new URL(url);
    u.searchParams.delete('_cb');
    u.searchParams.set('_cb', BUILD_ID);
    return u.toString();
  } catch (e) {
    return url;
  }
}

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
      if (!client.url) continue;
      var target = bustUrl(client.url);
      try {
        if ('navigate' in client) {
          await client.navigate(target);
        } else if ('postMessage' in client) {
          client.postMessage({ type: 'FORCE_RELOAD' });
        }
      } catch (e) {
        if ('postMessage' in client) {
          client.postMessage({ type: 'FORCE_RELOAD' });
        }
      }
    }
  })());
});
