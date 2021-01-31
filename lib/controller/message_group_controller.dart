import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageGroupController {
  final user = FirebaseAuth.instance.currentUser;

  Future<bool> getMessageCountChange(String groupName) async {
    final listOfMessage = await FirebaseFirestore.instance
        .collection('GroupChat')
        .doc(groupName)
        .collection(groupName)
        .orderBy("timestamp", descending: true)
        .limit(1)
        .get();

    final DocumentSnapshot userData =
        await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();

    final Timestamp lastTimeUserSeenGroupMessage = userData.data()['$groupName time'] as Timestamp;

    final Timestamp lasttimeMessageSent = listOfMessage.docs.last.data()['timestamp'] as Timestamp;

    if (lastTimeUserSeenGroupMessage == lasttimeMessageSent) {
      return false;
    } else {
      return true;
    }
  }
}
