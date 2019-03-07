import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/widgets/inf_icon.dart';

class FilterConfirmationButton extends StatefulWidget {
  const FilterConfirmationButton({
    Key key,
    this.showHideAnimation,
    @required this.initialIcon,
    @required this.child,
  }) : super(key: key);

  final Animation<double> showHideAnimation;
  final AppAsset initialIcon;
  final Widget child;

  static FilterConfirmationButtonState of(BuildContext context) {
    return context.ancestorStateOfType(const TypeMatcher<FilterConfirmationButtonState>());
  }

  @override
  FilterConfirmationButtonState createState() => FilterConfirmationButtonState();
}

class FilterConfirmationButtonState extends State<FilterConfirmationButton> {
  AppAsset _icon;

  @override
  void initState() {
    super.initState();
    _icon = widget.initialIcon;
  }

  set icon(AppAsset value) {
    setState(() => _icon = value);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        widget.child,
        Positioned(
          bottom: 24.0 + mediaQuery.padding.bottom,
          child: ScaleTransition(
            scale: widget.showHideAnimation,
            child: RawMaterialButton(
              onPressed: () {},
              // FIXME: _deselectFilterPanel
              fillColor: AppTheme.lightBlue,
              constraints: const BoxConstraints(minWidth: 64.0, minHeight: 64.0),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: const CircleBorder(),
              padding: const EdgeInsets.only(top: 4.0),
              child: Container(
                width: 64.0,
                height: 64.0,
                alignment: Alignment.center,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: InfIcon(_icon, size: 28.0, key: ValueKey(_icon)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
