import 'package:comic_short_forms/features/comics/application/comics_shorts_ui_notifier.dart';
import 'package:comic_short_forms/features/comics/domain/comics_shorts_ui_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/mock_data.dart';

void main() {
  group('ComicsShortsUiNotifier Tests', () {
    ComicsShortsUiNotifier createNotifier() {
      return ComicsShortsUiNotifier(mockArtworks);
    }

    test('초기 상태(Initial state)가 올바르게 설정되어야 한다', () {
      final notifier = createNotifier();

      final state = notifier.state;

      // 초기 상태 확인
      expect(state, ComicsShortsUiState.initial(mockArtworks));

      // 2. 세부 상태 값 확인
      expect(state.currentArtworkIdx, 0);
      expect(state.currentEpisodeIdx, 0);
      expect(state.currentPageIdx, 0);
      expect(state.isInfoVisible, false);

      // 3. Getter가 첫 번째 데이터를 올바르게 반환하는지 확인
      expect(state.currentArtwork, mockArtwork1);
      expect(state.currentEpisode, mockArtwork1.episodes.first);
      expect(state.currentPage, "a1.jpg");
    });

    test('handleNextPage: 페이지를 올바르게 증가시키고, 마지막 페이지에서 멈춰야 한다', () {
      // Arrange
      final notifier = createNotifier();
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
      final notifier = createNotifier();
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
      final notifier = createNotifier();
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
      final notifier = createNotifier();
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
      final notifier = createNotifier();
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
}
