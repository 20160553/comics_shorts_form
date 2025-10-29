import 'package:flutter/material.dart';

class HomeDetailScreen extends StatelessWidget {
  const HomeDetailScreen({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('$id'));
  }
}
