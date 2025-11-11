import 'package:comic_short_forms/features/comics/comics_shorts_ui_notifier.dart';
import 'package:comic_short_forms/features/comics/domain/comics_shorts_ui_state.dart';
import 'package:flutter/material.dart';

/// 정보 위젯
/// 좋아요, 댓글, 작품 정보 등 표시
/// 터치로 show/hide 토글
class InformationWidget extends StatelessWidget {
  const InformationWidget({
    super.key,
    required this.uiState,
    required this.uiNotifier,
  });
  final ComicsShortsUiState uiState;
  final ComicsShortsUiNotifier uiNotifier;

  @override
  Widget build(BuildContext context) {
    const iconSize = 36.0;
    const spacingValue = 8.0;
    const mockUpImageSrc =
        "https://upload.wikimedia.org/wikipedia/commons/0/05/Cat.png";
    final currentArtwork = uiState.currentArtwork;
    if (currentArtwork == null) {
      return Center(child: Text('Something wrong!'));
    }
    final currentEpisodeLikesCnt = '${uiState.currentEpisode?.likesCnt ?? 0}';
    final currentEpisodeCommentsCnt =
        '${uiState.currentEpisode?.commentsCnt ?? 0}';

    return Container(
      color: Colors.blue,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Visibility(
            visible: !uiState.isCommentOpend,
            child: Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: spacingValue,
                    children: [
                      ClipOval(
                        child: Image.network(
                          mockUpImageSrc,
                          width: iconSize,
                          height: iconSize,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(currentArtwork.author.nickname),
                      TextButton(onPressed: () {}, child: Text('팔로우')),
                    ],
                  ),
                  Text(currentArtwork.title),
                  Text(currentArtwork.description),
                  // Text('작품 태그'),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: spacingValue,
            children: [
              Column(
                children: [
                  Icon(Icons.favorite, size: iconSize),
                  Text(currentEpisodeLikesCnt),
                ],
              ),
              Column(
                children: [
                  Icon(Icons.comment, size: iconSize),
                  Text(currentEpisodeCommentsCnt),
                ],
              ),
              Icon(Icons.list_alt, size: iconSize),
              Icon(Icons.local_pizza, size: iconSize),
              Icon(Icons.share, size: iconSize),
              Icon(Icons.more_vert, size: iconSize),
            ],
          ),
          Visibility(
            visible: uiState.isCommentOpend,
            child: Expanded(child: Column(children: [
                
              ],)),
          ),
        ],
      ),
    );
  }
}
