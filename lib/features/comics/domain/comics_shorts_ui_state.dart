import 'package:comic_short_forms/features/comics/domain/artwork.dart';
import 'package:comic_short_forms/features/comics/domain/episode.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'comics_shorts_ui_state.freezed.dart';

@freezed
abstract class ComicsShortsUiState with _$ComicsShortsUiState {

  const factory ComicsShortsUiState({
    required List<Artwork> artworks,
    required int currentArtworkIdx,
    required int currentEpisodeIdx,
    required int currentPageIdx,
    @Default(false)
    bool isInfoVisible,
    @Default(false)
    bool isDescriptionExpanded,
    @Default(false)
    bool isCommentOpend,
    required bool isEnd,
    @Default(null) Artwork? endedArtwork,
  }) = _ComicsShortsUiState;

  // 초기 상태
  factory ComicsShortsUiState.initial(List<Artwork> artworks) {
    return ComicsShortsUiState(
      artworks: artworks,
      currentArtworkIdx: 0,
      currentEpisodeIdx: 0,
      currentPageIdx: 0,
      isInfoVisible: false,
      isEnd: false,
      endedArtwork: null,
    );
  }

  // --- 위젯에서 사용할 편의 Getter ---
  const ComicsShortsUiState._();
  Artwork? get currentArtwork => currentArtworkIdx < artworks.length
      ? artworks[currentArtworkIdx]
      : null;

  Episode? get currentEpisode =>
      currentEpisodeIdx < (currentArtwork?.episodes.length ?? 0)
          ? currentArtwork?.episodes[currentEpisodeIdx]
          : null;

  String get currentPage =>
      currentPageIdx < (currentEpisode?.imageUrls.length ?? 0)
          ? currentEpisode?.imageUrls[currentPageIdx] ?? ''
          : '';
}
