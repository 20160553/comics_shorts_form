import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract interface class UserModel with _$UserModel {
  const factory UserModel({
    required int uid,
    required String email,
    required String nickname,
    @Default(0)
    int followerNum,
    @Default('')
    String profileImg,
  }) = _UserModel;

  
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

}