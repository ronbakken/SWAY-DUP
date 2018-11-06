
import 'package:inf/backend/services/network_service.dart';
import 'package:inf/domain/domain.dart';
import 'package:rxdart/rxdart.dart';

class NetWorkServiceMock implements NetWorkService
{

  List<BusinessOffer> allOffers;

  /// TBD: What is the best was to define a Filter
  @override
  Observable<List<BusinessOffer>> getBusinessOffers(int userId,)
  {
      
  }

  @override
  Observable<List<Proposal>> getProposals(int userId, int offerId)
  {

  }

  Future<void> loadMockData() async {
    allOffers = [
      BusinessOffer(businessAccountId: 42,
      title: 'Card Wash',
      description: 'Our car wash is the best car wash in the universe of car washes'
      
      )
    ];
  }
}