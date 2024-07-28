import 'package:flutter/material.dart';
import 'package:flutter_task/data_models/user_model.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';

///
/// Created by Auro on 28/07/24
///

class AppState with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;

  User? get user => _user;

  Future<void> login(String email, String password) async {
    final User user =
        await _authService.signInWithEmailAndPassword(email, password);
    _user = user;
    notifyListeners();
  }

  Future<void> signUp(String name, String email, String password) async {
    final User user =
        await _authService.signUpWithEmailAndPassword(name, email, password);
    _user = user;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }
}
