import 'package:Evently/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterpage;

  LoginPage({super.key, required this.showRegisterpage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordObscured = true;
  final _loginformkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Authservice _authservice = Authservice();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Validate Email
  String? _validateEmail(String? email) {
    final RegExp emailRegex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    if (email == null || email.isEmpty || !emailRegex.hasMatch(email)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Validate Password
  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  // Handle Login and Password Update
  Future<void> loginemail() async {
    if (!_loginformkey.currentState!.validate()) {
      return; // Stop login if validation fails
    }

    try {
      // Authenticate User
      UserCredential userCredential =
          await _authservice.signInWithEmailAndPassword(
              _emailController.text.trim(), _passwordController.text.trim());

      // Get user ID
      String userId = userCredential.user!.uid;

      // Retrieve the current password stored in Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('Users').doc(userId).get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;

        if (userData != null) {
          String? storedPassword = userData['password'];

          // Check if password has changed
          if (storedPassword != _passwordController.text.trim()) {
            // Update password in Firestore
            await _firestore.collection('Users').doc(userId).update({
              'password': _passwordController.text.trim(),
              'passwordUpdatedAt': FieldValue.serverTimestamp(),
            });
          }
        }
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Login Successful!"), backgroundColor: Colors.green),
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginformkey,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    SizedBox(height: 80),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Email",
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 15),
                    _buildTextField(
                        controller: _emailController,
                        hintText: "Email",
                        icon: Icons.email,
                        validator: _validateEmail),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Password",
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 15),
                    _buildTextField(
                        controller: _passwordController,
                        hintText: "Password",
                        icon: Icons.lock,
                        isPassword: true,
                        validator: _validatePassword),
                    SizedBox(height: 30),
                    _buildLoginButton(),
                    _buildRegisterRedirect(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 180.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.pinkAccent.shade100,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Welcome Back",
              style: GoogleFonts.poppins(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
          SizedBox(height: 5.h),
          Text("Login to continue",
              style: GoogleFonts.poppins(fontSize: 16.sp, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? _isPasswordObscured : false,
        style: TextStyle(color: Colors.black),
        validator: validator,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(icon, color: Colors.black),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                      _isPasswordObscured
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      _isPasswordObscured = !_isPasswordObscured;
                    });
                  },
                )
              : null,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black54),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(12.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(12.r),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: loginemail,
      child: Container(
        height: 50.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.pinkAccent.shade100,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Text("Login",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }

  Widget _buildRegisterRedirect() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Don't have an account?",
              style: TextStyle(color: Colors.black, fontSize: 14.sp)),
          TextButton(
            onPressed: widget.showRegisterpage,
            child: Text("Sign Up",
                style: TextStyle(
                    color: Colors.pinkAccent.shade100,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
