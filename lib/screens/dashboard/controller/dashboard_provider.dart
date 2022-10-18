import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../adduser/view/screen_add_user.dart';
import '../../login/model/user_model.dart';
import '../../profile/view/screen_profile.dart';

class DashBoardProvider with ChangeNotifier {
  final TextEditingController firstNameRegController = TextEditingController();
  final TextEditingController ageRegController = TextEditingController();
  UserModel? userModel;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;

  String? validation(value, String text) {
    if (value == null || value.isEmpty) {
      return text;
    }
    return null;
  }

  Future<void> getData() async {
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.email.toString())
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        userModel = UserModel.fromMap(value.data()!);
        log(userModel.toString());
      });
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  void navigationToAdd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const ScreenAddUser(
          type: ActionType.addScreen,
        ),
      ),
    );
  }

  void navigationToProfile(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ScreenProfile(
          userId: FirebaseAuth.instance.currentUser!.email.toString(),
        ),
      ),
    );
  }
}
