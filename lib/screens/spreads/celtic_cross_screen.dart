import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../services/card_service.dart';
import '../../models/card_models.dart';
import '../../widgets/tarot_card_widget.dart';

class CelticCrossScreen extends StatefulWidget {
  const CelticCrossScreen({super.key});

  @override
  State<CelticCrossScreen> createState() => _CelticCrossScreenState();
}

class _CelticCrossScreenState extends State<CelticCrossScreen> {
  List<TarotCard> _drawnCards = [];
  bool _isLoading = false;
  bool _hasDrawn = false;

  final List<String> _positions = [
    '현재 상황',
    '도전과 장애',
    '과거의 영향',
    '미래의 가능성',
    '내면의 의지',
    '외부의 영향',
    '조언',
    '주변 환경',
    '희망과 두려움',
    '최종 결과',
  ];

  Future<void> _drawCards() async {
    setState(() {
      _isLoading = true;
      _hasDrawn = false;
    });

    await Future.delayed(const Duration(milliseconds: 1500));

    final cards = await CardService.drawTarotCards(10);
    if (cards.length == 10) {
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
        title: const Text('켈틱 크로스'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '켈틱 크로스 스프레드',
                style: AppTheme.heading1.copyWith(fontSize: 28),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                '상황을 깊이 있게 살펴보세요',
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
              else if (_hasDrawn && _drawnCards.length == 10)
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
          Container(
            width: 150,
            height: 150,
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
              Icons.grid_view,
              size: 64,
              color: AppTheme.primary,
            ),
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
        _buildCelticCrossLayout(),
        const SizedBox(height: 32),
        Text(
          '카드 해석',
          style: AppTheme.heading2,
        ),
        const SizedBox(height: 16),
        ...List.generate(10, (index) {
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

  Widget _buildCelticCrossLayout() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration.copyWith(
        color: AppTheme.background,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left side: Cross formation (cards 0-5)
            SizedBox(
              width: 280,
              height: 280,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Card 0: Center
                  Positioned(
                    left: 90,
                    top: 90,
                    child: _buildSmallCard(0)
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 0.ms)
                        .scale(begin: const Offset(0.5, 0.5)),
                  ),
                  // Card 1: Crossing (horizontal)
                  Positioned(
                    left: 90,
                    top: 90,
                    child: Transform.rotate(
                      angle: 1.5708, // 90 degrees
                      child: _buildSmallCard(1)
                          .animate()
                          .fadeIn(duration: 400.ms, delay: 200.ms)
                          .scale(begin: const Offset(0.5, 0.5)),
                    ),
                  ),
                  // Card 2: Top
                  Positioned(
                    left: 90,
                    top: 0,
                    child: _buildSmallCard(2)
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 400.ms)
                        .slideY(begin: -0.5, end: 0),
                  ),
                  // Card 3: Bottom
                  Positioned(
                    left: 90,
                    top: 180,
                    child: _buildSmallCard(3)
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 600.ms)
                        .slideY(begin: 0.5, end: 0),
                  ),
                  // Card 4: Left
                  Positioned(
                    left: 0,
                    top: 90,
                    child: _buildSmallCard(4)
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 800.ms)
                        .slideX(begin: -0.5, end: 0),
                  ),
                  // Card 5: Right
                  Positioned(
                    left: 180,
                    top: 90,
                    child: _buildSmallCard(5)
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 1000.ms)
                        .slideX(begin: 0.5, end: 0),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            // Right side: Staff formation (cards 6-9)
            Column(
              children: [
                _buildSmallCard(6)
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 1200.ms)
                    .slideY(begin: 0.3, end: 0),
                const SizedBox(height: 8),
                _buildSmallCard(7)
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 1400.ms)
                    .slideY(begin: 0.3, end: 0),
                const SizedBox(height: 8),
                _buildSmallCard(8)
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 1600.ms)
                    .slideY(begin: 0.3, end: 0),
                const SizedBox(height: 8),
                _buildSmallCard(9)
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 1800.ms)
                    .slideY(begin: 0.3, end: 0),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallCard(int index) {
    return TarotCardWidget(
      card: _drawnCards[index],
      width: 80,
      height: 112,
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
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppTheme.secondary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _positions[index],
                  style: AppTheme.heading3.copyWith(fontSize: 16),
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
          const SizedBox(height: 12),
          Text(
            card.displayName,
            style: AppTheme.heading3.copyWith(
              fontSize: 18,
              color: AppTheme.secondary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: card.keywords.map((keyword) {
              return Text(
                '#$keyword',
                style: AppTheme.caption.copyWith(
                  color: AppTheme.textSecondary,
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
        .fadeIn(duration: 500.ms, delay: (index * 100 + 2000).ms)
        .slideY(begin: 0.2, end: 0);
  }
}
