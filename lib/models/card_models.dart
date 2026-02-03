class TarotCard {
  final int id;
  final String nameKo;
  final String nameEn;
  final List<String> keywords;
  final String descUpright;
  final String descReversed;
  bool isReversed;

  TarotCard({
    required this.id,
    required this.nameKo,
    required this.nameEn,
    required this.keywords,
    required this.descUpright,
    required this.descReversed,
    this.isReversed = false,
  });

  factory TarotCard.fromJson(Map<String, dynamic> json) {
    return TarotCard(
      id: json['id'] as int,
      nameKo: json['name_ko'] as String,
      nameEn: json['name_en'] as String,
      keywords: List<String>.from(json['keywords'] as List),
      descUpright: json['desc_upright'] as String,
      descReversed: json['desc_reversed'] as String,
      isReversed: false,
    );
  }

  String get description => isReversed ? descReversed : descUpright;
  String get displayName => nameKo;
  String get position => isReversed ? '역방향' : '정방향';
}

class BellineCard {
  final int cardNumber;
  final String nameKo;
  final String planet;
  final String advice;

  BellineCard({
    required this.cardNumber,
    required this.nameKo,
    required this.planet,
    required this.advice,
  });

  factory BellineCard.fromJson(Map<String, dynamic> json) {
    return BellineCard(
      cardNumber: json['card_number'] as int,
      nameKo: json['name_ko'] as String,
      planet: json['planet'] as String,
      advice: json['advice'] as String,
    );
  }
}
