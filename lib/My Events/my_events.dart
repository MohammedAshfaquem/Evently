import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class MyEvents extends StatelessWidget {
  const MyEvents({super.key});

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(LineAwesomeIcons.angle_left_solid,
              color: Theme.of(context).colorScheme.primary),
        ),
        title: Text('My Events',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
                color: Colors.pinkAccent.shade100)),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('My Events')
            .where('uid', isEqualTo: uid) // Only filter without ordering
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print("Firestore Error: ${snapshot.error}"); // Debugging log
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset("lib/Animations/emptybox.json", height: 150),
                  SizedBox(height: 10),
                  Text(
                    "No listings available for this category.",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }

          final events = snapshot.data!.docs;

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index].data() as Map<String, dynamic>;
              final docId = events[index].id;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white),
                  height: 110.h,
                  width: 500.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(width: 10.w,),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: Image.network(
                          event['image'] ?? "https://via.placeholder.com/100",
                          fit: BoxFit.cover,
                          height: 80.h,
                          width: 100.w,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Colors.grey.shade100,
                              height: 80.h,
                              width: 100.w,
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Image.network(
                                "https://via.placeholder.com/100",
                                height: 80.h,
                                width: 100.w);
                          },
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                event['eventname'] ?? "No Name",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 19.sp),
                              ),
                              Text(
                                event['category'] ?? "No Category",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                              Text(
                                event['amount'] ?? "No Amount",
                                style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.warning,
                            showCancelBtn: true,
                            onCancelBtnTap: () => Navigator.pop(context),
                            title: 'Are you sure?',
                            onConfirmBtnTap: () async {
                              await deleteEvent(docId, event['eventid'],
                                  event['category']); // ✅ Pass category
                              Navigator.pop(context);
                            },
                          );
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      )
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

  /// Delete event from both 'Events' and 'My Events' collections
  Future<void> deleteEvent(
      String myEventId, String eventId, String category) async {
    final myEventsRef =
        FirebaseFirestore.instance.collection('My Events').doc(myEventId);
    final eventsRef = FirebaseFirestore.instance
        .collection('Events')
        .doc(category) // 🔹 Navigate to category subcollection
        .collection('Listings')
        .doc(eventId); // 🔹 Find event by its eventId

    await myEventsRef.delete();
    await eventsRef.delete();
  }
}
