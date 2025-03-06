import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

final _formkey = GlobalKey<FormState>();

class RegisterPage extends StatefulWidget {
  final VoidCallback showloginpage;
  const RegisterPage({
    super.key,
    required this.showloginpage,
  });

  @override
  State<RegisterPage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<RegisterPage> {
  var _isconfirmpassobscured;
  var _ispassobscured;
  final regemailcontroller = TextEditingController();
  final regpasswordcontroller = TextEditingController();
  final regnamecontroller = TextEditingController();
  final regconfirmpasscontroller = TextEditingController();
  bool value = false;

  bool passwordConfirmed() {
    return regpasswordcontroller.text.trim() ==
        regconfirmpasscontroller.text.trim();
  }

  void register() {
    if (regnamecontroller.text.trim().isEmpty ||
        regemailcontroller.text.trim().isEmpty ||
        regpasswordcontroller.text.trim().isEmpty ||
        regconfirmpasscontroller.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Form Incomplete"),
          content: const Text("Please fill all fields to continue."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }
    if (!passwordConfirmed()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Password Mismatch"),
          content:
              const Text("The passwords do not match. Please try again."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }
    // Proceed with the registration logic (e.g., store user details locally)
    print("User Registered: ${regnamecontroller.text}");
  }

  @override
  void dispose() {
    super.dispose();
    regemailcontroller.dispose();
    regpasswordcontroller.dispose();
    regnamecontroller.dispose();
    regconfirmpasscontroller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _ispassobscured = true;
    _isconfirmpassobscured = true;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20.h),
                child: Column(
                  children: [
                    Text(
                      "Let's Get Started",
                      style: GoogleFonts.poppins(
                          fontSize: 25,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: regnamecontroller,
                      decoration: const InputDecoration(
                        labelText: "Name",
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: regemailcontroller,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: regpasswordcontroller,
                      obscureText: _ispassobscured,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(_ispassobscured
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _ispassobscured = !_ispassobscured;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: regconfirmpasscontroller,
                      obscureText: _isconfirmpassobscured,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(_isconfirmpassobscured
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _isconfirmpassobscured = !_isconfirmpassobscured;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("I agree to the terms and conditions"),
                        CupertinoSwitch(
                          value: value,
                          onChanged: (newValue) {
                            setState(() {
                              value = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: register,
                      child: const Text("Sign Up"),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          onPressed: widget.showloginpage,
                          child: const Text("Login"),
                        ),
                      ],
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