import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Homepage/homepgae.dart';
import 'package:flutter_application_1/categpryprovider.dart';
import 'package:flutter_application_1/detailPgae.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CategoryListPage extends StatelessWidget {
  final String category;
  var eventimage;
  var eventname;
  var location;
  var amount;
  var description;
  var contact;
  var hostName;
  var image;

  CategoryListPage({
    super.key,
    required this.category,
    this.image,
    this.eventname,
    this.location,
    this.amount,
    this.description,
    this.contact,
    this.hostName,
    this.eventimage,
  });

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final categoryItems = categoryProvider.categories[category] ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent.shade100,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Homepage(),
                ));
          },
          icon: Icon(
            color: Colors.white,
            LineAwesomeIcons.angle_left_solid,
          ),
        ),
        title: Text("$category Listings",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            )),
        centerTitle: true,
        elevation: 0,
      ),
      body: categoryItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/no_data.png",
                      height: 150), // Replace with an appropriate image
                  SizedBox(height: 10),
                  Text(
                    "No listings available for this category.",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: categoryItems.length,
              itemBuilder: (context, index) {
                final item = categoryItems[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12),
                    leading: item.image.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(item.image),
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(Icons.image, size: 50, color: Colors.grey),
                    title: Text(
                      item.hostName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("${item.location} - ₹${item.amount}"),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.pink,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetailspage(
                            imageurl: item.image,
                            cntctno: item.contact,
                            description: item.description,
                            amount: item.amount,
                            eventname: item.eventname,
                            hostname: item.hostName,
                            location: item.location,
                            time: "10",
                          ),
                        ),
                      );
                      print("image:${item.image}");
                      print("conatct:$contact");
                      print("desc:$description");
                      print("amount:$amount");
                      print("eventname:$eventname");
                      print("hostname:$hostName");
                      print("locationt:$location");
                    },
                  ),
                );
              },
            ),
    );
  }
}
