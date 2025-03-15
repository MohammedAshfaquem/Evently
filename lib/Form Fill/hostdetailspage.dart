import 'dart:io';
import 'dart:math';
import 'package:Evently/Form%20Fill/person_details.dart';
import 'package:Evently/Form%20Fill/textformfiledmodel.dart';
import 'package:Evently/firestoreservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HostDetailsForm extends StatefulWidget {
  final String category;
  const HostDetailsForm({
    super.key,
    required this.category,
  });

  @override
  _HostDetailsFormState createState() => _HostDetailsFormState();
}

class _HostDetailsFormState extends State<HostDetailsForm> {
  //   final eventId = generateEvent();

  // String generateEvent({int length = 16}) {
  //     const characters =
  //         'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  //     final random = Random();
  //     return List.generate(
  //         length, (_) => characters[random.nextInt(characters.length)]).join();
  //   }

  final _eventdetailsformKey = GlobalKey<FormState>();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController eventnameController = TextEditingController();
  final FireStoreService fireStoreService = FireStoreService();
  File? _selectedImage;
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

 void _goToPersonDetails() {
  if (_eventdetailsformKey.currentState!.validate()) {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please select an image"),
          backgroundColor: Colors.red,
        ),
      );
      return; // Stop navigation if no image is selected
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonDetailsForm(
          eventname: eventnameController.text,
          location: locationController.text,
          amount: amountController.text,
          description: descriptionController.text,
          image: _selectedImage,
          category: widget.category,
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
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              LineAwesomeIcons.angle_left_solid,
              color: Colors.white,
            )),
        backgroundColor: Colors.pinkAccent.shade100,
      ),
      body: Form(
        key: _eventdetailsformKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        "${widget.category} Details",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        "Fill in the details below to host your event. Provide accurate information to help guests find your service easily.",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                    )
                  ],
                ),
                height: 120,
                width: 400,
                color: Colors.pinkAccent.shade100,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Form_model(
                      controller: eventnameController,
                      textfeildheading: "Event Name",
                      validator: (value) =>
                          value!.isEmpty ? "Event Name Required" : null,
                      hintText: "Event Name",
                      keyboardType: TextInputType.text,
                      maxLength: 10,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Form_model(
                      controller: locationController,
                      textfeildheading: "Location",
                      validator: (value) =>
                          value!.isEmpty ? "Location Required" : null,
                      hintText: "Location",
                      keyboardType: TextInputType.text,
                      maxLength: 10,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Form_model(
                      controller: amountController,
                      textfeildheading: "Amount",
                      validator: (value) =>
                          value!.isEmpty ? "Amount Required" : null,
                      hintText: "Amount",
                      keyboardType: TextInputType.number,
                      inputFormatter: [
                        FilteringTextInputFormatter
                            .digitsOnly // ✅ Allow only numbers
                      ],
                      maxLength: 7,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Form_model(
                      controller: descriptionController,
                      textfeildheading: "Description",
                      validator: (value) =>
                          value!.isEmpty ? "Description Required" : null,
                      hintText: "Description",
                      keyboardType: TextInputType.text,
                      maxLength: 100,
                    ),
                    SizedBox(height: 20),
                    _selectedImage == null
                        ? GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  size: 30,
                                ),
                              ),
                              height: 140,
                              width: 400,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: Colors.pinkAccent.shade100)),
                            ),
                          )
                        : Container(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  _selectedImage!,
                                  height: 150,
                                  fit: BoxFit.fill,
                                )),
                            height: 140,
                            width: 400,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.pinkAccent.shade100)),
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                        onTap: _goToPersonDetails,
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.pinkAccent.shade100),
                            height: 60,
                            width: 350,
                            child: Center(
                                child: Text(
                              "Submit",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 15,
                                  letterSpacing: 2),
                            )))),
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
