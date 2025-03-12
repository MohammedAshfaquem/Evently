import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Drawer/book.dart';
import 'package:flutter_application_1/My%20Events/my_events.dart';
import 'package:flutter_application_1/Drawer/about_page.dart';
import 'package:flutter_application_1/Drawer/faq_page.dart';
import 'package:flutter_application_1/Drawer/feedback_page.dart';
import 'package:flutter_application_1/Drawer/passreset.dart';
import 'package:flutter_application_1/Drawer/profiletile.dart';
import 'package:flutter_application_1/Drawer/settings.dart';
import 'package:flutter_application_1/Drawer/supportpage.dart';
import 'package:flutter_application_1/auth/auth_gate.dart';
import 'package:flutter_application_1/getdata.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final getdata = GetData();
  static const String imgBBApiKey =
      "ed8e4023ff7954cf55bdc23a566d1efa"; // ImgBB API Key

  String? imagePath; // Stores profile image URL
  double _rating = 3.0;

  @override
  void initState() {
    super.initState();
    _loadProfileImage(); // Load the profile image from Firestore
  }

  // Fetch profile image path from Firestore
  Future<void> _loadProfileImage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        String? fetchedImage = userDoc['image'];
        if (fetchedImage != null && fetchedImage.isNotEmpty) {
          setState(() {
            imagePath = fetchedImage; // Update the imagePath
          });
        }
      }
    }
  }

  // Pick image from gallery/camera
  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await ImagePicker().pickImage(source: source);

    if (image != null) {
      File imageFile = File(image.path);

      // ✅ Upload image to ImgBB and get the URL
      String? uploadedImageUrl = await _uploadImageToImgBB(imageFile);

      if (uploadedImageUrl != null) {
        // ✅ Update Firestore with the new image URL
        await _updateImagePathInFirestore(uploadedImageUrl);
      }
    }
  }

  // Upload image to ImgBB and return the URL
  Future<String?> _uploadImageToImgBB(File imageFile) async {
    try {
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      var response = await http.post(
        Uri.parse("https://api.imgbb.com/1/upload?key=$imgBBApiKey"),
        body: {"image": base64Image},
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        return jsonData['data']['url']; // ✅ Return image URL
      } else {
        print("❌ ImgBB Upload Failed: ${response.body}");
      }
    } catch (e) {
      print("❌ Error uploading to ImgBB: $e");
    }
    return null;
  }

  // Update Firestore with new image URL
  Future<void> _updateImagePathInFirestore(String imageUrl) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'image': imageUrl});

      setState(() {
        imagePath = imageUrl; // ✅ Update UI
      });

      print("✅ Firestore Updated with Image URL: $imageUrl");
    } catch (e) {
      print("❌ Firestore Update Failed: $e");
    }
  }

  Future<void> _deleteUser(BuildContext context) async {
    User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No user found')),
      );
      return;
    }

    try {
      String userId = currentUser.uid;

      // Step 1: Delete user's events from Firestore (from all categories)
      List<String> eventCategories = [
        "Camera Man",
        "Makeup Artist",
        "Caterers",
        "Invitations"
      ];

      for (String category in eventCategories) {
        QuerySnapshot eventsSnapshot = await _firestore
            .collection("Events")
            .doc(category)
            .collection("Listings")
            .where('uid', isEqualTo: userId)
            .get();

        for (var doc in eventsSnapshot.docs) {
          await doc.reference.delete();
        }
      }
      print("User's events deleted from all categories.");

      // Step 2: Delete user's bookings
      QuerySnapshot bookingsSnapshot = await _firestore
          .collection('Bookings')
          .where('userId', isEqualTo: userId)
          .get();
      for (var doc in bookingsSnapshot.docs) {
        await doc.reference.delete();
      }
      print("User's bookings deleted.");

      // Step 3: Delete user's feedback
      QuerySnapshot feedbackSnapshot = await _firestore
          .collection('Feedback')
          .where('uid', isEqualTo: userId)
          .get();
      for (var doc in feedbackSnapshot.docs) {
        await doc.reference.delete();
      }
      print("User's feedback deleted.");

      // Step 4: Delete user data from Firestore (Users collection)
      await _firestore.collection('Users').doc(userId).delete();
      print("User data deleted from Firestore.");

      // Step 5: Delete user account from Firebase Authentication
      await currentUser.delete();
      print("User account deleted from Firebase Authentication.");

      // Redirect to login screen after deletion
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print("Error deleting user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting user: $e')),
      );
    }
  }

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Rate Your Experience',
            style: TextStyle(color: Colors.black),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'How would you rate your experience?',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(height: 16.0),
              RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 40.0,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) {
                  return Icon(
                    Icons.star,
                    color: Colors.amber,
                  );
                },
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.pinkAccent.shade100),
              onPressed: () {
                // Submit the rating
                Navigator.of(context).pop(); // Close dialog
                _showSubmitMessage(context); // Show the submit message
              },
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSubmitMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Rating Submitted',
            style: TextStyle(color: Colors.black),
          ),
          content: Text(
              'Thank you for your feedback! Your rating: $_rating stars',
              style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(color: Colors.pinkAccent.shade100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _showImagePickerDialog(); // Open dialog for choosing image
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    backgroundImage: imagePath != null && imagePath!.isNotEmpty
                        ? NetworkImage(imagePath!) // ✅ Online image
                        : null,
                    child: imagePath == null || imagePath!.isEmpty
                        ? Icon(Icons.person, size: 40, color: Colors.grey)
                        : null,
                  ),
                ),
                SizedBox(height: 8),
                FutureBuilder(
                  future: getdata.getUsername(),
                  builder: (context, snapshot) => snapshot.hasData
                      ? Text(snapshot.data.toString(),
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold))
                      : Text(
                          "Loading",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                ),
                FutureBuilder(
                  future: getdata.getemail(),
                  builder: (context, snapshot) => snapshot.hasData
                      ? Container(
                        height: 30,
                        width: 250,
                        child: Text(snapshot.data.toString(),
                        overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600)),
                      )
                      : Text(
                          "Loading",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                ),
              ],
            ),
          ),
          ProfilePageTile(
            onTap: () {
              Navigator.pop(context);
            },
            text: "Home",
            colors: Colors.black,
            icon: Icons.home,
          ),
          // ListTile(
          //   leading: Icon(Icons.settings),
          //   title: Text('Settings'),
          //   onTap: () {
          //     Navigator.push(context, MaterialPageRoute(builder: (context) => Settingspage(),));
          //   },
          //),
          ProfilePageTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyEvents()),
              );
            },
            text: "My Events",
            colors: Colors.black,
            icon: Icons.event,
          ),
          ProfilePageTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookingDetailsPage()),
              );
            },
            text: "Booker Details",
            colors: Colors.black,
            icon: Icons.calendar_month_outlined,
          ),
          ProfilePageTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SupportPage(),
                ),
              );
            },
            text: "Help & Support",
            colors: Colors.black,
            icon: Icons.headphones,
          ),
          ProfilePageTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ComplaintPage(),
                ),
              );
            },
            text: "Report Bug",
            colors: Colors.black,
            icon: Icons.bug_report,
          ),
          ProfilePageTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FAQsPage()),
              );
            },
            text: "FAQS",
            colors: Colors.black,
            icon: Icons.question_answer,
          ),
          ProfilePageTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PassResetPage(),
                ),
              );
            },
            text: "Reset password",
            colors: Colors.black,
            icon: Icons.lock_open,
          ),
          ProfilePageTile(
            onTap: () {
              _showRatingDialog(context);
            },
            text: "Rating",
            colors: Colors.black,
            icon: Icons.star,
          ),
          ProfilePageTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutPage(),
                ),
              );
            },
            text: "About",
            colors: Colors.black,
            icon: Icons.info,
          ),
          ProfilePageTile(
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible:
                    false, // Prevents closing when tapping outside
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Do you want to delete your account?'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Optional rounded corners
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close alert on cancel
                        },
                        child: Text('No'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await _deleteUser(
                              context); // Call the function properly
                          Navigator.pop(
                              context); // Close the alert after deleting the user
                        },
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.red),
                        child: Text('Yes'),
                      ),
                    ],
                  );
                },
              );
            },
            text: "Delete Account",
            colors: Colors.black,
            icon: Icons.delete,
          ),
          ProfilePageTile(
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible:
                    false, // Prevents closing when tapping outside
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Do you want to logout?'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Optional: Rounded corners
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close alert on cancel
                        },
                        child: Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Close the alert dialog
                          Navigator.pop(context);

                          // Sign out user
                          FirebaseAuth.instance.signOut();

                          // Navigate to AuthGate screen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AuthGate(),
                            ),
                          );
                        },
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.red),
                        child: Text('Yes'),
                      ),
                    ],
                  );
                },
              );
            },
            text: "Log Out",
            colors: Colors.red,
            icon: Icons.info,
          ),
        ],
      ),
    );
  }

  // Show dialog for selecting image source
  void _showImagePickerDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.image),
              title: Text("Gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera),
              title: Text("Camera"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        );
      },
    );
  }
}
