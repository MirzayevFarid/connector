import 'package:cloud_firestore/cloud_firestore.dart';

class Date {
  static DateTime fromJson(String date) {
    return date != null && date != 'null'
        ? DateTime.fromMicrosecondsSinceEpoch(int.parse(date))
        : null;
  }

  static DateTime fromDocumentSnapshot(Timestamp date) {
    return date?.toDate();
  }

  static String toJson(DateTime date) {
    return date?.microsecondsSinceEpoch.toString();
  }

  static DateTime toPostJson(DateTime date) {
    return date;
  }
}
