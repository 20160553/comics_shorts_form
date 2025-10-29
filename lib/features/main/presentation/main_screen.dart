import 'package:comic_short_forms/core/constants/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(AppRoutes.home.icon), label: AppRoutes.home.nameKr),
          BottomNavigationBarItem(icon: Icon(AppRoutes.search.icon), label: AppRoutes.search.nameKr),
          BottomNavigationBarItem(icon: Icon(AppRoutes.latest.icon), label: AppRoutes.latest.nameKr),
          BottomNavigationBarItem(icon: Icon(AppRoutes.comunity.icon), label: AppRoutes.comunity.nameKr),
          BottomNavigationBarItem(icon: Icon(AppRoutes.mypage.icon), label: AppRoutes.mypage.nameKr),
        ],
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            // 탭 다시 눌렀을 때 탭의 첫 페이지로 이동
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
