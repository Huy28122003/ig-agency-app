import 'dart:js_interop';
import 'package:web/web.dart' as web;

class NotificationWebServices {
  static Future<bool> requestPermission() async {
    try {
      // Kiểm tra service worker
      final registrations =  web.window.navigator.serviceWorker.getRegistrations();
      print("ServiceWorker registrations: $registrations");
      // permission: 'default' | 'granted' | 'denied'
      final String current = web.Notification.permission;
      if (current == 'granted') return true;

      // requestPermission(): Promise<'default' | 'granted' | 'denied'>
      final jsResult = await web.Notification.requestPermission().toDart;
      final String result = jsResult.toDart; // convert JSString -> String
      return result == 'granted';
    } catch (e) {
      return false;
    }
  }
}
