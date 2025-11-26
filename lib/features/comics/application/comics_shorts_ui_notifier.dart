import 'package:comic_short_forms/core/locator/service_locator.dart';
import 'package:comic_short_forms/features/comics/application/reading_history_provider.dart';
import 'package:comic_short_forms/features/comics/domain/artwork.dart';
import 'package:comic_short_forms/features/comics/domain/comics_shorts_ui_state.dart';
import 'package:comic_short_forms/features/comics/domain/episode.dart';
import 'package:comic_short_forms/features/comics/domain/i_like_repository.dart';
import 'package:comic_short_forms/features/comics/infrastructure/mock_like_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final comicsShortsUiProvider = StateNotifierProvider.autoDispose
    .family<ComicsShortsUiNotifier, ComicsShortsUiState, List<Artwork>>((
      ref,
      artworks,
    ) {
      return ComicsShortsUiNotifier(artworks, ref);
    });

class ComicsShortsUiNotifier extends StateNotifier<ComicsShortsUiState> {
  ComicsShortsUiNotifier(List<Artwork> artworks, this._ref)
    : super(ComicsShortsUiState.initial(artworks));

  final Ref _ref;
  final ILikeRepository _likeRepository = locator<MockLikeRepositoryImpl>();

  /// 정보창 토글 메서드
  void toggleInfoVisibility() {
    state = state.copyWith(isInfoVisible: !state.isInfoVisible);
  }

  // 에피소드 최근 본 페이지 저장
  void savePage(int episodeId, int pageIdx) {
    _ref.read(readingHistoryProvider.notifier).update((map) => {
      ...map,
      episodeId: pageIdx,
    });
  }

  // 에피소드 최근 본 페이지 로드
  int loadPage(int episodeId) =>
      _ref.read(readingHistoryProvider).getPageIndex(episodeId);

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

    final nextEpisode = state.currentArtwork!.episodes[nextIdx];
    state = state.copyWith(
      currentEpisodeIdx: nextIdx,
      currentPageIdx: loadPage(nextEpisode.id),
    );
  }

  /// 다음 페이지 메서드
  void handleNextPage() {
    // 다음 페이지 없는 경우
    if ((state.currentEpisode?.imageUrls.length ?? -1) <=
        state.currentPageIdx + 1) {
      state = state.copyWith(isEnd: true);
      return;
    }
    
    // 에피소드 최근 본 페이지 저장
    savePage(state.currentEpisode!.id , state.currentPageIdx + 1);

    state = state.copyWith(
      currentPageIdx: state.currentPageIdx + 1,
      isEnd: false,
    );
  }

  void handlePrevPage() {
    // 이전 페이지 없는 경우
    if (state.currentPageIdx - 1 < 0) {
      state = state.copyWith(isEnd: true);
      return;
    }
    
    // 에피소드 최근 본 페이지 저장
    savePage(state.currentEpisode!.id , state.currentPageIdx - 1);
    state = state.copyWith(
      currentPageIdx: state.currentPageIdx - 1,
      isEnd: false,
    );
  }

  void handleNextEpisode() {
    if ((state.currentArtwork?.episodes.length ?? -1) <=
        state.currentEpisodeIdx + 1) {
      return;
    }
    state = state.copyWith(
      currentEpisodeIdx: state.currentEpisodeIdx + 1,
      isEnd: false,
      isCommentOpend: false,
      isInfoVisible: false,
      isDescriptionExpanded: false,
    );
  }

  void handlePrevEpisode() {
    // 이전 페이지 없는 경우
    if (state.currentEpisodeIdx - 1 < 0) return;
    state = state.copyWith(
      currentEpisodeIdx: state.currentEpisodeIdx - 1,
      isEnd: false,
      isCommentOpend: false,
      isInfoVisible: false,
      isDescriptionExpanded: false,
    );
  }

  void onCloseArtworkInfo() {
    state = state.copyWith(isEnd: false);
  }

  void onToggleInfoVisibility() {
    state = state.copyWith(
      isInfoVisible: !state.isInfoVisible,
      isEnd: false,
      isCommentOpend: false,
      isDescriptionExpanded: false,
    );
  }

  void onToggleDescriptionExpanded() {
    state = state.copyWith(isDescriptionExpanded: !state.isDescriptionExpanded);
  }

  void onToggleCommentLayout() {
    state = state.copyWith(isCommentOpend: !state.isCommentOpend);
  }

  /// 특정 화 좋아요 기능
  ///
  /// 로그아웃된 경우, currentArtwork or currentEpisode가 null일 경우 함수 종료
  void onToggleLikeEpisode() {
    // todo 로그인 / 로그아웃 로직 분리
    // 로그아웃된 경우 return

    // 현재 에피소드 like 토글 UI 갱신 로직
    if (state.currentArtwork == null || state.currentEpisode == null) return;

    final originalState = state;
    final newEpisode = state.currentEpisode!.copyWith(
      didLike: !state.currentEpisode!.didLike,
      likesCnt: state.currentEpisode!.didLike
          ? state.currentEpisode!.likesCnt - 1
          : state.currentEpisode!.likesCnt + 1,
    );

    final newEpisodes = List<Episode>.from(state.currentArtwork!.episodes);
    newEpisodes[state.currentEpisodeIdx] = newEpisode;

    final newArtwork = state.currentArtwork!.copyWith(episodes: newEpisodes);

    final newArtworks = List<Artwork>.from(state.artworks);
    newArtworks[state.currentArtworkIdx] = newArtwork;

    state = state.copyWith(artworks: newArtworks);

    //todo toggleLike 비즈니스 로직 (Repository)
    _callToggleLikeApi(originalState);
  }

  void _callToggleLikeApi(ComicsShortsUiState originalState) async {
    try {
      // // Repository의 비즈니스 로직 호출
      // await _likeRepository.toggleEpisodeLike(
      //   userUid,
      //   originalState.currentEpisode!.id,
      // );
    } catch (e) {
      state = originalState;

      // todo 에러 알림
      // showSnackBar("좋아요 처리에 실패했습니다.");
    }
  }
}
