import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/widgets/inf_bottom_button.dart';
import 'package:inf/ui/widgets/inf_bottom_sheet.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

class AddMediaSheet extends StatelessWidget {
  static Route<String> route() {
    return InfBottomSheet.route<String>(
      title: 'Add media',
      child: AddMediaSheet(),
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
          InfBottomButton(
            text: "CAMERA",
            icon: Icon(Icons.camera_alt), // TODO: Use AppAsset instead?
            color: AppTheme.charcoalGrey,
            padding: const EdgeInsets.all(8.0),
            onPressed: () => onSelect(context, 'camera'),
          ),
          InfBottomButton(
            text: "PHOTO & VIDEO LIBRARY",
            icon: Icon(Icons.photo), // TODO: Use AppAsset instead?
            color: AppTheme.charcoalGrey,
            padding: const EdgeInsets.all(8.0),
            onPressed: () => onSelect(context, 'media'),
          ),
          InfBottomButton(
            text: "DOCUMENT",
            icon: Icon(Icons.insert_drive_file), // TODO: Use AppAsset instead?
            color: AppTheme.charcoalGrey,
            padding: const EdgeInsets.all(8.0),
            onPressed: () => onSelect(context, 'document'),
          ),
          verticalMargin32,
        ],
      ),
    );
  }

  // TEMP
  void onSelect(BuildContext context, String type) => Navigator.of(context).pop<String>(type);
}
