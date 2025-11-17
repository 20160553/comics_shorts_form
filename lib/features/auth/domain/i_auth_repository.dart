import 'dart:io';

abstract interface class IAuthRepository {
  Future<HttpResponse> signIn();
}