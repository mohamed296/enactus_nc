import 'package:intl/intl.dart';

class Functions {
  static checkId(String id) {
    if (id.substring(0, 2) != 'ad') {
      return false;
    } else {
      return true;
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
