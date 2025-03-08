import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:flutter_application_1/auth/auth_gate.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String userName = "User Name";
  String userEmail = "example@email.com";
  bool isLoading = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // Load user details from Firestore
  Future<void> _loadUserProfile() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        setState(() => isLoading = false);
        return;
      }

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
        if (userData != null && mounted) {
          setState(() {
            userName = userData["name"] ?? "User Name";
            userEmail = userData["email"] ?? "example@email.com";
            isLoading = false;
          });
        }
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error loading user profile: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          isLoading
              ? SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                )
              : UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Colors.pinkAccent.shade100),
                  accountName: Text(
                    userName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  accountEmail: Text(userEmail),
                ),
          Expanded(
            child: ListView(
              children: [
                _buildDrawerItem(
                    Icons.event, "My Events", () => Navigator.pop(context)),
                _buildDrawerItem(
                    Icons.settings, "Settings", () => Navigator.pop(context)),
                _buildDrawerItem(
                    Icons.info, "About Us", () => Navigator.pop(context)),
                Divider(),
                _buildDrawerItem(Icons.logout, "Logout", () {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.warning,
                    title: 'Do you want to logout?',
                    confirmBtnText: 'Yes',
                    cancelBtnText: 'No',
                    showCancelBtn: true,
                    confirmBtnColor: Colors.red,
                    onCancelBtnTap: () => Navigator.pop(context),
                    onConfirmBtnTap: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => AuthGate()),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.pinkAccent.shade100),
      title: Text(title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }
}
