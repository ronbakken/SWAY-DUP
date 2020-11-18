import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateTime updateTimeOfDay(DateTime currentDate, TimeOfDay time) {
  assert(currentDate != null);
  assert(time != null);
  return DateTime(
    currentDate.year,
    currentDate.month,
    currentDate.day,
    time.hour,
    time.minute,
  );
}

DateTime getPureDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

bool isSameDay(DateTime d1, DateTime d2) {
  return getPureDate(d1).compareTo(getPureDate(d2)) == 0;
}

String getDateString(DateTime date, [bool shortDate = false, bool showDays = true]) {
  if (date == null) {
    return '';
  }
  final f = DateFormat("${showDays ? '${shortDate ? 'EE' : 'EEEE'}, ' : ''}d ${shortDate ? 'MMM' : 'MMMM'}  yyyy");
  return f.format(date);
}

String getTimeString(BuildContext context, TimeOfDay time) {
  if (time == null) {
    return '';
  }
  return time.format(context);
}

String sinceWhen(DateTime date) {
  var delta = DateTime.now().difference(date);
  if (delta < const Duration(minutes: 1)) {
    return '${delta.inSeconds} seconds ago';
  } else if (delta < const Duration(hours: 1)) {
    return '${delta.inMinutes} minute${delta.inMinutes > 1 ? 's' : ''} ago';
  } else if (delta < const Duration(days: 1)) {
    return '${delta.inHours} hour${delta.inHours > 1 ? 's' : ''} ago';
  } else if (delta < const Duration(days: 2)) {
    return 'Yesterday';
  } else {
    return DateFormat('MM/dd/yyyy hh:mmaa').format(date);
  }
}
