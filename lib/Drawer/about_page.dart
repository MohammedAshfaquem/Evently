import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent.shade100,
        centerTitle: true,
        title: Text(
          "About",
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.maybePop(context);
          },
          icon: Icon(
            LineAwesomeIcons.angle_left_solid,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Title
            Text(
              'Welcome to Evently!',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent.shade100,
                  fontSize: 20),
            ),
            SizedBox(height: 8.0),
            Text(
              'Evently is your all-in-one event management app, designed to make planning and organizing events seamless and stress-free. '
              'Whether it’s a wedding, corporate meeting, birthday party, or community gathering, Evently helps you manage every detail effortlessly.',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16),
            ),
            SizedBox(height: 16.0),

            // Mission Section
            Text(
              'Our Mission',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent.shade100,
                  fontSize: 20),
            ),
            SizedBox(height: 8.0),
            Text(
              'At Evently, we believe in simplifying event planning by bringing everything you need to one platform. '
              'Our goal is to empower users with efficient tools for booking vendors, managing guest lists, and ensuring every event is a success.',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16),
            ),
            SizedBox(height: 16.0),

            // How It Works Section
            Text(
              'How It Works',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent.shade100,
                  fontSize: 20),
            ),
            SizedBox(height: 8.0),
            Text(
              '1. **Create Your Event**: Start by setting up your event details such as date, location, and type.\n'
              '2. **Find & Book Services**: Browse and book services like caterers, photographers, decorators, and more.\n'
              '3. **Manage Guests & Invitations**: Send invites, track RSVPs, and keep your guest list organized.\n'
              '4. **Stay on Schedule**: Use our event timeline and reminders to stay on track for a smooth execution.',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16),
            ),
            SizedBox(height: 16.0),

            // Why Evently Section
            Text(
              'Why Evently?',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent.shade100,
                  fontSize: 20),
            ),
            SizedBox(height: 8.0),
            Text(
              '• **All-in-One Solution**: Everything you need for event planning in one app.\n'
              '• **User-Friendly Interface**: Designed to make event management easy for everyone.\n'
              '• **Vendor Marketplace**: Connect with reliable event service providers effortlessly.\n'
              '• **Real-Time Updates**: Keep track of every aspect of your event with live updates and reminders.',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16),
            ),
            SizedBox(height: 16.0),

            // Join Us Section
            Text(
              'Join Us in Creating Memorable Events',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent.shade100,
                  fontSize: 20),
            ),
            SizedBox(height: 8.0),
            Text(
              'Evently is here to transform the way you plan and manage events. Whether you’re organizing a small gathering or a grand celebration, '
              'we provide the tools and support you need to make it a success. Start planning today and make every event extraordinary!',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16),
            ),
            SizedBox(height: 16.0),

            // Contact Section
            Text(
              'Contact Us',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent.shade100,
                  fontSize: 20),
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Text(
                  '📧 Email:',
                  style: TextStyle(fontSize: 16.0, height: 1.5, color: Colors.black),
                ),
                Text(
                  ' evently266@gmail.com',
                  style: TextStyle(fontSize: 16.0, height: 1.5, color: Colors.blue),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '📞 Phone:',
                  style: TextStyle(fontSize: 16.0, height: 1.5, color: Colors.black),
                ),
                Text(
                  ' 7591937330',
                  style: TextStyle(fontSize: 16.0, height: 1.5, color: Colors.blue),
                ),
              ],
            ),
            SizedBox(height: 14.0),

            // Footer
            Center(
              child: Text(
                'Let’s make every event a success with Evently! 🎉',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
