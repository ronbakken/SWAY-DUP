import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/widgets/asset_imageI_circle_background.dart';
import 'package:inf/ui/widgets/inf_icon.dart';

class ImageSourceSelectorDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          const Radius.circular(5.0),
        ),
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InfIcon(AppIcons.close, color: AppTheme.white30),
                ),
              ),
            ),
            Text(
              'UPLOAD A PHOTO',
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 16.0,
            ),
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
                    SizedBox(
                      height: 8.0,
                    ),
                    Text('Library')
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
                    SizedBox(
                      height: 8.0,
                    ),
                    Text('Camera')
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
