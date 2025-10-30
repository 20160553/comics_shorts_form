import 'package:comic_short_forms/features/comics/domain/artwork.dart';
import 'package:comic_short_forms/features/comics/presentation/artwork_page_widget.dart';
import 'package:flutter/material.dart';

/// 코믹 숏폼
/// 만화를 표시하는 [ShortsFormWidget]
/// 기타 정보를 표시하는 [InformationWidget]
class ComicsShortsWidget extends StatefulWidget {
  final List<Artwork> artworks;
  const ComicsShortsWidget({super.key, required this.artworks});

  @override
  State<ComicsShortsWidget> createState() => _ComicsShortsWidgetState();
}

class _ComicsShortsWidgetState extends State<ComicsShortsWidget> {
  bool _isInfoVisible = false;
  bool _isEnd = false;
  Artwork? _endedArtwork;

  // 정보창 토글 메서드
  void _toggleInfoVisibility() {
    setState(() {
      _isInfoVisible = !_isInfoVisible;
    });
  }

  void _onChangeEpisodeImage(bool isEnd, Artwork artwork) {
    setState(() {
      _isEnd = isEnd;
      _endedArtwork = artwork;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ShortsFormWidget(
          artworks: widget.artworks,
          onChangeEpisodeImage: _onChangeEpisodeImage,
        ),
        Visibility(visible: _isInfoVisible, child: InformationWidget()),
        GestureDetector(
          child: Center(
            child: GestureDetector(
              onTap: _toggleInfoVisibility,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        ),
        if (_endedArtwork != null)
          Visibility(
            visible: _isEnd,
            child: _ArtworkInfoPage(artwork: _endedArtwork!),
          ),
      ],
    );
  }
}

// 수평 PageView의 "마지막" 페이지 (작품 정보)
class _ArtworkInfoPage extends StatelessWidget {
  final Artwork artwork;
  const _ArtworkInfoPage({required this.artwork});

  @override
  Widget build(BuildContext context) {
    // 요구사항 4: 다음 화가 없을 경우 (마지막 페이지)
    return Container(
      color: Colors.grey[800],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "작품: ${artwork.title}",
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
            Text(
              "작가: ${artwork.author}",
              style: const TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: 첫 화부터 다시 보기 등
              },
              child: const Text("첫 화부터 다시보기"),
            ),
          ],
        ),
      ),
    );
  }
}

/// 정보 위젯
/// 좋아요, 댓글, 작품 정보 등 표시
/// 터치로 show/hide 토글
class InformationWidget extends StatelessWidget {
  const InformationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.blue);
  }
}

/// 만화형 숏폼 위젯
/// 세로 방향 스크롤 : 새로운 만화
/// 가로 방향 스크롤 : 다음화
/// 순수 이미지만 표시하는 위젯
class ShortsFormWidget extends StatelessWidget {
  final List<Artwork> artworks;
  const ShortsFormWidget({
    super.key,
    required this.artworks,
    required this.onChangeEpisodeImage,
  });
  final Function(bool, Artwork)? onChangeEpisodeImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: PageView.builder(
        itemCount: artworks.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          final artwork = artworks[index];
          // 3. 수평 방향 Carousel을 가진 위젯
          return ArtworkPageWidget(
            artwork: artwork,
            onChangeEpisodeImage: onChangeEpisodeImage,
          );
        },
      ),
    );
  }
}
