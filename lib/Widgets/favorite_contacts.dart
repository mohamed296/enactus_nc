// import 'package:enactusnca/Models/message.dart';
// import 'package:enactusnca/Screens/views/chat_screen.dart';
// import 'package:flutter/material.dart';

// class FavoriteContacts extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         //  color: Constants.midBlue,
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(30),
//         ),
//       ),
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: 10),
//         child: Column(
//           children: <Widget>[
//             Container(
//               height: 120,
//               child: ListView.builder(
//                 padding: EdgeInsets.only(left: 10.0),
//                 scrollDirection: Axis.horizontal,
//                 itemCount: favorites.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => ChatScreen(
//                                   username: "favorites[index]",
//                                 )),
//                       );
//                     },
//                     child: Padding(
//                       padding: EdgeInsets.all(10.0),
//                       child: Column(
//                         children: <Widget>[
//                           CircleAvatar(
//                             radius: 35,
//                             backgroundImage: AssetImage(favorites[index].imageUrl),
//                           ),
//                           SizedBox(
//                             height: 6.0,
//                           ),
//                           Text(
//                             favorites[index].username,
//                             style: TextStyle(
//                                 letterSpacing: 1.0,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.grey.shade200,
//                                 fontSize: 16.0),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
