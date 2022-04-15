// ignore_for_file: use_key_in_widget_constructors

import 'package:chat_app/constants.dart';

import 'package:chat_app/screens/main_screen.dart';
import 'package:chat_app/screens/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'firebase_options.dart';

//bool USE_FIRESTORE_EMULATOR = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      //options: DefaultFirebaseOptions.currentPlatform,
      );

  // if (USE_FIRESTORE_EMULATOR) {
  //   FirebaseFirestore.instance.settings = const Settings(
  //       host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);
  // }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        theme: ThemeData(
            scaffoldBackgroundColor: Styles.backgroundPrimary,
            fontFamily: 'Nunito'),
        home: _auth.currentUser != null
            ? const MainScreen()
            : const WelcomeScreen()

        // home: VerifyNumberScreen(
        //   number: kPhoneNumber,
        // ),
        );
  }
}
