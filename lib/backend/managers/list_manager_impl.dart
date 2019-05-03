import 'dart:async';

import 'package:inf/backend/backend.dart';
import 'package:inf/backend/managers/list_manager_.dart';
import 'package:inf/domain/domain.dart';
import 'package:latlong/latlong.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class ListManagerImplementation implements ListManager {
  final _filterSubject = BehaviorSubject<Filter>();
  StreamSubscription<List<InfItem>> _subListItems;
  BehaviorSubject<List<InfItem>> _listItems;

  LatLng _northWest;
  LatLng _southEast;
  int _zoomLevel;

  ListManagerImplementation() {
    _listItems = BehaviorSubject<List<InfItem>>(
      onListen: () async {
        await backend<AuthenticationService>().refreshAccessToken();
        _subListItems = backend<InfListService>().listItems(_filterSubject).asyncMap(_fetchMapItems).listen(
          (data) => _listItems.add(data),
        );
      },
      onCancel: () {
        _subListItems?.cancel();
      },
    );
    _filterSubject.listen((data) => print('Filter Changed: $data'));
  }

  // FIXME: Temporary until server responds with more data
  Future<List<InfItem>> _fetchMapItems(List<InfItem> items) {
    return Future.wait(items.map<Future<InfItem>>((item) async {
      if (item.type != InfItemType.map) {
        return item;
      }
      if (item.mapMarker.type == MapMarkerType.user) {
        final user = await backend<UserManager>().getUser(item.mapMarker.userId);
        return InfItem(
          id: user.id,
          type: InfItemType.user,
          user: user,
          revision: item.revision,
          latitude: item.latitude,
          longitude: item.longitude,
        );
      } else if (item.mapMarker.type == MapMarkerType.offer) {
        final offer = await backend<OfferManager>().getFullOffer(item.mapMarker.offerId);
        return InfItem(
          id: offer.id,
          type: InfItemType.offer,
          offer: offer,
          revision: item.revision,
          latitude: item.latitude,
          longitude: item.longitude,
        );
      } else {
        throw StateError('Bad MapMarkerType');
      }
    }));
  }

  @override
  Stream<List<InfItem>> get listItems => _listItems.stream;

  @override
  void resetFilter() {
    if (backend<UserManager>().currentUser.userType == UserType.influencer) {
      _filterSubject.add(const OfferFilter());
    } else {
      _filterSubject.add(const UserFilter());
    }
  }

  @override
  void setFilter(LocationFilter filter) {
    if (_northWest != null && _southEast != null) {
      filter = filter.withNewLocation(
        northWest: _northWest,
        southEast: _southEast,
        zoomLevel: _zoomLevel,
      );
    }
    _filterSubject.add(filter);
  }

  @override
  void setMapBoundary(double nwLatitude, double nwLongitude, double seLatitude, double seLongitude, int zoomLevel) {
    _northWest = LatLng(nwLatitude, nwLongitude);
    _southEast = LatLng(seLatitude, seLongitude);
    _zoomLevel = zoomLevel;
    setFilter(_filterSubject.value);
  }
}
