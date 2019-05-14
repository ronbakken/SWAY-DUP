import 'package:flutter/material.dart';
import 'package:inf/ui/widgets/inf_bottom_button.dart';
import 'package:inf/ui/widgets/inf_bottom_sheet.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

class JobCompletedSheet extends StatelessWidget {
  static Route<bool> route() {
    return InfBottomSheet.route<bool>(
      title: 'Are you sure?',
      child: JobCompletedSheet(),
    );
  }

  static const String _message =
      "Before you continue, please be sure you have finished all deal requirements to avoid any disruption with your Sway account.";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 30,
        left: 25.0,
        right: 25.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(_message, style: TextStyle(fontSize: 18)),
          verticalMargin16,
          InfBottomButton(
            text: "JOB IS COMPLETE",
            color: const Color(0xFF3167B0),
            onPressed: () => onConfirm(context),
          )
        ],
      ),
    );
  }

  void onConfirm(BuildContext context) => Navigator.of(context).pop<bool>(true);
}
