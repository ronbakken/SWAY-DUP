import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/widgets/category_button.dart';
import 'package:inf/ui/widgets/inf_memory_image.dart';
import 'package:inf/utils/selection_set.dart';
import 'package:inf_api_client/inf_api_client.dart';

class DeliverySelector extends StatefulWidget {
  final SelectionSet<DeliverableType> deliverableTypes;
  final String label;
  final EdgeInsets padding;
  final bool readOnly;

  const DeliverySelector({Key key, this.deliverableTypes, this.label, this.padding, this.readOnly = false})
      : super(key: key);
  @override
  _DeliverySelectorState createState() => _DeliverySelectorState();
}

class _DeliverySelectorState extends State<DeliverySelector> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.label,
            textAlign: TextAlign.left,
            style: AppTheme.formFieldLabelStyle,
          ),
          SizedBox(height: 24),
          buildDeliverableTypeRow(),
        ],
      ),
    );
  }

  Widget buildDeliverableTypeRow() {
    final rowItems = <Widget>[];
    for (var icon in backend.get<ConfigService>().deliverableIcons) {
      rowItems.add(
        CategoryButton(
          onTap: !widget.readOnly ? () => setState(() => widget.deliverableTypes.toggle(icon.deliverableType)) : () {},
          radius: 64.0,
          child: InfMemoryImage(
            icon.iconData,
            color: Colors.white,
            width: 32.0,
            height: 32.0,
          ),
          label: icon.name,
          selected: widget.deliverableTypes.contains(icon.deliverableType),
        ),
      );
    }

    return SizedBox(
      height: 100.0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rowItems,
      ),
    );
  }
}
