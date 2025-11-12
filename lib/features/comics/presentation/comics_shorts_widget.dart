import 'package:comic_short_forms/features/comics/comics_shorts_ui_notifier.dart';
import 'package:comic_short_forms/features/comics/domain/artwork.dart';
import 'package:comic_short_forms/features/comics/presentation/artwork_page_widget.dart';
import 'package:comic_short_forms/features/comics/presentation/comics_information_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 코믹 숏폼
/// 만화를 표시하는 [ShortsFormWidget]
/// 기타 정보를 표시하는 [InformationWidget]
class ComicsShortsWidget extends ConsumerWidget {
  final List<Artwork> artworks;
  const ComicsShortsWidget({super.key, required this.artworks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiProvider = comicsShortsUiProvider(artworks);

    final uiState = ref.watch(uiProvider);
    final uiNotifier = ref.read(uiProvider.notifier);

    if (artworks.isEmpty) return SizedBox();
    return Stack(
      fit: StackFit.expand,
      children: [
        ShortsFormWidget(
          artworks: artworks,
          currentPage: uiState.currentPage,
          onArtworkChanged: uiNotifier.onArtworkChanged,
          onEpisodeChanged: uiNotifier.onEpisodeChanged,
        ),
        HandlePageInteractionWidget(
          handleNextPage: uiNotifier.handleNextPage,
          handlePrevPage: uiNotifier.handlePrevPage,
        ),
        Visibility(visible: uiState.isInfoVisible, child: InformationWidget(
          uiNotifier: uiNotifier,
          uiState: uiState,
        )),
        ShortsFormInteractionWidget(
          toggleInfoVisibility: uiNotifier.toggleInfoVisibility,
        ),
        if (uiState.endedArtwork != null)
          Visibility(
            visible: uiState.isEnd,
            child: _ArtworkInfoPage(artwork: uiState.endedArtwork!),
          ),
      ],
    );
  }
}

// 수평 PageView의 "마지막" 페이지 (작품 정보)
class _ArtworkInfoPage extends StatelessWidget {
  final Artwork artwork;
  const _ArtworkInfoPage({required this.artwork});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[800],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "작품: ${artwork.title}",
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
            Text(
              "작가: ${artwork.author}",
              style: const TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: 첫 화부터 다시 보기 등
              },
              child: const Text("첫 화부터 다시보기"),
            ),
          ],
        ),
      ),
    );
  }
}

/// 사용자 터치 감지 위젯
class ShortsFormInteractionWidget extends StatelessWidget {
  const ShortsFormInteractionWidget({
    super.key,
    this.toggleInfoVisibility,
  });

  /// 정보 위젯 표시 콜백
  final void Function()? toggleInfoVisibility;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Center(
        child: GestureDetector(
          onTap: toggleInfoVisibility,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}


/// 사용자 터치 감지 위젯
class HandlePageInteractionWidget extends StatelessWidget {
  const HandlePageInteractionWidget({
    super.key,
    this.handleNextPage,
    this.handlePrevPage,
  });

  /// 정보 위젯 표시 콜백
  final void Function()? handleNextPage;
  final void Function()? handlePrevPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: GestureDetector(onTap: handlePrevPage)),
        Expanded(child: GestureDetector(onTap: handleNextPage)),
      ],
    );
  }
}

/// 만화형 숏폼 위젯
///
/// 세로 방향 스크롤 : 새로운 만화
///
/// 가로 방향 스크롤 : 다음화
///
/// 순수 이미지만 표시하는 위젯
class ShortsFormWidget extends StatelessWidget {
  final List<Artwork> artworks;
  const ShortsFormWidget({
    super.key,
    required this.artworks,
    required this.currentPage,
    this.onArtworkChanged,
    this.onEpisodeChanged,
  });
  final void Function(int)? onArtworkChanged;
  final void Function(int)? onEpisodeChanged;
  final String currentPage;
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: PageView.builder(
        itemCount: artworks.length,
        scrollDirection: Axis.vertical,
        onPageChanged: onArtworkChanged,
        itemBuilder: (context, index) {
          final artwork = artworks[index];
          // 3. 수평 방향 Carousel을 가진 위젯
          return ArtworkPageWidget(
            artwork: artwork,
            onEpisodeChanged: onEpisodeChanged,
            currentPage: currentPage,
          );
        },
      ),
    );
  }
}
