import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';

class CategoryButton extends StatelessWidget {
  final int selectedSubCategories;
  final Widget child;
  final VoidCallback onTap;

  const CategoryButton({
    Key key,
    this.selectedSubCategories = 0,
    @required this.child,
    @required this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
        onTap: onTap,
          child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(4.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color:
                  selectedSubCategories > 0 ? AppTheme.lightBlue : AppTheme.grey,
              shape: BoxShape.circle,
              border: Border.all(
                  width: 2.0,
                  color:
                      selectedSubCategories > 0 ? Colors.white : AppTheme.grey),
            ),
            child: child,
          ),
          selectedSubCategories > 0
              ? Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  child: Container(
                    alignment: Alignment.center,
                    width: 28.0,
                    height: 28.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.red,
                        border: Border.all(color: Colors.black, width: 2.0)),
                    child: Text('$selectedSubCategories'),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
