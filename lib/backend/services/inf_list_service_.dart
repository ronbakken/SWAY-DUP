import 'dart:async';

import 'package:inf/domain/domain.dart';


abstract class InfListService {

  Stream<List<InfItem>> listItems(Stream<Filter> filterStream);
  Stream<List<InfItem>> listenItemChanges(Stream<Filter> filterStream);
  
}