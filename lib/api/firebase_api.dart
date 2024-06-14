import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flicky/features/landing/home.page.dart';
import 'package:flicky/helpers/utils.dart';
import 'package:go_router/go_router.dart';

void handleMessage(RemoteMessage? message){
  if (message == null) return;
  GoRouter.of(Utils.mainNav.currentContext!).go(HomePage.route);
}

Future initPushNotifications() async {
  await FirebaseMessaging.instance
    .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

  FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Title: ${message.notification?.body}');
  print('Title: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');

    initPushNotifications();
  }
}
