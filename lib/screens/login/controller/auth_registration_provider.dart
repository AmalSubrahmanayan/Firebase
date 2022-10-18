import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../utils/snack_bar.dart';
import '../../dashboard/view/screen_dashboard.dart';
import '../model/user_model.dart';

class FirebaseAuthSignUPProvider with ChangeNotifier {
  final TextEditingController emailRegController = TextEditingController();
  final TextEditingController passwordRegController = TextEditingController();
  final TextEditingController nameRegController = TextEditingController();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final formKeySignIn = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> createUserAccount(String email, String password, context) async {
    try {
      _isLoading = true;
      notifyListeners();
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        UserModel userModel = UserModel(
            email: auth.currentUser!.email,
            name: nameRegController.text,
            mob: 'No Mobile Number');

        await firebaseFirestore
            .collection(auth.currentUser!.email.toString())
            .doc(auth.currentUser!.uid)
            .set(userModel.toMap());
      });
      _isLoading = false;
      notifyListeners();
      ShowSnackBar()
          .showSnackBar(context, Colors.green, 'New user Creted Successfully');
      navigation(context);
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      switch (e.code) {
        case 'invalid-email':
          return ShowSnackBar().showSnackBar(
              context, Colors.red, 'The email address is Not correct format');
        case 'weak-password':
          return ShowSnackBar().showSnackBar(
              context, Colors.red, 'Password should be at least 6 characterst');
        case 'email-already-in-use':
          return ShowSnackBar().showSnackBar(context, Colors.red,
              'The email address is already in use by another account');
        default:
          return ShowSnackBar().showSnackBar(context, Colors.red,
              'The email Or Password is Not correct format');
      }
    } catch (e) {
      log(e.toString());
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
}
