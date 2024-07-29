import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_task/data_models/user_model.dart';
import 'package:flutter_task/services/auth_service.dart';
import 'package:flutter_task/utils/shared_preference_helper.dart';
import 'package:flutter_task/widgets/buttons/app_primary_button.dart';

///
/// Created by Auro on 29/07/24
///

class AuthProvider with ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<AppPrimaryButtonState> buttonKey =
      GlobalKey<AppPrimaryButtonState>();
  late AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  String name = '', email = '', password = '';
  int authType = 0;
  bool isObscure = true;

  final AuthService _authService = AuthService();
  UserDatum? _user;

  UserDatum? get user => _user;

  Future<bool> signUp() async {
    try {
      log("INSIDE SIGN UP : $name $email $password");
      buttonKey.currentState!.showLoader();
      notifyListeners();
      _user = await _authService.signUp(name, email, password);
      SharedPreferenceHelper.storeUser(_user);
      buttonKey.currentState!.hideLoader();
      notifyListeners();
      return _user != null;
    } catch (err) {
      buttonKey.currentState!.hideLoader();
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> signIn() async {
    try {
      log("INSIDE LOGIN : $email $password");
      buttonKey.currentState!.showLoader();
      notifyListeners();
      _user = await _authService.signIn(email, password);
      SharedPreferenceHelper.storeUser(_user);
      buttonKey.currentState!.hideLoader();
      notifyListeners();
      return _user != null;
    } catch (err) {
      buttonKey.currentState!.hideLoader();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }

  handleAutoValidate(AutovalidateMode c) {
    autoValidateMode = c;
    notifyListeners();
  }

  changeAuthType(int value) {
    authType = value;
    notifyListeners();
  }

  toggleObscure() {
    isObscure = !isObscure;
    notifyListeners();
  }

  onNameChanged(String v) {
    name = v;
    notifyListeners();
  }

  onEmailChanged(String v) {
    email = v;
    notifyListeners();
  }

  onPasswordChanged(String v) {
    password = v;
    notifyListeners();
  }
}
