import 'package:freezed_annotation/freezed_annotation.dart';

part 'episode.freezed.dart';
part 'episode.g.dart';

@freezed
abstract class Episode with _$Episode {
  const factory Episode({
    required int id,
    required String title,
    @Default([]) List<String> imageUrls,
    @Default(false) bool didLike,
    @Default(0) int likesCnt,
    @Default(0) int commentsCnt
  }) = _Episode;

  factory Episode.fromJson(Map<String, dynamic> json) =>
      _$EpisodeFromJson(json);
}