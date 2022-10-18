
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/auth_login_provider.dart';

class ScreenResetPassword extends StatelessWidget {
  const ScreenResetPassword({super.key});
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<FirebaseAuthLogInProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      data.emailController.clear();
      data.passwordController.clear();
    });
    final formKeyLogIn = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKeyLogIn,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) =>
                        data.validation(value, 'Enter Email Address'),
                    controller: data.resetPasswordController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      label: const Text('Email Id'),
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Consumer<FirebaseAuthLogInProvider>(
                    builder: (BuildContext context, value, Widget? child) {
                      return value.isLoading
                          ? const CupertinoActivityIndicator(
                              color: Colors.cyan,
                            )
                          : TextButton.icon(
                              onPressed: () async {
                                value.sentResetPassword(context);
                              },
                              icon: const Icon(Icons.login_outlined),
                              label: const Text('Login'),
                            );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
