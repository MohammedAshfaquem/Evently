import 'package:flutter/material.dart';
import 'package:flutter_application_1/person.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HostDetailsForm extends StatefulWidget {
  final String category;

  const HostDetailsForm({super.key, required this.category});

  @override
  _HostDetailsFormState createState() => _HostDetailsFormState();
}

class _HostDetailsFormState extends State<HostDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
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
      appBar: AppBar(title: Text("Host ${widget.category}")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: locationController,
              decoration: InputDecoration(labelText: "Location"),
              validator: (value) => value!.isEmpty ? "Enter location" : null,
            ),
            TextFormField(
              controller: amountController,
              decoration: InputDecoration(labelText: "Amount"),
              validator: (value) => value!.isEmpty ? "Enter amount" : null,
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: "Description"),
              validator: (value) => value!.isEmpty ? "Enter description" : null,
            ),
            SizedBox(height: 20),
            _selectedImage == null
                ? Text("No image selected")
                : Image.file(_selectedImage!, height: 150),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text("Select Image"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _goToPersonDetails,
              child: Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}
