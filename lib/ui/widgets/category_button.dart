import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';


/// This widget is used to display Toplevel categories or Content Types.
class CategoryButton extends StatelessWidget {
  /// if [selectedSubCategories] == null or == 0 no circle with number will be displayed
  final int selectedSubCategories;
  /// if this is true the button will be drawn blue
  final bool selected;
  final Widget child;
  final VoidCallback onTap;
  final String label;
  final double radius;

  const CategoryButton({
    Key key,
    this.selectedSubCategories = 0,
    this.selected = false,
    @required this.child,
    @required this.onTap,
    @required this.radius,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: InkResponse(
            onTap: onTap,
            child: AspectRatio(aspectRatio: 1.0,
                          child: Center(
                            child: Stack(fit: StackFit.passthrough,
                children: <Widget>[
                  Container(
                    width: 2 * radius,
                    height: 2 * radius,
                    padding: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selectedSubCategories > 0 || selected
                            ? AppTheme.lightBlue
                            : AppTheme.grey,
                      shape: BoxShape.circle,
                      border: Border.all(
                            width: 2.0,
                            color: selectedSubCategories > 0
                                ? Colors.white
                                : AppTheme.grey),
                    ),
                    child: child,
                  ),
                  (selectedSubCategories != null) && (selectedSubCategories > 0)
                      ? Positioned(
                            bottom: -4,
                            right: -12,
                            child: Container(
                              alignment: Alignment.center,
                              width: 28.0,
                              height: 28.0,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.red,
                                  border:
                                      Border.all(color: Colors.black, width: 2.0)),
                              child: Text('$selectedSubCategories'),
                            ),
                        )
                      : SizedBox(),
                ],
              ),
                          ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: label != null ? Text(label) : SizedBox(),
        ),
      ],
    );
  }
}
