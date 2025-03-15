import 'package:Evently/Carousal%20Slider/imagecontroller.dart';
import 'package:Evently/Category/category_provider.dart';
import 'package:Evently/auth/auth_gate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';


void main()async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SlideImageController()),
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
      home: AuthGate(),
    );
  }
}

