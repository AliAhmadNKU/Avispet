import 'package:avispets/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

toaster(BuildContext context, String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: MyColor.orange,
      textColor: MyColor.white,
      fontSize: 12.0);
}

progressBar() {
  return Center(
    child: CircularProgressIndicator(
      strokeWidth: 5,
      color: MyColor.white,
      backgroundColor: MyColor.orange2,
    ),
  );
}

customProgressBar() {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: MyColor.white,
        backgroundColor: MyColor.orange2,
      ),
    ),
  );
}
String formatDateTime(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
  print(formattedDate);
  return formattedDate;
}

String formatDateTimeShow(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
  print(formattedDate);
  return formattedDate;
}


timeValues(String tim) {
  // 2024-07-03 19:01:34.000
  var date = DateTime.fromMillisecondsSinceEpoch(int.parse(tim) * 1000);
  DateTime dateTime = date;
  debugPrint('time values $dateTime');

  Duration diff = DateTime.now().difference(dateTime);
  if (diff.inDays > 365) {
    return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year".tr : "years".tr}";
  }
  if (diff.inDays > 30) {
    return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month".tr : "months".tr}";
  }
  if (diff.inDays > 7) {
    return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week".tr : "weeks".tr}";
  }
  if (diff.inDays > 0) {
    return "${diff.inDays} ${diff.inDays == 1 ? "day".tr : "days".tr}";
  }
  if (diff.inHours > 0) {
    return "${diff.inHours} ${diff.inHours == 1 ? "hour".tr : "hrs".tr}";
  }
  if (diff.inMinutes > 0) {
    return "${diff.inMinutes} ${diff.inMinutes == 1 ? "min".tr : "min".tr}";
  }
  return "justNow".tr;
}

timeValues1(String tim) {
  // 2024-07-03 19:01:34.000z
  String timestamp = tim;
  DateTime dateTime = DateTime.parse(timestamp);
  DateTime now = DateTime.now();
  Duration diff = now.difference(dateTime);

  if (diff.inDays > 365) {
    return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year".tr : "years".tr} ${"ago".tr}";
  }
  if (diff.inDays > 30) {
    return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month".tr : "months".tr} ${"ago".tr}";
  }
  if (diff.inDays > 7) {
    return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week".tr : "weeks".tr} ${"ago".tr}";
  }
  if (diff.inDays > 0) {
    return "${diff.inDays} ${diff.inDays == 1 ? "day".tr : "days".tr} ${"ago".tr}";
  }
  if (diff.inHours > 0) {
    return "${diff.inHours} ${diff.inHours == 1 ? "hour".tr : "hrs".tr} ${"ago".tr}";
  }
  if (diff.inMinutes > 0) {
    return "${diff.inMinutes} ${diff.inMinutes == 1 ? "min".tr : "min".tr} ${"ago".tr}";
  }
  return "justNow".tr;
}


