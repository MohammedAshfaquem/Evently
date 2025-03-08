
import 'package:flutter/material.dart';
import 'package:flutter_application_1/login.dart';
import 'package:flutter_application_1/signuppage.dart';

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