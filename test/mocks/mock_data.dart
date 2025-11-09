// test/mocks/mock_data.dart

import 'package:comic_short_forms/features/comics/domain/artwork.dart';
import 'package:comic_short_forms/features/comics/domain/episode.dart';

// 테스트에 사용할 가짜 작품 1
final mockArtwork1 = Artwork(
  id: 1,
  title: "테스트 작품 1",
  author: "테스터",
  episodes: [
    // 1화 (이미지 2개)
    Episode(id: 101, title: "1화", imageUrls: ["a1.jpg", "a2.jpg"]),
    // 2화 (이미지 1개)
    Episode(id: 102, title: "2화", imageUrls: ["b1.jpg"]),
  ],
);

// 테스트에 사용할 가짜 작품 2
final mockArtwork2 = Artwork(
  id: 2,
  title: "테스트 작품 2",
  author: "테스터",
  episodes: [
    // 1화 (이미지 1개)
    Episode(id: 201, title: "1화", imageUrls: ["c1.jpg"]),
  ],
);

// 가짜 작품 목록
final List<Artwork> mockArtworks = [mockArtwork1, mockArtwork2];