import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? user;

  AuthProvider() {
    _authService.authStateChanges.listen((User? u) {
      user = u;
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    user = await _authService.login(email, password);
    notifyListeners();
  }

  Future<void> signup(String email, String password) async {
    user = await _authService.signUp(email, password);
    notifyListeners();
  }

  Future<void> googleLogin() async {
  user = await _authService.signInWithGoogle();
  notifyListeners();
}

  Future<void> logout() async {
    await _authService.logout();
    user = null;
    notifyListeners();
  }
}