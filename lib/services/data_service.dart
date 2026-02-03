import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/tarot_card.dart';
import '../models/belline_card.dart';

class DataService {
  static Future<List<TarotCard>> loadTarotCards() async {
    final String response =
        await rootBundle.loadString('assets/data/tarot_data.json');
    final List<dynamic> data = json.decode(response) as List;
    return data.map((json) => TarotCard.fromJson(json as Map<String, dynamic>)).toList();
  }

  static Future<List<BellineCard>> loadBellineCards() async {
    final String response =
        await rootBundle.loadString('assets/data/belline_data.json');
    final List<dynamic> data = json.decode(response) as List;
    return data.map((json) => BellineCard.fromJson(json as Map<String, dynamic>)).toList();
  }
}
