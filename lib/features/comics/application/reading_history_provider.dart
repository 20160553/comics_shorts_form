import 'package:flutter_riverpod/legacy.dart';

// Key: EpisodeId, Value: PageIndex
final readingHistoryProvider = StateProvider<Map<int, int>>((ref) => {});

// (편의용 메서드 확장)
extension ReadingHistoryExt on Map<int, int> {
  int getPageIndex(int episodeId) => this[episodeId] ?? 0;
}