import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const localNotificationChannel = "high_importance_channel";
const localNotificationChannelTitle = "High Importance Notifications";
const localNotificationChannelDescription =
    "This channel is used for important notifications.";

class FCMService {
  static final FCMService _singleton = FCMService._internal();

  factory FCMService() {
    return _singleton;
  }

  FCMService._internal();

  /// Firebase Messaging Instance
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  /// Android Notification Channel
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    localNotificationChannel,
    localNotificationChannelTitle,
    description: localNotificationChannelDescription,
    importance: Importance.max,
  );

  /// Flutter Notification Plugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Android Initialization Settings
  AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('ic_launcher');

  void listenForMessages() async {
    await initFlutterLocalNotification();
    await registerChannel();

    messaging.getToken().then((fcmToken) {
      debugPrint("FCM Token for Device ======> $fcmToken");
    });

    FirebaseMessaging.onMessage.listen((remoteMessage) {
      debugPrint("Notification Sent From Server while in foreground");
      RemoteNotification? notification = remoteMessage.notification;
      AndroidNotification? android = remoteMessage.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: android.smallIcon,
              ),
            ),
            payload: "This is notification payLoad");
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      debugPrint(
          "User pressed the notification ${remoteMessage.notification?.title}");
    });

    messaging.getInitialMessage().then((remoteMessage) {
      debugPrint("Message Launched ${remoteMessage?.notification?.title}");
    });
  }

  Future initFlutterLocalNotification() {
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: null,
      macOS: null,
    );
    return flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (notification) {
      debugPrint("Local Notification Clicked =====> $notification");
    });
  }

  Future? registerChannel() {
    return flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
}
