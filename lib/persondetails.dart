import 'package:flutter/material.dart';
import 'package:flutter_application_1/person.dart';
import 'package:flutter_application_1/textformfiledmodel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class HostDetailsForm extends StatefulWidget {
  final String category;
  final String image;

  const HostDetailsForm(
      {super.key, required this.category, required this.image});

  @override
  _HostDetailsFormState createState() => _HostDetailsFormState();
}

class _HostDetailsFormState extends State<HostDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController eventname = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
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
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PersonDetailsForm(
            eventname: widget.category,
            location: locationController.text,
            amount: amountController.text,
            description: descriptionController.text,
            image: _selectedImage,
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
        key: _formKey,
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
                        "Host ${widget.category}",
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
                      controller: eventname,
                      textfeildheading: "Event name",
                      validator: "Event Name Required",
                      hintText: "Event Name",
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Form_model(
                      controller: locationController,
                      textfeildheading: "Location",
                      validator: "Location Required",
                      hintText: "Location",
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Form_model(
                      controller: amountController,
                      textfeildheading: "Amount",
                      validator: "Amount Required",
                      hintText: "Amount",
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Form_model(
                      controller: descriptionController,
                      textfeildheading: "Description",
                      validator: "Description Required",
                      hintText: "Description",
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 10),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Pictures',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    _selectedImage == null
                        ? GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.black)),
                              height: 130,
                              width: 400,
                              child: Center(child: Icon(Icons.add)),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.black)),
                            height: 130,
                            width: 400,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.fill,
                                )),
                          ),
                    SizedBox(height: 20),
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
                              "Next",
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
