import 'package:inf/backend/services/resource_service_.dart';
import 'package:inf/domain/domain.dart';

class ResourceServiceImplementation implements ResourceService {
  @override
  Stream<WelcomePageImages> getWelcomePageProfileImages() {
    // TODO: implement getAllLinkedAccounts
    throw Exception('Not imnplemented');
  }

  @override
  String getMapApiKey() {
    // TODO: implement getMapApiKey
    throw Exception('Not imnplemented');
  }

  @override
  String getMapUrlTemplate() {
    // TODO: implement getMapApiKey
    throw Exception('Not imnplemented');
  }

  @override
  Future<List<Category>> getCategories() {
    // TODO: implement getTopLevelCategories
    throw Exception('Not imnplemented');
  }

  @override
  Future<List<DeliverableIcon>> getDeliverableIcons() {
    // TODO: implement getTopLevelCategories
    throw Exception('Not imnplemented');
  }
}
