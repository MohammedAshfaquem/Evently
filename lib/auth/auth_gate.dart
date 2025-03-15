
import 'package:Evently/Homepage/homepage.dart';
import 'package:Evently/auth/auth_page.dart';
import 'package:Evently/auth/emailverification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if(FirebaseAuth.instance.currentUser!.emailVerified == true){
              return Homepage();
            }
            return VerifyEmailPage();
          } else {
            return AuthPage();
          }
        },
      ),
    );
  }
}
