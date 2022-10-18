import 'package:firebase/screens/adduser/controller/add_newuser_pro.dart';
import 'package:firebase/screens/login/controller/auth_login_provider.dart';
import 'package:firebase/screens/login/controller/auth_registration_provider.dart';
import 'package:firebase/screens/login/view/screen_splash.dart';
import 'package:firebase/screens/profile/controller/profile_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/dashboard/controller/dashboard_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FirebaseAuthLogInProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FirebaseAuthSignUPProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DashBoardProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileProvider(),
        ),
        StreamProvider(
          create: (context) =>
              context.watch<FirebaseAuthLogInProvider>().straem(),
          initialData: null,
        ),
        ChangeNotifierProvider(
          create: (context) => AddNewUserProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ScreenSplash(),
    );
  }
}
