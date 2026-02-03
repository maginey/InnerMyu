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
    );
  }

  String get displayName => nameKo;
  String get description => isReversed ? descReversed : descUpright;
}
