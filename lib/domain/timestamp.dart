import 'package:fixnum/fixnum.dart';
import 'package:inf_api_client/inf_api_client.dart';

const int nanosecondsPerMicrosecond = 1000;

DateTime dateTimeFromTimestamp(Timestamp timestamp) {
  final seconds = (timestamp.seconds * Int64(Duration.microsecondsPerSecond));
  final nanos = timestamp.nanos ~/ nanosecondsPerMicrosecond;
  return DateTime.fromMicrosecondsSinceEpoch(seconds.toInt() + nanos);
}

Timestamp timestampFromDateTime(DateTime dateTime) {
  final microseconds = dateTime.microsecondsSinceEpoch;
  final seconds = microseconds ~/ Duration.microsecondsPerSecond;
  final nanos = (microseconds % Duration.microsecondsPerSecond) * nanosecondsPerMicrosecond;
  return Timestamp()
    ..seconds = Int64(seconds)
    ..nanos = nanos;
}
