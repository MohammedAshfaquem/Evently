import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/categpryprovider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class EventDetailspage extends StatefulWidget {
  var eventname;
  var description;
  var hostname;
  var cntctno;
  var imageurl;
  var time;
  var userimage;
  var amount;
  var location;
  var eventId;
  var category;
  var userid;

  EventDetailspage({
    super.key,
    this.description,
    this.cntctno,
    this.imageurl,
    this.time,
    this.userimage,
    this.eventname,
    this.hostname,
    this.amount,
    this.location,
    required this.eventId,
    required this.category,
    required this.userid,
  });

  @override
  State<EventDetailspage> createState() => _EventDetailspageState();
}

class _EventDetailspageState extends State<EventDetailspage> {
  bool isloading = true;

  @override
  Widget build(BuildContext context) {
    void showBookingDialog(BuildContext context, String eventId) {
      TextEditingController nameController = TextEditingController();
      TextEditingController contactController = TextEditingController();
      TextEditingController addressController = TextEditingController();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Book Event"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: contactController,
                  decoration: InputDecoration(labelText: "Contact Number"),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: "Address"),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), // Close dialog
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  if (nameController.text.isEmpty ||
                      contactController.text.isEmpty ||
                      addressController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill all fields')),
                    );
                    return;
                  }

                  try {
                    User? currentUser = FirebaseAuth.instance.currentUser;
                    if (currentUser == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('User not logged in')),
                      );
                      return;
                    }

                    // ✅ Add booking to Firestore
                    await FirebaseFirestore.instance
                        .collection("Bookings")
                        .add({
                      'eventId': eventId,
                      'bookerId': currentUser.uid, // Store the booker's ID
                      'bookerName': nameController.text,
                      'hosteruid': widget.userid,
                      'bookerContact': contactController.text,
                      'bookerAddress': addressController.text,
                      'timestamp': FieldValue.serverTimestamp(),
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Booking successful!')),
                    );

                    Navigator.pop(context); // Close dialog after saving
                  } catch (e) {
                    print("Error while booking: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                  Navigator.pop(context);
                },
                child: Text("Book Now"),
              ),
            ],
          );
        },
      );
    }

    void checkAndShowBookingDialog(
        BuildContext context, String category, String eventId) async {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not logged in')),
        );
        return;
      }

      try {
        // 🔹 Fetch event details to get the event host's UID
        DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
            .collection("Events")
            .doc(category) // Event category
            .collection("Listings")
            .doc(eventId) // Fetch event by ID
            .get();

        if (!eventSnapshot.exists) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Event not found!')),
          );
          return;
        }

        String eventOwnerId = eventSnapshot['uid']; // Get the host's UID

        // ✅ Prevent self-booking
        if (currentUser.uid == eventOwnerId) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You cannot book your own event!')),
          );
          return;
        }

        // ✅ Show booking dialog if the user is not the host
        showBookingDialog(context, eventId);
      } catch (e) {
        print("Error while checking event: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }

    Future<void> _makePhoneCall() async {
      final Uri phoneUri = Uri.parse('tel:${widget.cntctno}');

      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        throw 'Could not launch $phoneUri';
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent.shade100,
        leading: IconButton(
          onPressed: () {
            Navigator.maybePop(context);
          },
          icon: Icon(
            color: Colors.white,
            LineAwesomeIcons.angle_left_solid,
          ),
        ),
        title: Text("Event Details",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            )),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Consumer<CategoryProvider>(
          builder: (context, value, child) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30).w,
                  child: Image.network(
                    widget.imageurl,
                    width: 500.w,
                    height: 200.h,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(widget.eventname.toString(),
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.pink)),
                Container(
                  height: 70,
                  width: 400,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.pink.shade100),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Container(
                          width: 240,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 100.w,
                              ),
                              Text(widget.hostname.toString(),
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                              Text(widget.time,
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 70,
                        height: 70,
                        child: Center(
                          child: Text("${widget.amount}",
                              style: GoogleFonts.poppins(
                                  color: Colors.blue, fontSize: 15)),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Event details",
                            style: GoogleFonts.poppins(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.pink)),
                        SizedBox(height: 5.h),
                        Container(
                          height: 180.h,
                          width: 320.w,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.pink),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("${widget.description}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 10,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        checkAndShowBookingDialog(
                            context, widget.category, widget.eventId);
                      },
                      child: Container(
                        height: 50.h,
                        width: 100.w,
                        child: Center(
                            child: Text(
                          "Book",
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 19),
                        )),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12).w,
                            color: Colors.pinkAccent.shade100),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Container(
                      height: 50.h,
                      width: 230,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12).w,
                          color: Colors.pinkAccent.shade100),
                      child: Row(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.pink),
                                  borderRadius: BorderRadius.circular(12)),
                              height: 60,
                              width: 60,
                              child: Icon(Icons.call,
                                  color: Colors.pink.shade400)),
                          GestureDetector(
                            onTap: _makePhoneCall,
                            child: Container(
                              width: 160,
                              height: 60,
                              child: Center(
                                child: Text(widget.cntctno,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 23.sp)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
