import 'package:intl/intl.dart';

class Format {
  static String hours(double hours) {
    double hour= double.parse(hours.toStringAsFixed(2));
    final hoursNotNegative = hour < 0.0 ? 0.0 : hour;
    final formatter = NumberFormat.decimalPattern();
    final formatted = formatter.format(hoursNotNegative);
    return '${formatted}h';
  }

  static String date(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  static String dayOfWeek(DateTime date) {
    return DateFormat.E().format(date);
  }

  static String currency(double pay) {
    if (pay != 0.0) {
      // final formatter = NumberFormat.simpleCurrency(name:"AED", decimalDigits: 1);
      // return formatter.format(pay);
      return "$pay AED";
    }
    return '';
  }
}
