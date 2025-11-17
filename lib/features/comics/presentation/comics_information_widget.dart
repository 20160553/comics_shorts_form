import 'package:comic_short_forms/features/comics/application/comics_shorts_notifier.dart';
import 'package:comic_short_forms/features/comics/application/comics_shorts_ui_notifier.dart';
import 'package:comic_short_forms/features/comics/domain/artwork.dart';
import 'package:comic_short_forms/features/comics/presentation/widgets/icon_with_label_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 정보 위젯
/// 좋아요, 댓글, 작품 정보 등 표시
/// 터치로 show/hide 토글
class InformationWidget extends ConsumerWidget {
  const InformationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Artwork> artworks = ref.watch(comicsShortsProvider).requireValue;
    const iconSize = 36.0;
    const spacingValue = 8.0;
    const mockUpImageSrc =
        "https://upload.wikimedia.org/wikipedia/commons/0/05/Cat.png";

    final uiProivder = comicsShortsUiProvider(artworks);
    final currentArtwork = ref.watch(
      uiProivder.select((value) => value.currentArtwork),
    );
    final currentEpisode = ref.watch(
      uiProivder.select((value) => value.currentEpisode),
    );
    final uiNotifier = ref.read(uiProivder.notifier);

    if (currentArtwork == null || currentEpisode == null) {
      return Center(child: Text('Something wrong!'));
    }
    final currentEpisodeDidLike = currentEpisode.didLike;
    final currentEpisodeLikesCnt = '${currentEpisode.likesCnt}';
    final currentEpisodeCommentsCnt = '${currentEpisode.commentsCnt}';
    final isCommentOpend = ref.watch(
      uiProivder.select((value) => value.isCommentOpend),
    );

    return Container(
      color: Colors.blue,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Visibility(
            visible: !isCommentOpend,
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
              IconWithLabelButton(
                icon: !currentEpisodeDidLike
                    ? Icons.favorite_outline
                    : Icons.favorite,
                size: iconSize,
                label: currentEpisodeLikesCnt,
                onPressed: uiNotifier.onToggleLikeEpisode,
              ),
              IconWithLabelButton(
                icon: Icons.comment,
                size: iconSize,
                label: currentEpisodeCommentsCnt,
                onPressed: uiNotifier.onToggleCommentLayout,
              ),
              IconWithLabelButton(icon: Icons.list_alt, size: iconSize),
              IconWithLabelButton(icon: Icons.local_pizza, size: iconSize),
              IconWithLabelButton(icon: Icons.share, size: iconSize),
              IconWithLabelButton(icon: Icons.more_vert, size: iconSize),
            ],
          ),
          Visibility(
            visible: isCommentOpend,
            child: Expanded(
              child: Container(
                color: Colors.amber,
                child: Column(children: [
                ],),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
