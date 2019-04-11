import 'dart:async';
import 'package:inf/domain/domain.dart';


abstract class InfListService {
  Stream<List<InfItem>> listMyOffers();
  Stream<List<InfItem>> listItems(Stream<Filter> filterStream);
  Stream<List<InfItem>> listenForOfferChanges(Stream<Filter> filterStream);
}