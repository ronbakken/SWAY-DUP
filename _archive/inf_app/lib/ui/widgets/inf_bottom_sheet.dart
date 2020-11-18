import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/widgets/curved_box.dart';
import 'package:inf/ui/widgets/inf_icon.dart';

class InfBottomSheet extends StatelessWidget {
  static Route route<T>({
    String title,
    Widget child,
    bool barrierDismissible = true,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (BuildContext context, _, __) {
        return InfBottomSheet(
          title: title,
          child: child,
        );
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation, _, Widget child) {
        final slide = Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero).animate(animation);
        return SlideTransition(
          position: slide,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      opaque: false,
      barrierColor: barrierDismissible ? Colors.black54 : null,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierDismissible ? 'Dismiss' : null,
    );
  }

  const InfBottomSheet({
    Key key,
    this.title,
    this.child,
  }) : super(key: key);

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(top: mediaQuery.padding.top),
        reverse: true,
        child: Material(
          child: Padding(
            padding: EdgeInsets.only(bottom: mediaQuery.padding.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CurvedBox(
                  bottom: true,
                  color: AppTheme.menuUserNameBackground,
                  child: _InfBottomSheetHeader(
                    title: title,
                  ),
                ),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfBottomSheetHeader extends StatelessWidget {
  const _InfBottomSheetHeader({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 44.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 0.0,
              right: 0.0,
              child: Padding(
                padding: const EdgeInsets.only(left: 48.0, right: 48.0),
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: InkResponse(
                onTap: () => Navigator.of(context).pop(null),
                child: const Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  child: InfIcon(AppIcons.close, size: 16.0),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
