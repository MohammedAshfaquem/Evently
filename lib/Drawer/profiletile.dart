import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfilePageTile extends StatelessWidget {
  const ProfilePageTile(
      {super.key,
      required this.onTap,
      required this.text,
     
      required this.icon,
      this.colors = Colors.white});
  final String text;
  final IconData icon;
  final Color colors;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        leading: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                100,
              ),
          ),
          height: 40,
          width: 40,
          child: Icon(
            icon,
            color: Colors.black,
          ),
        ),
        title: Text(text,
            style: GoogleFonts.poppins(
                color:colors, fontWeight: FontWeight.w500, fontSize: 17)),
       
      ),
    );
  }
}
