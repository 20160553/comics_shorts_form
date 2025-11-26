import 'package:comic_short_forms/core/constants/constants.dart';
import 'package:comic_short_forms/features/comics/application/comics_shorts_notifier.dart';
import 'package:comic_short_forms/features/comics/application/comics_shorts_ui_notifier.dart';
import 'package:comic_short_forms/features/comics/application/reading_history_provider.dart';
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
    final episodeController = ref.read(episodePageControllerProvider(artwork.id));
    final episodeCount = episodes.length;

    ref.listen(uiProvider, (previous, next) {
      if (next.currentArtwork == null) return;
      if (next.currentArtwork!.id == artwork.id &&
          previous?.currentEpisodeIdx != next.currentEpisodeIdx) {
        if (episodeController.hasClients) {
          episodeController.animateToPage(
            next.currentEpisodeIdx,
            duration: pageViewAnimationDuration,
            curve: Curves.easeInOut,
          );
        }
      }
    });

    return PageView.builder(
      scrollDirection: Axis.horizontal,
      controller: episodeController,
      itemCount: episodeCount,
      onPageChanged: onEpisodeChanged,
      itemBuilder: (context, index) {
        final episode = episodes[index];
        return _EpisodeWidget(artworkId: artwork.id, episode: episode);
      },
    );
  }
}


class _EpisodeWidget extends ConsumerWidget {
  const _EpisodeWidget({
    super.key, 
    required this.artworkId, 
    required this.episode
  });
  
  final int artworkId;
  final Episode episode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artworks = ref.read(comicsShortsProvider).requireValue;
    final uiState = ref.watch(comicsShortsUiProvider(artworks));
    final history = ref.watch(readingHistoryProvider);

    int displayPageIdx = history.getPageIndex(episode.id);
    
    debugPrint('episodePage: $displayPageIdx');

    // if (uiState.currentArtwork?.id == artworkId && 
    //     uiState.currentEpisode?.id == episode.id) {
    //   displayPageIdx = uiState.currentPageIdx;
    // } else {
      
    // }

    return Column(
      children: [
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
          episode.imageUrls.elementAtOrNull(displayPageIdx) ?? '',
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