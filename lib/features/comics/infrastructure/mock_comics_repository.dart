import 'package:comic_short_forms/features/auth/domain/user_model.dart';
import 'package:comic_short_forms/features/comics/domain/artwork.dart';
import 'package:comic_short_forms/features/comics/domain/episode.dart';
import 'package:comic_short_forms/features/comics/domain/i_comics_repository.dart';

class MockComicsRepositoryImpl implements IComicsRepository {
  @override
  Future<List<Artwork>> fetchArtworks() async {
    // 가짜 로딩
    await Future.delayed(const Duration(seconds: 2));
    const dummyAuthor = UserModel(
      uid: 1,
      email: 'dummy@email.com',
      nickname: 'dummy',
    );
    const dummyAuthor2 = UserModel(
      uid: 1,
      email: 'dummy2@email.com',
      nickname: 'dummy2',
    );

    return [
      // 작품 1 (3화 + 정보)
      Artwork(
        id: 1,
        title: "플러터 마스터",
        author: dummyAuthor,
        description: '플러터 마스터가 될거야!',
        episodes: [
          Episode(
            id: 101,
            title: "1화",
            imageUrls: [
              "https://picsum.photos/seed/a1/400/800",
              "https://picsum.photos/seed/a2/400/800",
              "https://picsum.photos/seed/a3/400/800",
              "https://picsum.photos/seed/a4/400/800",
              "https://picsum.photos/seed/a5/400/800",
            ],
          ),
          Episode(
            id: 102,
            title: "2화",
            imageUrls: [
              "https://picsum.photos/seed/b1/400/800",
              "https://picsum.photos/seed/b2/400/800",
              "https://picsum.photos/seed/b3/400/800",
              "https://picsum.photos/seed/b4/400/800",
              "https://picsum.photos/seed/b5/400/800",
            ],
          ),
          Episode(
            id: 103,
            title: "3화",
            imageUrls: [
              "https://picsum.photos/seed/c1/400/800",
              "https://picsum.photos/seed/c2/400/800",
              "https://picsum.photos/seed/c3/400/800",
              "https://picsum.photos/seed/c4/400/800",
              "https://picsum.photos/seed/c5/400/800",
            ],
          ),
        ],
      ),
      // 작품 2 (2화 + 정보)
      Artwork(
        id: 2,
        title: "Dart의 신",
        author: dummyAuthor2,
        description: '나는 다트의 신이다.',
        episodes: [
          Episode(
            id: 201,
            title: "1화",
            imageUrls: [
              "https://picsum.photos/seed/d1/400/800",
              "https://picsum.photos/seed/d2/400/800",
              "https://picsum.photos/seed/d3/400/800",
              "https://picsum.photos/seed/d4/400/800",
              "https://picsum.photos/seed/d5/400/800",
            ],
          ),
          Episode(
            id: 202,
            title: "2화",
            imageUrls: [
              "https://picsum.photos/seed/e1/400/800",
              "https://picsum.photos/seed/e2/400/800",
              "https://picsum.photos/seed/e3/400/800",
              "https://picsum.photos/seed/e4/400/800",
              "https://picsum.photos/seed/e5/400/800",
            ],
          ),
        ],
      ),
    ];
  }
}
