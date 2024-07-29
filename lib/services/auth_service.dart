import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_task/data_models/user_model.dart';
import 'package:flutter_task/utils/shared_preference_helper.dart';

///
/// Created by Auro on 29/07/24
///

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserDatum?> signUp(String name, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      if (user != null) {
        UserDatum newUser = UserDatum(
          uid: user.uid,
          name: name,
          email: email,
        );
        await _firestore.collection('user').doc(user.uid).set(newUser.toJson());
        return newUser;
      }
    } on FirebaseAuthException catch (e) {
      log("ERROR IN SIGN IN ${e.code}");

      if (e.code == 'weak-password') {
        throw 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        throw 'An account already exists with this email address.';
      } else if (e.code == 'invalid-email') {
        throw 'The email address is not valid.';
      } else {
        throw 'An error occurred. Please try again.';
      }
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
    return null;
  }

  Future<UserDatum?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      if (user != null) {
        DocumentSnapshot doc =
            await _firestore.collection('user').doc(user.uid).get();
        return UserDatum.fromJson(doc.data() as Map<String, dynamic>);
      }
    } on FirebaseAuthException catch (e) {
      log("ERROR IN SIGN IN ${e.code}");
      if (e.code == 'invalid-credential') {
        throw 'Invalid credentials. Please check your email and password.';
      } else {
        throw 'An error occurred. Please try again.';
      }
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
    return null;
  }

  Future<void> signOut() async {
    SharedPreferenceHelper.clear();
    await _auth.signOut();
  }
}
