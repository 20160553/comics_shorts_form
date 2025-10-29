import 'package:flutter/material.dart';

class RouteInfo {
  final String nameKr;
  final String nameEn;
  final String path;
  final IconData icon;

  const RouteInfo({
    required this.nameKr,
    required this.nameEn,
    required this.path,
    required this.icon,
  });
}

class AppRoutes {
  AppRoutes._();

  static const RouteInfo home = RouteInfo(
    nameKr: '홈',
    nameEn: 'HOME',
    path: '/home',
    icon: Icons.home,
  );
  static const RouteInfo search = RouteInfo(
    nameKr: '검색',
    nameEn: 'SEARCH',
    path: '/search',
    icon: Icons.search,
  );
  static const RouteInfo latest = RouteInfo(
    nameKr: '최신',
    nameEn: 'LATEST',
    path: '/latest',
    icon: Icons.crop_square,
  );
  static const RouteInfo comunity = RouteInfo(
    nameKr: '커뮤니티',
    nameEn: 'comunity',
    path: '/comunity',
    icon: Icons.location_searching,
  );
  static const RouteInfo mypage = RouteInfo(
    nameKr: '마이페이지',
    nameEn: 'MYPAGE',
    path: '/mypage',
    icon: Icons.person,
  );
}
