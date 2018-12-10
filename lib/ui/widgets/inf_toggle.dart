import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';

// Is sued in BrowseMode to switch between map/ ListView

// TODO: replace with better version
class InfToggle<T> extends StatelessWidget {
  final T leftState;
  final T rightState;
  final T currentState;
  final AppAsset left;
  final AppAsset right;
  final ValueChanged<T> onChanged;

  const InfToggle(
      {Key key,
      this.currentState,
      this.leftState,
      this.rightState,
      this.left,
      this.right,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color leftBackGroundColor;
    Color leftIconColor;
    Color rightBackGroundColor;
    Color rightIconColor;
    if (currentState == leftState) {
      leftBackGroundColor = AppTheme.toggleActive;
      leftIconColor = AppTheme.toggleIconActive;
      rightIconColor = AppTheme.toggleIconInActive;
      rightBackGroundColor = AppTheme.toggleInActive;
    } else {
      rightIconColor = AppTheme.toggleIconActive;
      rightBackGroundColor = AppTheme.toggleActive;
      leftIconColor = AppTheme.toggleIconInActive;
      leftBackGroundColor = AppTheme.toggleInActive;
    }

    return Material(
      shape: const StadiumBorder(),
      color: AppTheme.toggleBackground,
      clipBehavior: Clip.antiAlias,
      child: InkResponse(
        onTap: () =>
            onChanged(currentState == leftState ? rightState : leftState),
        child: SizedBox(
          width: 64,
          height: 32,
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 26.0,
                  decoration: BoxDecoration(
                    color: leftBackGroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: InfAssetImage(
                      left,
                      color: leftIconColor,
                    ),
                  ),
                ),
                Container(
                  width: 26.0,
                  decoration: BoxDecoration(
                    color: rightBackGroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: InfAssetImage(
                      right,
                      color: rightIconColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
