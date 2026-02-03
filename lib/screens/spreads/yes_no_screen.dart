import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../services/card_service.dart';
import '../../models/card_models.dart';
import '../../widgets/tarot_card_widget.dart';

class YesNoScreen extends StatefulWidget {
  const YesNoScreen({super.key});

  @override
  State<YesNoScreen> createState() => _YesNoScreenState();
}

class _YesNoScreenState extends State<YesNoScreen> {
  TarotCard? _drawnCard;
  bool _isLoading = false;
  bool _hasDrawn = false;
  String _answer = '';

  Future<void> _drawCard() async {
    setState(() {
      _isLoading = true;
      _hasDrawn = false;
      _answer = '';
    });

    await Future.delayed(const Duration(milliseconds: 800));

    final cards = await CardService.drawTarotCards(1);
    if (cards.isNotEmpty) {
      final card = cards.first;
      final answer = _calculateAnswer(card);

      setState(() {
        _drawnCard = card;
        _answer = answer;
        _isLoading = false;
        _hasDrawn = true;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _calculateAnswer(TarotCard card) {
    // Positive cards (0-10, 17, 19, 21)
    const positiveCards = [0, 1, 3, 4, 6, 7, 8, 10, 17, 19, 21];

    if (card.isReversed) {
      return 'NO';
    } else if (positiveCards.contains(card.id)) {
      return 'YES';
    } else {
      return 'MAYBE';
    }
  }

  Color _getAnswerColor() {
    switch (_answer) {
      case 'YES':
        return Colors.green;
      case 'NO':
        return Colors.red;
      case 'MAYBE':
        return AppTheme.accent;
      default:
        return AppTheme.primary;
    }
  }

  String _getAnswerKorean() {
    switch (_answer) {
      case 'YES':
        return '긍정';
      case 'NO':
        return '부정';
      case 'MAYBE':
        return '신중히';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yes or No'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Yes or No',
                style: AppTheme.heading1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                '명확한 질문을 떠올리고\n답을 구해보세요',
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
                        '답을 찾고 있습니다...',
                        style: AppTheme.caption,
                      ),
                    ],
                  ),
                )
              else if (_hasDrawn && _drawnCard != null)
                _buildCardResult()
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
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: AppTheme.cardBack,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.help_outline,
              size: 80,
              color: AppTheme.primary,
            ),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 2000.ms, color: AppTheme.secondary),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _drawCard,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              child: Text('답 구하기'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardResult() {
    if (_drawnCard == null) return const SizedBox();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          decoration: BoxDecoration(
            color: _getAnswerColor().withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _getAnswerColor(),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Text(
                _answer,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  color: _getAnswerColor(),
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _getAnswerKorean(),
                style: AppTheme.heading3.copyWith(
                  color: _getAnswerColor(),
                ),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms)
            .scale(begin: const Offset(0.5, 0.5)),
        const SizedBox(height: 32),
        TarotCardWidget(card: _drawnCard!)
            .animate()
            .fadeIn(duration: 400.ms, delay: 300.ms)
            .scale(begin: const Offset(0.8, 0.8)),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: AppTheme.cardDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _drawnCard!.displayName,
                      style: AppTheme.heading2,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _drawnCard!.isReversed
                          ? AppTheme.accent.withValues(alpha: 0.1)
                          : AppTheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _drawnCard!.position,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _drawnCard!.isReversed
                            ? AppTheme.accent
                            : AppTheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _drawnCard!.nameEn,
                style: AppTheme.caption.copyWith(
                  color: AppTheme.secondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _drawnCard!.keywords.map((keyword) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme.secondary,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      keyword,
                      style: AppTheme.goldAccent.copyWith(fontSize: 12),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),
              Text(
                '카드의 메시지',
                style: AppTheme.heading3,
              ),
              const SizedBox(height: 12),
              Text(
                _drawnCard!.description,
                style: AppTheme.body,
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 500.ms)
            .slideY(begin: 0.2, end: 0),
        const SizedBox(height: 24),
        OutlinedButton(
          onPressed: () {
            setState(() {
              _drawnCard = null;
              _hasDrawn = false;
              _answer = '';
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
}
