import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/card_models.dart';

class TarotCardWidget extends StatelessWidget {
  final TarotCard card;
  final double width;
  final double height;

  const TarotCardWidget({
    super.key,
    required this.card,
    this.width = 200,
    this.height = 280,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: card.isReversed ? 3.14159 : 0, // 180 degrees in radians
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.surface,
              AppTheme.primary.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.secondary,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getCardIcon(card.id),
              size: 80,
              color: AppTheme.primary,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                card.displayName,
                style: AppTheme.heading3.copyWith(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              card.nameEn,
              style: AppTheme.caption.copyWith(
                color: AppTheme.secondary,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCardIcon(int cardId) {
    const icons = [
      Icons.emoji_emotions, // 0 - The Fool
      Icons.auto_fix_high, // 1 - The Magician
      Icons.auto_awesome, // 2 - The High Priestess
      Icons.favorite, // 3 - The Empress
      Icons.shield, // 4 - The Emperor
      Icons.menu_book, // 5 - The Hierophant
      Icons.volunteer_activism, // 6 - The Lovers
      Icons.directions_car, // 7 - The Chariot
      Icons.fitness_center, // 8 - Strength
      Icons.psychology, // 9 - The Hermit
      Icons.refresh, // 10 - Wheel of Fortune
      Icons.balance, // 11 - Justice
      Icons.swap_vert, // 12 - The Hanged Man
      Icons.transform, // 13 - Death
      Icons.tune, // 14 - Temperance
      Icons.warning, // 15 - The Devil
      Icons.flash_on, // 16 - The Tower
      Icons.star, // 17 - The Star
      Icons.nightlight, // 18 - The Moon
      Icons.wb_sunny, // 19 - The Sun
      Icons.campaign, // 20 - Judgement
      Icons.public, // 21 - The World
    ];

    return cardId < icons.length ? icons[cardId] : Icons.auto_awesome;
  }
}

class CardBackWidget extends StatelessWidget {
  final double width;
  final double height;

  const CardBackWidget({
    super.key,
    this.width = 200,
    this.height = 280,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.cardBack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.divider,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(
        Icons.auto_awesome,
        size: 64,
        color: AppTheme.primary,
      ),
    );
  }
}
