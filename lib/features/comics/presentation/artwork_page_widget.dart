import 'package:comic_short_forms/features/comics/comics_shorts_notifier.dart';
import 'package:comic_short_forms/features/comics/comics_shorts_ui_notifier.dart';
import 'package:comic_short_forms/features/comics/domain/artwork.dart';
import 'package:comic_short_forms/features/comics/domain/episode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArtworkPageWidget extends StatelessWidget {
  const ArtworkPageWidget({
    super.key,
    required this.artwork,
    this.onEpisodeChanged,
  });

  final Artwork artwork;
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
        return _EpisodePage(episode: episode);
      },
    );
  }
}

// 수평 PageView의 "에피소드(화)" 페이지
class _EpisodePage extends ConsumerWidget {
  const _EpisodePage({required this.episode});
  final Episode episode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artworks = ref.watch(comicsShortsProvider).requireValue;
    final uiProvider = comicsShortsUiProvider(artworks);
    final currentPage = ref.watch(
      uiProvider.select((value) => value.currentPage),
    );

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
