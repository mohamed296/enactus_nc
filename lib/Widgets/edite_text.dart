import 'package:flutter/material.dart';

class EditeText extends StatefulWidget {
  final String title;
  final bool obscureText;
  final TextEditingController textEditingController;
  final String data;
  EditeText({this.title, this.obscureText, this.data, this.textEditingController});

  @override
  _EditeTextState createState() => _EditeTextState();
}

class _EditeTextState extends State<EditeText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          20,
        ),

        //  color: KSacandColor.withOpacity(0.2),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: TextFormField(
        controller: widget.textEditingController,
        obscureText: widget.obscureText,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: widget.title,
          labelText: widget.title,
          //errorText: 'Error message',
          border: OutlineInputBorder(),
          hintStyle: TextStyle(fontSize: 18.0, color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
