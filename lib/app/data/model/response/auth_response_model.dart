import 'package:blooket/app/data/model/user_model.dart';

class AuthResponseModel {
  final String? accessToken;
  final String? refreshToken;
  final UserModel? user;

  AuthResponseModel({this.accessToken, this.refreshToken, this.user});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],

      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'user': user?.toJson(),
    };
  }
}
