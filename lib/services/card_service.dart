import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/card_models.dart';

class CardService {
  static List<TarotCard>? _tarotCards;
  static List<BellineCard>? _bellineCards;

  // Load Tarot Cards
  static Future<List<TarotCard>> loadTarotCards() async {
    if (_tarotCards != null) return _tarotCards!;

    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/tarot_cards.json');
      final List<dynamic> jsonData = json.decode(jsonString) as List;
      _tarotCards = jsonData.map((json) => TarotCard.fromJson(json as Map<String, dynamic>)).toList();
      return _tarotCards!;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error loading tarot cards: $e');
      }
      return [];
    }
  }

  // Load Belline Cards
  static Future<List<BellineCard>> loadBellineCards() async {
    if (_bellineCards != null) return _bellineCards!;

    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/belline_cards.json');
      final List<dynamic> jsonData = json.decode(jsonString) as List;
      _bellineCards = jsonData.map((json) => BellineCard.fromJson(json as Map<String, dynamic>)).toList();
      return _bellineCards!;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error loading belline cards: $e');
      }
      return [];
    }
  }

  // Shuffle and draw Tarot cards
  static Future<List<TarotCard>> drawTarotCards(int count) async {
    final cards = await loadTarotCards();
    if (cards.isEmpty) return [];

    final shuffled = List<TarotCard>.from(cards)..shuffle();
    final drawn = shuffled.take(count).toList();

    // Randomly set reversed state (30% chance)
    final random = Random();
    for (var card in drawn) {
      card.isReversed = random.nextDouble() < 0.3;
    }

    return drawn;
  }

  // Draw a single Belline card
  static Future<BellineCard?> drawBellineCard() async {
    final cards = await loadBellineCards();
    if (cards.isEmpty) return null;

    final shuffled = List<BellineCard>.from(cards)..shuffle();
    return shuffled.first;
  }

  // Draw multiple Belline cards
  static Future<List<BellineCard>> drawBellineCards(int count) async {
    final cards = await loadBellineCards();
    if (cards.isEmpty) return [];

    final shuffled = List<BellineCard>.from(cards)..shuffle();
    return shuffled.take(count).toList();
  }
}
