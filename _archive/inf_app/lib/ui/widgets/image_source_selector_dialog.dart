import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/widgets/asset_image_circle_background.dart';
import 'package:inf/ui/widgets/inf_icon.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

class ImageSourceSelectorDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Container(
        color: AppTheme.darkGrey,
        height: 196,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkResponse(
                onTap: () => Navigator.of(context).pop(null),
                child: const Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InfIcon(AppIcons.close, color: AppTheme.white30),
                ),
              ),
            ),
            const Text(
              'UPLOAD A PHOTO',
              textAlign: TextAlign.center,
            ),
            verticalMargin16,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: <Widget>[
                    AssetImageCircleBackgroundButton(
                      radius: 35,
                      backgroundColor: AppTheme.grey,
                      asset: AppIcons.photo,
                      onTap: () => Navigator.of(context).pop(false),
                    ),
                    verticalMargin8,
                    const Text('Library')
                  ],
                ),
                Column(
                  children: <Widget>[
                    AssetImageCircleBackgroundButton(
                      radius: 35,
                      backgroundColor: AppTheme.grey,
                      asset: AppIcons.camera,
                      onTap: () => Navigator.of(context).pop(true),
                    ),
                    verticalMargin8,
                    const Text('Camera')
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
