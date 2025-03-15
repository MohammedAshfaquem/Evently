import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

class Mybooking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    // Function to delete a booking
    Future<void> deleteBooking(String bookingId) async {
      try {
        await FirebaseFirestore.instance.collection("Bookings").doc(bookingId).delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Booking deleted successfully")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete booking: $e")),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            LineAwesomeIcons.angle_left_solid,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        elevation: 0,
        title: Text(
          "My Bookings",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
            color: Colors.pink,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Bookings")
            .where("bookerId", isEqualTo: currentUserUid) // ✅ Fetch only current user's bookings
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset("lib/Animations/emptybox.json", height: 150),
                  SizedBox(height: 10),
                  Text(
                    "No My Bookings yet!",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }

          var bookings = snapshot.data!.docs;

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              var bookingDoc = bookings[index];
              var bookingData = bookingDoc.data() as Map<String, dynamic>;

              return Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Container(
                  height: 130,
                  width: 400,
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 2.w),
                          Container(
                            height: 60.h,
                            width: 60.w,
                            child: Icon(
                              Icons.book,
                              size: 40.sp,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 60.h,
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    " ${bookingData['bookerName']}",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                  Text(
                                    "${bookingData['bookerContact']}",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Show delete button if current user is the booker
                          if (currentUserUid == bookingData['bookerId'])
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.white),
                              onPressed: () {
                                // Show confirmation dialog before deleting
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Delete Booking"),
                                    content: Text("Are you sure you want to delete this booking?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          deleteBooking(bookingDoc.id);
                                          Navigator.pop(context);
                                        },
                                        child: Text("Delete", style: TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                      Divider(color: Colors.white),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.location_on, color: Colors.white),
                          Container(
                            height: 20.h,
                            width: 150.w,
                            child: Center(
                              child: Text(
                                overflow: TextOverflow.ellipsis,
                                "${bookingData['bookerAddress']}",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 30.h,
                            width: 130.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                overflow: TextOverflow.ellipsis,
                                "${bookingData['category']}",
                                style: GoogleFonts.poppins(
                                  color: Colors.pinkAccent.shade100,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
