import 'package:enactusnca/BottomNavBar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Profile extends StatefulWidget {
  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  final String logo = 'img/en.png';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(25, 53, 93, 1.0),
      /*appBar: AppBar(
        backgroundColor:Color.fromRGBO(26, 69, 131, 1.0),
      ),*/

      body: SafeArea(
          child: Container(
        height: double.infinity,
        // decoration: BoxDecoration(
        //     gradient: LinearGradient(colors: [
        //   Color.fromRGBO(25, 53, 93, 1.0),
        //   Color.fromRGBO(25, 53, 93, 1.0),
        //   //Color.fromRGBO(26, 69, 131, 1.0),

        // ])),
        child: SingleChildScrollView(
          child: Card(
            margin: EdgeInsets.fromLTRB(20, 130, 20, 0),
            color: Colors.white,
            // color:Color.fromRGBO(26, 69, 131, 1.0),
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(45.0),
              borderSide: BorderSide.none,
            ),
            child: Column(
              children: <Widget>[
                /*  Container(
                  margin: const EdgeInsets.only(top: 40.0, bottom: 20.0),
                  height: 50.0,
                  child: Image.asset(logo)),*/
                Container(
                  margin: const EdgeInsets.only(top: 5.0, bottom: 20.0),
                  child: Text(
                    "Login".toUpperCase(),
                    style:
                        TextStyle(color: Colors.amber, fontSize: 50.0, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 20, 0),
                  padding: const EdgeInsets.all(1.0),
                  width: double.infinity,
                  child: TextField(
                    // controller: _EmailController,
                    scrollPadding: const EdgeInsets.all(20.0),
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      contentPadding: const EdgeInsets.all(10.0),
                      hintText: "Email",
                      filled: false,
                      fillColor: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 20, 0),
                  padding: const EdgeInsets.all(1.0),
                  width: double.infinity,
                  child: TextField(
                    cursorColor: Colors.amber,
                    textAlign: TextAlign.start,
                    autocorrect: true,
                    //   controller: _passwordController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10.0),
                      icon: Icon(Icons.lock),
                      hintText: "Password",
                      filled: false,
                      fillColor: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
                FlatButton(
                  child: Text(
                    "forget password".toUpperCase(),
                    style: TextStyle(color: Colors.amber),
                  ),
                  onPressed: () {},
                ),
                SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  width: 140,
                  child: RaisedButton(
                    color: Color.fromRGBO(253, 194, 35, 1.0),
                    textColor: Color.fromRGBO(25, 53, 93, 1.0),
                    padding: const EdgeInsets.all(15.0),
                    child: Text("Login".toUpperCase()),
                    onPressed: () {
                      /* FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: _EmailController.text,password: _passwordController.text
                      ).then((FirebaseUser) async {
                        Navigator.of(context).pushReplacementNamed('/home');
                      }).catchError((e){
                        print(e);
                      });*/
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new IconButton(
                        icon: Icon(
                          FontAwesomeIcons.googlePlusSquare,
                          color: Colors.red,
                          size: 45.0,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                              new MaterialPageRoute(builder: (context) => new BottomNavBar()));
                        }),
                  ],
                ),
                SizedBox(height: 30.0),
                Container(
                  margin: const EdgeInsets.only(top: 5.0, bottom: 20.0),
                  child: Text(
                    "Don't Have an Account switch to".toUpperCase(),
                    style:
                        TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
