import 'dart:async';

import 'package:inf/domain/domain.dart';

abstract class InfOfferService {

  Future<BusinessOffer> getOffer(String id);
  
}