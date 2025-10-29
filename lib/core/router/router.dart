import 'package:comic_short_forms/core/constants/app_routes.dart';
import 'package:comic_short_forms/features/community/presentation/community_screen.dart';
import 'package:comic_short_forms/features/home/presentation/home_detail_screen.dart';
import 'package:comic_short_forms/features/home/presentation/home_screen.dart';
import 'package:comic_short_forms/features/latest/presentation/latest_screen.dart';
import 'package:comic_short_forms/features/main/presentation/main_screen.dart';
import 'package:comic_short_forms/features/mypage/presentation/mypage_screen.dart';
import 'package:comic_short_forms/features/search/presentation/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// 앱 전체 네비게이터 키
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final _shellNavigatorKeyTabHome = GlobalKey<NavigatorState>(
  debugLabel: AppRoutes.home.nameEn,
);
final _shellNavigatorKeyTabSearch = GlobalKey<NavigatorState>(
  debugLabel: AppRoutes.search.nameEn,
);
final _shellNavigatorKeyTabLatest = GlobalKey<NavigatorState>(
  debugLabel: AppRoutes.latest.nameEn,
);
final _shellNavigatorKeyTabCommunity = GlobalKey<NavigatorState>(
  debugLabel: AppRoutes.comunity.nameEn,
);
final _shellNavigatorKeyTabMypage = GlobalKey<NavigatorState>(
  debugLabel: AppRoutes.mypage.nameEn,
);

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.home.path, // 앱 시작 시 첫 페이지
    // (⭐ 해결책) 리다이렉트 로직 추가
    redirect: (context, state) {
      // 사용자가 루트('/') 경로로 왔다면,
      if (state.matchedLocation == '/') {
        // initialLocation인 '/home'으로 리다이렉트
        return AppRoutes.home.path;
      }
      // 그 외에는 아무것도 하지 않음 (null 반환)
      return null;
    },
    routes: [
      // (로그인 페이지 - 쉘 외부의 라우트)
      // GoRoute(
      //   path: '/login',
      //   builder: (context, state) => LoginScreen(),
      // ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorKeyTabHome,
            routes: [
              GoRoute(
                path: AppRoutes.home.path,
                builder: (context, state) => const HomeScreen(),
                routes: [
                  // 딥링크 확장 가능
                  GoRoute(
                    path: 'details/:id', // /home/details/:id
                    builder: (context, state) {
                      final id = int.parse(state.pathParameters['id']!);
                      return HomeDetailScreen(id: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorKeyTabSearch,
            routes: [
              GoRoute(
                path: AppRoutes.search.path,
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorKeyTabLatest,
            routes: [
              GoRoute(
                path: AppRoutes.latest.path,
                builder: (context, state) => const LatestScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorKeyTabCommunity,
            routes: [
              GoRoute(
                path: AppRoutes.comunity.path,
                builder: (context, state) => const CommunityScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorKeyTabMypage,
            routes: [
              GoRoute(
                path: AppRoutes.mypage.path,
                builder: (context, state) => const MypageScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
