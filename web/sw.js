const staticCacheName = 'site-static-v1';

//install service worker
self.addEventListener('install', function(event) {
  event.waitUntil(
    caches.open(staticCacheName).then(function(cache) {
      return cache.addAll(
        [
          '/Queue.jsp',
          '/QueueCSS.css',
          '/404.jsp',
          '/QueueLogo.png',
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
	  'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/fonts/fontawesome-webfont.ttf?v=4.7.0',
          '/icons/Logo.png',
	  '/icons/icons8-notification-50.png',
	  '/icons/icons8-user-account-20.png',
	  '/icons/NoProPicAvatar.png',
	  '/icons/ActiveSpotsIcon.png',
	  '/icons/AddPhotoImg.png',
	  '/icons/ExploreIcon.png',
	  '/icons/FavoritesIcon.png',
	  '/icons/ProviderApptIcon.png',
	  '/icons/SecondExploreIcon.png',
	  '/icons/SecondFavoritesIcon.png',
	  '/icons/icons8-arrow-pointing-left-100.png',
	  '/icons/SecondUserProfileIcon.png',
	  '/icons/SpotsIcon.png',
	  '/icons/UserProfileIcon.png',
	  '/icons/icons8-barber-clippers-filled-70.png',
	  '/icons/icons8-barber-pole-16.png',
	  '/icons/icons8-barber-pole-30.png',
	  '/icons/icons8-barber-pole-50.png',
	  '/icons/icons8-barbershop-50.png',
	  '/icons/icons8-business-15.png',
	  '/icons/icons8-business-50.png',
	  '/icons/icons8-calendar-50.png',
	  '/icons/icons8-cleansing-filled-70.png',
	  '/icons/icons8-coach-96.png',
	  '/icons/icons8-comments-96.png',
	  '/icons/icons8-cosmetic-brush-96.png',
	  '/icons/icons8-cosmetic-brush-filled-70.png',
	  '/icons/icons8-customer-filled-100.png',
	  '/icons/icons8-dairy-50.png',
	  '/icons/icons8-dairy-filled-70.png',
	  '/icons/icons8-dog-filled-70.png',
	  '/icons/icons8-edit-96.png',
	  '/icons/icons8-ellipsis-filled-70.png',
	  '/icons/icons8-eye-50.png',
	  '/icons/icons8-eye-filled-70.png',
	  '/icons/icons8-feedback-20.png',
	  '/icons/icons8-foot-96.png',
	  '/icons/icons8-foot-filled-70.png',
	  '/icons/icons8-german-shepherd-96.png',
	  '/icons/icons8-home-50 (1).png',
	  '/icons/icons8-massage-96.png',
	  '/icons/icons8-massage-filled-70.png',
	  '/icons/icons8-mortar-and-pestle-100.png',
	  '/icons/icons8-mortar-and-pestle-96.png',
	  '/icons/icons8-nails-96.png',
	  '/icons/icons8-standing-man-filled-50 (1).png',
	  '/icons/icons8-standing-man-filled-50 (2).png',
	  '/icons/icons8-standing-man-filled-50.png',
	  '/icons/icons8-tattoo-machine-50.png',
	  '/icons/icons8-tattoo-machine-filled-70.png',
	  '/icons/icons8-tooth-50.png',
	  '/icons/icons8-tooth-filled-70.png',
	  '/icons/icons8-trash-20.png',
	  '/icons/nextIcon.png',
	  '/icons/icons8-workout-96.png'
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
        }).catch(() => {
	  return caches.match('/404.jsp');
        })
    );
});
