import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/widgets/inf_location_field.dart';
import 'package:inf/ui/widgets/inf_slider.dart';

class LocationFilterPanel extends StatefulWidget {
  const LocationFilterPanel({
    Key key,
    this.padding = EdgeInsets.zero,
  })  : assert(padding != null),
        super(key: key);

  final EdgeInsets padding;

  @override
  _LocationFilterPanelState createState() => _LocationFilterPanelState();
}

class _LocationFilterPanelState extends State<LocationFilterPanel> {
  final _value = ValueNotifier<double>(30.0);
  Location _location;

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
              location: _location,
              onChanged: (value) => setState(() => _location = value),
            ),
            SizedBox(height: 8.0),
            Text(
              'DISTANCE FROM SEARCHED LOCATION',
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Material(
              color: AppTheme.grey,
              shape: const StadiumBorder(),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ValueListenableBuilder(
                  valueListenable: _value,
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
            SizedBox(height: 4.0),
            InfSlider(
              min: 0.0,
              max: 100.0,
              value: _value.value,
              onChanged: (value) => setState(() => _value.value = value),
            ),
          ],
        ),
      ),
    );
  }
}
