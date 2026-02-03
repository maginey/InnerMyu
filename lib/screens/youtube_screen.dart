import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class YouTubeScreen extends StatelessWidget {
  const YouTubeScreen({super.key});

  // 샘플 유튜브 영상 데이터
  final List<Map<String, String>> _videos = const [
    {
      'id': 'dQw4w9WgXcQ',
      'title': '타로 카드 입문 가이드',
      'description': '타로 카드의 기본을 배워보세요',
      'thumbnail': 'https://img.youtube.com/vi/dQw4w9WgXcQ/mqdefault.jpg',
    },
    {
      'id': 'jNQXAC9IVRw',
      'title': '오라클 카드 리딩 방법',
      'description': '오라클 카드로 메시지를 받는 법',
      'thumbnail': 'https://img.youtube.com/vi/jNQXAC9IVRw/mqdefault.jpg',
    },
    {
      'id': '9bZkp7q19f0',
      'title': '켈틱 크로스 스프레드 해석',
      'description': '10장 스프레드 완전 분석',
      'thumbnail': 'https://img.youtube.com/vi/9bZkp7q19f0/mqdefault.jpg',
    },
    {
      'id': 'kJQP7kiw5Fk',
      'title': '타로 카드 상징과 의미',
      'description': '메이저 아르카나 22장 해설',
      'thumbnail': 'https://img.youtube.com/vi/kJQP7kiw5Fk/mqdefault.jpg',
    },
    {
      'id': 'fJ9rUzIMcZQ',
      'title': '오늘의 타로 리딩',
      'description': '매일 아침 카드 한 장으로 시작하기',
      'thumbnail': 'https://img.youtube.com/vi/fJ9rUzIMcZQ/mqdefault.jpg',
    },
    {
      'id': 'y6120QOlsfU',
      'title': '연애운 타로 풀이',
      'description': '사랑과 관계에 대한 타로 조언',
      'thumbnail': 'https://img.youtube.com/vi/y6120QOlsfU/mqdefault.jpg',
    },
  ];

  Future<void> _launchYouTube(String videoId) async {
    final Uri url = Uri.parse('https://www.youtube.com/watch?v=$videoId');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
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
                    'InnerMyu 튜브',
                    style: AppTheme.heading1,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '타로와 오라클의 세계를 더 깊이',
                    style: AppTheme.body.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final video = _videos[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _buildVideoCard(context, video),
                  );
                },
                childCount: _videos.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(BuildContext context, Map<String, String> video) {
    return InkWell(
      onTap: () => _launchYouTube(video['id']!),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: AppTheme.cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 썸네일
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      color: AppTheme.cardBack,
                      child: Image.network(
                        video['thumbnail']!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppTheme.cardBack,
                            child: const Center(
                              child: Icon(
                                Icons.play_circle_outline,
                                size: 64,
                                color: AppTheme.primary,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // 콘텐츠
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video['title']!,
                    style: AppTheme.heading3.copyWith(fontSize: 17),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    video['description']!,
                    style: AppTheme.body.copyWith(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.play_circle_outline,
                        size: 16,
                        color: AppTheme.secondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'YouTube에서 보기',
                        style: AppTheme.goldAccent.copyWith(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
