importScripts("https://www.gstatic.com/firebasejs/9.6.10/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.6.10/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyAuBpERSCO-EiTRYa741iIsNTAusYxzH-s",
  authDomain: "ig-agency-7a016.firebaseapp.com",
  projectId: "ig-agency-7a016",
  storageBucket: "ig-agency-7a016.appspot.com",
  messagingSenderId: "275257763877",
  appId: "1:275257763877:web:f2aef1a198b2ccacefb7cc",
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log("[firebase-messaging-sw.js] Received background message ", payload);
  const notificationTitle = payload.notification?.title || "New Message";
  const notificationOptions = {
    body: payload.notification?.body,
    icon: "/icons/Icon-192.png",
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
