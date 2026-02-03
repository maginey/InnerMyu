import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../services/card_service.dart';
import '../../models/card_models.dart';
import '../../widgets/tarot_card_widget.dart';

class DailySpreadScreen extends StatefulWidget {
  const DailySpreadScreen({super.key});

  @override
  State<DailySpreadScreen> createState() => _DailySpreadScreenState();
}

class _DailySpreadScreenState extends State<DailySpreadScreen> {
  TarotCard? _drawnCard;
  bool _isLoading = false;
  bool _hasDrawn = false;

  Future<void> _drawCard() async {
    setState(() {
      _isLoading = true;
      _hasDrawn = false;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    final cards = await CardService.drawTarotCards(1);
    if (cards.isNotEmpty) {
      setState(() {
        _drawnCard = cards.first;
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
        title: const Text('오늘의 운세'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '오늘 하루의 에너지',
                style: AppTheme.heading1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                '마음을 차분히 하고\n카드를 뽑아보세요',
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
            height: 280,
            decoration: BoxDecoration(
              color: AppTheme.cardBack,
              borderRadius: BorderRadius.circular(16),
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
          )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 2000.ms, color: AppTheme.secondary),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _drawCard,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              child: Text('카드 뽑기'),
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
        TarotCardWidget(card: _drawnCard!)
            .animate()
            .fadeIn(duration: 400.ms)
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
                '해석',
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
            .fadeIn(duration: 600.ms, delay: 200.ms)
            .slideY(begin: 0.2, end: 0),
        const SizedBox(height: 24),
        OutlinedButton(
          onPressed: () {
            setState(() {
              _drawnCard = null;
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
}
