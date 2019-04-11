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
        _subListItems = backend<InfListService>().listItems(_filterSubject).listen((data) {
          _listItems.add(data);
        });
      },
      onCancel: () {
        _subListItems?.cancel();
      },
    );
    _filterSubject.listen((data) => print('Filter Changed: $data'));
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
