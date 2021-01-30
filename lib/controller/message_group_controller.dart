import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageGroupController {
  final user = FirebaseAuth.instance.currentUser;

  Future<bool> getMessageCountChange(String groupName) async {
    var listOfMessage = await FirebaseFirestore.instance
        .collection('GroupChat')
        .doc(groupName)
        .collection(groupName)
        .orderBy("timestamp", descending: true)
        .limit(1)
        .get();

    DocumentSnapshot userData =
        await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();

    Timestamp lastTimeUserSeenGroupMessage = userData.data()['$groupName time'];

    Timestamp lasttimeMessageSent = listOfMessage.docs.last.data()['timestamp'];

    if (lastTimeUserSeenGroupMessage == lasttimeMessageSent) {
      return false;
    } else {
      return true;
    }
  }
}
