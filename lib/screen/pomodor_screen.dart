import 'package:flutter/material.dart';
import 'package:dars9/services/pomodoro_notification_service.dart';

class PomodoroHomeScreen extends StatefulWidget {
  @override
  _PomodoroHomeScreenState createState() => _PomodoroHomeScreenState();
}

class _PomodoroHomeScreenState extends State<PomodoroHomeScreen> {
  final PomodoroNotificationService _pomodoroNotificationService =
      PomodoroNotificationService();

  @override
  void initState() {
    super.initState();
    _pomodoroNotificationService.repeatPomodoroReminder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pomodoro Timer'),
      ),
      body: Center(
        child: Text('Pomodoro Timer is running. Take breaks every 5 secund.'),
      ),
    );
  }
}
