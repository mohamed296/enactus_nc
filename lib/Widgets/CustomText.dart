import 'package:enactusnca/Widgets/constants.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String hint;
  final IconData icon;
  final Function onClick;
  String _errorMassage(String str) {
    switch (hint) {
      case 'Enter your ID':
        return 'ID is empty';
      case 'Enter your Email':
        return 'Email is empty';
      case 'Enter your Number':
        return 'Number is empty';
      case 'Enter your UserName':
        return 'UserName is empty';
      case 'Enter your Password':
        return 'Password is empty';
    }
  }

  CustomText(
      {@required this.onClick, @required this.hint, @required this.icon});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return _errorMassage(hint);
        }
      },
      onSaved: onClick,
      obscureText: hint == 'Enter your Password' ? true : false,
      cursorColor: KSacandColor,
      scrollPadding: const EdgeInsets.all(30.0),
      textAlign: TextAlign.start,
      decoration: InputDecoration(
        icon: Icon(icon),
        contentPadding: const EdgeInsets.all(10.0),
        hintText: hint,
      ),
    );
  }
}
