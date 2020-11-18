import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Before you continue, please be sure you have finished all deal '
            'requirements to avoid any disruption with your Sway account.',
          ),
          verticalMargin16,
          InfBottomButton(
            text: 'JOB IS COMPLETE',
            color: AppTheme.lightBlue,
            onPressed: () => Navigator.of(context).pop<bool>(true),
          ),
        ],
      ),
    );
  }
}
