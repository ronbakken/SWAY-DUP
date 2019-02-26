import 'dart:async';

import 'package:inf/backend/backend.dart';
import 'package:inf/backend/services/inf_offer_service_.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf_api_client/inf_api_client.dart';

class InfOfferServiceImplementation implements InfOfferService {
  @override
  Future<BusinessOffer> getOffer(String id) async {
    var result = await backend.get<InfApiClientsService>().offerClient.getOffer(
          GetOfferRequest()..id = id,
        );
    return BusinessOffer.fromDto(result.offer);
  }

  @override
  Future<BusinessOffer> updateOffer(OfferBuilder offerBuilder) async
  {
    var result = await backend.get<InfApiClientsService>().offerClient.updateOffer(
          UpdateOfferRequest()..offer = offerBuilder.toDto(),
        );
    return BusinessOffer.fromDto(result.offer);

  }

}
