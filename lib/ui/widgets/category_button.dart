import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

/// This widget is used to display Toplevel categories or Content Types.
class CategoryButton extends StatelessWidget {
  const CategoryButton({
    Key key,
    this.selectedSubCategories = 0,
    this.selected = false,
    this.onTap,
    @required this.radius,
    @required this.child,
    this.label,
  }) : super(key: key);

  /// if [selectedSubCategories] == null or == 0 no circle with number will be displayed
  final int selectedSubCategories;

  /// if this is true the button will be drawn blue
  final bool selected;
  final Widget child;
  final VoidCallback onTap;
  final String label;
  final double radius;

  bool get _selected => selectedSubCategories > 0 || selected;

  @override
  Widget build(BuildContext context) {
    Widget count;
    if (selectedSubCategories != null && selectedSubCategories > 0) {
      count = Container(
        alignment: Alignment.center,
        width: 28.0,
        height: 28.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.red,
          border: Border.all(color: Colors.black, width: 2.0),
        ),
        child: Text(
          selectedSubCategories.toString(),
          strutStyle: const StrutStyle(
            height: 1,
            forceStrutHeight: true,
          ),
        ),
      );
    } else {
      count = emptyWidget;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Stack(
            fit: StackFit.passthrough,
            overflow: Overflow.visible,
            children: <Widget>[
              SizedBox(
                width: 2 * radius,
                height: 2 * radius,
                child: Material(
                  color: _selected ? AppTheme.lightBlue : AppTheme.grey,
                  shape: CircleBorder(
                    side: BorderSide(
                      width: 2.0,
                      color: _selected ? Colors.white : AppTheme.grey,
                    ),
                  ),
                  child: InkResponse(
                    onTap: onTap,
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      child: child,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -4,
                right: -12,
                child: AnimatedSwitcher(
                  transitionBuilder: _scaleTransitionBuilder,
                  duration: kThemeChangeDuration,
                  child: count,
                ),
              ),
            ],
          ),
        ),
        label != null
            ? Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(label),
              )
            : emptyWidget,
      ],
    );
  }

  Widget _scaleTransitionBuilder(Widget child, Animation<double> animation) {
    return ScaleTransition(scale: animation, child: child);
  }
}
