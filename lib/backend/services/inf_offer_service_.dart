import 'dart:async';

import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';

abstract class InfOfferService {

  Future<BusinessOffer> getOffer(String id, String creatorId);
  Future<BusinessOffer> updateOffer(OfferBuilder offerBuilder);
  
}