abstract interface class ILikeRepository {
  Future<void> toggleEpisodeLike(int userUid, int workId);
}