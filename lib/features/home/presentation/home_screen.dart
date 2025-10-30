import 'package:comic_short_forms/features/comics/presentation/comics_shorts_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ComicsShortsScreen(),
    );
  }
}
