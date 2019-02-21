import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/widgets/category_button.dart';
import 'package:inf/ui/widgets/inf_memory_image.dart';
import 'package:inf/ui/widgets/overflow_row.dart';
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
    return OverflowRow(
      height: 96.0,
      childrenWidth: 64.0,
      children: backend.get<ConfigService>().deliverableIcons.map((icon) {
        return CategoryButton(
          onTap: widget.readOnly ? null : () => _toggleType(icon.deliverableType),
          radius: 64.0,
          label: icon.name,
          selected: widget.deliverableTypes.contains(icon.deliverableType),
          child: InfMemoryImage(
            icon.iconData,
            color: Colors.white,
            width: 32.0,
            height: 32.0,
          ),
        );
      }).toList(growable: false),
    );
  }

  void _toggleType(DeliverableType type) {
    setState(() => widget.deliverableTypes.toggle(type));
  }
}
