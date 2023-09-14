import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> login() async {
    String token = 'my_personal_secret_token';

    await _storage.write(key: 'token', value: token);

    attempt(token);

    notifyListeners();
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');

    _isAuthenticated = false;

    notifyListeners();
  }

  Future<void> attempt(String? token) async {
    if (token != null) {
      _isAuthenticated = true;
    } else {
      _isAuthenticated = false;
    }

    notifyListeners();
  }
}
