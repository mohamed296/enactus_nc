import 'package:intl/intl.dart';

class Functions {
  static bool checkId(String id) {
    if (id.substring(0, 2) != 'ad') {
      return false;
    } else {
      return true;
    }
  }

  // static Future<bool> checkIfIdValid(String id) async {
  //   final String _dateTime = formatDate(DateTime.now(), [yyyy]);

  //   QuerySnapshot _doc;
  //   await FirebaseFirestore.instance
  //       .collection("Posts")
  //       .where('id.$id', isEqualTo: id)
  //       .get()
  //       .then((value) => _doc = value);
  //   if ((id.substring(0, 3) == 'PRO' ||
  //           id.substring(0, 3) == 'PRE' ||
  //           id.substring(0, 2) == 'HR' ||
  //           id.substring(0, 2) == 'MM' ||
  //           id.substring(0, 2) == 'ER') &&
  //       _dateTime.substring(2, 4) == '20' &&
  //       _doc.data.documents[0].data["id"] == true &&
  //       _doc.data.documents[0].data["isRegistered"] == false) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  static String readTimestamp(int timestamp) {
    final now = DateTime.now();
    final format = DateFormat().add_jm();
    final date = DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    final diff = date.difference(now);
    var time = '';
    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else {
      if (diff.inDays == 1) {
        time = '${diff.inDays}DAY AGO';
      } else {
        time = '${diff.inDays}DAYS AGO';
      }
    }
    return time;
  }
}
