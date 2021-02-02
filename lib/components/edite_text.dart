import 'package:flutter/material.dart';

class EditeText extends StatefulWidget {
  final String title;
  final bool obscureText;
  final TextEditingController textEditingController;
  final String data;
  const EditeText({
    Key key,
    this.title,
    this.obscureText,
    this.textEditingController,
    this.data,
  }) : super(key: key);

  @override
  _EditeTextState createState() => _EditeTextState();
}

class _EditeTextState extends State<EditeText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: TextFormField(
        controller: widget.textEditingController,
        obscureText: widget.obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: widget.title,
          labelText: widget.title,
          border: const OutlineInputBorder(),
          hintStyle:
              const TextStyle(fontSize: 18.0, color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
