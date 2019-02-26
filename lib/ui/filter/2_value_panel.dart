import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/widgets/inf_icon.dart';
import 'package:inf/ui/widgets/inf_stadium_button.dart';
import 'package:intl/intl.dart';

class ValueFilterPanel extends StatefulWidget {
  const ValueFilterPanel({
    Key key,
    this.padding = EdgeInsets.zero,
  })  : assert(padding != null),
        super(key: key);

  final EdgeInsets padding;

  @override
  _ValueFilterPanelState createState() => _ValueFilterPanelState();
}

class _ValueFilterPanelState extends State<ValueFilterPanel> {
  final _formatter = NumberFormat.currency(locale: "en_US", symbol: '\$', decimalDigits: 0);
  final _value = ValueNotifier<double>(100.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding + const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: InfStadiumButton(
                  icon: Icon(Icons.shopping_cart),
                  text: 'PRODUCTS',
                  color: AppTheme.blue,
                  onPressed: (){},
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: InfStadiumButton(
                  icon: InfIcon(AppIcons.value),
                  text: 'CASH',
                  color: AppTheme.blue,
                  onPressed: (){},
                ),
              ),
            ],
          ),
          Text(_formatter.format(_value.value),
              style: const TextStyle(
                fontSize: 32.0,
              )),
          Slider(
            min: 10.0,
            max: 100000.0,
            value: _value.value,
            onChanged: (value) => setState(() => _value.value = value),
            activeColor: AppTheme.lightBlue,
          ),
        ],
      ),
    );
  }
}
