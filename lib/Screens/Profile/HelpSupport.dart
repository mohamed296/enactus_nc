import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupport extends StatefulWidget {
  static String id = 'HelpSupport';
  @override
  _HelpSupportState createState() => _HelpSupportState();
}

class _HelpSupportState extends State<HelpSupport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Help & Support"),
      ),
      body: Center(
        child: Column(
          children: [
            FlatButton(
              child:
                  Image(image: AssetImage('assets/images/Facebook-icon.png')),
              onPressed: () async {
                const url = "https://www.facebook.com/EnactusNewCairo/";
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              "contact@enactusnewcairo.org",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
