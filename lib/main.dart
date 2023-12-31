import "package:firebase_auth2/auth_page.dart";
import "package:firebase_auth2/verify_email.dart";
import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";
import "package:firebase_auth/firebase_auth.dart";
import "Util.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: Util.messengerKey,
        title: 'Flutter Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey.shade800,
          textTheme: Theme.of(context)
              .textTheme
              .apply(bodyColor: Colors.white, displayColor: Colors.white),
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            body: StreamBuilder<User?>(
                //to check if user is logged in or logged out
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text("Something Went Wrong "));
                  }
                  if (snapshot.hasData) {
                    return const VerifyEmail();
                  } else {
                    return const AuthPage();
                  }
                })));
  }
}
