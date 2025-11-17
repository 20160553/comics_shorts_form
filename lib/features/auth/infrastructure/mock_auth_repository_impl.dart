
import 'dart:io';

import 'package:comic_short_forms/features/auth/domain/i_auth_repository.dart';

class MockAuthRepositoryImpl implements IAuthRepository {
  @override
  Future<HttpResponse> signIn() {
    // TODO: implement signIn
    throw UnimplementedError();
  }
    
}