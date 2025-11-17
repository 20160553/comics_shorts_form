import 'package:comic_short_forms/features/comics/domain/i_like_repository.dart';

class MockLikeRepositoryImpl implements ILikeRepository {
  @override
  Future<void> toggleEpisodeLike(int userUid, int workId) {
    return Future.delayed((const Duration(milliseconds: 500)));
  }
}
