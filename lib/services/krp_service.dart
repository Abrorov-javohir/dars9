import 'dart:convert';

import 'package:dars9/models/krp.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class KrpService extends ChangeNotifier {
  final url = "https://type.fit/api/quotes";

  Future<List<Krp>> getKrp() async {
    final connect = Uri.parse(url);
    final data = await http.get(connect);
    if (data.statusCode == 200) {
      List decode = jsonDecode(data.body);
      return decode.map<Krp>((json) => Krp.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load quotes');
    }
  }
}
