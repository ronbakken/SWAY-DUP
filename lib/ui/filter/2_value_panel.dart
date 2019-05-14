import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/widgets/inf_icon.dart';
import 'package:inf/ui/widgets/inf_slider.dart';
import 'package:inf/ui/widgets/inf_stadium_button.dart';
import 'package:inf/ui/widgets/widget_utils.dart';
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
  final _formatter = NumberFormat.currency(locale: "en_US", symbol: '\$', decimalDigits: 0);
  final _value = ValueNotifier<double>(100.0);

  bool _toggle = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding + const EdgeInsets.all(24.0),
      child: OverflowBox(
        maxHeight: 200.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: InfStadiumButton(
                    icon: const Icon(Icons.shopping_cart),
                    text: 'PRODUCTS',
                    color: _toggle ? AppTheme.blue : AppTheme.grey,
                    onPressed: () {
                      setState(() => _toggle = true);
                    },
                  ),
                ),
                horizontalMargin16,
                Expanded(
                  child: InfStadiumButton(
                    icon: const InfIcon(AppIcons.value),
                    text: 'CASH',
                    color: _toggle ? AppTheme.grey : AppTheme.blue,
                    onPressed: () {
                      setState(() => _toggle = false);
                    },
                  ),
                ),
              ],
            ),
            Text(
              _formatter.format(_value.value),
              style: const TextStyle(
                fontSize: 32.0,
              ),
            ),
            InfSlider(
              min: 10.0,
              max: 100000.0,
              value: _value.value,
              onChanged: (value) => setState(() => _value.value = value),
            ),
          ],
        ),
      ),
    );
  }
}
