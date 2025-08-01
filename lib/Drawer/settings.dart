// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/Drawer/about_page.dart';
// import 'package:flutter_application_1/Drawer/faq_page.dart';
// import 'package:flutter_application_1/Drawer/feedback_page.dart';
// import 'package:flutter_application_1/Drawer/passreset.dart';
// import 'package:flutter_application_1/Drawer/profiletile.dart';
// import 'package:flutter_application_1/Drawer/supportpage.dart';
// import 'package:flutter_application_1/auth/auth_gate.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:quickalert/models/quickalert_type.dart';
// import 'package:quickalert/widgets/quickalert_dialog.dart';

// class Settingspage extends StatefulWidget {
//   const Settingspage({super.key});

//   @override
//   State<Settingspage> createState() => _SettingspageState();
// }

// class _SettingspageState extends State<Settingspage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Function to delete user data, donations, and account
//   Future<void> _deleteUser(BuildContext context) async {
//     User? currentUser = _auth.currentUser;

//     if (currentUser == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('No user found')),
//       );
//       return;
//     }

//     try {
//       String userId = currentUser.uid;

//       // Step 1: Delete the user's data from Firestore
//       await _firestore.collection('Users').doc(userId).delete();
//       print("User data deleted from Firestore.");

//       // Step 2: Delete the user from Firebase Authentication
//       await currentUser.delete();
//       print("User account deleted from Firebase Authentication.");

//       // Redirect to login or home screen after deletion
//       Navigator.pushReplacementNamed(
//           context, '/login'); // Adjust route as needed
//     } catch (e) {
//       print("Error deleting user: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error deleting user: $e')),
//       );
//     }
//   }

//   // Function to delete the user's donations from Firestore
//   Future<void> _deleteUserDonations(String userId) async {
//     try {
//       // Query the donations collection where the 'userId' field matches the current user's UID
//       var donationsSnapshot = await _firestore
//           .collection('Donations')
//           .where('uid', isEqualTo: userId)
//           .get();

//       // Delete each donation document associated with the user
//       for (var doc in donationsSnapshot.docs) {
//         await doc.reference.delete();
//         print("Deleted donation with ID: ${doc.id}");
//       }
//     } catch (e) {
//       print("Error deleting donations: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error deleting donations: $e')),
//       );
//     }
//   }

//   Future<void> _deleteUserComplaints(String userId) async {
//     try {
//       // Query the donations collection where the 'userId' field matches the current user's UID
//       var donationsSnapshot = await _firestore
//           .collection('feedback')
//           .where('uid', isEqualTo: userId)
//           .get();

//       // Delete each donation document associated with the user
//       for (var doc in donationsSnapshot.docs) {
//         await doc.reference.delete();
//         print("Deleted complaint with ID: ${doc.id}");
//       }
//     } catch (e) {
//       print("Error deleting complaint: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error deleting complaints: $e')),
//       );
//     }
//   }

//   // Re-authenticate the user if necessary (required if the session is old)
//   // Future<void> _reauthenticateAndDelete(User user) async {
//   //   try {
//   //     // Re-authenticate the user via Google Sign-In
//   //     final AuthCredential credential = GoogleAuthProvider.credential(
//   //       accessToken: googleAuth.accessToken,
//   //       idToken: googleAuth.idToken,
//   //     );

//   //     // Re-authenticate the user
//   //     await user.reauthenticateWithCredential(credential);
//   //     print("Re-authenticated successfully.");
//   //   } catch (e) {
//   //     print("Error during reauthentication: $e");
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text('Re-authentication failed: $e')),
//   //     );
//   //     throw e; // Propagate the error to be handled in the delete method
//   //   }
//   // }

//   double _rating = 3.0; // Default rating

//   // Show rating dialog
//   void _showRatingDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(
//             'Rate Your Experience',
//             style: TextStyle(color: Colors.black),
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'How would you rate your experience?',
//                 style: TextStyle(
//                     fontSize: 18.0,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black),
//               ),
//               SizedBox(height: 16.0),
//               RatingBar.builder(
//                 initialRating: _rating,
//                 minRating: 1,
//                 direction: Axis.horizontal,
//                 allowHalfRating: true,
//                 itemCount: 5,
//                 itemSize: 40.0,
//                 itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
//                 itemBuilder: (context, _) {
//                   return Icon(
//                     Icons.star,
//                     color: Colors.amber,
//                   );
//                 },
//                 onRatingUpdate: (rating) {
//                   setState(() {
//                     _rating = rating;
//                   });
//                 },
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close dialog
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               style: TextButton.styleFrom(
//                   backgroundColor: Colors.pinkAccent.shade100),
//               onPressed: () {
//                 // Submit the rating
//                 Navigator.of(context).pop(); // Close dialog
//                 _showSubmitMessage(context); // Show the submit message
//               },
//               child: Text(
//                 'Submit',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Show a confirmation message after submission
//   void _showSubmitMessage(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(
//             'Rating Submitted',
//             style: TextStyle(color: Colors.black),
//           ),
//           content: Text(
//               'Thank you for your feedback! Your rating: $_rating stars',
//               style: TextStyle(color: Colors.black)),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close dialog
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.pinkAccent.shade100,
//         centerTitle: true,
//         title: Text(
//           "Settings",
//           style: GoogleFonts.poppins(
//               color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           ProfilePageTile(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => SupportPage(),
//                 ),
//               );
//             },
//             text: "Help & Support",
//             colors: Theme.of(context).colorScheme.surface,
//             icon: Icons.headphones,
//           ),
//           ProfilePageTile(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ComplaintPage(),
//                 ),
//               );
//             },
//             text: "Report  Bug",
//             colors: Theme.of(context).colorScheme.surface,
//             icon: Icons.bug_report,
//           ),
//           ProfilePageTile(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => FAQsPage(),
//                 ),
//               );
//             },
//             text: "FAQS",
//             colors: Theme.of(context).colorScheme.surface,
//             icon: Icons.question_answer,
//           ),
//           ProfilePageTile(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => PassResetPage(),
//                 ),
//               );
//             },
//             text: "Reset Password",
//             colors: Theme.of(context).colorScheme.surface,
//             icon: Icons.lock_open,
//           ),
//           ProfilePageTile(
//             onTap: () {
//               _showRatingDialog(context);
//             },
//             text: "Rating",
//             colors: Theme.of(context).colorScheme.surface,
//             icon: Icons.star,
//           ),
//           ProfilePageTile(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => AboutPage(),
//                 ),
//               );
//             },
//             text: "About",
//             colors: Theme.of(context).colorScheme.surface,
//             icon: Icons.info,
//           ),
//           ProfilePageTile(
//             onTap: () {
//               QuickAlert.show(
//                 context: context,
//                 type: QuickAlertType.warning,
//                 title: 'Do you want to delete your account?',
//                 confirmBtnText: 'Yes',
//                 cancelBtnText: 'No',
//                 showCancelBtn: true,
//                 confirmBtnColor: Colors.red,
//                 onCancelBtnTap: () => Navigator.pop(context),
//                 onConfirmBtnTap: () async {
//                   await _deleteUser(context); // Call the function properly
//                   Navigator.pop(
//                       context); // Close the alert after deleting the user
//                 },
//               );
//             },
//             text: "Delete Account",
//             colors: Theme.of(context).colorScheme.surface,
//             icon: Icons.delete,
//           ),
//         ],
//       ),
//     );
//   }
// }
