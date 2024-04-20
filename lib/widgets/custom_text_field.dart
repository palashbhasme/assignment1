import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  const CustomTextField({Key? key, required this.hintText, required this.controller}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (val){
        if(val==null || val.isEmpty){
            return 'Enter a ${hintText}';
        }
      },
      controller: controller,
      decoration: InputDecoration(
        labelText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
