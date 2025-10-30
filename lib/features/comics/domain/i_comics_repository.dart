import 'package:comic_short_forms/features/comics/domain/artwork.dart';

abstract class IComicsRepository {
  Future<List<Artwork>> fetchArtworks();
}