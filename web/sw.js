var cacheName = 'Queue Cache';


//on application istall_to-home-screen event handler
self.addEventListener('install', function(event) {
  event.waitUntil(
    caches.open(cacheName).then(function(cache) {
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
          'scripts/ChangeProfileInformationFormDiv.js'
        ]
      );
    })
  );
});


//another event listener
self.addEventListener('', event => {
    console.log(event);
    
});


//another event listener 
self.addEventListener('', event => {
    console.log(event);
});