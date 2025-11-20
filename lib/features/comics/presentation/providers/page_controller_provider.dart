import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Artwork Id를 키로 사용하며, 해당 작품의 가로 스크롤 담당하는 컨트롤러
final episodePageControllerProvider = Provider.autoDispose.family<PageController, int>((ref, artworkId) {
  return PageController(initialPage: 0);
});