import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:imnote_app/screens/login_screen.dart';
import 'package:imnote_app/utils/pages_navigator.dart';

class AuthCheckService extends StatelessWidget {
  const AuthCheckService({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            return PagesNavigator();
          }
          return LoginScreen();
        });
  }
}
