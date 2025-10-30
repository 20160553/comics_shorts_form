import 'package:comic_short_forms/features/comics/domain/artwork.dart';
import 'package:comic_short_forms/features/comics/domain/episode.dart';
import 'package:flutter/material.dart';

class ArtworkPageWidget extends StatelessWidget {
  final Artwork artwork;
  const ArtworkPageWidget({super.key, required this.artwork, required this.onChangeEpisodeImage});
  final Function(bool, Artwork)? onChangeEpisodeImage;

  @override
  Widget build(BuildContext context) {
    final episodes = artwork.episodes;
    
    // 요구사항 4: (에피소드 개수 + 마지막 작품 정보 페이지 1개)
    final pageCount = episodes.length + 1;

    return PageView.builder(
      // 수평 방향 (기본값)
      scrollDirection: Axis.horizontal,
      itemCount: pageCount,
      onPageChanged: (value) => onChangeEpisodeImage?.call(value == episodes.length, artwork),
      itemBuilder: (context, index) {
        // 4. 에피소드(화) 페이지인 경우
        final episode = episodes[index];
        return _EpisodePage(episode: episode);
      },
    );
  }
}

// 수평 PageView의 "에피소드(화)" 페이지
class _EpisodePage extends StatelessWidget {
  final Episode episode;
  const _EpisodePage({required this.episode});

  @override
  Widget build(BuildContext context) {
    // (간단한 예시) 해당 '화'의 첫 번째 이미지만 표시
    // TODO: episode.imageUrls를 사용해 컷툰처럼 구현
    return Column(
      children: [
        // (임시) 화 정보
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(episode.title, style: const TextStyle(fontSize: 24, color: Colors.white, backgroundColor: Colors.black45)),
        ),
        Image.network(
          episode.imageUrls.first,
          fit: BoxFit.fitWidth,
          loadingBuilder: (context, child, progress) {
            return progress == null
                ? child
                : const Center(child: CircularProgressIndicator());
          },
        ),
      ],
    );
  }
}
