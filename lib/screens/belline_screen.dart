import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../services/card_service.dart';
import '../models/card_models.dart';

class BellineScreen extends StatefulWidget {
  const BellineScreen({super.key});

  @override
  State<BellineScreen> createState() => _BellineScreenState();
}

class _BellineScreenState extends State<BellineScreen> {
  BellineCard? _drawnCard;
  bool _isLoading = false;
  bool _hasDrawn = false;

  Future<void> _drawCard() async {
    setState(() {
      _isLoading = true;
      _hasDrawn = false;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    final card = await CardService.drawBellineCard();
    if (card != null) {
      setState(() {
        _drawnCard = card;
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
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '오라클 벨린',
                    style: AppTheme.heading1,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '운명의 별들이 전하는 조언',
                    style: AppTheme.body.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isLoading)
                    Column(
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          '별들의 메시지를 듣고 있습니다...',
                          style: AppTheme.caption,
                        ),
                      ],
                    )
                  else if (_hasDrawn && _drawnCard != null)
                    _buildCardResult()
                  else
                    _buildDrawButton(),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawButton() {
    return Column(
      children: [
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.accent.withValues(alpha: 0.2),
                AppTheme.primary.withValues(alpha: 0.2),
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.accent.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.stars,
            size: 80,
            color: AppTheme.accent,
          ),
        )
            .animate(onPlay: (controller) => controller.repeat())
            .shimmer(duration: 2000.ms, color: AppTheme.secondary)
            .then()
            .scale(
              duration: 2000.ms,
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.1, 1.1),
            )
            .then()
            .scale(
              duration: 2000.ms,
              begin: const Offset(1.1, 1.1),
              end: const Offset(1.0, 1.0),
            ),
        const SizedBox(height: 32),
        Text(
          '마음을 차분히 하고\n카드를 뽑아보세요',
          style: AppTheme.body.copyWith(
            color: AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: _drawCard,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accent,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
          ),
          child: const Text(
            '카드 뽑기',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardResult() {
    if (_drawnCard == null) return const SizedBox();

    return Column(
      children: [
        _buildBellineCardWidget()
            .animate()
            .fadeIn(duration: 600.ms)
            .scale(begin: const Offset(0.8, 0.8)),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(28),
          decoration: AppTheme.cardDecoration.copyWith(
            border: Border.all(
              color: AppTheme.accent.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.accent.withValues(alpha: 0.2),
                          AppTheme.primary.withValues(alpha: 0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.brightness_1,
                          size: 12,
                          color: AppTheme.accent,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${_drawnCard!.cardNumber}번',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (_drawnCard!.planet != 'None')
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.trip_origin,
                            size: 14,
                            color: AppTheme.secondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _drawnCard!.planet,
                            style: AppTheme.goldAccent.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                _drawnCard!.nameKo,
                style: AppTheme.heading1.copyWith(
                  fontSize: 28,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: AppTheme.accent,
                      size: 28,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '벨린의 조언',
                            style: AppTheme.heading3.copyWith(
                              fontSize: 16,
                              color: AppTheme.accent,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _drawnCard!.advice,
                            style: AppTheme.body.copyWith(
                              fontSize: 15,
                              height: 1.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 700.ms, delay: 300.ms)
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
            foregroundColor: AppTheme.accent,
            side: const BorderSide(color: AppTheme.accent),
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

  Widget _buildBellineCardWidget() {
    return Container(
      width: 220,
      height: 300,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.surface,
            AppTheme.accent.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.accent,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accent.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.accent.withValues(alpha: 0.2),
                  AppTheme.primary.withValues(alpha: 0.2),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getBellineIcon(_drawnCard!.cardNumber),
              size: 56,
              color: AppTheme.accent,
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              _drawnCard!.nameKo,
              style: AppTheme.heading2.copyWith(
                fontSize: 20,
                color: AppTheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          if (_drawnCard!.planet != 'None')
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppTheme.secondary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _drawnCard!.planet,
                style: AppTheme.goldAccent.copyWith(
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  IconData _getBellineIcon(int cardNumber) {
    const icons = [
      Icons.vpn_key, // 1 - 운명 (열쇠)
      Icons.man, // 2 - 남자의 별
      Icons.woman, // 3 - 여자의 별
      Icons.celebration, // 4 - 행운
      Icons.favorite, // 5 - 사랑
      Icons.card_giftcard, // 6 - 선물
      Icons.mail, // 7 - 편지
      Icons.sentiment_dissatisfied, // 8 - 상실
      Icons.healing, // 9 - 질병
      Icons.attach_money, // 10 - 돈
      Icons.warning, // 11 - 적
      Icons.flight, // 12 - 여행
      Icons.transform, // 13 - 변화
      Icons.business, // 14 - 사업
      Icons.emoji_emotions, // 15 - 희망
      Icons.favorite_border, // 16 - 결혼
      Icons.fork_right, // 17 - 선택
      Icons.gavel, // 18 - 법
      Icons.emoji_events, // 19 - 성공
      Icons.home, // 20 - 가족
      Icons.block, // 21 - 배신
      Icons.new_releases, // 22 - 시작
      Icons.check_circle, // 23 - 끝
      Icons.school, // 24 - 지혜
      Icons.psychology, // 25 - 직관
    ];

    return cardNumber > 0 && cardNumber <= icons.length
        ? icons[cardNumber - 1]
        : Icons.stars;
  }
}
