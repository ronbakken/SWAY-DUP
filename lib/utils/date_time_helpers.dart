import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateTime updateTimeOfDay(DateTime currentDate, TimeOfDay time) {
  assert(currentDate != null);
  assert(time != null);
  return new DateTime(
    currentDate.year,
    currentDate.month,
    currentDate.day,
    time.hour,
    time.minute,
  );
}

DateTime getPureDate(DateTime date) {
  return new DateTime(date.year, date.month, date.day);
}

bool isSameDay(DateTime d1, DateTime d2) {
  return getPureDate(d1).compareTo(getPureDate(d2)) == 0;
}

String getDateString(DateTime date, [bool shortDate = false, bool showDays = true]) {
  if (date == null) {
    return '';
  }

  final f = new DateFormat("${showDays ? '${shortDate ? 'EE' : 'EEEE'}, ' : ''}d ${shortDate ? 'MMM' : 'MMMM'}  yyyy");
  return f.format(date);
}

String getTimeString(BuildContext context, TimeOfDay time) {
  if (time == null) {
    return '';
  }
  return time.format(context);
}
