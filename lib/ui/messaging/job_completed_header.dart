import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/widgets/inf_form_label.dart';

class JobCompletedHeader extends StatelessWidget {
  const JobCompletedHeader({
    this.height = 30,
    this.color = AppTheme.blackTwo,
    @required this.onTap,
  });

  final double height;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text("Deal Completed?"),
          GestureDetector(
            onTap: onTap,
            child: const InfFormLabel(
              "MARK AS COMPLETE",
              style: TextStyle(decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }
}
