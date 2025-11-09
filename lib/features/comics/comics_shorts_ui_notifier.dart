import 'package:comic_short_forms/features/comics/domain/artwork.dart';
import 'package:comic_short_forms/features/comics/domain/comics_shorts_ui_state.dart';
import 'package:flutter_riverpod/legacy.dart';

final comicsShortsUiProvider = StateNotifierProvider.autoDispose
    .family<ComicsShortsUiNotifier, ComicsShortsUiState, List<Artwork>>((
      ref,
      artworks,
    ) {
      return ComicsShortsUiNotifier(artworks);
    });

class ComicsShortsUiNotifier extends StateNotifier<ComicsShortsUiState> {
  ComicsShortsUiNotifier(List<Artwork> artworks)
    : super(ComicsShortsUiState.initial(artworks));

  /// 정보창 토글 메서드
  void toggleInfoVisibility() {
    state = state.copyWith(isInfoVisible: !state.isInfoVisible);
  }

  /// 작품 변경 메서드
  void onArtworkChanged(int nextIdx) {
    if (nextIdx < 0 || nextIdx >= state.artworks.length) return;
    state = state.copyWith(
      currentArtworkIdx: nextIdx,
      currentEpisodeIdx: 0,
      currentPageIdx: 0,
    );
  }

  /// 에피소드 변경 메서드
  void onEpisodeChanged(int nextIdx) {
    if (nextIdx < 0 || nextIdx >= (state.currentArtwork?.episodes.length ?? -1))
      return;
    state = state.copyWith(currentEpisodeIdx: nextIdx, currentPageIdx: 0);
  }

  /// 다음 페이지 메서드  
  void handleNextPage() {
    // 다음 페이지 없는 경우
    if ((state.currentEpisode?.imageUrls.length ?? -1) <=
        state.currentPageIdx + 1) {
      return;
    }
    state = state.copyWith(currentPageIdx: state.currentPageIdx + 1);
  }

  void handlePrevPage() {
    // 이전 페이지 없는 경우
    if (state.currentPageIdx - 1 < 0) return;
    state = state.copyWith(currentPageIdx: state.currentPageIdx - 1);
  }
  
  void onChangeEpisodeImage(bool isEnd, Artwork artwork) {
    state = state.copyWith(
      isEnd: isEnd,
      endedArtwork: artwork
    );
  }
}
