import 'package:flutter/material.dart';
import 'package:inf/ui/widgets/inf_input_decorator.dart';
import 'package:intl/intl.dart';

class InfTimePicker extends FormField<TimeOfDay> {
  InfTimePicker({
    Key key,
    TimeOfDay initialValue,
    FormFieldSetter<TimeOfDay> onSaved,
    FormFieldValidator<TimeOfDay> validator,
    bool autoValidate = false,
    bool enabled = true,
    this.focusNode,
    this.decoration = const InputDecoration(),
  }) : super(
          key: key,
          initialValue: initialValue,
          onSaved: onSaved,
          validator: validator,
          autovalidate: autoValidate,
          enabled: enabled,
          builder: (FormFieldState<TimeOfDay> state) {
            return (state as _InfDatePickerState)._buildField();
          },
        );

  final InputDecoration decoration;
  final FocusNode focusNode;

  @override
  FormFieldState<TimeOfDay> createState() => _InfDatePickerState();
}

class _InfDatePickerState extends FormFieldState<TimeOfDay> {
  @override
  InfTimePicker get widget => super.widget;

  FocusNode _focusNode;

  FocusNode get _effectiveFocusNode => widget.focusNode ?? (_focusNode ??= FocusNode());

  @override
  void didUpdateWidget(InfTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    final bool isEnabled = widget.enabled ?? widget.decoration?.enabled ?? true;
    final bool wasEnabled = oldWidget.enabled ?? oldWidget.decoration?.enabled ?? true;
    if (wasEnabled && !isEnabled) {
      _effectiveFocusNode.unfocus();
    }
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    super.dispose();
  }

  Widget _buildField() {
    return InfInputDecorator(
      onTap: _openPicker,
      isEmpty: value == null,
      focusNode: _effectiveFocusNode,
      decoration: widget.decoration.copyWith(
        errorText: errorText,
      ),
      child: Text(value != null ? value.format(context) : ''),
    );
  }

  void _openPicker() async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: value ?? TimeOfDay.now(),
    );
    if (mounted) {
      if (picked != null) {
        FocusScope.of(context).requestFocus(_focusNode);
        didChange(picked);
      }
    }
  }
}
