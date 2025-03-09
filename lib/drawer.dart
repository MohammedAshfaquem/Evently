import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_gate.dart';
import 'package:flutter_application_1/getdata.dart';
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
  final getdata = GetData();
  static const String imgBBApiKey =
      "ed8e4023ff7954cf55bdc23a566d1efa"; // ImgBB API Key

  String? imagePath; // Stores profile image URL

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
                      ? Text(
                          snapshot.data.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )
                      : Text(
                          "Loading",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                ),
                FutureBuilder(
                  future: getdata.getemail(),
                  builder: (context, snapshot) => snapshot.hasData
                      ? Text(
                          snapshot.data.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )
                      : Text(
                          "Loading",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.warning,
                title: 'Do you want to logout?',
                confirmBtnText: 'Yes',
                cancelBtnText: 'No',
                showCancelBtn: true,
                showConfirmBtn: true,
                confirmBtnColor: Colors.red,
                onCancelBtnTap: () => Navigator.pop(context),
                onConfirmBtnTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AuthGate(),
                    ),
                  );
                  Navigator.pop(context);
                },
              );
            },
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
