import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/widgets/inf_icon.dart';

class FilterConfirmButton extends StatefulWidget {
  const FilterConfirmButton({
    Key key,
    this.showHideAnimation,
    @required this.initialDelegate,
    @required this.child,
  }) : super(key: key);

  final Animation<double> showHideAnimation;
  final FilterConfirmButtonDelegate initialDelegate;
  final Widget child;

  static FilterConfirmButtonState of(BuildContext context) {
    return context.ancestorStateOfType(const TypeMatcher<FilterConfirmButtonState>());
  }

  @override
  FilterConfirmButtonState createState() => FilterConfirmButtonState();
}

class FilterConfirmButtonState extends State<FilterConfirmButton> {
  FilterConfirmButtonDelegate _delegate;

  @override
  void initState() {
    super.initState();
    _delegate = widget.initialDelegate;
  }

  set delegate(FilterConfirmButtonDelegate value) {
    setState(() => _delegate = value);
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
              onPressed: _delegate.onPressed,
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
                  child: InfIcon(_delegate.icon, size: 28.0, key: ValueKey(_delegate.icon)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FilterConfirmButtonDelegate {
  final AppAsset icon;
  final VoidCallback onPressed;

  const FilterConfirmButtonDelegate(this.icon, [this.onPressed]);
}
