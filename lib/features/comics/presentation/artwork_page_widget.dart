import 'package:comic_short_forms/core/constants/constants.dart';
import 'package:comic_short_forms/features/comics/application/comics_shorts_notifier.dart';
import 'package:comic_short_forms/features/comics/application/comics_shorts_ui_notifier.dart';
import 'package:comic_short_forms/features/comics/domain/artwork.dart';
import 'package:comic_short_forms/features/comics/domain/episode.dart';
import 'package:comic_short_forms/features/comics/presentation/providers/page_controller_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArtworkPageWidget extends ConsumerWidget {
  const ArtworkPageWidget({
    super.key,
    required this.artwork,
    this.onEpisodeChanged,
  });

  final Artwork artwork;
  final void Function(int)? onEpisodeChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episodes = artwork.episodes;
    final uiProvider = comicsShortsUiProvider(
      ref.read(comicsShortsProvider).requireValue,
    );
    final pageController = ref.read(episodePageControllerProvider(artwork.id));
    final pageCount = episodes.length;

    ref.listen(uiProvider, (previous, next) {
      if (next.currentArtwork == null) return;
      if (next.currentArtwork!.id == artwork.id &&
          previous?.currentEpisodeIdx != next.currentEpisodeIdx) {
        if (pageController.hasClients) {
          pageController.animateToPage(
            next.currentEpisodeIdx,
            duration: pageViewAnimationDuration,
            curve: Curves.easeInOut,
          );
        }
      }
    });

    return PageView.builder(
      scrollDirection: Axis.horizontal,
      controller: pageController,
      itemCount: pageCount,
      onPageChanged: onEpisodeChanged,
      itemBuilder: (context, index) {
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
