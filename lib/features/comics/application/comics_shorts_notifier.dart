import 'dart:async';

import 'package:comic_short_forms/core/locator/service_locator.dart';
import 'package:comic_short_forms/features/comics/domain/artwork.dart';
import 'package:comic_short_forms/features/comics/domain/i_comics_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final comicsShortsProvider =
    AsyncNotifierProvider<ComicsShortsNotifier, List<Artwork>>(
      ComicsShortsNotifier.new,
    );

class ComicsShortsNotifier extends AsyncNotifier<List<Artwork>> {
  final IComicsRepository _repository = locator<IComicsRepository>();

  @override
  FutureOr<List<Artwork>> build() {
    return _repository.fetchArtworks();
  }
}
