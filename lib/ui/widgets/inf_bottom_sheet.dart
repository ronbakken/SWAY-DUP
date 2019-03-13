import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/widgets/curved_box.dart';
import 'package:inf/ui/widgets/inf_icon.dart';

class InfBottomSheet extends StatelessWidget {
  final Widget child;
  final String title;

  const InfBottomSheet({Key key, this.child, this.title}) : super(key: key);

  static Route route<T>({String title, Widget child}) {
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
      transitionDuration: const Duration(milliseconds: 650),
      opaque: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
      child: SingleChildScrollView(
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 44.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacer(),
          Text(title, style: const TextStyle(fontSize: 20)),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: InkResponse(
                onTap: () => Navigator.of(context).pop(null),
                child: const Center(child: InfIcon(AppIcons.close, size: 16.0)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
