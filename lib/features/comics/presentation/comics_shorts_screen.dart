import 'package:comic_short_forms/features/comics/comics_shorts_notifier.dart';
import 'package:comic_short_forms/features/comics/presentation/comics_shorts_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ComicsShortsScreen extends ConsumerWidget {
  const ComicsShortsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 상태 구독
    final artworksState = ref.watch(comicsShortsProvider);

    return artworksState.when(
      data: (artworks) {
        return ComicsShortsWidget(artworks: artworks);
      },
      loading: () {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
      error: (error, stackTrace) {
        return Scaffold(
          body: Center(child: Text("오류 발생: $error")),
        );
      },
    );
  }
}