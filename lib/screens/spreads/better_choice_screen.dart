import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../services/card_service.dart';
import '../../models/card_models.dart';
import '../../widgets/tarot_card_widget.dart';

class BetterChoiceScreen extends StatefulWidget {
  const BetterChoiceScreen({super.key});

  @override
  State<BetterChoiceScreen> createState() => _BetterChoiceScreenState();
}

class _BetterChoiceScreenState extends State<BetterChoiceScreen> {
  final TextEditingController _choice1Controller = TextEditingController();
  final TextEditingController _choice2Controller = TextEditingController();

  List<TarotCard> _choice1Cards = [];
  List<TarotCard> _choice2Cards = [];
  bool _isLoading = false;
  bool _hasDrawn = false;
  int _betterChoice = 0; // 1 or 2

  @override
  void dispose() {
    _choice1Controller.dispose();
    _choice2Controller.dispose();
    super.dispose();
  }

  Future<void> _drawCards() async {
    if (_choice1Controller.text.trim().isEmpty ||
        _choice2Controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('두 가지 선택지를 모두 입력해주세요'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _hasDrawn = false;
    });

    await Future.delayed(const Duration(milliseconds: 1500));

    final allCards = await CardService.drawTarotCards(6);
    if (allCards.length == 6) {
      final choice1 = allCards.sublist(0, 3);
      final choice2 = allCards.sublist(3, 6);

      final score1 = _calculateScore(choice1);
      final score2 = _calculateScore(choice2);

      setState(() {
        _choice1Cards = choice1;
        _choice2Cards = choice2;
        _betterChoice = score1 >= score2 ? 1 : 2;
        _isLoading = false;
        _hasDrawn = true;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  int _calculateScore(List<TarotCard> cards) {
    int score = 0;
    const positiveCards = [0, 1, 3, 4, 6, 7, 8, 10, 17, 19, 21];

    for (var card in cards) {
      if (card.isReversed) {
        score -= 1;
      } else if (positiveCards.contains(card.id)) {
        score += 2;
      } else {
        score += 1;
      }
    }

    return score;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('양자택일'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '두 가지 선택',
                style: AppTheme.heading1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                '고민되는 두 가지 선택을\n비교해보세요',
                style: AppTheme.body.copyWith(
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              if (!_hasDrawn) _buildInputForm(),
              if (_isLoading)
                Center(
                  child: Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        '두 가지 길을 살펴보고 있습니다...',
                        style: AppTheme.caption,
                      ),
                    ],
                  ),
                )
              else if (_hasDrawn)
                _buildComparisonResult(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputForm() {
    return Column(
      children: [
        TextField(
          controller: _choice1Controller,
          decoration: InputDecoration(
            labelText: '선택지 1',
            hintText: '예: 이직하기',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primary, width: 2),
            ),
          ),
          maxLength: 20,
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _choice2Controller,
          decoration: InputDecoration(
            labelText: '선택지 2',
            hintText: '예: 현재 직장 유지',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primary, width: 2),
            ),
          ),
          maxLength: 20,
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: _drawCards,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
            child: Text('카드 비교하기'),
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonResult() {
    return Column(
      children: [
        _buildChoiceSection(
          choice: 1,
          title: _choice1Controller.text,
          cards: _choice1Cards,
          isBetter: _betterChoice == 1,
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.secondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.auto_awesome,
                color: AppTheme.secondary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'VS',
                style: AppTheme.heading2.copyWith(
                  color: AppTheme.secondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.auto_awesome,
                color: AppTheme.secondary,
                size: 24,
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 1000.ms)
            .scale(begin: const Offset(0.8, 0.8)),
        const SizedBox(height: 32),
        _buildChoiceSection(
          choice: 2,
          title: _choice2Controller.text,
          cards: _choice2Cards,
          isBetter: _betterChoice == 2,
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: AppTheme.cardDecoration.copyWith(
            color: AppTheme.secondary.withValues(alpha: 0.05),
          ),
          child: Column(
            children: [
              Icon(
                Icons.tips_and_updates,
                size: 48,
                color: AppTheme.secondary,
              ),
              const SizedBox(height: 16),
              Text(
                '뮤너의 조언',
                style: AppTheme.heading2.copyWith(
                  color: AppTheme.secondary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '카드들은 "${_betterChoice == 1 ? _choice1Controller.text : _choice2Controller.text}"이(가) 현재 당신에게 더 긍정적인 에너지를 가져다줄 것이라고 말하고 있습니다.',
                style: AppTheme.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '하지만 최종 선택은 당신의 직관과 상황을 고려하여 결정하세요.',
                style: AppTheme.caption.copyWith(
                  color: AppTheme.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 800.ms, delay: 2000.ms)
            .slideY(begin: 0.2, end: 0),
        const SizedBox(height: 24),
        OutlinedButton(
          onPressed: () {
            setState(() {
              _choice1Cards = [];
              _choice2Cards = [];
              _hasDrawn = false;
              _betterChoice = 0;
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
          child: const Text('다시 비교하기'),
        ),
      ],
    );
  }

  Widget _buildChoiceSection({
    required int choice,
    required String title,
    required List<TarotCard> cards,
    required bool isBetter,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration.copyWith(
        border: isBetter
            ? Border.all(color: AppTheme.secondary, width: 2)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.heading2.copyWith(fontSize: 20),
                ),
              ),
              if (isBetter)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.secondary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.recommend,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '추천',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 1800.ms)
                    .scale(begin: const Offset(0.5, 0.5)),
            ],
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: TarotCardWidget(
                    card: cards[index],
                    width: 90,
                    height: 126,
                  )
                      .animate()
                      .fadeIn(
                        duration: 400.ms,
                        delay: ((choice - 1) * 800 + index * 200).ms,
                      )
                      .scale(begin: const Offset(0.8, 0.8)),
                );
              }),
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(3, (index) {
            final card = cards[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                card.displayName,
                                style: AppTheme.heading3.copyWith(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Text(
                              card.position,
                              style: TextStyle(
                                fontSize: 10,
                                color: card.isReversed
                                    ? AppTheme.accent
                                    : AppTheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          card.keywords.join(', '),
                          style: AppTheme.caption.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: ((choice - 1) * 800).ms)
        .slideY(begin: 0.2, end: 0);
  }
}
