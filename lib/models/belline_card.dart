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

  String get displayName => '$cardNumber. $nameKo';
}
