import 'package:dars9/services/motivation_notification.dart';
import 'package:flutter/material.dart';
import 'package:dars9/services/krp_service.dart';
import 'package:dars9/models/krp.dart';
import 'package:provider/provider.dart';

class MotivationScreen extends StatefulWidget {
  @override
  _MotivationScreenState createState() => _MotivationScreenState();
}

class _MotivationScreenState extends State<MotivationScreen> {
  late KrpService krpService;

  @override
  void initState() {
    super.initState();
    krpService = Provider.of<KrpService>(context, listen: false);
    scheduleDailyMotivation();
  }

  Future<void> scheduleDailyMotivation() async {
    List<Krp> quotes = await krpService.getKrp();
    if (quotes.isNotEmpty) {
      Krp quote = quotes.first; // Get the first quote for simplicity
      MotivationNotification.scheduleDailyNotification(
        id: 0,
        title: 'Daily Motivation',
        body: '${quote.text} - ${quote.author}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('KRP Daily Motivation')),
      body: Center(
          child:
              Text('Daily motivational quotes will be sent every 1 minutes')),
    );
  }
}
