import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/ui/widgets/inf_icon.dart';

class HelpButton extends StatelessWidget {
  final VoidCallback onTap;

  const HelpButton({
    Key key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
        ),
        child: InfIcon(AppIcons.help, size: 24),
      ),
    );
  }
}
