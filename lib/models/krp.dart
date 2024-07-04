import 'dart:convert';

import 'package:flutter/foundation.dart';

class Krp  {
  String text;
  String author;

  Krp({
    required this.text,
    required this.author,
  });

  factory Krp.fromJson(Map<String, dynamic> json) {
    return Krp(
      text: json['text'],
      author: json['author'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'author': author,
    };
  }
}

List<Krp> krpFromJson(String str) {
  return List<Krp>.from(
    json.decode(str).map((x) => Krp.fromJson(x)),
  );
}

String krpToJson(List<Krp> data) {
  return json.encode(
    List<dynamic>.from(data.map((x) => x.toJson())),
  );
}