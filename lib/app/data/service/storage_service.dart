import 'package:get_storage/get_storage.dart';
import '../model/user_model.dart';

class StorageService {
  final GetStorage _box = GetStorage();

  static const String _userKey = 'currentUser';
  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';

  Future<void> saveUser(UserModel user) async {
    await _box.write(_userKey, user.toJson());
  }

  Future<void> saveTokens({
    required String access,
    required String refresh,
  }) async {
    await Future.wait([
      _box.write(_accessTokenKey, access),
      _box.write(_refreshTokenKey, refresh),
    ]);
  }

  UserModel? getUser() {
    final data = _box.read(_userKey);
    if (data != null) {
      return UserModel.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  String? getAccessToken() => _box.read(_accessTokenKey);

  String? getRefreshToken() => _box.read(_refreshTokenKey);

  Future<void> clearSession() async {
    await Future.wait([
      _box.remove(_userKey),
      _box.remove(_accessTokenKey),
      _box.remove(_refreshTokenKey),
    ]);
  }

  bool hasToken() => _box.hasData(_accessTokenKey);
}
