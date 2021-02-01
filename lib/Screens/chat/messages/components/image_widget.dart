import 'package:enactusnca/Helpers/constants.dart';
import 'package:enactusnca/Models/messages_model.dart';
import 'package:enactusnca/Screens/Profile/profile.dart';
import 'package:enactusnca/Screens/chat/show_image/open_image_and_downloaded.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  ImageWidget({Key key, this.message}) : super(key: key);

  final MessageModel message;
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: user.uid == message.senderId
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (user.uid != message.senderId)
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Profile(
                      isAppBarEnabled: true,
                      userId: message.senderId,
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(right: 12.0),
                height: 34,
                width: 34,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24.0),
                  child: message.userImg != null
                      ? Image.network(
                          message.userImg,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            return loadingProgress == null
                                ? child
                                : const Center(
                                    child: CircularProgressIndicator());
                          },
                        )
                      : Image.asset('assets/images/enactus.png'),
                ),
              ),
            )
          else
            Container(),
          Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: user.uid != message.senderId
                  ? Constants.lightBlue
                  : Constants.midBlue,
              borderRadius: user.uid == message.senderId
                  ? const BorderRadius.only(
                      bottomLeft: Radius.circular(8.0),
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    )
                  : const BorderRadius.only(
                      bottomRight: Radius.circular(8.0),
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
            ),
            width: MediaQuery.of(context).size.width * 0.50,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return OpenImage(url: message.message);
                    },
                  ),
                );
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: Image.network(message.message),
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    '${message.userName} . ${message.timestamp.toDate().hour.toString()}:${message.timestamp.toDate().minute.toString()}',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w200,
                      color: Colors.grey.shade100,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
