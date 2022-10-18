import 'package:firebase/screens/login/view/user_registration.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/auth_login_provider.dart';

class ScreenLogin extends StatelessWidget {
  const ScreenLogin({super.key});
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
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'LogIn Page',
          style: TextStyle(color: Colors.black),
        ),
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
                  const SizedBox(
                    height: 100,
                  ),
                  const CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(
                        'https://i.pinimg.com/736x/64/81/22/6481225432795d8cdf48f0f85800cf66.jpg'),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) =>
                        data.validation(value, 'Enter your Email Address'),
                    controller: data.emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      label: const Text('Email Id'),
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) =>
                        data.validation(value, 'Enter your Password'),
                    controller: data.passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.adobe,
                        color: Colors.black,
                      ),
                      label: const Text('Password'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          data.navigationToResetPassword(context);
                        },
                        child: const Text(
                          'Forget Password?',
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  Consumer<FirebaseAuthLogInProvider>(
                    builder: (BuildContext context, value, Widget? child) {
                      return value.isLoading
                          ? const CupertinoActivityIndicator(
                              color: Colors.cyan,
                            )
                          : TextButton.icon(
                              onPressed: () async {
                                await data.signInUserAccount(
                                    data.emailController.text,
                                    data.passwordController.text,
                                    context,
                                    formKeyLogIn);
                              },
                              icon: const Icon(
                                Icons.logout_outlined,
                                color: Colors.black,
                              ),
                              label: const Text(
                                'Login',
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                    },
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => const ScreenUserRegistration(),
                        ),
                      );
                    },
                    child: const Text('New User? Register Now',style: TextStyle(color: Colors.black),),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
