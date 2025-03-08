import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_service.dart';
import 'package:flutter_application_1/signuppage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

final _loginformkey = GlobalKey<FormState>();

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterpage;

  const LoginPage({super.key, required this.showRegisterpage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordObscured = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _validateEmail(String? email) {
    final RegExp emailRegex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}");
    if (email == null || email.isEmpty || !emailRegex.hasMatch(email)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }
  void loginemail() async {
    final authservice = Authservice();

    try {
      await authservice.signInWithEmailAndPassword(
          _emailController.text, _passwordController.text);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            e.toString(),
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
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
                child: Form(
                  // key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 80,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Email",
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      _buildTextField(
                          controller: _emailController,
                          hintText: "Email",
                          icon: Icons.email,
                          validator: _validateEmail),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Password",
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      _buildTextField(
                          controller: _passwordController,
                          hintText: "Password",
                          icon: Icons.lock,
                          isPassword: true,
                          validator: _validatePassword),
                      SizedBox(
                        height: 30,
                      ),
                      _buildLoginButton(),
                      _buildRegisterRedirect(),
                    ],
                  ),
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
                    color: Colors.grey,
                  ),
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
    onTap: () => loginemail(),
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
