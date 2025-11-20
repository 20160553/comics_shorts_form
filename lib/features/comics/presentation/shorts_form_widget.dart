
import 'package:comic_short_forms/features/comics/application/comics_shorts_notifier.dart';
import 'package:comic_short_forms/features/comics/application/comics_shorts_ui_notifier.dart';
import 'package:comic_short_forms/features/comics/presentation/artwork_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
