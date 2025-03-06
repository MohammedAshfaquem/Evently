import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DonateCard extends StatelessWidget {
  const DonateCard(
      {super.key,
      required this.text,
      required this.imageurl,
      required this.onTap,
      required this.height});
  final String text;
  final String imageurl;
  final VoidCallback onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200.h,
        decoration: BoxDecoration(
            color: Colors.pinkAccent.shade100,
            borderRadius: BorderRadius.circular(20)),
        width: 160.w,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Image.asset(imageurl, height: height),
            Text(text,
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
