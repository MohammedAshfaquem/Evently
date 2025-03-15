
import 'package:Evently/auth/login.dart';
import 'package:Evently/auth/signuppage.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showloginpage = true;
  void togglescreens(){
    setState(() {
      showloginpage = !showloginpage;
    });
  }
  @override
  Widget build(BuildContext context) {
   if(showloginpage){
    return LoginPage(showRegisterpage:togglescreens,);
   }else{
    return RegisterPage(showloginpage:togglescreens,);
   }
  }
}