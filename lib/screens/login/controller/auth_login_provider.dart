import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../utils/snack_bar.dart';
import '../../dashboard/view/screen_dashboard.dart';
import '../model/user_model.dart';
import '../view/reset_pass.dart';

class FirebaseAuthLogInProvider with ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController resetPasswordController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  Stream<User?> straem() => auth.authStateChanges();
  UserModel? model;
  final user = FirebaseAuth.instance.currentUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  dynamic signInUserAccount(String email, String password, context,
      GlobalKey<FormState> formKeyLogIn) async {
    try {
      if (formKeyLogIn.currentState!.validate()) {
        _isLoading = true;
        notifyListeners();
        await auth.signInWithEmailAndPassword(email: email, password: password);
        _isLoading = false;
        notifyListeners();
        navigation(context);
        return Future.value('');
      }
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      switch (e.code) {
        case 'invalid-email':
          return ShowSnackBar()
              .showSnackBar(context, Colors.red, 'Inavlid Email Id');
        case 'wrong-password':
          return ShowSnackBar()
              .showSnackBar(context, Colors.red, 'Inavlid Password');
        case 'user-not-found':
          return ShowSnackBar()
              .showSnackBar(context, Colors.red, 'Invalid Email Or Password');
        default:
          log(e.toString());
      }
    }
  }

  String? validation(value, String text) {
    if (value == null || value.isEmpty) {
      return text;
    }
    return null;
  }

  void navigation(context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (ctx) => const ScreenDashBoard(),
        ),
        (route) => false);
  }

  void navigationToResetPassword(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const ScreenResetPassword(),
      ),
    );
  }

  dynamic sentResetPassword(context) async {
    try {
      await auth
          .sendPasswordResetEmail(email: resetPasswordController.text)
          .then(
            (value) => Navigator.pop(context),
          );
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      switch (e.code) {
        case 'user-not-found':
          return ShowSnackBar().showSnackBar(context, Colors.red,
              'There is no user record corresponding to this identifier');

        default:
          log(e.toString());
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
