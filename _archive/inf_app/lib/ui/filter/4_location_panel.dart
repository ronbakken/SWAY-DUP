import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/filter/filter_confirmation.dart';
import 'package:inf/ui/filter/filter_panel.dart';
import 'package:inf/ui/widgets/inf_location_field.dart';
import 'package:inf/ui/widgets/inf_slider.dart';
import 'package:inf/ui/widgets/widget_utils.dart';
import 'package:inf/utils/geo.dart';
import 'package:latlong/latlong.dart';

class LocationFilterPanel extends StatefulWidget {
  const LocationFilterPanel({
    Key key,
    this.padding = EdgeInsets.zero,
    this.closePanel,
  })  : assert(padding != null),
        super(key: key);

  final EdgeInsets padding;
  final VoidCallback closePanel;

  @override
  _LocationFilterPanelState createState() => _LocationFilterPanelState();
}

class _LocationFilterPanelState extends State<LocationFilterPanel> {
  static const double _defaultRadius = 30.0;
  static const double _kmsInMile = 1.60934;
  final _radius = ValueNotifier<double>(_defaultRadius);
  final _location = ValueNotifier<Location>(null);
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FilterConfirmButton.of(context).delegate = FilterConfirmButtonDelegate(AppIcons.tick, _onConfirmed);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) {
      return;
    }

    _initialized = true;
    final filter = FilterPanel.of(context).value;
    const milesInKm = 0.621371;

    if (filter is UserFilter) {
      if (filter.northWest != null && filter.southEast != null) {
        final boundingBox = GeoBoundingBox(
          northWest: GeoPoint(
            filter.northWest.latitude,
            filter.northWest.longitude,
          ),
          southEast: GeoPoint(
            filter.southEast.latitude,
            filter.southEast.longitude,
          ),
        );
        final area = getAreaFromBoundingBox(boundingBox);

        _radius.value = area.radiusInKilometers * milesInKm;
        _location.value = Location(
          latitude: area.center.latitude,
          longitude: area.center.longitude,
          name: filter.locationName,
        );
      } else {
        _radius.value = _defaultRadius;
        _location.value = null;
      }
    } else if (filter is OfferFilter) {
      if (filter.northWest != null && filter.southEast != null) {
        final boundingBox = GeoBoundingBox(
          northWest: GeoPoint(
            filter.northWest.latitude,
            filter.northWest.longitude,
          ),
          southEast: GeoPoint(
            filter.southEast.latitude,
            filter.southEast.longitude,
          ),
        );
        final area = getAreaFromBoundingBox(boundingBox);

        _radius.value = area.radiusInKilometers * milesInKm;
        _location.value = Location(
          latitude: area.center.latitude,
          longitude: area.center.longitude,
          name: filter.locationName,
        );
      } else {
        _radius.value = _defaultRadius;
        _location.value = null;
      }
    }

    _radius.addListener(_onChanged);
    _location.addListener(_onChanged);
  }

  void _onChanged() {
    final filter = FilterPanel.of(context);
    final value = filter.value;

    if (value is UserFilter) {
      if (_location.value == null) {
        filter.value = value.copyWithout(
          northWest: true,
          southEast: true,
        );
      } else {
        final area = GeoArea(
          GeoPoint(_location.value.latitude, _location.value.longitude),
          _radius.value * _kmsInMile,
        );
        final boundingBox = getBoundingBoxFromArea(area);

        filter.value = value.copyWith(
          northWest: LatLng(boundingBox.northWest.latitude, boundingBox.northWest.longitude),
          southEast: LatLng(boundingBox.southEast.latitude, boundingBox.southEast.longitude),
          locationName: _location.value.name,
        );
      }
    } else if (value is OfferFilter) {
      if (_location.value == null) {
        filter.value = value.copyWithout(
          northWest: true,
          southEast: true,
        );
      } else {
        final area = GeoArea(
          GeoPoint(_location.value.latitude, _location.value.longitude),
          _radius.value * _kmsInMile,
        );
        final boundingBox = getBoundingBoxFromArea(area);

        filter.value = value.copyWith(
          northWest: LatLng(boundingBox.northWest.latitude, boundingBox.northWest.longitude),
          southEast: LatLng(boundingBox.southEast.latitude, boundingBox.southEast.longitude),
          locationName: _location.value.name,
        );
      }
    }
  }

  @override
  void dispose() {
    _radius.removeListener(_onChanged);
    _location.removeListener(_onChanged);
    super.dispose();
  }

  void _onConfirmed() {
    widget.closePanel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding + const EdgeInsets.all(20.0),
      child: OverflowBox(
        maxHeight: 200.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InfLocationField(
              location: _location.value,
              onChanged: (value) => setState(() => _location.value = value),
            ),
            verticalMargin8,
            const Text(
              'DISTANCE FROM SEARCHED LOCATION',
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            verticalMargin8,
            Material(
              color: AppTheme.grey,
              shape: const StadiumBorder(),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ValueListenableBuilder(
                  valueListenable: _radius,
                  builder: (BuildContext context, double value, Widget child) {
                    return Text(
                      '${value.toStringAsFixed(0)} miles',
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    );
                  },
                ),
              ),
            ),
            verticalMargin4,
            InfSlider(
              min: 0.0,
              max: 100.0,
              value: _radius.value,
              onChanged: (value) => setState(() => _radius.value = value),
            ),
          ],
        ),
      ),
    );
  }
}
