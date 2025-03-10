import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class BookingDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

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
        title: Text("Booker Details",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
                color: Colors.pink)),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Bookings")
            .where("userId",
                isEqualTo: currentUserUid) // Fetch bookings for current hoster
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No bookings yet!"));
          }

          var bookings = snapshot.data!.docs;

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              var bookingData = bookings[index].data() as Map<String, dynamic>;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 90,
                  width: 400,
                  decoration: BoxDecoration(
                      color: Colors.pinkAccent.shade100,
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 2.w,
                      ),
                      Container(
                        height: 90.h,
                        width: 60.w,
                        child: Icon(
                          Icons.book,
                          size: 40.sp,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        height: 90.h,
                        width: 160.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              " ${bookingData['bookerName']}",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20.sp),
                            ),
                            Text(
                              "${bookingData['bookerContact']}",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20.sp),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 90.h,
                        width: 90.w,
                        child: Center(
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            "${bookingData['bookerAddress']}",
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
              //ListTile(
              //   title: Text("Booker: ${bookingData['bookerName']}"),
              //   subtitle: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text("Contact: ${bookingData['bookerContact']}"),
              //       Text("Address: ${bookingData['bookerAddress']}"),
              //       Text("Event ID: ${bookingData['eventId']}"), // Optional
              //     ],
              //   ),
              //   leading: Icon(Icons.person),
              // );
            },
          );
        },
      ),
    );
  }
}
