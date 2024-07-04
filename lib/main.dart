import 'package:dars9/firebase_options.dart';
import 'package:dars9/screen/home_screen.dart';
import 'package:dars9/services/krp_service.dart';
import 'package:dars9/services/local_notification_service.dart';
import 'package:dars9/services/motivation_notification.dart';
import 'package:dars9/services/note_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifictionSerivce.requestPermission();
  await LocalNotifictionSerivce.start();
  await MotivationNotification.requestPermission();
  await MotivationNotification.start();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  MotivationNotification.scheduleDailyNotification(
    id: 0,
    title: 'Your Daily Motivation',
    body: 'Stay motivated and keep coding!',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Notesservice(),
        ),
        ChangeNotifierProvider(
          create: (context) => KrpService(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
