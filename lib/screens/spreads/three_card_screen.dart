import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../services/card_service.dart';
import '../../models/card_models.dart';
import '../../widgets/tarot_card_widget.dart';

class ThreeCardScreen extends StatefulWidget {
  const ThreeCardScreen({super.key});

  @override
  State<ThreeCardScreen> createState() => _ThreeCardScreenState();
}

class _ThreeCardScreenState extends State<ThreeCardScreen> {
  List<TarotCard> _drawnCards = [];
  bool _isLoading = false;
  bool _hasDrawn = false;

  final List<String> _positions = ['과거', '현재', '미래'];
  final List<String> _descriptions = [
    '지나온 상황과 배경',
    '현재의 에너지와 상태',
    '다가올 가능성',
  ];

  Future<void> _drawCards() async {
    setState(() {
      _isLoading = true;
      _hasDrawn = false;
    });

    await Future.delayed(const Duration(milliseconds: 1200));

    final cards = await CardService.drawTarotCards(3);
    if (cards.length == 3) {
      setState(() {
        _drawnCards = cards;
        _isLoading = false;
        _hasDrawn = true;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('3카드 스프레드'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '과거, 현재, 미래',
                style: AppTheme.heading1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                '시간의 흐름 속에서\n당신의 이야기를 읽어보세요',
                style: AppTheme.body.copyWith(
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              if (_isLoading)
                Center(
                  child: Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        '카드를 섞고 있습니다...',
                        style: AppTheme.caption,
                      ),
                    ],
                  ),
                )
              else if (_hasDrawn && _drawnCards.length == 3)
                _buildCardsResult()
              else
                _buildDrawButton(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawButton() {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: CardBackWidget(width: 100, height: 140),
              );
            }),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 2000.ms, color: AppTheme.secondary),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _drawCards,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              child: Text('카드 뽑기'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardsResult() {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    TarotCardWidget(
                      card: _drawnCards[index],
                      width: 100,
                      height: 140,
                    )
                        .animate()
                        .fadeIn(duration: 400.ms, delay: (index * 200).ms)
                        .scale(begin: const Offset(0.8, 0.8)),
                    const SizedBox(height: 12),
                    Text(
                      _positions[index],
                      style: AppTheme.goldAccent,
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 32),
        ...List.generate(3, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildCardDetail(index),
          );
        }),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () {
            setState(() {
              _drawnCards = [];
              _hasDrawn = false;
            });
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.primary,
            side: const BorderSide(color: AppTheme.primary),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('다시 뽑기'),
        ),
      ],
    );
  }

  Widget _buildCardDetail(int index) {
    final card = _drawnCards[index];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.secondary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _positions[index],
                  style: AppTheme.goldAccent.copyWith(fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _descriptions[index],
                  style: AppTheme.caption,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  card.displayName,
                  style: AppTheme.heading3.copyWith(fontSize: 18),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: card.isReversed
                      ? AppTheme.accent.withValues(alpha: 0.1)
                      : AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  card.position,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: card.isReversed
                        ? AppTheme.accent
                        : AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: card.keywords.map((keyword) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.secondary.withValues(alpha: 0.5),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  keyword,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Text(
            card.description,
            style: AppTheme.body.copyWith(fontSize: 14),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: (index * 150 + 400).ms)
        .slideY(begin: 0.2, end: 0);
  }
}
