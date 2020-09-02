import 'package:enactusnca/Widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:enactusnca/BottomNavBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class home extends StatefulWidget {
  static String id = 'home';
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  List posts = List();
  String Add = "";

  /*CreatePosts(){
      DocumentReference documentRefrance =Firestore.instance.collection("mypost").document(Add);

      Map<String , String> posts ={
        'postTitle' : Add
      };
      documentRefrance.setData(posts).whenComplete((){
        print('$Add  created');
      });
  }*/

  deletepost() {}

  @override
  void initState() {
    super.initState();
    posts.add(
        "COVID-19 from spreading to prevention .../COVID-19 from spreading to prevention ...");
    posts.add(
        "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto");
    posts.add(
        "Stay safe and follow the instructions. You and everyone around you will be safe⁦❤⁩.");
    posts.add(
        'Stay safe and follow the instructions. You and everyone around you will be safe⁦❤⁩.');
    posts.add(
        'Stay safe and follow the instructions. You and everyone around you will be safe⁦❤⁩..Stay safe and follow the instructions. You and everyone around you will be safe⁦❤⁩.');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          /*   floatingActionButton: FloatingActionButton(
            //backgroundColor: Color.fromRGBO(26, 69, 131, 1.0),
            backgroundColor: KSacandColor,
            child: Icon(Icons.add, color: KMainColor),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      title: Text('add post'),
                      content: TextField(
                        onChanged: (String value) {
                          Add = value;
                        },
                      ),
                      actions: <Widget>[
                        FlatButton(
                          /*onPressed: (){
                          CreatePosts ();
                          Navigator.of(context).pop();

                        },
                        */
                          onPressed: () {
                            setState(() {
                              posts.add(Add);
                            });
                          },
                          child: Text('Add'),
                        )
                      ],
                    );
                  });
            },
          ),*/
          backgroundColor: KMainColor,
          body:
              /* Container(
                decoration: BoxDecoration(
              image: DecorationImage(image:AssetImage('img/bg.jpg',),
              fit: BoxFit.cover
              )
              ),*/
              ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int index) {
              /*  return Container(
                      child: ppost(),
                    );*/

              return Padding(
                padding: EdgeInsets.all(15.0),
                child: Material(
                  borderRadius: BorderRadius.circular(15.0),
                  elevation: 8.0,
                  shadowColor: Color(0x8022417A),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Color.fromRGBO(20, 69, 131, 1.0),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              CircleAvatar(),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "A_Shokry",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          Text(
                            posts[index],
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 1.0,
                            color: Colors.grey,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    setState(() {});
                                  }),
                              IconButton(
                                  icon: Icon(
                                    Icons.comment,
                                  ),
                                  onPressed: () {}),
                            ],
                          )
                        ]),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
