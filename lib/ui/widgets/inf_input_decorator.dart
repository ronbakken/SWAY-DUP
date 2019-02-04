import 'package:flutter/material.dart';
import 'package:inf/ui/widgets/listenable_builder.dart';
import 'package:inf/utils/utils.dart';

class InfInputDecorator extends StatefulWidget {
  const InfInputDecorator({
    Key key,
    this.decoration,
    this.baseStyle,
    this.textAlign,
    this.focusNode,
    this.isEmpty = false,
    this.onTap,
    this.child,
  })  : assert(isEmpty != null),
        super(key: key);

  final InputDecoration decoration;
  final TextStyle baseStyle;
  final TextAlign textAlign;
  final FocusNode focusNode;
  final bool isEmpty;
  final VoidCallback onTap;
  final Widget child;

  @override
  _InfInputDecoratorState createState() => _InfInputDecoratorState();
}

class _InfInputDecoratorState extends State<InfInputDecorator> {
  @override
  Widget build(BuildContext context) {
    final effectiveDecoration = widget.decoration.applyDefaults(
      Theme.of(context).inputDecorationTheme,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        effectiveDecoration.labelText != null
            ? Text(
                effectiveDecoration.labelText,
                style: effectiveDecoration.labelStyle,
              )
            : SizedBox(),
        InkWell(
          onTap: widget.onTap,
          child: ListenableBuilder(
            listenable: widget.focusNode,
            builder: (BuildContext context, Widget child) {
              return InputDecorator(
                decoration: removeInputDecoration(
                  effectiveDecoration,
                  labelText: true,
                ),
                baseStyle: widget.baseStyle,
                textAlign: widget.textAlign,
                isFocused: widget.focusNode.hasFocus,
                isEmpty: widget.isEmpty,
                child: child,
              );
            },
            child: widget.child,
          ),
        ),
      ],
    );
  }
}
