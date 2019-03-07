import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/ui/widgets/inf_icon.dart';
import 'package:inf/ui/widgets/inf_input_decorator.dart';
import 'package:inf/ui/widgets/location_selector_page.dart';

export 'package:inf/domain/location.dart';

class InfLocationField extends StatelessWidget {
  const InfLocationField({
    Key key,
    this.location,
    this.onChanged,
  }) : super(key: key);

  final Location location;
  final ValueChanged<Location> onChanged;

  @override
  Widget build(BuildContext context) {
    return InfInputDecorator(
      onTap: () async {
        final value = await Navigator.of(context).push(LocationSelectorPage.route());
        onChanged?.call(value);
      },
      decoration: const InputDecoration(
        prefixIcon: const InfIcon(AppIcons.location, size: 20),
        suffixIcon: const InfIcon(AppIcons.search, size: 20),
      ),
      child: Text(
        location != null ? location.name : 'Location',
        maxLines: 2,
      ),
    );
  }
}
