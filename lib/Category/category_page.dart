import 'package:flutter/material.dart';
import 'package:flutter_application_1/categorylistpage.dart';
import 'package:flutter_application_1/hostdetailspage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CategorySelectionPage extends StatelessWidget {
  final bool isHoster;

  const CategorySelectionPage({super.key, required this.isHoster});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {"name": "Camera Man", "image": "lib/images/cameraman.png"},
      {"name": "Invitations", "image": "lib/images/iinvitations.png"},
      {"name": "Makeup Artists", "image": "lib/images/make up.png"},
      {"name": "Caterers", "image": "lib/images/caterers.png"},
      {"name": "Auditoriums", "image": "lib/images/auditoriam.png"},
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              LineAwesomeIcons.angle_left_solid,
              color: Theme.of(context).colorScheme.primary,
            )),
        elevation: 0,
        title: Text(isHoster ? "Vendor Event" : "Find an Event",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
                color: Colors.pink)),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (isHoster) {
                //Navigate to hoster form
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HostDetailsForm(
                            category: categories[index]
                                ["name"]!, // Fetching the name
                          )),
                );
              } else {
                // Navigate to guest view of the category
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryListPage(
                      category: categories[index]["name"]!, // Fetching the name
                    ),
                  ),
                );
              }
            },
            child: Container(
              width: 350.w,
              height: 160.h,
              margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.pinkAccent.shade100,
                borderRadius: BorderRadius.circular(25.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 35.h),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          "Category ${index + 1}",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          categories[index]['name']!,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 200,
                    width: 150,
                    child: Image.asset(categories[index]['image']!,
                        fit: BoxFit.fill),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
