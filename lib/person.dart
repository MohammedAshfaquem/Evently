import 'package:flutter/material.dart';
import 'package:flutter_application_1/categorylistpage.dart';
import 'package:flutter_application_1/categpryprovider.dart';
import 'package:flutter_application_1/textformfiledmodel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class PersonDetailsForm extends StatefulWidget {
  final String eventname;
  final String location;
  final String amount;
  final String description;
  final File? image;

  const PersonDetailsForm({
    super.key,
    required this.eventname,
    required this.location,
    required this.amount,
    required this.description,
    this.image,
  });

  @override
  _PersonDetailsFormState createState() => _PersonDetailsFormState();
}

class _PersonDetailsFormState extends State<PersonDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final categoryItem = CategoryItem(
      
        location: widget.location,
        amount: widget.amount,
        description: widget.description,
        contact: contactController.text,
        hostName: "${firstNameController.text} ${lastNameController.text}",
        image: widget.image?.path ?? "",
        eventname: widget.eventname
      );

      final provider = Provider.of<CategoryProvider>(context, listen: false);
      provider.addCategoryItem(widget.eventname, categoryItem);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Category Hosted Successfully!")),
      );

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryListPage(
              category: widget.eventname,
              image: widget.image.toString(),
              amount: widget.amount,
              hostName:
                  "${firstNameController.text} ${lastNameController.text}",
              contact: contactController.text,
              description: widget.description,
              location: widget.location,
              eventname: widget.eventname,
            ),
          ));
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
                        "Person Deatils",
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
                      controller: firstNameController,
                      textfeildheading: "First Name",
                      validator: "First Name Required",
                      hintText: "First Name",
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Form_model(
                      controller: lastNameController,
                      textfeildheading: "Last name",
                      validator: "Last name Required",
                      hintText: "Last name",
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Form_model(
                      controller: contactController,
                      textfeildheading: "Contact No",
                      validator: "Contact No Required",
                      hintText: "Contact No",
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Form_model(
                      controller: emailController,
                      textfeildheading: "Email",
                      validator: "Email Required",
                      hintText: "Email",
                      keyboardType: TextInputType.text,
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
