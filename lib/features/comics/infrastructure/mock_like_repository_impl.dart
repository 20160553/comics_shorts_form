import 'package:comic_short_forms/features/comics/domain/i_like_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MockLikeRepositoryImpl implements ILikeRepository {
  @override
  Future<void> toggleEpisodeLike(int userUid, int workId) {
    return Future.delayed((const Duration(milliseconds: 500)));
  }
}

final mockLikeRepositoryProvider = Provider<ILikeRepository>((ref) {
  return MockLikeRepositoryImpl();
});