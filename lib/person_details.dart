import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/My%20Events/firestoremyevents.dart';
import 'package:flutter_application_1/categorylistpage.dart';
import 'package:flutter_application_1/firestoreservuce.dart';
import 'package:flutter_application_1/textformfiledmodel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class PersonDetailsForm extends StatefulWidget {
  final String eventname;
  final String location;
  final String amount;
  final String description;
  final File? image;
  final String category;

  const PersonDetailsForm({
    super.key,
    required this.eventname,
    required this.location,
    required this.amount,
    required this.description,
    this.image,
    required this.category,
  });

  @override
  _PersonDetailsFormState createState() => _PersonDetailsFormState();
}

class _PersonDetailsFormState extends State<PersonDetailsForm> {
  final _personformKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final FireStoreService fireStoreService = FireStoreService();
  final FireStoreMyServivce fireStoreMyServivce = FireStoreMyServivce();
  String eventId = FirebaseFirestore.instance.collection('Events').doc().id;


  static const String imgBBApiKey = "ed8e4023ff7954cf55bdc23a566d1efa";

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
        return jsonData['data']['url'];
      } else {
        print("❌ ImgBB Upload Failed: ${response.body}");
      }
    } catch (e) {
      print("❌ Error uploading to ImgBB: $e");
    }
    return null;
  }

  void _submitForm() async {
    if (_personformKey.currentState!.validate()) {
      String? imageUrl = widget.image != null
          ? await _uploadImageToImgBB(widget.image!)
          : null;

      await FireStoreService().addEvent(
        category: widget.category,
        hosterName: "${firstNameController.text} ${lastNameController.text}",
        number: contactController.text,
        eventName: widget.eventname,
        location: widget.location,
        amount: widget.amount,
        description: widget.description,
        image: imageUrl ?? "NO_IMAGE",
        time: DateTime.now(),
        eventId: eventId,

      );
      await fireStoreMyServivce.addmyevents(
        widget.category,
        "${firstNameController.text} ${lastNameController.text}",
        contactController.text,
        widget.eventname,
        widget.location,
        widget.amount,
        widget.description,
        imageUrl ?? "NO_IMAGE",
        DateTime.now(),
        eventId,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Category Hosted Successfully!")),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CategoryListPage(
            category: widget.eventname,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(LineAwesomeIcons.angle_left_solid, color: Colors.white),
        ),
        backgroundColor: Colors.pinkAccent.shade100,
      ),
      body: Form(
        key: _personformKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 120,
                width: double.infinity,
                color: Colors.pinkAccent.shade100,
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Person Details",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.white)),
                    SizedBox(height: 5),
                    Text("Fill in the details below to host your event.",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500, color: Colors.white)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Form_model(
                      controller: firstNameController,
                      textfeildheading: "First Name",
                      validator: (value) =>
                          value!.isEmpty ? "First Name Required" : null,
                      hintText: "First Name",
                      keyboardType: TextInputType.text,
                      maxLength: 10,
                    ),
                    SizedBox(height: 10),
                    Form_model(
                      controller: lastNameController,
                      textfeildheading: "Last Name",
                      validator: (value) =>
                          value!.isEmpty ? "Last Name Required" : null,
                      hintText: "Last Name",
                      keyboardType: TextInputType.text,
                      maxLength: 10,
                    ),
                    SizedBox(height: 10),
                    Form_model(
                      controller: contactController,
                      textfeildheading: "Contact No",
                      validator: (value) =>
                          value!.isEmpty ? "Contact No Required" : null,
                      hintText: "Contact No",
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    SizedBox(height: 10),
                    Form_model(
                      controller: emailController,
                      textfeildheading: "Email",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        } else if (!value.endsWith('@gmail.com')) {
                          return 'Email must be end with  @gmail.com address';
                        }
                        return null;
                      },
                      hintText: "Email",
                      keyboardType: TextInputType.text,
                      maxLength: 20,
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: _submitForm,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.pinkAccent.shade100),
                        height: 60,
                        width: 350,
                        child: Center(
                          child: Text("Submit",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 15,
                                  letterSpacing: 2)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
