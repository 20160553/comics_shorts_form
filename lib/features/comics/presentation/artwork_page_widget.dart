import 'package:comic_short_forms/features/comics/domain/artwork.dart';
import 'package:comic_short_forms/features/comics/domain/episode.dart';
import 'package:flutter/material.dart';

class ArtworkPageWidget extends StatelessWidget {
  const ArtworkPageWidget({
    super.key,
    required this.artwork,
    required this.currentPage,
    this.onEpisodeChanged,
  });

  final Artwork artwork;
  final String currentPage;
  final void Function(int)? onEpisodeChanged;

  @override
  Widget build(BuildContext context) {
    final episodes = artwork.episodes;

    // 요구사항 4: (에피소드 개수 + 마지막 작품 정보 페이지 1개)
    final pageCount = episodes.length;

    return PageView.builder(
      // 수평 방향 (기본값)
      scrollDirection: Axis.horizontal,
      itemCount: pageCount,
      onPageChanged: onEpisodeChanged,
      itemBuilder: (context, index) {
        // 4. 에피소드(화) 페이지인 경우
        final episode = episodes[index];
        return _EpisodePage(episode: episode, currentPage: currentPage,);
      },
    );
  }
}

// 수평 PageView의 "에피소드(화)" 페이지
class _EpisodePage extends StatelessWidget {
  const _EpisodePage({required this.episode, required this.currentPage});
  final Episode episode;
  final String currentPage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // (임시) 화 정보
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            episode.title,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              backgroundColor: Colors.black45,
            ),
          ),
        ),
        Image.network(
          currentPage,
          fit: BoxFit.fitWidth,
          loadingBuilder: (context, child, progress) {
            return progress == null
                ? child
                : const Center(child: CircularProgressIndicator());
          },
        ),
      ],
    );
  }
}
