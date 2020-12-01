import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String content;
  final String title;
  final Function onTap;
  final bool showTitle;

  const CustomDialog({
    Key key,
    this.content,
    this.title,
    @required this.onTap,
    @required this.showTitle,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 7.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      backgroundColor: Theme.of(context).primaryColor,
      title: showTitle ? Text(title) : Container(),
      content: Text(content),
      actions: [
        FlatButton(
          onPressed: onTap,
          child: Text('OK'),
        ),
      ],
    );
  }
}
