import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:snapbook/splash.dart';
import 'package:snapbook/utils/constants/text_strings.dart';
import 'package:snapbook/utils/theme/theme.dart';
import 'package:timezone/data/latest_10y.dart';

FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeTimeZones(); // Initialize time zones from the timezone package

  final androidSettings = AndroidInitializationSettings("@mipmap/ic_launcher");
  final iosSettings = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestCriticalPermission: true,
    requestSoundPermission: true,
  );

  final initSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await notificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (response) {
      print("Tapped notification: ${response.payload}");
    },
  );

  // 🔔 Create Notification Channel (for Android >= Oreo)
  await notificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(
        AndroidNotificationChannel(
          "notifications-youtube", // Unique channel ID
          "YouTube Notifications", // Channel name
          description: "This channel is used for general notifications",
          importance: Importance.max, // Maximum importance
        ),
      );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: TTexts.appName,
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
