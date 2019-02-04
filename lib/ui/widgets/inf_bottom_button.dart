import 'package:flutter/material.dart';
import 'package:inf/ui/widgets/inf_stadium_button.dart';

const kInfBottomButtonPadding = const EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0);

class InfBottomButton extends StatelessWidget implements PreferredSizeWidget {
  const InfBottomButton({
    Key key,
    this.color = Colors.white,
    this.text,
    this.onPressed,
    this.panelColor,
  }) : super(key: key);

  final Color color;
  final String text;
  final VoidCallback onPressed;
  final Color panelColor;

  @override
  Size get preferredSize => Size(double.infinity, 48.0 + kInfBottomButtonPadding.vertical);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      color: panelColor,
      padding: EdgeInsets.only(bottom: mediaQuery.padding.bottom) + kInfBottomButtonPadding,
      child: InfStadiumButton(
        height: 48.0,
        color: Colors.white,
        text: text,
        onPressed: onPressed,
      ),
    );
  }
}
