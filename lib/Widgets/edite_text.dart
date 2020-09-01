import 'package:flutter/material.dart';

class EditeText extends StatelessWidget {
  final String title;
  final bool obscureText;
  final TextEditingController textEditingController;
  String data;
  EditeText(
      {this.title, this.obscureText, this.data, this.textEditingController});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 8),
      child: TextFormField(
        controller: textEditingController,
        obscureText: obscureText,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration.collapsed(
          hintText: title,
          hintStyle: TextStyle(
              fontSize: 18.0, color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
