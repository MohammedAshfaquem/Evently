import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/categpryprovider.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

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
  });

  @override
  State<EventDetailspage> createState() => _EventDetailspageState();
}

class _EventDetailspageState extends State<EventDetailspage> {
  bool isloading = true;

  @override
  Widget build(BuildContext context) {
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
                       
                      },
                      child: Container(
                        height: 50.h,
                        width: 350,
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
                                width: 80,
                                child: Icon(Icons.call,
                                    color: Colors.pink.shade400)),
                            Container(
                              width: 250,
                              height: 60,
                              child: Center(
                                child: Text(widget.cntctno,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 23.sp)),
                              ),
                            ),
                          ],
                        ),
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
