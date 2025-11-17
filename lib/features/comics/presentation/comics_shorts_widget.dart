import 'package:comic_short_forms/core/constants/num_constant.dart';
import 'package:comic_short_forms/features/comics/application/comics_shorts_notifier.dart';
import 'package:comic_short_forms/features/comics/application/comics_shorts_ui_notifier.dart';
import 'package:comic_short_forms/features/comics/domain/artwork.dart';
import 'package:comic_short_forms/features/comics/presentation/artwork_page_widget.dart';
import 'package:comic_short_forms/features/comics/presentation/comics_information_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 코믹 숏폼
/// 만화를 표시하는 [ShortsFormWidget]
/// 기타 정보를 표시하는 [InformationWidget]
class ComicsShortsWidget extends ConsumerWidget {
  const ComicsShortsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artworks = ref.watch(comicsShortsProvider).requireValue;
    final uiProvider = comicsShortsUiProvider(artworks);
    final isInfoVisible = ref.watch(
      uiProvider.select((value) => value.isInfoVisible),
    );
    final isEnd = ref.watch(uiProvider.select((value) => value.isEnd));
    final uiNotifier = ref.read(uiProvider.notifier);

    if (artworks.isEmpty) return SizedBox();
    return Stack(
      fit: StackFit.expand,
      children: [
        ShortsFormWidget(),
        HandlePageInteractionWidget(
          handleNextPage: uiNotifier.handleNextPage,
          handlePrevPage: uiNotifier.handlePrevPage,
        ),
        Visibility(visible: isInfoVisible, child: InformationWidget()),
        ShortsFormInteractionWidget(
          toggleInfoVisibility: uiNotifier.onToggleInfoVisibility,
        ),
        // 다음화보기 위젯
        Visibility(visible: isEnd, child: _ArtworkInfoPage()),
      ],
    );
  }
}

// 수평 PageView의 "마지막" 페이지 (작품 정보)
class _ArtworkInfoPage extends ConsumerWidget {
  const _ArtworkInfoPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Artwork> artworks = ref.read(comicsShortsProvider).requireValue;
    final uiProvider = comicsShortsUiProvider(artworks);
    final currentArtwork = ref.watch(
      uiProvider.select((value) => value.currentArtwork),
    );
    final currentEpisodeIdx = ref.watch(
      uiProvider.select((value) => value.currentEpisodeIdx),
    );
    final uiNotifier = ref.read(uiProvider.notifier);

    if (currentArtwork == null) return const SizedBox();
    return Container(
      color: Colors.grey[800],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "작품: ${currentArtwork.title}",
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
            Text(
              "작가: ${currentArtwork.author.nickname}",
              style: const TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 20),
            if (currentEpisodeIdx >= currentArtwork.episodes.length)
              ElevatedButton(
                onPressed: () {
                  // TODO: 첫 화부터 다시 보기 등
                },
                child: const Text("첫 화부터 다시보기"),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: smallSpacing,
                children: [
                  ElevatedButton(
                    onPressed: uiNotifier.handlePrevEpisode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentEpisodeIdx - 1 < 0
                          ? Colors.grey
                          : null,
                    ),
                    child: const Text("이전화"),
                  ),
                  ElevatedButton(
                    onPressed: uiNotifier.handleNextEpisode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          currentArtwork.episodes.length <=
                              currentEpisodeIdx + 1
                          ? Colors.grey
                          : null,
                    ),
                    child: const Text("다음화"),
                  ),
                ],
              ),
            TextButton(
              onPressed: uiNotifier.onCloseArtworkInfo,
              child: Text('닫기'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 사용자 터치 감지 위젯
class ShortsFormInteractionWidget extends StatelessWidget {
  const ShortsFormInteractionWidget({super.key, this.toggleInfoVisibility});

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
class ShortsFormWidget extends ConsumerWidget {
  const ShortsFormWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artworks = ref.watch(comicsShortsProvider).requireValue;
    final uiProvider = comicsShortsUiProvider(artworks);
    final uiNotifier = ref.read(uiProvider.notifier);

    return SizedBox(
      child: PageView.builder(
        itemCount: artworks.length,
        scrollDirection: Axis.vertical,
        onPageChanged: uiNotifier.onArtworkChanged,
        itemBuilder: (context, index) {
          final artwork = artworks[index];
          // 3. 수평 방향 Carousel을 가진 위젯
          return ArtworkPageWidget(
            artwork: artwork,
            onEpisodeChanged: uiNotifier.onEpisodeChanged,
          );
        },
      ),
    );
  }
}
