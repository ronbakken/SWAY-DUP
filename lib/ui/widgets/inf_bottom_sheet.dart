import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/widgets/curved_box.dart';

class InfBottomSheet extends StatelessWidget {
  final Widget child;
  final String title;

  const InfBottomSheet({Key key, this.child, this.title}) : super(key: key);

  static Route route({String title, Widget child}) {
    return PageRouteBuilder(
      pageBuilder: (BuildContext context, _, __) {
        return InfBottomSheet(
          title: title,
          child: child,
        );
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation, _, Widget child) {
        final slide = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero).animate(animation);
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
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: constraints.copyWith(
            minWidth: constraints.maxWidth,
            minHeight: constraints.maxHeight,
            maxHeight: double.infinity,
          ),
          child: IntrinsicHeight(
            child: Column(mainAxisSize: MainAxisSize.min,
              children: [
                Spacer(),
                Material(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: mediaQuery.padding.bottom + 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CurvedBox(
                          bottom: true,
                          top: false,
                          color: AppTheme.menuUserNameBackground,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 48),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Spacer(),
                                Text(
                                  title,
                                  style: const TextStyle(fontSize: 20),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: InkResponse(
                                      onTap: () => Navigator.of(context).pop(null),
                                      child: Icon(Icons.close, size: 32),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        child,
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
