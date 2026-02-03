import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'spreads/daily_spread_screen.dart';
import 'spreads/three_card_screen.dart';
import 'spreads/celtic_cross_screen.dart';
import 'spreads/yes_no_screen.dart';
import 'spreads/better_choice_screen.dart';

class TarotScreen extends StatelessWidget {
  const TarotScreen({super.key});

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
                    '타로 카드',
                    style: AppTheme.heading1,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '마음을 열고 질문을 떠올려보세요',
                    style: AppTheme.body.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSpreadCard(
                  context,
                  icon: Icons.wb_sunny_outlined,
                  title: '오늘의 운세',
                  subtitle: '하루의 에너지를 확인하세요',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DailySpreadScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildSpreadCard(
                  context,
                  icon: Icons.view_carousel_outlined,
                  title: '3카드 스프레드',
                  subtitle: '과거, 현재, 미래를 살펴보세요',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ThreeCardScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildSpreadCard(
                  context,
                  icon: Icons.grid_view,
                  title: '켈틱 크로스',
                  subtitle: '상황을 깊이 있게 분석합니다',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CelticCrossScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildSpreadCard(
                  context,
                  icon: Icons.check_circle_outline,
                  title: 'Yes or No',
                  subtitle: '명확한 답을 원할 때',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const YesNoScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildSpreadCard(
                  context,
                  icon: Icons.compare_arrows,
                  title: '양자택일',
                  subtitle: '두 가지 선택을 비교해보세요',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BetterChoiceScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpreadCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: AppTheme.cardDecoration,
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppTheme.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.heading3,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTheme.body.copyWith(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppTheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
