import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../login/model/user_model.dart';
import '../../login/view/login_page.dart';

class ProfileProvider with ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobController = TextEditingController();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  File? image;
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  UserModel? userModel;

  bool isEditing = false;
  String? downloadUrl;
  Future<void> getImage(ImageSource source) async {
    final pikImage = await ImagePicker().pickImage(
      source: source,
    );
    if (pikImage == null) {
      return;
    } else {
      final imageTemp = File(pikImage.path);
      image = imageTemp;
      notifyListeners();
      log("image picked ");
    }
  }

  Future<void> signOutPage(context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.signOut();
      downloadUrl = null;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (ctx) => const ScreenLogin(),
        ),
        (route) => false,
      );
      log('called');
    } catch (e) {
      log(
        e.toString(),
      );
    }
  }

  Future<void> uploeadPick(String? userid) async {
    Reference reference =
        FirebaseStorage.instance.ref().child('$userid/images');
    await reference.putFile(image!);
    notifyListeners();
  }

  void getProfileImage(String? userid) async {
    try {
      _isLoading = true;
      notifyListeners();
      Reference reference =
          FirebaseStorage.instance.ref().child('$userid/images');
      downloadUrl = await reference.getDownloadURL();
      _isLoading = false;
      notifyListeners();
      log(downloadUrl!);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      log('getImageException${e.toString()}');
    }
  }

  Future<void> submitUpdate(String? userid, context) async {
    if (formKey.currentState!.validate()) {
      _isLoading = true;
      notifyListeners();
      if (image != null) {
        _isLoading = true;
        notifyListeners();
        await uploeadPick(userid);
      } else {
        log('not called');
      }

      UserModel userModel = UserModel(
          email: auth.currentUser!.email.toString(),
          name: nameController.text,
          mob: mobController.text);
      await firebaseFirestore
          .collection(auth.currentUser!.email.toString())
          .doc(auth.currentUser!.uid)
          .update(userModel.toMap());
      _isLoading = false;
      isEditing = false;
      notifyListeners();
      log('submit called');
      //  Navigator.pop(context);
    }
  }

  String? validation(value, String text) {
    if (value == null || value.isEmpty) {
      return text;
    }
    return null;
  }

  String? phoneValidation(String? value) {
    if (value == null || value.isEmpty || value.length != 10) {
      return 'please enter 10 numbers';
    }
    return null;
  }
}
