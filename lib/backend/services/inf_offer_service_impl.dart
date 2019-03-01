import 'dart:async';

import 'package:inf/backend/backend.dart';
import 'package:inf/backend/services/inf_offer_service_.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf_api_client/inf_api_client.dart';

class InfOfferServiceImplementation implements InfOfferService {
  @override
  Future<BusinessOffer> getOffer(String id) async {
    GetOfferResponse response;
    try {
      response = await backend
          .get<InfApiClientsService>()
          .offerClient
          .getOffer(GetOfferRequest()..id = id, options: backend<AuthenticationService>().callOptions);
    } on GrpcError catch (e) {
      if (e.code == 7) // permission denied
      {
        // retry with new access token
        await backend<AuthenticationService>().refreshAccessToken();
        response = await backend
            .get<InfApiClientsService>()
            .offerClient
            .getOffer(GetOfferRequest()..id = id, options: backend<AuthenticationService>().callOptions);
      } else {
        await backend<ErrorReporter>().logException(e, message: 'getOffer');
        print(e);
        rethrow;
      }
    }
    return BusinessOffer.fromDto(response.offer);
  }

  @override
  Future<BusinessOffer> updateOffer(OfferBuilder offerBuilder) async {
    UpdateOfferResponse response;
    try {
      response = await backend<InfApiClientsService>().offerClient.updateOffer(
          UpdateOfferRequest()..offer = offerBuilder.toDto(),
          options: backend<AuthenticationService>().callOptions);
    } on GrpcError catch (e) {
      if (e.code == 7) // permission denied
      {
        // retry with new access token
        await backend<AuthenticationService>().refreshAccessToken();
        response = await backend<InfApiClientsService>().offerClient.updateOffer(
            UpdateOfferRequest()..offer = offerBuilder.toDto(),
            options: backend<AuthenticationService>().callOptions);
      } else {
        await backend<ErrorReporter>().logException(e, message: 'updateOffer');
        print(e);
        rethrow;
      }
    }
    return BusinessOffer.fromDto(response.offer);
  }
}
