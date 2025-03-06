import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Form_model extends StatelessWidget {
  const Form_model({super.key, required this.controller, required this.textfeildheading, required this.validator, required this.hintText, required this.keyboardType});
  final TextEditingController controller;
  final String textfeildheading;
  final String validator;
  final String hintText;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return   Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(textfeildheading,style: GoogleFonts.poppins(fontWeight: FontWeight.bold),),
                        SizedBox(height: 5,),
                        TextFormField(
                          keyboardType: keyboardType,
                          style: TextStyle(color: Colors.black),
                          validator: (description) =>
                              description!.isEmpty ? validator : null,
                          controller: controller,
                          decoration: InputDecoration(
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