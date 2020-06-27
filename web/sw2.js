const dynamicCacheName = 'S2site-dynamic-v1';

//cache size limit function
const limitCacheSize = (name, size) => {
	caches.open(name).then(cache => {
	cache.keys().then(keys => {
	    if(keys.length > size){
				cache.delete(keys[20]).then(()=>{
					limitCacheSize(name, size);
				});
			}
		});
	});
}
//
//install service worker
self.addEventListener('install', function(event) {
  console.log("sw2 installed");
});


//activate service worker
self.addEventListener('activate', evt => {
  //console.log('service worker activated');
  evt.waitUntil(
    caches.keys().then(keys => {
      //console.log(keys);
      return Promise.all(keys
        .filter(key => key !== dynamicCacheName)
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
			
        return fetch(event.request).then(fetchRes => {
				return caches.open(dynamicCacheName).then(cache => {
					
					return cache.keys().then(keys => {
						//console.log(keys);
						if(keys.length > 100){
							//console.log("keys greater than 10");
							cache.put(event.request.url, fetchRes.clone());
							cache.delete(keys[0]);
							return fetchRes
						}else{
							cache.put(event.request.url, fetchRes.clone());
							return fetchRes
						}
					});
					
				});
			}).catch(() => {
			    return cacheRes || caches.match('/404.jsp');
		    });
		  
        })
    );
});

