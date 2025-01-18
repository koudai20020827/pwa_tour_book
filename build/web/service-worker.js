self.addEventListener("install", function (event) {
  event.waitUntil(
    caches.open("pwa-cache").then(function (cache) {
      return cache.addAll([
        "/",
        "/index.html",
        "/main.dart.js",
        "/manifest.json",
        "/icons/Icon-192.png",
        "/icons/Icon-512.png",
      ]);
    })
  );
});

self.addEventListener("fetch", function (event) {
  event.respondWith(
    caches.match(event.request).then(function (response) {
      return response || fetch(event.request);
    })
  );
});
