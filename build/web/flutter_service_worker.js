'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "57ac61a75d9c9c2d5cb1fa87952cf0e0",
"assets/AssetManifest.bin.json": "796d1474a3d8d66cbc6446183eab6fe3",
"assets/AssetManifest.json": "c172a0d13520656f6b551451b1805a32",
"assets/assets/images/anime2.jpg": "a1c4cdb16ed7f3cc15d7f48e59860497",
"assets/assets/images/calificaciones_cuestionarios.png": "f221546ec773641d3e03b0509b7b4d39",
"assets/assets/images/calificaciones_examenes.png": "0b11f4af632105012f46da86da9fddc0",
"assets/assets/images/chico.png": "6e2cf06875cc010705e3c7ad0a9f5f59",
"assets/assets/images/leyendo.png": "e782311e0ca1db3ed63c1367d4b4fd28",
"assets/assets/images/logo1.png": "a4f19cfdd2c8fe85cc732a146b3da2b2",
"assets/assets/images/logoAppMate.jpg": "78ac0f7379bdbae0130832456994d14a",
"assets/assets/images/nina.png": "db57629b4328c1c38077f3de797653f6",
"assets/assets/images/profesor.png": "825903bd13e9e970b97b070ff1de0793",
"assets/assets/images/usuario.jpg": "b2b34517339101a111716be1c203f354",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "4baf1acb673c56b2015b11d0c59926b6",
"assets/images/boleta-de-calificaciones.png": "d44974f4abd92e6e102e9695622d6f88",
"assets/images/calificaciones.png": "1e77e458f51ad88fb0f6e9911f37d127",
"assets/images/categorias.png": "2d97285f58246bd74c449c539547961e",
"assets/images/certificado.png": "76cffe509e98753db8fbc4338e4c4a2c",
"assets/images/chico.png": "6e2cf06875cc010705e3c7ad0a9f5f59",
"assets/images/cuestionario.png": "f22bf9e1e3048d6c4c15c5f8ee6c0325",
"assets/images/enhorabuena.png": "e72f094f7b71ffbe39169f61c7eaf632",
"assets/images/estudiante.png": "cbf788be00a160cb69e9b8b469c52b00",
"assets/images/examen.png": "7d42544c038373693c6b6c9d7041ff5a",
"assets/images/examen_resultado.png": "ef500690be323a5259b35bb5726fd762",
"assets/images/gorra.png": "dc65b85784c11c16e6aa64b6271d7775",
"assets/images/leyendo.png": "e782311e0ca1db3ed63c1367d4b4fd28",
"assets/images/libro.png": "a9acc61aa3297627c8c4c476e1f63eca",
"assets/images/nina.png": "db57629b4328c1c38077f3de797653f6",
"assets/images/notas%2520cuestionario.png": "4595911ff8168e1f4e4880f28fd634af",
"assets/images/notas.png": "5df2de20a0698fba39d53c86d5b90876",
"assets/images/practicas.png": "e14fdfa49440cc9ba023a0110c43503d",
"assets/images/temario.PNG": "eea7a3ba8faba11e775d24a525d9ebda",
"assets/images/temariosExamen.png": "2ab5f19bc29fb186b70ec846cbb54f2c",
"assets/images/temas.png": "7fb4fcd4990ee582d09ca30e1e73311e",
"assets/images/temasExamen.png": "17bb9cfef809fe3827a8308b7c5edd48",
"assets/NOTICES": "9ac97746d85cb44e1105b2a7cf3e6730",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "f2163b9d4e6f1ea52063f498c8878bb9",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/shaders/ink_sparkle.frag": "4096b5150bac93c41cbc9b45276bd90f",
"canvaskit/canvaskit.js": "eb8797020acdbdf96a12fb0405582c1b",
"canvaskit/canvaskit.wasm": "64edb91684bdb3b879812ba2e48dd487",
"canvaskit/chromium/canvaskit.js": "0ae8bbcc58155679458a0f7a00f66873",
"canvaskit/chromium/canvaskit.wasm": "f87e541501c96012c252942b6b75d1ea",
"canvaskit/skwasm.js": "87063acf45c5e1ab9565dcf06b0c18b8",
"canvaskit/skwasm.wasm": "4124c42a73efa7eb886d3400a1ed7a06",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "59a12ab9d00ae8f8096fffc417b6e84f",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "9fb04f1bf482c24c8e2b527db7831553",
"/": "9fb04f1bf482c24c8e2b527db7831553",
"main.dart.js": "b318c6f7ef9f9236c05a18fa704d63d2",
"manifest.json": "b7782b638a227fd1cf4dd4748788a645",
"version.json": "4fa67ce22bf62a94daee2c5a4d7309d0"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
