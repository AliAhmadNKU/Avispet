import 'package:intl/intl.dart';

class BaseDateUtils{

  /// Parses a date string in 'MM/dd/yyyy' format into a DateTime object.
  static String formatToMMddyyyy(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return DateFormat('MM/dd/yyyy').format(date);
  }
}