import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';

class Functions {
  static checkId(String id) {
    if (id.substring(0, 2) != 'ad') {
      return false;
    } else {
      return true;
    }
  }

  static checkIfIdValid(String id) async {
    String _dateTime = formatDate(
      DateTime.now(),
      [yyyy],
    );
    var _doc;
    await Firestore.instance
        .collection("Posts")
        .where('id.$id', isEqualTo: id)
        .getDocuments()
        .then((value) => _doc = value);
    if ((id.substring(0, 3) == 'PRO' ||
        id.substring(0, 3) == 'PRE' ||
        id.substring(0, 2) == 'HR' ||
        id.substring(0, 2) == 'MM' ||
        id.substring(0, 2) == 'ER') &&
        _dateTime.substring(2, 4) == '20' &&
        _doc.data.documents[0].data["id"] &&
        _doc.data.documents[0].data["isRegistered"] == false) {
      return 'Invalid ID';
    } else {
      return 'Valid ID';
    }
  }

  static String readTimestamp(int timestamp) {
    var now = new DateTime.now();
    var format = new DateFormat().add_jm();
    var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    var diff = date.difference(now);
    var time = '';
    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + 'DAY AGO';
      } else {
        time = diff.inDays.toString() + 'DAYS AGO';
      }
    }
    return time;
  }
}
