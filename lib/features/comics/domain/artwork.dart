import 'package:comic_short_forms/features/comics/domain/episode.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'artwork.freezed.dart';
part 'artwork.g.dart';

@freezed
abstract class Artwork with _$Artwork {
  const factory Artwork({
    required int id,
    required String title,
    required String author,
    @Default([]) List<Episode> episodes,
  }) = _Artwork;

  factory Artwork.fromJson(Map<String, dynamic> json) =>
      _$ArtworkFromJson(json);
}
