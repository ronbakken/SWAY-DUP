import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/filter/filter_confirmation.dart';
import 'package:inf/ui/filter/filter_panel.dart';
import 'package:inf/ui/widgets/inf_slider.dart';
import 'package:intl/intl.dart';

class ValueFilterPanel extends StatefulWidget {
  const ValueFilterPanel({
    Key key,
    this.padding = EdgeInsets.zero,
    this.closePanel,
  })  : assert(padding != null),
        super(key: key);

  final EdgeInsets padding;
  final VoidCallback closePanel;

  @override
  _ValueFilterPanelState createState() => _ValueFilterPanelState();
}

class _ValueFilterPanelState extends State<ValueFilterPanel> {
  static const double _defaultValue = 0;
  final _values = <double>[0, 10, 100, 500, 1000, 5000, 10000];
  final _currencyFormatter = NumberFormat.currency(locale: "en_US", symbol: '\$', decimalDigits: 0);

  // For filtering offers
  final _cashValue = ValueNotifier<double>(_defaultValue);
  final _serviceValue = ValueNotifier<double>(_defaultValue);

  // For filtering users
  final _maximumFee = ValueNotifier<double>(_defaultValue);

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
    final filter = FilterPanel.of(context).value;

    if (filter is OfferFilter) {
      final cashValue = filter.minimumRewardCashValue == null ? _defaultValue : filter.minimumRewardCashValue.value.toDouble() / 100;
      final serviceValue = filter.minimumRewardServiceValue == null ? _defaultValue : filter.minimumRewardServiceValue.value.toDouble() / 100;

      _cashValue.value = cashValue;
      _serviceValue.value = serviceValue;
    } else if (filter is UserFilter) {
      final maximumFee = filter.maximumFee == null ? _defaultValue : filter.maximumFee.value.toDouble() / 100;

      _maximumFee.value = maximumFee;
    }

    _cashValue.addListener(_onCashValueChanged);
    _serviceValue.addListener(_onServiceValueChanged);

    _maximumFee.addListener(_onMaximumFeeChanged);
  }

  void _onCashValueChanged() {
    final filter = FilterPanel.of(context);
    final value = filter.value;

    if (value is OfferFilter) {
      if (_cashValue.value == _defaultValue) {
        filter.value = value.copyWithout(
          minimumRewardCashValue: true,
        );
      } else {
        filter.value = value.copyWith(
          minimumRewardCashValue: Money.fromDecimal(Decimal.fromInt((_cashValue.value * 100).toInt())),
        );
      }
    }
  }

  void _onServiceValueChanged() {
    final filter = FilterPanel.of(context);
    final value = filter.value;

    if (value is OfferFilter) {
      if (_serviceValue.value == _defaultValue) {
        filter.value = value.copyWithout(
          minimumRewardServiceValue: true,
        );
      } else {
        filter.value = value.copyWith(
          minimumRewardServiceValue: Money.fromDecimal(Decimal.fromInt((_serviceValue.value * 100).toInt())),
        );
      }
    }
  }

  void _onMaximumFeeChanged() {
    final filter = FilterPanel.of(context);
    final value = filter.value;

    if (value is UserFilter) {
      if (_maximumFee.value == _defaultValue) {
        filter.value = value.copyWithout(
          maximumFee: true,
        );
      } else {
        filter.value = value.copyWith(
          maximumFee: Money.fromDecimal(Decimal.fromInt((_maximumFee.value * 100).toInt())),
        );
      }
    }
  }

  @override
  void dispose() {
    _cashValue.removeListener(_onCashValueChanged);
    _serviceValue.removeListener(_onServiceValueChanged);
    _maximumFee.removeListener(_onMaximumFeeChanged);

    super.dispose();
  }

  void _onConfirmed() {
    widget.closePanel();
  }

  double _getValueForIndex(int index) => _values[index];

  int _getIndexForValue(double value) => _values.indexOf(value);

  String _getFormattedValueForIndex(int index, {@required String name}) {
    assert(name != null);

    final value = _getValueForIndex(index);

    if (value == 0) {
      return "Any $name";
    }

    return "${_currencyFormatter.format(value)} $name";
  }

  @override
  Widget build(BuildContext context) {
    final isFilteringOffers = FilterPanel.of(context).value is OfferFilter;
    final columnChildren = isFilteringOffers
        ? <Widget>[
            Text(
              _getFormattedValueForIndex(
                _getIndexForValue(_cashValue.value),
                name: "cash",
              ),
              style: const TextStyle(
                fontSize: 24.0,
              ),
            ),
            InfSlider(
              divisions: _values.length - 1,
              min: 0,
              max: (_values.length - 1).toDouble(),
              value: _getIndexForValue(_cashValue.value).toDouble(),
              onChanged: (value) => setState(() => _cashValue.value = _getValueForIndex(value.toInt())),
            ),
            Text(
              _getFormattedValueForIndex(
                _getIndexForValue(_serviceValue.value),
                name: "products",
              ),
              style: const TextStyle(
                fontSize: 24.0,
              ),
            ),
            InfSlider(
              divisions: _values.length - 1,
              min: 0,
              max: (_values.length - 1).toDouble(),
              value: _getIndexForValue(_serviceValue.value).toDouble(),
              onChanged: (value) => setState(() => _serviceValue.value = _getValueForIndex(value.toInt())),
            ),
          ]
        : <Widget>[
            Text(
              _getFormattedValueForIndex(
                _getIndexForValue(_maximumFee.value),
                name: "fee",
              ),
              style: const TextStyle(
                fontSize: 24.0,
              ),
            ),
            InfSlider(
              divisions: _values.length - 1,
              min: 0,
              max: (_values.length - 1).toDouble(),
              value: _getIndexForValue(_maximumFee.value).toDouble(),
              onChanged: (value) => setState(() => _maximumFee.value = _getValueForIndex(value.toInt())),
            ),
          ];

    return Container(
      padding: widget.padding + const EdgeInsets.all(24.0),
      child: OverflowBox(
        maxHeight: 200.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: columnChildren,
        ),
      ),
    );
  }
}
