import 'package:comic_short_forms/features/comics/application/comics_shorts_ui_notifier.dart';
import 'package:comic_short_forms/features/comics/application/reading_history_provider.dart';
import 'package:comic_short_forms/features/comics/domain/comics_shorts_ui_state.dart';
import 'package:comic_short_forms/features/comics/domain/i_like_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/mock_data.dart';

class MockLikeRepository extends Mock implements ILikeRepository {}

final fakeReadingHistoryProvider = StateProvider<Map<int, int>>((ref) => {});
void main() {
  late MockLikeRepository mockLikeRepository;
  late ProviderContainer container;

  // 테스트 실행 전 공통 초기화 로직
  setUp(() {
    mockLikeRepository = MockLikeRepository();

    container = ProviderContainer(
      overrides: [readingHistoryProvider.overrideWith((ref) => {})],
    );
  });

  // 테스트 종료 후 정리
  tearDown(() {
    container.dispose();
  });

  // Notifier 가져오기 도우미 함수
  ComicsShortsUiNotifier getNotifier() {
    // family provider이므로 mockArtworks를 인자로 넘겨줍니다.
    return container.read(comicsShortsUiProvider(mockArtworks).notifier);
  }

  // State 가져오기 도우미 함수
  ComicsShortsUiState getState() {
    return container.read(comicsShortsUiProvider(mockArtworks));
  }

  group('ComicsShortsUiNotifier Tests', () {
    test('초기 상태(Initial state)가 올바르게 설정되어야 한다', () {
      final state = getState();

      // 초기 상태 확인
      expect(state, ComicsShortsUiState.initial(mockArtworks));

      // 2. 세부 상태 값 확인
      expect(state.currentArtworkIdx, 0);
      expect(state.currentEpisodeIdx, 0);
      expect(state.currentPageIdx, 0);
      expect(state.isInfoVisible, false);
      expect(state.isDescriptionExpanded, false);
      expect(state.isCommentOpend, false);
      expect(state.isEnd, false);

      // 3. Getter가 첫 번째 데이터를 올바르게 반환하는지 확인
      expect(state.currentArtwork, mockArtwork1);
      expect(state.currentEpisode, mockArtwork1.episodes.first);
      expect(state.currentPage, "a1.jpg");
    });

    test('handleNextPage: 페이지를 올바르게 증가시키고, 마지막 페이지에서 멈춰야 한다', () {
      // Arrange
      final notifier = getNotifier();
      // 초기 페이지 인덱스는 0
      expect(notifier.state.currentPageIdx, 0);

      // Act (1) - 1번 호출
      notifier.handleNextPage();

      // Assert (1) - 페이지 1로 이동 (mockArtwork1.episodes[0]의 2번째 이미지)
      expect(notifier.state.currentPageIdx, 1);
      expect(notifier.state.currentPage, "a2.jpg");

      // Act (2) - 1번 더 호출 (총 2번)
      notifier.handleNextPage();

      // Assert (2) - 더 이상 증가하지 않음 (1화는 이미지가 2개 뿐)
      expect(notifier.state.currentPageIdx, 1);
    });

    test('handlePrevPage: 페이지를 올바르게 감소시키고, 첫 페이지에서 멈춰야 한다', () {
      // Arrange
      final notifier = getNotifier();
      // 강제로 1페이지로 이동
      notifier.handleNextPage();
      expect(notifier.state.currentPageIdx, 1);

      // Act (1) - 1번 호출
      notifier.handlePrevPage();

      // Assert (1) - 0페이지로 이동
      expect(notifier.state.currentPageIdx, 0);
      expect(notifier.state.currentPage, "a1.jpg");

      // Act (2) - 1번 더 호출
      notifier.handlePrevPage();

      // Assert (2) - 더 이상 감소하지 않음
      expect(notifier.state.currentPageIdx, 0);
    });

    test('onEpisodeChanged: 에피소드를 변경하고, 페이지 인덱스를 0으로 초기화해야 한다', () {
      // Arrange
      final notifier = getNotifier();
      ;
      // 1페이지로 이동
      notifier.handleNextPage();
      expect(notifier.state.currentPageIdx, 1); // 현재 1페이지

      // Act
      notifier.onEpisodeChanged(1); // 2화로 이동 (0 -> 1)

      // Assert
      expect(notifier.state.currentEpisodeIdx, 1);
      // (⭐ 핵심) currentPageIdx가 0으로 초기화됨
      expect(notifier.state.currentPageIdx, 0);
      expect(notifier.state.currentEpisode, mockArtwork1.episodes[1]);
      expect(notifier.state.currentPage, "b1.jpg");
    });

    test('onArtworkChanged: 작품을 변경하고, 에피소드와 페이지 인덱스를 0으로 초기화해야 한다', () {
      // Arrange
      final notifier = getNotifier();
      // 2화, 1페이지로 이동
      notifier.onEpisodeChanged(1);
      // (2화는 이미지가 1개 뿐이라 handleNextPage() 호출해도 0에 머무름)
      expect(notifier.state.currentEpisodeIdx, 1);
      expect(notifier.state.currentPageIdx, 0);

      // Act
      notifier.onArtworkChanged(1); // 2번 작품으로 이동 (0 -> 1)

      // Assert
      expect(notifier.state.currentArtworkIdx, 1);
      // (⭐ 핵심) 모든 하위 인덱스가 0으로 초기화됨
      expect(notifier.state.currentEpisodeIdx, 0);
      expect(notifier.state.currentPageIdx, 0);
      expect(notifier.state.currentArtwork, mockArtwork2);
      expect(notifier.state.currentPage, "c1.jpg");
    });

    test('toggleInfoVisibility: 정보창 표시 상태를 토글(toggle)해야 한다', () {
      // Arrange
      final notifier = getNotifier();
      expect(notifier.state.isInfoVisible, false); // 초기값 false

      // Act (1)
      notifier.toggleInfoVisibility();
      // Assert (1)
      expect(notifier.state.isInfoVisible, true);

      // Act (2)
      notifier.toggleInfoVisibility();
      // Assert (2)
      expect(notifier.state.isInfoVisible, false);
    });
  });

  group('History 테스트', () {
    test('savePage: 페이지 정보를 저장하면 Provider의 상태가 업데이트되어야 한다', () {
      final notifier = getNotifier();
      final episodeId = 101;
      final pageIdx = 5;

      final historyMap = container.read(readingHistoryProvider);
      expect(historyMap.containsKey(episodeId), false);
      expect(historyMap[episodeId], null);

      notifier.savePage(episodeId, pageIdx);

      final historyMap2 = container.read(readingHistoryProvider);
      expect(historyMap2.containsKey(episodeId), true);
      expect(historyMap2[episodeId], pageIdx);
    });
  });

  test('loadPage: 페이지 정보를 저장하면 Provider의 상태가 업데이트되어야 한다', () {
    final notifier = getNotifier();
    final episodeId = 202;
    final savedPageIdx = 3;

    // 데이터 조작
    container.read(readingHistoryProvider.notifier).state = {
      episodeId: savedPageIdx,
      999: 10, // 다른 데이터
    };
    final result = notifier.loadPage(episodeId);

    // Assert
    expect(result, savedPageIdx);
  });

  test('savePage: 페이지 정보를 덮어쓸 수 있다.', () {
    final notifier = getNotifier();
    final episodeId = 101;

    // 먼저 저장
    notifier.savePage(episodeId, 3);
    expect(container.read(readingHistoryProvider)[episodeId], 3);

    // 덮어쓰기
    notifier.savePage(episodeId, 2);
    expect(container.read(readingHistoryProvider)[episodeId], 2);
  });
}
