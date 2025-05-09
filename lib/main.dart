import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:snapbook/splash.dart';
import 'package:snapbook/utils/constants/text_strings.dart';
import 'package:snapbook/utils/theme/theme.dart';
import 'package:timezone/data/latest_10y.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();

  tz_data.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'scheduled_channel',
      channelName: 'Scheduled Notifications',
      channelDescription: 'Channel for scheduled reminders',
      importance: NotificationImportance.Max,
      defaultColor: Colors.blue,
      ledColor: Colors.white,
      playSound: true,
      enableVibration: true,
      criticalAlerts: true,
      locked: true,
      defaultRingtoneType: DefaultRingtoneType.Alarm,
    ),
  ]);

  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
    isAllowed = await AwesomeNotifications().isNotificationAllowed();
  }

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
      // initialRoute: AppRoutes.splash,
      // getPages: AppRoutes.routes,
    );
  }
}
