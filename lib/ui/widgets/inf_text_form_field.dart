import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/inf_input_decorator.dart';

class InfTextFormField extends FormField<String> {
  /// Creates a [FormField] that contains a [TextField].
  ///
  /// When a [controller] is specified, [initialValue] must be null (the
  /// default). If [controller] is null, then a [TextEditingController]
  /// will be constructed automatically and its `text` will be initialized
  /// to [initalValue] or the empty string.
  ///
  /// For documentation about the various parameters, see the [TextField] class
  /// and [new TextField], the constructor.
  InfTextFormField({
    Key key,
    this.controller,
    String initialValue,
    this.focusNode,
    InputDecoration decoration = const InputDecoration(),
    TextInputType keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction textInputAction,
    TextStyle style,
    TextDirection textDirection,
    TextAlign textAlign = TextAlign.start,
    bool autofocus = false,
    bool obscureText = false,
    bool autoCorrect = true,
    bool autoValidate = false,
    bool maxLengthEnforced = true,
    int maxLines = 1,
    int maxLength,
    VoidCallback onEditingComplete,
    ValueChanged<String> onFieldSubmitted,
    FormFieldSetter<String> onSaved,
    FormFieldValidator<String> validator,
    List<TextInputFormatter> inputFormatters,
    bool enabled = true,
    double cursorWidth = 2.0,
    Radius cursorRadius,
    Color cursorColor,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
    bool enableInteractiveSelection = true,
    InputCounterWidgetBuilder buildCounter,
    VoidCallback onHelpPressed,
  })  : assert(initialValue == null || controller == null),
        assert(textAlign != null),
        assert(autofocus != null),
        assert(obscureText != null),
        assert(autoCorrect != null),
        assert(autoValidate != null),
        assert(maxLengthEnforced != null),
        assert(scrollPadding != null),
        assert(maxLines == null || maxLines > 0),
        assert(maxLength == null || maxLength > 0),
        assert(enableInteractiveSelection != null),
        super(
          key: key,
          initialValue: controller != null ? controller.text : (initialValue ?? ''),
          onSaved: onSaved,
          validator: validator,
          autovalidate: autoValidate,
          enabled: enabled,
          builder: (FormFieldState<String> field) {
            final _InfTextFormFieldState state = field;
            final InputDecoration effectiveDecoration = (decoration ?? const InputDecoration()).applyDefaults(
              Theme.of(field.context).inputDecorationTheme,
            );
            // FIXME: InputDecorator issue with hosting itself.
            return InfInputDecorator(
              decoration: effectiveDecoration.copyWith(
                //contentPadding: EdgeInsets.zero,
                errorText: field.errorText,
              ),
              baseStyle: style,
              textAlign: textAlign,
              isEmpty: field.value == null || field.value.isEmpty,
              focusNode: state.effectiveFocusNode,
              onHelpPressed: onHelpPressed,
              child: TextField(
                decoration: null,
                controller: state._effectiveController,
                focusNode: state.effectiveFocusNode,
                keyboardType: keyboardType,
                textInputAction: textInputAction,
                style: style,
                textAlign: textAlign,
                textDirection: textDirection,
                textCapitalization: textCapitalization,
                autofocus: autofocus,
                obscureText: obscureText,
                autocorrect: autoCorrect,
                maxLengthEnforced: maxLengthEnforced,
                maxLines: maxLines,
                maxLength: maxLength,
                onChanged: field.didChange,
                onEditingComplete: onEditingComplete,
                onSubmitted: onFieldSubmitted,
                inputFormatters: inputFormatters,
                enabled: enabled,
                cursorWidth: cursorWidth,
                cursorRadius: cursorRadius,
                cursorColor: cursorColor,
                scrollPadding: scrollPadding,
                keyboardAppearance: Brightness.dark,
                enableInteractiveSelection: enableInteractiveSelection,
                buildCounter: buildCounter,
              ),
            );
          },
        );
  
  /// Creates a [InfTextFormField] designed for currency input.
  factory InfTextFormField.money({
    String labelText,
    String initialValue,
    FormFieldSetter<Money> onSaved,
  }) {
    return InfTextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        prefix: Text('\$ ', style: TextStyle(color: Colors.grey.shade300)),
      ),
      initialValue: initialValue,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      onSaved: (s) => onSaved(Money.fromInt(int.parse(s))),
      keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
    );
  }

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController] and
  /// initialize its [TextEditingController.text] with [initialValue].
  final TextEditingController controller;

  final FocusNode focusNode;

  @override
  _InfTextFormFieldState createState() => _InfTextFormFieldState();
}

class _InfTextFormFieldState extends FormFieldState<String> {
  TextEditingController _controller;

  TextEditingController get _effectiveController => widget.controller ?? _controller;

  FocusNode _focusNode;

  FocusNode get effectiveFocusNode => widget.focusNode ?? (_focusNode ??= FocusNode());

  @override
  InfTextFormField get widget => super.widget;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    } else {
      widget.controller.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(InfTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null)
        _controller = TextEditingController.fromValue(oldWidget.controller.value);
      if (widget.controller != null) {
        setValue(widget.controller.text);
        if (oldWidget.controller == null) _controller = null;
      }
    }
  }

  @override
  void dispose() {
    widget.focusNode?.dispose();
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController.text = widget.initialValue;
    });
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (_effectiveController.text != value) didChange(_effectiveController.text);
  }
}
