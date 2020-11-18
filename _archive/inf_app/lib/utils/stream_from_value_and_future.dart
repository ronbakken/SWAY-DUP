import 'dart:async';

Stream<T> streamFromValueAndFuture<T>(T initial, Future<T> future) async*{
  yield initial;
  yield await future;
}