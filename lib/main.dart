import 'package:flutter/material.dart';
import 'package:flutter_application_1/Carousal%20Slider/imagecontroller.dart';
import 'package:flutter_application_1/categpryprovider.dart';
import 'package:flutter_application_1/donate_controller%20copy.dart';
import 'package:flutter_application_1/signuppage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';




void main() {
  
    runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SlideImageController()),
        ChangeNotifierProvider(create: (context) => Donate()),
      ChangeNotifierProvider(create: (context) => CategoryProvider()),
      ],
      child: ScreenUtilInit(
        designSize: Size(360, 690), // Adjust as per your design
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: MyApp(),
          );
        },
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Event Management',
      home: RegisterPage(),
    );
  }
}

