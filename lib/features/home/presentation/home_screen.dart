import 'package:comic_short_forms/core/constants/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('${AppRoutes.home.path}/details/123'),
          child: Text('상세페이지 딥링크: (ID: 123)'),
        ),
      ),
    );
  }
}
