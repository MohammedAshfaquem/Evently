import 'package:Evently/Homepage/homepage.dart';
import 'package:Evently/details_Page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';

class CategoryListPage extends StatelessWidget {
  final String category;

  CategoryListPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent.shade100,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Homepage()),
            );
          },
          icon: Icon(
            LineAwesomeIcons.angle_left_solid,
            color: Colors.white,
          ),
        ),
        title: Text(
          "$category Listings",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Events")
            .doc(category) // ✅ Correct category document reference
            .collection("Listings") // ✅ Access Listings subcollection
            .orderBy("timestamp", descending: true) // ✅ Sort by timestamp
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
                    "No listings available for this category.",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }

          var events = snapshot.data!.docs;
          print("Fetched ${events.length} events for category: $category");

          for (var event in events) {
            print("Event ID: ${event.id}, Data: ${event.data()}");
          }

          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: events.length,
            itemBuilder: (context, index) {
              var eventData = events[index].data() as Map<String, dynamic>;

              // Debugging - Print Image URL to Console
              print("Event Image URL: ${eventData['image']}");

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: eventData['image'] != null &&
                            eventData['image'].toString().isNotEmpty
                        ? Image.network(
                            eventData['image'], // ✅ Correct image URL
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return CircularProgressIndicator(color: Colors.black,);
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.broken_image,
                                  size: 50, color: Colors.grey);
                            },
                          )
                        : Icon(Icons.image,
                            size: 50,
                            color: Colors.grey), // Placeholder if no image
                  ),

                  //   _buildEventImage(eventData['image']),
                  title: Container(
                    width: 100,
                    child: Text(
                      eventData['eventname'] ?? "Unknown Host",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  subtitle: Container(
                    width: 100,
                    child: Text(
                      "${eventData['location'] ?? "No Location"} ",
                    ),
                  ),
                  trailing: Container(
                    height: 100,
                    width: 100,
                    child: Center(child: Text("₹${eventData['amount'] ?? "0"}",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w800,fontSize: 15),))),
                  onTap: () {
                    print("Event Image URL: ${eventData['image']}",);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailspage(
                          userid: eventData['uid'] ?? "No user",
                          category: eventData['category'] ?? "No Category",
                          eventId: eventData['eventid'] ?? "No id",
                          imageurl: eventData['image'] ?? "",
                          cntctno: eventData['number'] ?? "No Contact",
                          description:
                              eventData['description'] ?? "No Description",
                          amount: eventData['amount'] ?? "0",
                          eventname: eventData['eventname'] ?? "No Event Name",
                          hostname: eventData['hostername'] ?? "Unknown Host",
                          location: eventData['location'] ?? "No Location",
                          time: eventData['time'] != null
                              ? DateFormat('MMM dd, yyyy hh:mm a').format(
                                  (eventData['time'] as Timestamp).toDate(),
                                )
                              : "No Time",
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// ✅ Function to Build Event Image (Handles Missing or Invalid URLs)
  // Widget _buildEventImage(dynamic imageUrl) {
  //   if (imageUrl != null &&
  //       imageUrl.toString().trim().isNotEmpty &&
  //       Uri.tryParse(imageUrl.toString())?.hasAbsolutePath == true) {
  //     return ClipRRect(
  //       borderRadius: BorderRadius.circular(8),
  //       child: Image.File(
  //         eventData['image'] ?? "",
  //         width: 60,
  //         height: 60,
  //         fit: BoxFit.cover,
  //         errorBuilder: (context, error, stackTrace) {
  //           return Icon(Icons.broken_image, size: 50, color: Colors.grey);
  //         },
  //       ),
  //     );
  //   } else {
  //     return Icon(Icons.image, size: 50, color: Colors.grey);
  //   }
  // }
}
