import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:inf_api_client/inf_api_client.dart';
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

String sinceWhen(DateTime date)
{
  var delta = DateTime.now().difference(date);
  if (delta.compareTo(const Duration(hours: 1)) < 0)
  {
    return '${delta.inMinutes} min. ago';
  }

  if (delta.compareTo(const Duration(days: 1)) < 0)
  {
    if (delta.inHours ==1)
    {
      return '1 hour ago';
    }
    return '${delta.inHours} hours ago';
  }

  if (delta.compareTo(const Duration(days: 2)) < 0)
  {
    return 'one day ago';
  }

  return DateFormat('mm/dd/yyyy').format(date);
}

DateTime fromTimeStamp(Timestamp t)
{
  return DateTime.fromMillisecondsSinceEpoch(t.seconds.toInt()*1000);
}

Timestamp toTimeStamp(DateTime date)
{
  return Timestamp()..seconds = Int64(date.millisecondsSinceEpoch ~/ 1000);
}