import 'dart:async';

import 'package:comic_short_forms/core/locator/service_locator.dart';
import 'package:comic_short_forms/features/auth/domain/i_auth_repository.dart';
import 'package:comic_short_forms/features/auth/domain/user_model.dart';
import 'package:comic_short_forms/features/auth/infrastructure/mock_auth_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 로그인 데이터 Notifier
class AuthNotifier extends AsyncNotifier<UserModel?>{
  final IAuthRepository _authRepository = locator<MockAuthRepositoryImpl>();
  @override
  FutureOr<UserModel> build() {
    // TODO: implement build
    throw UnimplementedError();
  }

}