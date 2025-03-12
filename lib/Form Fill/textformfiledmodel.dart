import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class Form_model extends StatelessWidget {
  Form_model(
      {super.key,
      required this.controller,
      required this.textfeildheading,
      required this.validator,
      required this.hintText,
      required this.keyboardType,
      this.inputFormatter,
      required this.maxLength});
  final TextEditingController controller;
  final String textfeildheading;
  final FormFieldValidator<String>?validator;
  final String hintText;
  final TextInputType keyboardType;
  var inputFormatter;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            textfeildheading,
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          TextFormField(
            maxLengthEnforcement:
                MaxLengthEnforcement.enforced, // Enforce limit
            keyboardType: keyboardType,
            maxLength: maxLength,
            style: TextStyle(color: Colors.black),
            validator: validator,
            controller: controller,
            inputFormatters: inputFormatter,
            decoration: InputDecoration(
              counterText: '',
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(23),
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(23),
                borderSide: BorderSide(color: Colors.black),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(23),
                borderSide: BorderSide(color: Colors.red.shade900),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
