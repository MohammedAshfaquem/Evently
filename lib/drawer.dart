import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header with Profile Picture and Name
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.pinkAccent.shade100),
            accountName: Text("John Doe", style: TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text("johndoe@example.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage("assets/profile.jpg"), // Add a profile picture here
            ),
          ),

          // Drawer Items
          Expanded(
            child: ListView(
              children: [
                _buildDrawerItem(Icons.event, "My Events", () {
                  Navigator.pop(context);
                  // Navigate to My Events Page
                }),
                _buildDrawerItem(Icons.settings, "Settings", () {
                  Navigator.pop(context);
                  // Navigate to Settings Page
                }),
                _buildDrawerItem(Icons.info, "About Us", () {
                  Navigator.pop(context);
                  // Navigate to About Us Page
                }),
                _buildDrawerItem(Icons.palette, "Theme", () {
                  Navigator.pop(context);
                  // Implement Theme Change Logic
                }),
                Divider(),
                _buildDrawerItem(Icons.logout, "Logout", () {
                  // Handle Logout
                  Navigator.pop(context);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Drawer Item Builder
  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.pinkAccent.shade100),
      title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }
}
