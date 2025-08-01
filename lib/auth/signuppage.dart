import 'package:Evently/auth/emailverification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: camel_case_types
final _signformkey = GlobalKey<FormState>();

class RegisterPage extends StatefulWidget {
  final VoidCallback showloginpage;
  const RegisterPage({
    super.key,
    required this.showloginpage,
  });

  @override
  State<RegisterPage> createState() => _RegisterpageState();
}

// ignore: camel_case_types
class _RegisterpageState extends State<RegisterPage> {
  var _isconfirmpassobscured;
  var _ispassobscured;
  final regemailcontroller = TextEditingController();
  final regpasswordcontroller = TextEditingController();
  final regnamecontroller = TextEditingController();
  final regconfirmpasscontroller = TextEditingController();
  bool value = false;

  String? validatemail(String? email) {
    RegExp emailRegex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    final isemailvalid = emailRegex.hasMatch(email ?? '');
    if (!isemailvalid) {
      return 'Please Enter a valid email';
    }
    return null;
  }

  bool passwordConfirmed() {
    if (regpasswordcontroller.text.trim() ==
        regconfirmpasscontroller.text.trim()) {
      return true;
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Password Mismatch',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            content: Text(
                'The passwords you entered do not match. Please try again.',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w500)),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      return false;
    }
  }

  Future<void> signupEmail() async {
    if (regnamecontroller.text.trim().isEmpty) {
      // Show an alert dialog if the name is empty
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Fill the form",
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold),
          ),
          content: Text(
            "Fill the form to continue.",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
      return print("false"); // Exit the function if the name is empty
    }
    if (passwordConfirmed()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: regemailcontroller.text.trim(),
                password: regpasswordcontroller.text.trim());
        // Send email verification
        await userCredential.user?.sendEmailVerification();
        // Save user data and creation timestamp to Firestore
        String uid = userCredential.user!.uid;
        await FirebaseFirestore.instance.collection('Users').doc(uid).set({
          'email': regemailcontroller.text,
          'name': regnamecontroller.text,
          'emailVerified': false,
          'createdAt': FieldValue.serverTimestamp(), // Store creation time
          'password': regconfirmpasscontroller.text,
          'uid': uid,
          'image':"",
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyEmailPage(),
          ),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              e.toString(),
              style: TextStyle(color: Colors.black),
            ),
          ),
        );
        print("error:${e.toString()}");
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    regemailcontroller.dispose();
    regpasswordcontroller.dispose();
  }

  void initState() {
    super.initState();
    _ispassobscured = true;
    _isconfirmpassobscured = true;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _signformkey,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 200,
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.pinkAccent.shade100,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20.r)),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 80,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Lets's Get Started",
                          style: GoogleFonts.poppins(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Fill the form to continue",
                          style: GoogleFonts.poppins(
                              fontSize: 15.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 880.h,
                width: 420.w,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.h),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: TextFormField(
                              style: TextStyle(color: Colors.black),
                              validator: (value) {
                                return value == null || value.isEmpty
                                    ? "Please fill this field"
                                    : "";
                              },
                              obscureText: false,
                              controller: regnamecontroller,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.black,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(15).r,
                                ),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15).r),
                                hintText: "Name",
                                hintStyle: TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15).r,
                                  borderSide:
                                      const BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: TextFormField(
                              style: TextStyle(color: Colors.black),
                              validator: (value) {
                                return value == null || value.isEmpty
                                    ? "Please fill this field"
                                    : "";
                              },
                              obscureText: false,
                              controller: regemailcontroller,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.black,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(15).r,
                                ),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15).r),
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15).r,
                                  borderSide:
                                      const BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          // Registerfield(
                          //     controller: regemailcontroller,
                          //     hintText: "Your email",
                          //     icon: Icons.email,
                          //     obscuretext: false),
                          SizedBox(
                            height: 15.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: TextFormField(
                              style: TextStyle(color: Colors.black),
                              validator: (value) {
                                return value == null || value.isEmpty
                                    ? "Please fill this field"
                                    : "";
                              },
                              obscureText: _ispassobscured,
                              controller: regpasswordcontroller,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.black,
                                ),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _ispassobscured = !_ispassobscured;
                                      });
                                    },
                                    icon: _ispassobscured
                                        ? Icon(Icons.visibility_off,
                                            color: Colors.grey)
                                        : Icon(Icons.visibility,
                                            color: Colors.black)),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(15).r,
                                ),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15).r),
                                hintText: "password",
                                hintStyle: TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15).r,
                                  borderSide:
                                      const BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: TextFormField(
                              style: TextStyle(color: Colors.black),
                              validator: (value) {
                                return value == null || value.isEmpty
                                    ? "Please fill this field"
                                    : "";
                              },
                              obscureText: _isconfirmpassobscured,
                              controller: regconfirmpasscontroller,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isconfirmpassobscured =
                                            !_isconfirmpassobscured;
                                      });
                                    },
                                    icon: _isconfirmpassobscured
                                        ? Icon(Icons.visibility_off,
                                            color: Colors.grey)
                                        : Icon(Icons.visibility,
                                            color: Colors.black)),
                                fillColor: Colors.white,
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.black,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(15).r,
                                ),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15).r),
                                hintText: "Confirm password",
                                hintStyle: TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15).r,
                                  borderSide:
                                      const BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "i agree with terms and use",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                width: 120.w,
                              ),
                              CupertinoSwitch(
                                value: value,
                                onChanged: (newvalue) {
                                  setState(() {
                                    value = !value;
                                  });
                                },
                                focusColor: Colors.white,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          GestureDetector(
                            onTap: () {
                              signupEmail();
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 20.w),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.pinkAccent.shade100,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                height: 55.h,
                                width: 390.w,
                                child: Center(
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account?",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              GestureDetector(
                                onTap: widget.showloginpage,
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.pinkAccent.shade100,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15.sp),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
