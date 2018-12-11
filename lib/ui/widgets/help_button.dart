import 'package:flutter/material.dart';

class HelpButton extends StatelessWidget {
  final VoidCallback onTap;

  const HelpButton({
    Key key,
    @required this.onTap,
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
        child: Icon(
          Icons.help,
          size: 24,
        ),
      ),
    );
  }
}
