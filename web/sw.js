const staticCacheName = 'site-static-v1';

//install service worker
self.addEventListener('install', function(event) {
  event.waitUntil(
    caches.open(staticCacheName).then(function(cache) {
      return cache.addAll(
        [
          '/Queue.jsp',
          '/QueueCSS.css',
          'https://fonts.googleapis.com/css?family=Roboto',
          'https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js',
          'https://code.jquery.com/jquery-1.12.4.js',
          'https://code.jquery.com/ui/1.12.1/jquery-ui.js',
          "//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css",
          'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css',
          "//cdnjs.cloudflare.com/ajax/libs/timepicker/1.3.5/jquery.timepicker.min.js",
          "//cdnjs.cloudflare.com/ajax/libs/timepicker/1.3.5/jquery.timepicker.min.css",
          'scripts/script.js',
          'scripts/checkAppointmentDateUpdate.js',
          'scripts/updateUserProfile.js',
          'scripts/customerReviewsAndRatings.js',
          'scripts/SettingsDivBehaviour.js',
          'scripts/ChangeProfileInformationFormDiv.js',
	  'https://fonts.gstatic.com/s/roboto/v20/KFOmCnqEu92Fr1Mu4mxKKTU1Kg.woff2',
	  'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/fonts/fontawesome-webfont.woff2?v=4.7.0',
	  'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/fonts/fontawesome-webfont.ttf?v=4.7.0'
        ]
      );
    })
  );
});


//activate service worker
self.addEventListener('activate', evt => {
  //console.log('service worker activated');
  evt.waitUntil(
    caches.keys().then(keys => {
      //console.log(keys);
      return Promise.all(keys
        .filter(key => key !== staticCacheName)
        .map(key => caches.delete(key))
      );
    })
  );
});

//fecth event listener
self.addEventListener('fetch', event => {
    //console.log("fetch event handler called", event);
    event.respondWith(
        caches.match(event.request).then(cacheRes => {
          return cacheRes || fetch(event.request);
        })
    );
});
