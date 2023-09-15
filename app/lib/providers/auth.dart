import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

// Helpers
import 'package:chirper/helpers/dio.dart';

// Models
import 'package:chirper/models/user.dart';

class AuthProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  User? _user;
  User? get user => _user;

  Future<Response?> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    try {
      Response response = await dio().post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirm,
      });

      String token = response.toString();

      await _storage.write(key: 'token', value: token);

      attempt(token);

      notifyListeners();

      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<Response?> login({
    required String email,
    required String password,
  }) async {
    try {
      Response response = await dio().post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      String token = response.toString();

      await _storage.write(key: 'token', value: token);

      attempt(token);

      notifyListeners();

      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<void> logout() async {
    _isAuthenticated = false;

    await dio().post('/auth/logout');

    await _storage.delete(key: 'token');

    notifyListeners();
  }

  Future<void> attempt(String? token) async {
    try {
      Response response = await dio().get('/auth/user');

      _user = User.fromJson(response.data);

      _isAuthenticated = true;
    } on DioException catch (e) {
      if (e.response != null) {
        if (kDebugMode) {
          print('Catch: true');
          print(e.response);
        }
      } else {
        if (kDebugMode) {
          print('Catch: false');
          print(e.response);
        }
      }

      _isAuthenticated = false;
    }

    notifyListeners();
  }
}
