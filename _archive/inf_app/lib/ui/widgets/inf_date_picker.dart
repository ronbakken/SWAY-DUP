import 'package:flutter/material.dart';
import 'package:inf/ui/widgets/inf_input_decorator.dart';
import 'package:intl/intl.dart';

class InfDatePicker extends FormField<DateTime> {
  InfDatePicker({
    Key key,
    DateTime initialValue,
    @required this.firstDate,
    @required this.lastDate,
    FormFieldSetter<DateTime> onSaved,
    FormFieldValidator<DateTime> validator,
    bool autoValidate = false,
    bool enabled = true,
    this.focusNode,
    this.decoration = const InputDecoration(),
    this.dateFormat,
  }) : super(
          key: key,
          initialValue: initialValue,
          onSaved: onSaved,
          validator: validator,
          autovalidate: autoValidate,
          enabled: enabled,
          builder: (FormFieldState<DateTime> state) {
            return (state as _InfDatePickerState)._buildField();
          },
        );

  final DateTime firstDate;
  final DateTime lastDate;
  final InputDecoration decoration;
  final FocusNode focusNode;
  final DateFormat dateFormat;

  @override
  FormFieldState<DateTime> createState() => _InfDatePickerState();
}

class _InfDatePickerState extends FormFieldState<DateTime> {
  @override
  InfDatePicker get widget => super.widget;

  DateFormat _dateFormat;
  DateFormat get _effectiveFormat => widget.dateFormat ?? (_dateFormat ??= DateFormat('MM / dd / yyyy'));

  FocusNode _focusNode;

  FocusNode get _effectiveFocusNode => widget.focusNode ?? (_focusNode ??= FocusNode());

  @override
  void didUpdateWidget(InfDatePicker oldWidget) {
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
      child: Text(value != null ? _effectiveFormat.format(value) : ''),
    );
  }

  void _openPicker() async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: value ?? widget.firstDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );
    if (mounted) {
      if (picked != null) {
        FocusScope.of(context).requestFocus(_focusNode);
        didChange(picked);
      }
    }
  }
}
