
import 'package:firebase/screens/login/controller/auth_registration_provider.dart';
import 'package:firebase/utils/core/constent_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../dashboard/controller/dashboard_provider.dart';

class ScreenUserRegistration extends StatelessWidget {
  const ScreenUserRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    final data =
        Provider.of<FirebaseAuthSignUPProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      data.emailRegController.clear();
      data.nameRegController.clear();
      data.passwordRegController.clear();

      await Provider.of<DashBoardProvider>(context, listen: false).getData();
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('FirebaseAut',style: TextStyle(color: Colors.black),),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: data.formKeySignIn,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  validator: (value) =>
                      data.validation(value, 'Enter your Name'),
                  controller: data.nameRegController,
                  decoration: InputDecoration(
                    label: const Text('Full Name'),
                    prefixIcon: const Icon(Icons.nest_cam_wired_stand,color: Colors.black,),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                ConstentWidget.kWidth20,
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      data.validation(value, 'Enter your Email'),
                  controller: data.emailRegController,
                  decoration: InputDecoration(
                    label: const Text('Email Id'),
                    prefixIcon: const Icon(Icons.email,color: Colors.black,),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                ConstentWidget.kWidth20,
                TextFormField(
                  validator: (value) =>
                      data.validation(value, 'Enter your Password'),
                  controller: data.passwordRegController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.adobe,color: Colors.black,),
                    label: const Text('Password'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                ConstentWidget.kWidth32,
                Consumer<FirebaseAuthSignUPProvider>(
                  builder: (BuildContext context, value, Widget? child) {
                    return value.isLoading
                        ? const CupertinoActivityIndicator(
                            color: Colors.cyan,
                          )
                        : TextButton.icon(
                            onPressed: () async {
                              if (data.formKeySignIn.currentState!.validate()) {
                                await data.createUserAccount(
                                    data.emailRegController.text,
                                    data.passwordRegController.text,
                                    context);
                              }
                            },
                            icon: const Icon(Icons.recent_actors,color: Colors.black,),
                            label: const Text('Register',style: TextStyle(color: Colors.black),),
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
